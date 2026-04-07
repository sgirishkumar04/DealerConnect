package com.dealerconnect.repository;

import com.dealerconnect.entity.AuditLog;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.time.LocalDateTime;

public interface AuditLogRepositoryCustom {
    Page<AuditLog> searchLogs(Long dealerId, String entityName, String action, 
                             LocalDateTime start, LocalDateTime end, Pageable pageable);
}
