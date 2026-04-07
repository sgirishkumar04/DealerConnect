package com.dealerconnect.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@Entity
@Table(name = "service_appointments",
    indexes = {
        @Index(columnList = "customer_id"),
        @Index(columnList = "appointment_date"),
        @Index(columnList = "status"),
        @Index(columnList = "dealer_id")
    })
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class ServiceAppointment {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "appointment_no", nullable = false, unique = true, length = 20)
    private String appointmentNo;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "customer_id", nullable = false)
    private Customer customer;

    @Column(name = "vehicle_reg_no", nullable = false, length = 20)
    private String vehicleRegNo;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "vehicle_variant_id")
    private VehicleVariant vehicleVariant;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "appointed_by", nullable = false)
    private Employee appointedBy;

    @Column(name = "appointment_date", nullable = false)
    private LocalDateTime appointmentDate;

    @Enumerated(EnumType.STRING)
    @Column(name = "service_type", nullable = false, length = 15)
    private ServiceType serviceType;

    @Builder.Default
    @Enumerated(EnumType.STRING)
    @Column(length = 15)
    private AppointmentStatus status = AppointmentStatus.SCHEDULED;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "dealer_id")
    private Dealer dealer;

    @Column(columnDefinition = "TEXT")
    private String remarks;

    @Builder.Default
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Builder.Default
    @Column(name = "updated_at")
    private LocalDateTime updatedAt = LocalDateTime.now();

    @PreUpdate
    public void preUpdate() { this.updatedAt = LocalDateTime.now(); }

    public enum ServiceType { PERIODIC, REPAIR, ACCIDENTAL, WARRANTY, RECALL, GENERAL_CHECKUP }
    public enum AppointmentStatus { SCHEDULED, IN_PROGRESS, COMPLETED, CANCELLED }
}
