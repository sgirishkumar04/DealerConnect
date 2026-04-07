package com.dealerconnect.controller;

import com.dealerconnect.dto.request.VehicleRequest;
import com.dealerconnect.dto.response.VehicleDetailsDTO;
import com.dealerconnect.entity.Vehicle;
import com.dealerconnect.service.impl.VehicleService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.*;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/vehicles")
@RequiredArgsConstructor
public class VehicleController {

    private final VehicleService vehicleService;

    @GetMapping
    public ResponseEntity<Page<Vehicle>> getAll(
        @RequestParam(required = false) String status,
        @RequestParam(required = false) Long modelId,
        @RequestParam(defaultValue = "0") int page,
        @RequestParam(defaultValue = "10") int size) {
        return ResponseEntity.ok(
            vehicleService.getAll(status, modelId, PageRequest.of(page, size)));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Vehicle> getById(@PathVariable Long id) {
        return ResponseEntity.ok(vehicleService.getById(id));
    }

    @GetMapping("/{id}/details")
    public ResponseEntity<VehicleDetailsDTO> getDetails(@PathVariable Long id) {
        return ResponseEntity.ok(vehicleService.getVehicleDetails(id));
    }

    @PostMapping
    public ResponseEntity<Vehicle> create(@Valid @RequestBody VehicleRequest req) {
        return ResponseEntity.status(HttpStatus.CREATED).body(vehicleService.create(req));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Vehicle> update(@PathVariable Long id, @Valid @RequestBody VehicleRequest req) {
        return ResponseEntity.ok(vehicleService.update(id, req));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        vehicleService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @PatchMapping("/{id}/status")
    public ResponseEntity<Vehicle> updateStatus(@PathVariable Long id, @RequestParam String status) {
        return ResponseEntity.ok(vehicleService.updateStatus(id, status));
    }

    @GetMapping("/inventory-summary")
    public ResponseEntity<List<Object[]>> inventorySummary() {
        return ResponseEntity.ok(vehicleService.getInventorySummary());
    }
}