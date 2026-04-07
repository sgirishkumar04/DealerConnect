package com.dealerconnect.controller;

import com.dealerconnect.service.impl.LookupService;
import com.dealerconnect.entity.*;
import lombok.RequiredArgsConstructor;
import org.springframework.http.CacheControl;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;
import java.util.concurrent.TimeUnit;

/**
 * Provides all dropdown / lookup data for the Angular frontend.
 * Every listed endpoint is read-only (GET only).
 */
@RestController
@RequestMapping("/lookup")
@RequiredArgsConstructor
public class LookupController {

    private final LookupService lookupService;

    private <T> ResponseEntity<List<T>> cached(List<T> data) {
        return ResponseEntity.ok()
            .cacheControl(CacheControl.maxAge(1, TimeUnit.HOURS).cachePublic())
            .body(data);
    }

    @GetMapping("/roles")          public ResponseEntity<List<Role>>              roles()       { 
        return ResponseEntity.ok()
            .cacheControl(CacheControl.noCache())
            .header("Pragma", "no-cache")
            .header("Expires", "0")
            .body(lookupService.getRoles()); 
    }
    @GetMapping("/departments")    public ResponseEntity<List<Department>>         departments() { return cached(lookupService.getDepartments()); }
    @GetMapping("/vehicle-models") public ResponseEntity<List<VehicleModel>>       models()      { return cached(lookupService.getModels()); }
    @GetMapping("/vehicle-variants") public ResponseEntity<List<VehicleVariant>>   variants()    { return cached(lookupService.getVariants()); }
    @GetMapping("/vehicle-variants/{modelId}") public ResponseEntity<List<VehicleVariant>> variantsByModel(@PathVariable Long modelId) {
        return cached(lookupService.getVariantsByModel(modelId));
    }
    @GetMapping("/colors")         public ResponseEntity<List<Color>>             colors()      { return cached(lookupService.getColors()); }
    @GetMapping("/engine-types")   public ResponseEntity<List<EngineType>>        engineTypes() { return cached(lookupService.getEngineTypes()); }
    @GetMapping("/locations")      public ResponseEntity<List<InventoryLocation>>  locations()   { return cached(lookupService.getLocations()); }
    @GetMapping("/lead-sources")   public ResponseEntity<List<LeadSource>>        leadSources() { return cached(lookupService.getLeadSources()); }
    @GetMapping("/suppliers")      public ResponseEntity<List<Supplier>>          suppliers()   { return cached(lookupService.getSuppliers()); }
    @GetMapping("/banks")          public ResponseEntity<List<Bank>>              banks()       { return cached(lookupService.getBanks()); }
}