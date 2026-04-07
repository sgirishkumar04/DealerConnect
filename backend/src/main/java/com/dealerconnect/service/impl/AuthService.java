package com.dealerconnect.service.impl;

import com.dealerconnect.dto.request.LoginRequest;
import com.dealerconnect.dto.response.AuthResponse;
import com.dealerconnect.entity.Employee;
import com.dealerconnect.entity.Dealer.DealerStatus;
import com.dealerconnect.repository.EmployeeRepository;
import com.dealerconnect.security.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final AuthenticationManager authManager;
    private final JwtTokenProvider tokenProvider;
    private final EmployeeRepository employeeRepository;

    public AuthResponse login(LoginRequest request) {
        Authentication auth = authManager.authenticate(
            new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword()));

        UserDetails userDetails = (UserDetails) auth.getPrincipal();
        Employee emp = employeeRepository.findByEmail(request.getEmail())
            .orElseThrow(() -> new RuntimeException("Employee record not found"));

        if (!Boolean.TRUE.equals(emp.getIsActive())) {
            String adminName = emp.getDeactivatedByName() != null ? emp.getDeactivatedByName() : "System Admin";
            throw new DisabledException("Your account was deactivated by Admin " + adminName + ". Please contact them for assistance.");
        }

        // 2. Check Dealership Status
        if (emp.getDealer() != null && emp.getDealer().getStatus() == DealerStatus.DEACTIVATED) {
            String saName = emp.getDealer().getDeactivatedByName() != null ? emp.getDealer().getDeactivatedByName() : "Super Admin";
            throw new DisabledException("The dealership [" + emp.getDealer().getName() + "] has been deactivated by " + saName + ". Please contact support.");
        }

        boolean isSuperAdmin = "SUPER_ADMIN".equals(emp.getRole().getName());
        Long dealerId = (emp.getDealer() != null) ? emp.getDealer().getId() : null;

        String token = tokenProvider.generateToken(userDetails, dealerId, isSuperAdmin);

        return AuthResponse.builder()
            .token(token)
            .email(emp.getEmail())
            .role(emp.getRole().getName())
            .fullName(emp.getFirstName() + " " + emp.getLastName())
            .employeeId(emp.getId())
            .dealerId(dealerId)
            .isSuperAdmin(isSuperAdmin)
            .permissions(emp.getRole().getPermissions() != null
                ? emp.getRole().getPermissions().stream().map(p -> p.getName()).toList()
                : java.util.List.of())
            .build();
    }
}
