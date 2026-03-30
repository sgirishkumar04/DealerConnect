package com.hyundai.dms.controller;

import com.hyundai.dms.dto.response.DealerPerformanceDTO;
import com.hyundai.dms.dto.response.InventoryStatusDTO;
import com.hyundai.dms.dto.response.LeadVolumeDTO;
import com.hyundai.dms.entity.Dealer;
import com.hyundai.dms.entity.DealerRegistration;
import com.hyundai.dms.repository.DealerRepository;
import com.hyundai.dms.service.impl.DealerRegistrationService;
import com.hyundai.dms.service.impl.SuperAdminReportService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/dealers")
@RequiredArgsConstructor
public class DealerController {

    private final DealerRegistrationService regService;
    private final DealerRepository dealerRepo;
    private final SuperAdminReportService superAdminReportService;

    @PreAuthorize("hasRole('SUPER_ADMIN')")
    @GetMapping("/stats/performance")
    public ResponseEntity<List<DealerPerformanceDTO>> getDealerPerformance() {
        return ResponseEntity.ok(superAdminReportService.getDealerPerformance());
    }

    @PreAuthorize("hasRole('SUPER_ADMIN')")
    @GetMapping("/stats/inventory")
    public ResponseEntity<List<InventoryStatusDTO>> getNetworkInventory() {
        return ResponseEntity.ok(superAdminReportService.getNetworkInventory());
    }

    @PreAuthorize("hasRole('SUPER_ADMIN')")
    @GetMapping("/stats/leads")
    public ResponseEntity<List<LeadVolumeDTO>> getLeadEfficiency() {
        return ResponseEntity.ok(superAdminReportService.getLeadEfficiency());
    }

    @PreAuthorize("hasRole('SUPER_ADMIN')")
    @GetMapping("/stats/monthly-sales")
    public ResponseEntity<List<Object[]>> getMonthlyNetworkBookings(@RequestParam(required = false) Integer year) {
        return ResponseEntity.ok(superAdminReportService.getMonthlyNetworkBookings(year));
    }

    @PreAuthorize("hasRole('SUPER_ADMIN')")
    @GetMapping("/stats/top-models")
    public ResponseEntity<List<Object[]>> getTopSellingModelsNetworkWide(
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer month) {
        return ResponseEntity.ok(superAdminReportService.getTopSellingModelsNetworkWide(year, month));
    }

    @PreAuthorize("hasRole('SUPER_ADMIN')")
    @GetMapping("/stats/stock-by-model")
    public ResponseEntity<List<Object[]>> getStockByModelNetworkWide(
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer month) {
        return ResponseEntity.ok(superAdminReportService.getStockByModelNetworkWide(year, month));
    }

    @PreAuthorize("hasRole('SUPER_ADMIN')")
    @GetMapping("/stats/regional-sales")
    public ResponseEntity<List<Object[]>> getRegionalSalesPerformance(
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer month) {
        return ResponseEntity.ok(superAdminReportService.getRegionalSalesPerformance(year, month));
    }

    @PreAuthorize("hasRole('SUPER_ADMIN')")
    @GetMapping("/stats/discount-metrics")
    public ResponseEntity<List<Object[]>> getDiscountMetrics(
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer month) {
        return ResponseEntity.ok(superAdminReportService.getDiscountMetrics(year, month));
    }

    @PreAuthorize("hasRole('SUPER_ADMIN')")
    @GetMapping("/stats/pipeline")

    public ResponseEntity<List<Object[]>> getNetworkLeadPipeline(
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer month) {
        return ResponseEntity.ok(superAdminReportService.getNetworkLeadPipeline(year, month));
    }

    @PreAuthorize("hasRole('SUPER_ADMIN')")
    @GetMapping("/stats/service-workload")
    public ResponseEntity<List<Object[]>> getDealershipServiceWorkload(
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer month) {
        return ResponseEntity.ok(superAdminReportService.getDealershipServiceWorkload(year, month));
    }

    // ── Public: register as a new dealer ─────────────────────────────────────
    @PostMapping("/register")
    public ResponseEntity<DealerRegistration> register(@RequestBody DealerRegistration request) {
        return ResponseEntity.ok(regService.register(request));
    }

    // ── SUPER_ADMIN: list pending registrations ───────────────────────────────
    @GetMapping("/registrations/pending")
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    public ResponseEntity<List<DealerRegistration>> getPending() {
        return ResponseEntity.ok(regService.getPending());
    }

    // ── SUPER_ADMIN: list all registrations ──────────────────────────────────
    @GetMapping("/registrations")
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    public ResponseEntity<List<DealerRegistration>> getAll() {
        return ResponseEntity.ok(regService.getAll());
    }

    // ── SUPER_ADMIN: approve ──────────────────────────────────────────────────
    @PostMapping("/registrations/{id}/approve")
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    public ResponseEntity<DealerRegistration> approve(@PathVariable Long id) {
        return ResponseEntity.ok(regService.approve(id));
    }

    // ── SUPER_ADMIN: decline ─────────────────────────────────────────────────
    @PostMapping("/registrations/{id}/decline")
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    public ResponseEntity<DealerRegistration> decline(
            @PathVariable Long id,
            @RequestBody(required = false) Map<String, String> body) {
        String reason = body != null ? body.getOrDefault("reason", "") : "";
        return ResponseEntity.ok(regService.decline(id, reason));
    }

    // ── SUPER_ADMIN: list all approved dealers ───────────────────────────────
    @GetMapping
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    public ResponseEntity<List<Dealer>> getAllDealers() {
        return ResponseEntity.ok(dealerRepo.findAll());
    }

    @PostMapping("/{id}/toggle-status")
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    public ResponseEntity<Dealer> toggleStatus(@PathVariable Long id) {
        return ResponseEntity.ok(regService.toggleDealerStatus(id));
    }
}