package com.dealerconnect.service.impl;

import com.dealerconnect.entity.*;
import com.dealerconnect.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
public class LookupService {

    private final RoleRepository roleRepo;
    private final DepartmentRepository deptRepo;
    private final VehicleModelRepository modelRepo;
    private final VehicleVariantRepository variantRepo;
    private final ColorRepository colorRepo;
    private final EngineTypeRepository engineTypeRepo;
    private final InventoryLocationRepository locationRepo;
    private final LeadSourceRepository leadSourceRepo;
    private final SupplierRepository supplierRepo;
    private final BankRepository bankRepo;

    public List<Role> getRoles() { return roleRepo.findAll(); }
    
    @Cacheable(value = "lookups", key = "'departments'") 
    public List<Department> getDepartments() { return deptRepo.findAll(); }
    
    @Cacheable(value = "lookups", key = "'models'") 
    public List<VehicleModel> getModels() { return modelRepo.findAll(); }
    
    @Cacheable(value = "lookups", key = "'variants_all'") 
    public List<VehicleVariant> getVariants() { return variantRepo.findAll(); }
    
    // The default KeyGenerator will use 'modelId' here, which is perfectly safe.
    @Cacheable(value = "lookups") 
    public List<VehicleVariant> getVariantsByModel(Long modelId) { return variantRepo.findByModelId(modelId); }
    
    @Cacheable(value = "lookups", key = "'colors'") 
    public List<Color> getColors() { return colorRepo.findAll(); }
    
    @Cacheable(value = "lookups", key = "'engines'") 
    public List<EngineType> getEngineTypes() { return engineTypeRepo.findAll(); }
    
    @Cacheable(value = "lookups", key = "'locations'") 
    public List<InventoryLocation> getLocations() { return locationRepo.findAll(); }
    
    @Cacheable(value = "lookups", key = "'leadsources'") 
    public List<LeadSource> getLeadSources() { return leadSourceRepo.findAll(); }
    
    @Cacheable(value = "lookups", key = "'suppliers'") 
    public List<Supplier> getSuppliers() { return supplierRepo.findAll(); }
    
    @Cacheable(value = "lookups", key = "'banks'") 
    public List<Bank> getBanks() { return bankRepo.findAll(); }
}
