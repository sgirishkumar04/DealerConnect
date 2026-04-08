package com.dealerconnect.service.impl;

import com.dealerconnect.security.DealerContext;
import com.dealerconnect.repository.DealerRepository;

import com.dealerconnect.dto.request.EmployeeRequest;
import com.dealerconnect.entity.*;
import com.dealerconnect.exception.ResourceNotFoundException;
import com.dealerconnect.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.*;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.dealerconnect.util.PasswordValidator;

@Service
@RequiredArgsConstructor
public class EmployeeService {

    private final EmployeeRepository employeeRepo;
    private final DealerRepository dealerRepo;
    private final PasswordEncoder passwordEncoder;

    public Page<Employee> getAll(String search, Pageable pageable) {
        Long dealerId = DealerContext.getCurrentDealerId();
        return employeeRepo.searchAll(search, dealerId, pageable);
    }

    public Employee getById(Long id) {
        Long dealerId = DealerContext.getCurrentDealerId();
        return employeeRepo.findById(id)
            .filter(e -> e.getDealer() == null || e.getDealer().getId().equals(dealerId) || DealerContext.isCurrentSuperAdmin())
            .orElseThrow(() -> new ResourceNotFoundException("Employee not found: " + id));
    }

    public Employee getByEmail(String email) {
        return employeeRepo.findByEmailAndIsActiveTrue(email)
            .orElseThrow(() -> new ResourceNotFoundException("Employee not found for email: " + email));
    }

    @Transactional
    public Employee create(EmployeeRequest req) {
        Long dealerId = DealerContext.getCurrentDealerId();
        
        if (req.getPassword() == null || req.getPassword().isBlank()) {
            throw new IllegalArgumentException("Password is required for new employees");
        }
        
        if (!PasswordValidator.isValid(req.getPassword())) {
            throw new IllegalArgumentException(PasswordValidator.getRequirementsMessage());
        }
        
        String employeeCode = generateNextEmployeeCode(dealerId);

        Employee emp = Employee.builder()
            .employeeCode(employeeCode)
            .firstName(req.getFirstName())
            .lastName(req.getLastName())
            .email(req.getEmail())
            .phone(req.getPhone())
            .passwordHash(passwordEncoder.encode(req.getPassword()))
            .dateOfJoin(req.getDateOfJoin())
            .dealer(dealerRepo.findById(dealerId).orElse(null))
            .isActive(true)
            .build();

        // Resolve department and role via lazy-initialized repos
        emp.setDepartment(Department.builder().id(req.getDepartmentId()).build());
        emp.getRoles().add(Role.builder().id(req.getRoleId()).build());
        if (req.getManagerId() != null)
            emp.setManager(Employee.builder().id(req.getManagerId()).build());

        return employeeRepo.save(emp);
    }

    private String generateNextEmployeeCode(Long dealerId) {
        String maxCode = employeeRepo.findMaxEmployeeCode(dealerId);
        int nextId = 1;
        if (maxCode != null && maxCode.contains("-")) {
            try {
                String numPart = maxCode.substring(maxCode.lastIndexOf("-") + 1);
                nextId = Integer.parseInt(numPart) + 1;
            } catch (Exception e) {
                nextId = (int)(employeeRepo.countByDealerId(dealerId) + 1);
            }
        } else {
            nextId = (int)(employeeRepo.countByDealerId(dealerId) + 1);
        }
        return String.format("EMP-DLR%02d-%04d", dealerId, nextId);
    }

    @Transactional
    public Employee update(Long id, EmployeeRequest req) {
        Employee emp = getById(id);
        emp.setFirstName(req.getFirstName());
        emp.setLastName(req.getLastName());
        emp.setPhone(req.getPhone());
        
        if (req.getPassword() != null && !req.getPassword().isBlank()) {
            if (!PasswordValidator.isValid(req.getPassword())) {
                throw new IllegalArgumentException(PasswordValidator.getRequirementsMessage());
            }
            emp.setPasswordHash(passwordEncoder.encode(req.getPassword()));
        }
        
        emp.setDepartment(Department.builder().id(req.getDepartmentId()).build());
        emp.getRoles().clear();
        emp.getRoles().add(Role.builder().id(req.getRoleId()).build());
        if (req.getManagerId() != null)
            emp.setManager(Employee.builder().id(req.getManagerId()).build());
        return employeeRepo.save(emp);
    }

    @Transactional
    public void deactivate(Long id) {
        Employee target = getById(id);
        Employee currentUser = employeeRepo.findByEmail(org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication().getName())
            .orElseThrow(() -> new RuntimeException("Current user not found"));

        boolean isSuperAdmin = DealerContext.isCurrentSuperAdmin();
        boolean targetIsAdmin = target.getRoles().stream().anyMatch(r -> "ADMIN".equals(r.getName()));

        // 1. Prevent deactivating a Super Admin (Global Policy)
        if (target.getRoles().stream().anyMatch(r -> "SUPER_ADMIN".equals(r.getName()))) {
            throw new org.springframework.security.access.AccessDeniedException("Cannot deactivate a Super Admin");
        }

        // 2. Only Super Admin can deactivate an ADMIN
        if (targetIsAdmin && !isSuperAdmin) {
            throw new org.springframework.security.access.AccessDeniedException("Only a Super Admin can deactivate an Admin account");
        }

        // 3. Admin can deactivate others, but not fellow Admins (covered above)
        // No additional check needed if we assume standard Spring Security @PreAuthorize handles basic access.

        if (target.getIsActive()) {
            target.setIsActive(false);
            target.setDeactivatedByName(currentUser.getFirstName() + " " + currentUser.getLastName());
            target.setDeactivatedAt(java.time.LocalDateTime.now());
        } else {
            // Reactivate
            target.setIsActive(true);
            target.setDeactivatedByName(null);
            target.setDeactivatedAt(null);
        }
        
        employeeRepo.save(target);
    }

    @Transactional
    public void unlock(Long id) {
        Employee emp = getById(id);
        emp.setFailedLoginAttempts(0);
        emp.setIsLocked(false);
        employeeRepo.save(emp);
    }
}
