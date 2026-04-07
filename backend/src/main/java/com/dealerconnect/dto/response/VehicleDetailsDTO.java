package com.dealerconnect.dto.response;

import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDate;

@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class VehicleDetailsDTO {
    // Core Vehicle Info
    private Long id;
    private String vin;
    private String engineNumber;
    private String chassisNumber;
    private String modelName;
    private String variantName;
    private String colorName;
    private String hexCode;
    private Integer mfgYear;
    private LocalDate mfgDate;
    private LocalDate arrivalDate;
    private String locationName;
    private BigDecimal dealerCost;
    private BigDecimal exShowroomPrice;
    private String status;

    // Sales Info (Optional)
    private SalesInfo salesInfo;

    @Data @NoArgsConstructor @AllArgsConstructor @Builder
    public static class SalesInfo {
        private String bookingNumber;
        private String customerName;
        private String customerEmail;
        private String customerPhone;
        private String salesExecutiveName;
        private String invoiceNumber; // Simulated or placeholder for now
        private LocalDate deliveryDate; // expected or actual
        private String bookingStatus;
    }
}
