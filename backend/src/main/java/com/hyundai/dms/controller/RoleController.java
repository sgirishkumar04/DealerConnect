package com.hyundai.dms.controller;

import com.hyundai.dms.entity.Permission;
import com.hyundai.dms.entity.Role;
import com.hyundai.dms.repository.PermissionRepository;
import com.hyundai.dms.repository.RoleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.HashSet;
import java.util.List;

@RestController
@RequestMapping("/roles")
@RequiredArgsConstructor
public class RoleController {

    private final RoleRepository roleRepo;
    private final PermissionRepository permRepo;

    /**
     * Updates the granular permissions assigned to a specific role.
     * Only Full Admins can perform this action.
     */
    @PutMapping("/{id}/permissions")
    @PreAuthorize("hasAuthority('EMPLOYEES_EDIT')")
    @CacheEvict(cacheNames = "lookups", allEntries = true)
    
    public ResponseEntity<Role> updateRolePermissions(
            @PathVariable Long id,
            @RequestBody List<Long> permissionIds) {
        
        Role role = roleRepo.findById(id)
            .orElseThrow(() -> new RuntimeException("Role not found"));

        List<Permission> permissions = permRepo.findAllById(permissionIds);
        role.setPermissions(new HashSet<>(permissions));
        
        return ResponseEntity.ok(roleRepo.save(role));
    }

    /**
     * Gets all available permissions in the system for the Admin UI grid.
     */
    @GetMapping("/permissions")
    @PreAuthorize("hasAuthority('EMPLOYEES_VIEW')")
    public ResponseEntity<List<Permission>> getAllPermissions() {
        return ResponseEntity.ok(permRepo.findAll());
    }
}