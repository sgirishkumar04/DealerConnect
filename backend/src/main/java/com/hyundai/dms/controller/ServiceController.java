package com.hyundai.dms.controller;

import com.hyundai.dms.entity.ServiceAppointment;
import com.hyundai.dms.repository.ServiceAppointmentRepository;
import com.hyundai.dms.security.DealerContext;
import com.hyundai.dms.repository.DealerRepository;
import com.hyundai.dms.entity.Dealer;
import com.hyundai.dms.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.*;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/service")
@RequiredArgsConstructor
public class ServiceController {

    private final ServiceAppointmentRepository appointmentRepo;
    private final DealerRepository dealerRepo;

    @GetMapping("/appointments")
    public ResponseEntity<Page<ServiceAppointment>> getAll(
        @RequestParam(required = false) String status,
        @RequestParam(defaultValue = "0") int page,
        @RequestParam(defaultValue = "10") int size) {
        Long dealerId = DealerContext.getCurrentDealerId();
        Pageable pageable = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "appointmentDate"));
        if (status != null)
            return ResponseEntity.ok(appointmentRepo.findByStatusAndDealerId(
                ServiceAppointment.AppointmentStatus.valueOf(status), dealerId, pageable));
        return ResponseEntity.ok(appointmentRepo.findByDealerId(dealerId, pageable));
    }

    @GetMapping("/appointments/{id}")
    public ResponseEntity<ServiceAppointment> getById(@PathVariable Long id) {
        return appointmentRepo.findById(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping("/appointments")
    public ResponseEntity<ServiceAppointment> create(@RequestBody ServiceAppointment appointment) {
        Long dealerId = DealerContext.getCurrentDealerId();
        Dealer dealer = dealerRepo.findById(dealerId)
                .orElseThrow(() -> new ResourceNotFoundException("Dealer not found"));
        appointment.setDealer(dealer);
        return ResponseEntity.status(HttpStatus.CREATED).body(appointmentRepo.save(appointment));
    }

    @PutMapping("/appointments/{id}")
    public ResponseEntity<ServiceAppointment> update(@PathVariable Long id,
                                                     @RequestBody ServiceAppointment appointment) {
        return appointmentRepo.findById(id).map(existing -> {
            existing.setAppointmentDate(appointment.getAppointmentDate());
            existing.setServiceType(appointment.getServiceType());
            existing.setStatus(appointment.getStatus());
            existing.setRemarks(appointment.getRemarks());
            return ResponseEntity.ok(appointmentRepo.save(existing));
        }).orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/workload")
    public ResponseEntity<List<Object[]>> workload() {
        Long dealerId = DealerContext.getCurrentDealerId();
        return ResponseEntity.ok(appointmentRepo.getWorkloadSummary(null, null, dealerId));
    }
}