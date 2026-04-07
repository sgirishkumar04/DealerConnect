package com.dealerconnect.dto.request;

import jakarta.validation.constraints.*;
import lombok.*;
import java.time.LocalDate;

@Data @NoArgsConstructor @AllArgsConstructor
public class LeadRequest {
    @NotBlank @Size(max = 20) private String leadNumber;
    private Long customerId;
    private String customerName;
    private String customerPhone;
    @NotNull  private Long sourceId;
    @NotNull  private Long assignedTo;
    private Long preferredModelId;
    private Long preferredVariantId;
    private Long preferredColorId;
    private String status;
    private String remarks;
    private LocalDate expectedCloseDate;
}
