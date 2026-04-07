package com.dealerconnect.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@Entity
@Table(name = "bookings",
    indexes = {
        @Index(columnList = "status"),
        @Index(columnList = "customer_id"),
        @Index(columnList = "sales_exec_id"),
        @Index(columnList = "dealer_id")
    })
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class Booking {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "booking_number", nullable = false, unique = true, length = 20)
    private String bookingNumber;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "lead_id")
    private Lead lead;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "customer_id", nullable = false)
    private Customer customer;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "variant_id", nullable = false)
    private VehicleVariant variant;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "color_id", nullable = false)
    private Color color;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "sales_exec_id", nullable = false)
    private Employee salesExec;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "vehicle_id")
    private Vehicle vehicle;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "dealer_id")
    private Dealer dealer;

    @Column(name = "ex_showroom", nullable = false, precision = 12, scale = 2)
    private BigDecimal exShowroom;

    @Builder.Default
    @Column(precision = 10, scale = 2)
    private BigDecimal discount = BigDecimal.ZERO;

    @Builder.Default
    @Column(name = "accessories_amt", precision = 10, scale = 2)
    private BigDecimal accessoriesAmt = BigDecimal.ZERO;

    @Builder.Default
    @Column(name = "tcs_amt", precision = 10, scale = 2)
    private BigDecimal tcsAmt = BigDecimal.ZERO;

    @Builder.Default
    @Column(name = "registration_amt", precision = 10, scale = 2)
    private BigDecimal registrationAmt = BigDecimal.ZERO;

    @Builder.Default
    @Column(name = "insurance_amt", precision = 10, scale = 2)
    private BigDecimal insuranceAmt = BigDecimal.ZERO;

    @Column(name = "total_on_road", nullable = false, precision = 12, scale = 2)
    private BigDecimal totalOnRoad;

    @Builder.Default
    @Enumerated(EnumType.STRING)
    @Column(length = 15)
    private BookingStatus status = BookingStatus.BOOKED;

    @Column(name = "expected_delivery")
    private LocalDate expectedDelivery;

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

    public enum BookingStatus { BOOKED, ALLOCATED, INVOICED, DELIVERED, CANCELLED }
}
