package com.dealerconnect.service.impl;

import com.dealerconnect.entity.*;
import com.dealerconnect.entity.Dealer.DealerStatus;
import com.dealerconnect.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class DealerRegistrationService {

    private final DealerRegistrationRepository regRepo;
    private final DealerRepository dealerRepo;
    private final EmployeeRepository employeeRepo;
    private final RoleRepository roleRepo;
    private final DepartmentRepository deptRepo;
    private final PasswordEncoder passwordEncoder;

    /** Submit a new dealer registration (public endpoint – no auth required) */
    @Transactional
    public DealerRegistration register(DealerRegistration request) {
        if (regRepo.existsByAdminEmail(request.getAdminEmail())) {
            throw new IllegalArgumentException("An account with this email is already registered or pending.");
        }
        // Hash the password before saving
        request.setAdminPasswordHash(passwordEncoder.encode(request.getAdminPasswordHash()));
        request.setStatus(DealerStatus.PENDING);
        request.setCreatedAt(LocalDateTime.now());
        return regRepo.save(request);
    }

    /** List pending registrations — SUPER_ADMIN only */
    public List<DealerRegistration> getPending() {
        return regRepo.findByStatus(DealerStatus.PENDING);
    }

    /** List all registrations — SUPER_ADMIN only */
    public List<DealerRegistration> getAll() {
        return regRepo.findAll();
    }

    /** Approve a pending registration — SUPER_ADMIN only */
    @Transactional
    public DealerRegistration approve(Long regId) {
        DealerRegistration reg = regRepo.findById(regId)
            .orElseThrow(() -> new IllegalArgumentException("Registration not found: " + regId));

        if (reg.getStatus() != DealerStatus.PENDING) {
            throw new IllegalStateException("Registration is not PENDING.");
        }

        // 1. Create Dealer record
        String dealerCode = "DLR-" + reg.getCity().toUpperCase().substring(0, Math.min(3, reg.getCity().length()))
                            + "-" + System.currentTimeMillis() % 10000;
        
        // Handle potential empty GST number to avoid UNIQUE collision on empty strings
        String gst = reg.getGstNumber();
        if (gst != null && gst.trim().isEmpty()) {
            gst = null;
        }

        Dealer dealer = dealerRepo.save(Dealer.builder()
            .dealerCode(dealerCode)
            .name(reg.getDealerName())
            .city(reg.getCity())
            .state(reg.getState())
            .address(reg.getAddress())
            .gstNumber(gst)
            .contactName(reg.getContactName())
            .contactPhone(reg.getContactPhone())
            .contactEmail(reg.getAdminEmail())
            .status(DealerStatus.ACTIVE)
            .build());

        // 2. Create the dealer ADMIN employee
        Role adminRole = roleRepo.findByName("ADMIN")
            .orElseThrow(() -> new RuntimeException("ADMIN role not found"));
        Department adminDept = deptRepo.findAll().stream()
            .filter(d -> d.getName().equalsIgnoreCase("Administration"))
            .findFirst()
            .orElseGet(() -> deptRepo.save(Department.builder().name("Administration").description("Admin & HR").build()));

        // Generate employee code (using registration ID to ensure uniqueness)
        String empCode = String.format("DLR%02d-ADM", dealer.getId());

        String[] nameParts = reg.getAdminFullName().trim().split(" ", 2);
        String firstName = nameParts[0];
        String lastName = nameParts.length > 1 ? nameParts[1] : "-";

        employeeRepo.save(Employee.builder()
            .employeeCode(empCode)
            .firstName(firstName)
            .lastName(lastName)
            .email(reg.getAdminEmail())
            .phone(reg.getContactPhone())
            .passwordHash(reg.getAdminPasswordHash()) // already hashed
            .department(adminDept)
            .role(adminRole)
            .dealer(dealer)
            .isActive(true)
            .build());

        // 3. Update registration status
        reg.setStatus(DealerStatus.ACTIVE);
        reg.setDealer(dealer);
        reg.setReviewedAt(LocalDateTime.now());
        return regRepo.save(reg);
    }

    /** Decline a pending registration — SUPER_ADMIN only */
    @Transactional
    public DealerRegistration decline(Long regId, String reason) {
        DealerRegistration reg = regRepo.findById(regId)
            .orElseThrow(() -> new IllegalArgumentException("Registration not found: " + regId));

        if (reg.getStatus() != DealerStatus.PENDING) {
            throw new IllegalStateException("Registration is not PENDING.");
        }

        reg.setStatus(DealerStatus.DECLINED);
        reg.setRejectionReason(reason);
        reg.setReviewedAt(LocalDateTime.now());
        return regRepo.save(reg);
    }

    @Transactional
    public Dealer toggleDealerStatus(Long dealerId) {
        Dealer dealer = dealerRepo.findById(dealerId)
            .orElseThrow(() -> new IllegalArgumentException("Dealer not found: " + dealerId));

        Employee currentUser = employeeRepo.findByEmail(org.springframework.security.core.context.SecurityContextHolder.getContext().getAuthentication().getName())
            .orElseThrow(() -> new RuntimeException("Current user not found"));

        if (dealer.getStatus() == DealerStatus.ACTIVE) {
            dealer.setStatus(DealerStatus.DEACTIVATED);
            dealer.setDeactivatedByName(currentUser.getFirstName() + " " + currentUser.getLastName());
            dealer.setDeactivatedAt(LocalDateTime.now());
        } else if (dealer.getStatus() == DealerStatus.DEACTIVATED) {
            dealer.setStatus(DealerStatus.ACTIVE);
            dealer.setDeactivatedByName(null);
            dealer.setDeactivatedAt(null);
        } else {
            throw new IllegalStateException("Dealer is not in a togglable state (Current status: " + dealer.getStatus() + ")");
        }

        return dealerRepo.save(dealer);
    }
}
