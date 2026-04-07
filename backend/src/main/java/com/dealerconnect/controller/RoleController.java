package com.dealerconnect.controller;

import com.dealerconnect.entity.Permission;
import com.dealerconnect.entity.Role;
import com.dealerconnect.repository.PermissionRepository;
import com.dealerconnect.repository.RoleRepository;
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