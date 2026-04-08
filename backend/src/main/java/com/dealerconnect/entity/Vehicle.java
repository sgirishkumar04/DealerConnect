package com.dealerconnect.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@Entity
@Table(name = "vehicles",
    indexes = {
        @Index(columnList = "status"),
        @Index(columnList = "variant_id"),
        @Index(columnList = "location_id")
    })
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class Vehicle extends AbstractAuditable {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 17)
    private String vin;
    
    @Column(name = "engine_number", unique = true)
    private String engineNumber;

    @Column(name = "chassis_number", unique = true)
    private String chassisNumber;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "variant_id", nullable = false)
    private VehicleVariant variant;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "color_id", nullable = false)
    private Color color;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "location_id", nullable = false)
    private InventoryLocation location;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "dealer_id")
    private Dealer dealer;

    @Column(name = "mfg_year")
    private Integer mfgYear;

    @Column(name = "mfg_date")
    private LocalDate mfgDate;

    @Column(name = "arrival_date")
    private LocalDate arrivalDate;

    @Builder.Default
    @Enumerated(EnumType.STRING)
    @Column(length = 20)
    private VehicleStatus status = VehicleStatus.IN_STOCK;

    @Column(name = "invoice_date")
    private LocalDate invoiceDate;

    @Column(name = "dealer_cost", precision = 12, scale = 2)
    private BigDecimal dealerCost;

    @Builder.Default
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    @Builder.Default
    @Column(name = "updated_at")
    private LocalDateTime updatedAt = LocalDateTime.now();

    @PreUpdate
    public void preUpdate() { this.updatedAt = LocalDateTime.now(); }

    public enum VehicleStatus { IN_STOCK, ALLOCATED, SOLD, IN_TRANSIT, DEMO }
}
