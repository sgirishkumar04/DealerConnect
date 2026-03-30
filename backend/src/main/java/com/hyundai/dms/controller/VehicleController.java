package com.hyundai.dms.controller;

import com.hyundai.dms.dto.request.VehicleRequest;
import com.hyundai.dms.dto.response.VehicleDetailsDTO;
import com.hyundai.dms.entity.Vehicle;
import com.hyundai.dms.service.impl.VehicleService;
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

    @GetMapping("/inventory-summary")
    public ResponseEntity<List<Object[]>> inventorySummary() {
        return ResponseEntity.ok(vehicleService.getInventorySummary());
    }
}