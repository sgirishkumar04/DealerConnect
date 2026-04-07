package com.dealerconnect.controller;

import com.dealerconnect.security.DealerContext;
import com.dealerconnect.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/reports")
@RequiredArgsConstructor
public class ReportController {

    private final BookingRepository bookingRepo;
    private final LeadRepository leadRepo;
    private final VehicleRepository vehicleRepo;
    private final ServiceAppointmentRepository serviceRepo;

    /** Q7 – Monthly revenue */
    @GetMapping("/monthly-bookings")
    public ResponseEntity<List<Object[]>> monthlyBookings(
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Long dealerId) {
        Long effectiveDealerId = DealerContext.isCurrentSuperAdmin() ? dealerId : DealerContext.getCurrentDealerId();
        return ResponseEntity.ok(bookingRepo.getMonthlyBookings(year, effectiveDealerId));
    }

    /** Q8 – Top selling models */
    @GetMapping("/top-selling-models")
    public ResponseEntity<List<Object[]>> topSellingModels(
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer month,
            @RequestParam(required = false) Long dealerId) {
        Long effectiveDealerId = DealerContext.isCurrentSuperAdmin() ? dealerId : DealerContext.getCurrentDealerId();
        return ResponseEntity.ok(bookingRepo.getTopSellingModels(year, month, effectiveDealerId));
    }

    /** Q4 – Sales pipeline funnel */
    @GetMapping("/sales-pipeline")
    public ResponseEntity<List<Object[]>> salesPipeline(
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer month,
            @RequestParam(required = false) Long dealerId) {
        Long effectiveDealerId = DealerContext.isCurrentSuperAdmin() ? dealerId : DealerContext.getCurrentDealerId();
        return ResponseEntity.ok(leadRepo.getLeadFunnelCounts(year, month, effectiveDealerId));
    }

    /** Q1 – Inventory status */
    @GetMapping("/inventory-status")
    public ResponseEntity<List<Object[]>> inventoryStatus(
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer month,
            @RequestParam(required = false) Long dealerId) {
        Long effectiveDealerId = DealerContext.isCurrentSuperAdmin() ? dealerId : DealerContext.getCurrentDealerId();
        return ResponseEntity.ok(vehicleRepo.getInventoryStatusSummary(year, month, effectiveDealerId));
    }

    /** Q5 – Service workload */
    @GetMapping("/service-workload")
    public ResponseEntity<List<Object[]>> serviceWorkload(
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer month,
            @RequestParam(required = false) Long dealerId) {
        Long effectiveDealerId = DealerContext.isCurrentSuperAdmin() ? dealerId : DealerContext.getCurrentDealerId();
        return ResponseEntity.ok(serviceRepo.getWorkloadSummary(year, month, effectiveDealerId));
    }

    /** Custom – Stock distribution by model */
    @GetMapping("/stock-by-model")
    public ResponseEntity<List<Object[]>> stockByModel(
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer month,
            @RequestParam(required = false) Long dealerId) {
        Long effectiveDealerId = DealerContext.isCurrentSuperAdmin() ? dealerId : DealerContext.getCurrentDealerId();
        return ResponseEntity.ok(vehicleRepo.getStockByModelCount(year, month, effectiveDealerId));
    }

    /** Custom – Bookings distribution by model */
    @GetMapping("/bookings-by-model")
    public ResponseEntity<List<Object[]>> bookingsByModel(
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer month,
            @RequestParam(required = false) Long dealerId) {
        Long effectiveDealerId = DealerContext.isCurrentSuperAdmin() ? dealerId : DealerContext.getCurrentDealerId();
        return ResponseEntity.ok(bookingRepo.getBookingsByModelCount(year, month, effectiveDealerId));
    }
}