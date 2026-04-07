package com.dealerconnect.dto.request;

import jakarta.validation.constraints.*;
import lombok.*;
import java.time.LocalDate;

@Data @NoArgsConstructor @AllArgsConstructor
public class VehicleRequest {
    @NotBlank @Size(max = 17) private String vin;
    private String engineNumber;
    private String chassisNumber;
    @NotNull private Long variantId;
    @NotNull private Long colorId;
    @NotNull private Long locationId;
    private Integer mfgYear;
    private LocalDate mfgDate;
    private LocalDate arrivalDate;
    private String status;
    private LocalDate invoiceDate;
    private java.math.BigDecimal dealerCost;
}
