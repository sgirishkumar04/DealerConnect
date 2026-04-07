package com.dealerconnect.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DealerPerformanceDTO {
    private String name;
    private long totalSales;
    private double totalRevenue;
}
