package com.hyundai.dms.controller;

import com.hyundai.dms.dto.request.LeadRequest;
import com.hyundai.dms.entity.Lead;
import com.hyundai.dms.service.impl.LeadService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.*;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/leads")
@RequiredArgsConstructor
public class LeadController {

    private final LeadService leadService;

    @GetMapping
    public ResponseEntity<Page<Lead>> getAll(
        @RequestParam(required = false) String status,
        @RequestParam(required = false) Long execId,
        @RequestParam(defaultValue = "0") int page,
        @RequestParam(defaultValue = "10") int size) {
        return ResponseEntity.ok(leadService.getAll(status, execId, PageRequest.of(page, size)));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Lead> getById(@PathVariable Long id) {
        return ResponseEntity.ok(leadService.getById(id));
    }

    @PostMapping
    public ResponseEntity<Lead> create(@Valid @RequestBody LeadRequest req) {
        return ResponseEntity.status(HttpStatus.CREATED).body(leadService.create(req));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Lead> update(@PathVariable Long id, @Valid @RequestBody LeadRequest req) {
        return ResponseEntity.ok(leadService.update(id, req));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        leadService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/funnel-summary")
    public ResponseEntity<List<Object[]>> funnelSummary() {
        return ResponseEntity.ok(leadService.getFunnelSummary());
    }

    @GetMapping("/next-number")
    public ResponseEntity<String> getNextLeadNumber() {
        return ResponseEntity.ok(leadService.generateNextLeadNumber());
    }
}