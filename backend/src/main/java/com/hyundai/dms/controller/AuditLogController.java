package com.hyundai.dms.controller;

import com.hyundai.dms.entity.AuditLog;
import com.hyundai.dms.entity.QAuditLog;
import com.hyundai.dms.repository.AuditLogRepository;
import com.querydsl.core.BooleanBuilder;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;

@RestController
@RequestMapping("/audit-logs")
@RequiredArgsConstructor
@CrossOrigin(origins = "http://localhost:4200", allowCredentials = "true")
public class AuditLogController {

    private final AuditLogRepository auditRepo;

    @GetMapping
    @PreAuthorize("hasRole('SUPER_ADMIN')")
    public ResponseEntity<Page<AuditLog>> getLogs(
            @RequestParam(required = false) Long dealerId,
            @RequestParam(required = false) String entityName,
            @RequestParam(required = false) String action,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        
        QAuditLog log = QAuditLog.auditLog;
        BooleanBuilder builder = new BooleanBuilder();

        if (dealerId != null) builder.and(log.dealerId.eq(dealerId));
        if (entityName != null && !entityName.isEmpty()) builder.and(log.entityName.equalsIgnoreCase(entityName));
        if (action != null && !action.isEmpty()) builder.and(log.action.equalsIgnoreCase(action));
        if (startDate != null) builder.and(log.createdAt.goe(startDate));
        if (endDate != null) builder.and(log.createdAt.loe(endDate));

        Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
        
        // If no filters are applied, builder.getValue() is null. 
        // QuerydslPredicateExecutor.findAll(Predicate, Pageable) handles null as "no predicate".
        return ResponseEntity.ok(auditRepo.findAll(builder, pageable));
    }
}