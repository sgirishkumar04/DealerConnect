package com.dealerconnect.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@Entity
@Table(name = "vehicle_variants",
    indexes = { @Index(columnList = "model_id") })
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class VehicleVariant {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "model_id", nullable = false)
    private VehicleModel model;

    @Column(name = "variant_code", nullable = false, unique = true, length = 20)
    private String variantCode;

    @Column(name = "variant_name", nullable = false, length = 100)
    private String variantName;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "engine_type_id", nullable = false)
    private EngineType engineType;

    @Column(length = 30)
    private String transmission;

    @Builder.Default
    @Column(name = "seating_capacity")
    private Integer seatingCapacity = 5;

    @Column(name = "ex_showroom_price", nullable = false, precision = 12, scale = 2)
    private BigDecimal exShowroomPrice;

    @Builder.Default
    @Column(name = "is_active")
    private Boolean isActive = true;

    @Builder.Default
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt = LocalDateTime.now();
}
