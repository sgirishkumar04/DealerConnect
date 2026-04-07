package com.dealerconnect.service.impl;

import com.dealerconnect.dto.request.VehicleRequest;
import com.dealerconnect.dto.response.VehicleDetailsDTO;
import com.dealerconnect.entity.*;
import com.dealerconnect.entity.QVehicle;
import com.dealerconnect.exception.ResourceNotFoundException;
import com.dealerconnect.repository.*;
import com.dealerconnect.service.AuditService;
import com.querydsl.core.BooleanBuilder;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.jdbc.core.JdbcTemplate;

import com.dealerconnect.security.DealerContext;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class VehicleService {

    private final VehicleRepository vehicleRepo;
    private final BookingRepository bookingRepo;
    private final AuditService auditService;
    private final ObjectMapper objectMapper;
    private final JdbcTemplate jdbc;

    public Page<Vehicle> getAll(String status, Long modelId, Pageable pageable) {
        QVehicle v = QVehicle.vehicle;
        BooleanBuilder builder = new BooleanBuilder();

        Long dealerId = DealerContext.getCurrentDealerId();
        if (dealerId != null) {
            builder.and(v.dealer.id.eq(dealerId));
        }

        if (status != null && !status.trim().isEmpty()) {
            builder.and(v.status.eq(Vehicle.VehicleStatus.valueOf(status)));
        }
        
        if (modelId != null) {
            builder.and(v.variant.model.id.eq(modelId));
        }

        return vehicleRepo.findAll(builder, pageable);
    }

    public Vehicle getById(Long id) {
        Long dealerId = DealerContext.getCurrentDealerId();
        return vehicleRepo.findById(id)
            .filter(v -> DealerContext.isCurrentSuperAdmin() || (v.getDealer() != null && v.getDealer().getId().equals(dealerId)))
            .orElseThrow(() -> new ResourceNotFoundException("Vehicle not found: " + id));
    }

    public VehicleDetailsDTO getVehicleDetails(Long id) {
        Vehicle v = getById(id);
        
        VehicleDetailsDTO dto = VehicleDetailsDTO.builder()
            .id(v.getId())
            .vin(v.getVin())
            .engineNumber(v.getEngineNumber())
            .chassisNumber(v.getChassisNumber())
            .modelName(v.getVariant().getModel().getModelName())
            .variantName(v.getVariant().getVariantName())
            .colorName(v.getColor().getName())
            .hexCode(v.getColor().getHexCode())
            .mfgYear(v.getMfgYear())
            .mfgDate(v.getMfgDate())
            .arrivalDate(v.getArrivalDate())
            .locationName(v.getLocation().getName())
            .dealerCost(v.getDealerCost())
            .exShowroomPrice(v.getVariant().getExShowroomPrice())
            .status(v.getStatus().name())
            .build();

        bookingRepo.findByVehicleId(v.getId()).stream().findFirst().ifPresent(b -> {
            dto.setSalesInfo(VehicleDetailsDTO.SalesInfo.builder()
                .bookingNumber(b.getBookingNumber())
                .customerName(b.getCustomer().getFirstName() + " " + b.getCustomer().getLastName())
                .customerEmail(b.getCustomer().getEmail())
                .customerPhone(b.getCustomer().getPhone())
                .salesExecutiveName(b.getSalesExec().getFirstName() + " " + b.getSalesExec().getLastName())
                .bookingStatus(b.getStatus().name())
                .deliveryDate(b.getExpectedDelivery())
                .invoiceNumber(b.getStatus() == Booking.BookingStatus.INVOICED || b.getStatus() == Booking.BookingStatus.DELIVERED ? "INV-" + b.getBookingNumber() : null)
                .build());
        });

        return dto;
    }

    @Transactional
    public Vehicle create(VehicleRequest req) {
        if (vehicleRepo.existsByVin(req.getVin()))
            throw new IllegalArgumentException("VIN already registered: " + req.getVin());

        Vehicle v = Vehicle.builder()
            .vin(req.getVin())
            .engineNumber(req.getEngineNumber())
            .chassisNumber(req.getChassisNumber())
            .variant(VehicleVariant.builder().id(req.getVariantId()).build())
            .color(Color.builder().id(req.getColorId()).build())
            .location(InventoryLocation.builder().id(req.getLocationId()).build())
            .mfgYear(req.getMfgYear())
            .mfgDate(req.getMfgDate())
            .arrivalDate(req.getArrivalDate())
            .status(req.getStatus() != null
                ? Vehicle.VehicleStatus.valueOf(req.getStatus()) : Vehicle.VehicleStatus.IN_STOCK)
            .invoiceDate(req.getInvoiceDate())
            .dealerCost(req.getDealerCost())
            .dealer(Dealer.builder().id(DealerContext.getCurrentDealerId()).build())
            .build();
        Vehicle savedVehicle = vehicleRepo.save(v);
        auditService.log("Vehicle", savedVehicle.getId(), "CREATE", null, savedVehicle);
        return savedVehicle;
    }

    @Transactional
    public Vehicle update(Long id, VehicleRequest req) {
        Vehicle v = getById(id);
        String oldJson = null;
        try {
            oldJson = objectMapper.writeValueAsString(v);
        } catch (Exception e) {
            log.error("Failed to serialize vehicle for update audit: {}", e.getMessage());
        }

        v.setVin(req.getVin());
        v.setEngineNumber(req.getEngineNumber());
        v.setChassisNumber(req.getChassisNumber());
        v.setVariant(VehicleVariant.builder().id(req.getVariantId()).build());
        v.setColor(Color.builder().id(req.getColorId()).build());
        v.setLocation(InventoryLocation.builder().id(req.getLocationId()).build());
        v.setMfgYear(req.getMfgYear());
        v.setMfgDate(req.getMfgDate());
        v.setArrivalDate(req.getArrivalDate());
        v.setStatus(Vehicle.VehicleStatus.valueOf(req.getStatus()));
        v.setDealerCost(req.getDealerCost());
        v.setInvoiceDate(req.getInvoiceDate());
        
        Vehicle savedVehicle = vehicleRepo.save(v);
        auditService.log("Vehicle", savedVehicle.getId(), "UPDATE", oldJson, savedVehicle);
        return savedVehicle;
    }

    @Transactional
    public void delete(Long id) {
        Vehicle v = getById(id);
        String oldJson = null;
        try {
            oldJson = objectMapper.writeValueAsString(v);
        } catch (Exception e) {
            log.error("Failed to serialize vehicle for delete audit: {}", e.getMessage());
        }

        // 1. Un-allocate from bookings (set vehicle_id to NULL)
        jdbc.update("UPDATE bookings SET vehicle_id = NULL, status = 'BOOKED' WHERE vehicle_id = ?", id);
        
        // 2. Delete the vehicle
        vehicleRepo.deleteById(id);
        
        auditService.log("Vehicle", id, "DELETE", oldJson, null);
    }

    @Transactional
    public Vehicle updateStatus(Long id, String status) {
        Vehicle v = getById(id);
        String oldJson = null;
        try {
            oldJson = objectMapper.writeValueAsString(v);
        } catch (Exception e) {
            log.error("Failed to serialize vehicle for status update audit: {}", e.getMessage());
        }

        v.setStatus(Vehicle.VehicleStatus.valueOf(status));
        Vehicle savedVehicle = vehicleRepo.save(v);
        
        auditService.log("Vehicle", savedVehicle.getId(), "STATUS_UPDATE", oldJson, savedVehicle);
        return savedVehicle;
    }

    public List<Object[]> getInventorySummary() {
        Long dealerId = DealerContext.getCurrentDealerId();
        return vehicleRepo.getInventoryStatusSummary(null, null, dealerId);
    }
}
