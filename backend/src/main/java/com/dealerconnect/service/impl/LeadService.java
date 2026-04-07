package com.dealerconnect.service.impl;

import com.dealerconnect.security.DealerContext;
import com.dealerconnect.dto.request.LeadRequest;
import com.dealerconnect.entity.*;
import com.dealerconnect.exception.ResourceNotFoundException;
import com.dealerconnect.repository.*;
import com.dealerconnect.service.AuditService;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.jdbc.core.JdbcTemplate;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class LeadService {

    private final LeadRepository leadRepo;
    private final CustomerRepository customerRepo;
    private final BookingRepository bookingRepo;
    private final DealerRepository dealerRepo;
    private final JdbcTemplate jdbc;
    private final AuditService auditService;
    private final ObjectMapper objectMapper;

    public Page<Lead> getAll(String status, Long execId, Pageable pageable) {
        Long dealerId = DealerContext.getCurrentDealerId();
        if (status != null) {
            try {
                return leadRepo.findByStatusAndDealerId(Lead.LeadStatus.valueOf(status.toUpperCase()), dealerId, pageable);
            } catch (Exception e) {
                // Return empty page if invalid status
                return new PageImpl<>(Collections.emptyList(), pageable, 0);
            }
        }
        if (execId != null) return leadRepo.findByAssignedToIdAndDealerId(execId, dealerId, pageable);
        if (DealerContext.isCurrentSuperAdmin()) return leadRepo.findAll(pageable);
        return leadRepo.findByDealerId(dealerId, pageable);
    }

    public Lead getById(Long id) {
                Long dealerId = DealerContext.getCurrentDealerId();
        return leadRepo.findById(id)
            .filter(l -> DealerContext.isCurrentSuperAdmin() || (l.getDealer() != null && l.getDealer().getId().equals(dealerId)))
            .orElseThrow(() -> new ResourceNotFoundException("Lead not found: " + id));
    }

    @Transactional
    public Lead create(LeadRequest req) {
                Long dealerId = DealerContext.getCurrentDealerId();
        Dealer dealer = dealerRepo.findById(dealerId)
            .orElseThrow(() -> new ResourceNotFoundException("Dealer not found"));

        Customer customer;
        if (req.getCustomerId() != null) {
            customer = customerRepo.findById(req.getCustomerId())
                .filter(c -> c.getDealer().getId().equals(dealerId))
                .orElseThrow(() -> new ResourceNotFoundException("Customer not found: " + req.getCustomerId()));
        } else {
            // Create new customer from lead details
            String name = req.getCustomerName() != null ? req.getCustomerName() : "Lead Guest";
            String[] parts = name.split(" ", 2);
            customer = Customer.builder()
                .customerCode("CUST-L-" + System.currentTimeMillis() % 100000)
                .firstName(parts[0])
                .lastName(parts.length > 1 ? parts[1] : "")
                .phone(req.getCustomerPhone())
                .customerType(Customer.CustomerType.INDIVIDUAL)
                .dealer(dealer)
                .build();
            customer = customerRepo.save(customer);
        }

        Lead lead = Lead.builder()
            .leadNumber(req.getLeadNumber())
            .customer(customer)
            .source(LeadSource.builder().id(req.getSourceId()).build())
            .assignedTo(Employee.builder().id(req.getAssignedTo()).build())
            .dealer(dealer)
            .status(req.getStatus() != null ? Lead.LeadStatus.valueOf(req.getStatus().toUpperCase()) : Lead.LeadStatus.NEW)
            .remarks(req.getRemarks())
            .expectedCloseDate(req.getExpectedCloseDate())
            .build();
        if (req.getPreferredModelId() != null)
            lead.setPreferredModel(VehicleModel.builder().id(req.getPreferredModelId()).build());
        if (req.getPreferredVariantId() != null)
            lead.setPreferredVariant(VehicleVariant.builder().id(req.getPreferredVariantId()).build());
        if (req.getPreferredColorId() != null)
            lead.setPreferredColor(Color.builder().id(req.getPreferredColorId()).build());
        Lead savedLead = leadRepo.save(lead);
        auditService.log("Lead", savedLead.getId(), "CREATE", null, savedLead);
        checkAndCreateBooking(savedLead);
        return savedLead;
    }

    @Transactional
    public Lead update(Long id, LeadRequest req) {
        Lead lead = getById(id);
        String oldJson = null;
        try {
            oldJson = objectMapper.writeValueAsString(lead);
        } catch (Exception e) {
            log.error("Failed to serialize lead for update audit: {}", e.getMessage());
        }
        
        if (req.getCustomerId() != null) lead.setCustomer(Customer.builder().id(req.getCustomerId()).build());
        if (req.getSourceId() != null) lead.setSource(LeadSource.builder().id(req.getSourceId()).build());
        lead.setAssignedTo(Employee.builder().id(req.getAssignedTo()).build());
        if (req.getStatus() != null) lead.setStatus(Lead.LeadStatus.valueOf(req.getStatus().toUpperCase()));
        lead.setRemarks(req.getRemarks());
        lead.setExpectedCloseDate(req.getExpectedCloseDate());
        
        lead.setPreferredModel(req.getPreferredModelId() != null ? VehicleModel.builder().id(req.getPreferredModelId()).build() : null);
        lead.setPreferredVariant(req.getPreferredVariantId() != null ? VehicleVariant.builder().id(req.getPreferredVariantId()).build() : null);
        lead.setPreferredColor(req.getPreferredColorId() != null ? Color.builder().id(req.getPreferredColorId()).build() : null);

        Lead savedLead = leadRepo.save(lead);
        auditService.log("Lead", savedLead.getId(), "UPDATE", oldJson, savedLead);
        checkAndCreateBooking(savedLead);
        return savedLead;
    }

    private void checkAndCreateBooking(Lead lead) {
        if (lead.getStatus() == Lead.LeadStatus.BOOKED || lead.getStatus() == Lead.LeadStatus.DELIVERED) {
            Optional<Booking> existing = bookingRepo.findByLeadIdAndDealerId(lead.getId(), lead.getDealer().getId());
            if (existing.isEmpty()) {
                Booking b = Booking.builder()
                    .bookingNumber("BKG-AUTO-" + lead.getId())
                    .lead(lead)
                    .customer(lead.getCustomer())
                    .variant(lead.getPreferredVariant() != null ? lead.getPreferredVariant() : VehicleVariant.builder().id(1L).build())
                    .color(lead.getPreferredColor() != null ? lead.getPreferredColor() : Color.builder().id(1L).build())
                    .salesExec(lead.getAssignedTo())
                    .exShowroom(BigDecimal.valueOf(1000000))
                    .totalOnRoad(BigDecimal.valueOf(1200000))
                    .status(lead.getStatus() == Lead.LeadStatus.DELIVERED ? Booking.BookingStatus.DELIVERED : Booking.BookingStatus.BOOKED)
                    .dealer(lead.getDealer())
                    .build();
                bookingRepo.save(b);
            } else {
                Booking b = existing.get();
                if (lead.getStatus() == Lead.LeadStatus.DELIVERED && b.getStatus() != Booking.BookingStatus.DELIVERED) {
                    b.setStatus(Booking.BookingStatus.DELIVERED);
                    bookingRepo.save(b);
                }
            }
        }
    }

    @Transactional
    public void delete(Long id) {
        Lead lead = getById(id);
        String oldJson = null;
        try {
            oldJson = objectMapper.writeValueAsString(lead);
        } catch (Exception e) {
            log.error("Failed to serialize lead for delete audit: {}", e.getMessage());
        }

        // 1. Find all bookings associated with this lead
        List<Long> bIds = jdbc.queryForList("SELECT id FROM bookings WHERE lead_id = ?", Long.class, id);
        
        for (Long bId : bIds) {
            // 2. Delete dependent records of bookings
            jdbc.update("DELETE FROM finance_loans WHERE booking_id = ?", bId);
            jdbc.update("DELETE FROM invoices WHERE booking_id = ?", bId);
        }
        
        // 3. Delete bookings
        jdbc.update("DELETE FROM bookings WHERE lead_id = ?", id);
        
        // 4. Finally delete the lead
        leadRepo.deleteById(id);
        auditService.log("Lead", id, "DELETE", oldJson, null);
    }

    public String generateNextLeadNumber() {
        Long dealerId = DealerContext.getCurrentDealerId();
        String max = leadRepo.findMaxLeadNumber(dealerId);
        if (max == null || !max.startsWith("LD")) {
            long count = leadRepo.countByDealerId(dealerId);
            return String.format("LD%04d", count + 1);
        }
        try {
            int num = Integer.parseInt(max.substring(2));
            return String.format("LD%04d", num + 1);
        } catch (Exception e) {
            return "LD-" + (System.currentTimeMillis() % 10000);
        }
    }

    public List<Object[]> getFunnelSummary() { 
        Long dealerId = DealerContext.getCurrentDealerId();
        return leadRepo.getLeadFunnelCounts(null, null, dealerId); 
    }
}
