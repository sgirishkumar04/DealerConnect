package com.dealerconnect.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.dealerconnect.entity.AuditLog;
import com.dealerconnect.repository.AuditLogRepository;
import com.dealerconnect.security.UserPrincipal;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
@Slf4j
public class AuditService {

    private final AuditLogRepository auditRepo;
    private final ObjectMapper objectMapper;

    /**
     * Captures an audit log entry.
     * Use Propagation.REQUIRES_NEW to ensure the log is saved even if the main transaction fails (optional).
     */
    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public void log(String entityName, Long entityId, String action, Object oldValue, Object newValue) {
        try {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();
            Long userId = null;
            String userName = "SYSTEM";
            Long dealerId = null;

            if (auth != null && auth.getPrincipal() instanceof UserPrincipal principal) {
                userId = principal.getId();
                userName = principal.getUsername();
                dealerId = principal.getDealerId();
            }

            String oldJson = (oldValue instanceof String s) ? s : 
                             oldValue != null ? objectMapper.writeValueAsString(oldValue) : null;
            String newJson = (newValue instanceof String s) ? s : 
                             newValue != null ? objectMapper.writeValueAsString(newValue) : null;

            AuditLog logEntry = AuditLog.builder()
                .dealerId(dealerId)
                .userId(userId)
                .userName(userName)
                .entityName(entityName)
                .entityId(entityId)
                .action(action)
                .oldValue(oldJson)
                .newValue(newJson)
                .createdAt(LocalDateTime.now())
                .build();

            auditRepo.save(logEntry);
        } catch (Exception e) {
            log.error("Failed to save audit log for {} {}: {}", entityName, entityId, e.getMessage());
        }
    }
}
