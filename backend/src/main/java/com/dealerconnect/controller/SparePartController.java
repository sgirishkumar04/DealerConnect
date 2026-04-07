package com.dealerconnect.controller;

import com.dealerconnect.entity.SparePart;
import com.dealerconnect.repository.SparePartRepository;
import com.dealerconnect.security.DealerContext;
import com.dealerconnect.repository.DealerRepository;
import com.dealerconnect.entity.Dealer;
import com.dealerconnect.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.*;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/parts")
@RequiredArgsConstructor
public class SparePartController {

    private final SparePartRepository partRepo;
    private final DealerRepository dealerRepo;

    @GetMapping
    @PreAuthorize("hasAuthority('PARTS_VIEW')")
    public ResponseEntity<Page<SparePart>> getAll(
            @RequestParam(required = false) String search,
            @RequestParam(required = false) String category,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        
        Long dealerId = DealerContext.getCurrentDealerId();
        Pageable pageable = PageRequest.of(page, size, Sort.by("name"));
        
        if (search != null && !search.isEmpty()) {
            return ResponseEntity.ok(partRepo.search(search, dealerId, pageable));
        }
        if (category != null && !category.isEmpty()) {
            return ResponseEntity.ok(partRepo.findByCategoryAndDealerId(category, dealerId, pageable));
        }
        
        if (DealerContext.isCurrentSuperAdmin()) {
            return ResponseEntity.ok(partRepo.findAll(pageable));
        }
        return ResponseEntity.ok(partRepo.findByDealerId(dealerId, pageable));
    }

    @GetMapping("/categories")
    @PreAuthorize("hasAuthority('PARTS_VIEW')")
    public ResponseEntity<List<String>> getCategories() {
        Long dealerId = DealerContext.getCurrentDealerId();
        return ResponseEntity.ok(partRepo.findAllCategoriesByDealerId(dealerId));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAuthority('PARTS_VIEW')")
    public ResponseEntity<SparePart> getById(@PathVariable Long id) {
        return partRepo.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    @PreAuthorize("hasAuthority('PARTS_CREATE')")
    public ResponseEntity<SparePart> create(@RequestBody SparePart part) {
        Long dealerId = DealerContext.getCurrentDealerId();
        Dealer dealer = dealerRepo.findById(dealerId)
                .orElseThrow(() -> new ResourceNotFoundException("Dealer not found"));
        part.setDealer(dealer);
        return ResponseEntity.ok(partRepo.save(part));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasAuthority('PARTS_EDIT')")
    public ResponseEntity<SparePart> update(@PathVariable Long id, @RequestBody SparePart details) {
        return partRepo.findById(id)
                .map(existing -> {
                    existing.setPartNumber(details.getPartNumber());
                    existing.setName(details.getName());
                    existing.setDescription(details.getDescription());
                    existing.setCategory(details.getCategory());
                    existing.setUnit(details.getUnit());
                    existing.setUnitPrice(details.getUnitPrice());
                    existing.setGstRate(details.getGstRate());
                    existing.setIsActive(details.getIsActive());
                    if (details.getSupplier() != null) {
                        existing.setSupplier(details.getSupplier());
                    }
                    return ResponseEntity.ok(partRepo.save(existing));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasAuthority('PARTS_DELETE')")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        if (!partRepo.existsById(id)) return ResponseEntity.notFound().build();
        partRepo.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}