package com.dealerconnect.security;

import com.dealerconnect.repository.EmployeeRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.event.EventListener;
import org.springframework.security.authentication.event.AuthenticationFailureBadCredentialsEvent;
import org.springframework.security.authentication.event.AuthenticationSuccessEvent;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Component
@Slf4j
@RequiredArgsConstructor
public class AuthenticationEventListener {

    private final EmployeeRepository employeeRepository;
    private static final int MAX_FAILED_ATTEMPTS = 5;

    @EventListener
    @Transactional
    public void onAuthenticationFailure(AuthenticationFailureBadCredentialsEvent event) {
        String email = event.getAuthentication().getName();
        log.debug("Authentication failure for user: {}", email);

        employeeRepository.findByEmail(email).ifPresent(employee -> {
            int newAttempts = (employee.getFailedLoginAttempts() != null ? employee.getFailedLoginAttempts() : 0) + 1;
            employee.setFailedLoginAttempts(newAttempts);
            if (newAttempts >= MAX_FAILED_ATTEMPTS) {
                employee.setIsLocked(true);
                log.warn("Account locked for user: {} due to {} failed attempts", email, newAttempts);
            }
            employeeRepository.save(employee);
        });
    }

    @EventListener
    @Transactional
    public void onAuthenticationSuccess(AuthenticationSuccessEvent event) {
        String email = event.getAuthentication().getName();
        log.debug("Authentication success for user: {}", email);

        employeeRepository.findByEmail(email).ifPresent(employee -> {
            if (employee.getFailedLoginAttempts() != null && employee.getFailedLoginAttempts() > 0) {
                employee.setFailedLoginAttempts(0);
                employeeRepository.save(employee);
            }
        });
    }
}
