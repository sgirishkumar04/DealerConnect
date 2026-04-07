package com.dealerconnect.dto.request;

import lombok.Data;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
public class BookingRequest {
    private Long customerId;
    private String customerName; // For Guest
    private String customerPhone; // For Guest
    
    private Long vehicleId;
    private Long salesExecId;
    
    private BigDecimal exShowroom;
    private BigDecimal discount;
    private BigDecimal tcsAmt;
    private BigDecimal registrationAmt;
    private BigDecimal insuranceAmt;
    private BigDecimal accessoriesAmt;
    private BigDecimal totalOnRoad;
    
    private LocalDateTime expectedDelivery;
    private String remarks;
}
