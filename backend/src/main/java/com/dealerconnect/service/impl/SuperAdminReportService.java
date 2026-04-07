package com.dealerconnect.service.impl;

import com.dealerconnect.dto.response.DealerPerformanceDTO;
import com.dealerconnect.dto.response.InventoryStatusDTO;
import com.dealerconnect.dto.response.LeadVolumeDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class SuperAdminReportService {

    private final JdbcTemplate jdbcTemplate;

    // --- SALES ---
    public List<DealerPerformanceDTO> getDealerPerformance() {
        String sql = """
            SELECT 
                d.name as dealer_name, 
                COUNT(b.id) as total_sales, 
                COALESCE(SUM(b.total_on_road), 0) as total_revenue
            FROM dealers d
            LEFT JOIN bookings b ON d.id = b.dealer_id AND b.status = 'DELIVERED'
            GROUP BY d.id, d.name
            ORDER BY total_sales DESC
        """;
        return jdbcTemplate.query(sql, (rs, rowNum) -> new DealerPerformanceDTO(
                rs.getString("dealer_name"),
                rs.getLong("total_sales"),
                rs.getDouble("total_revenue")
        ));
    }

    public List<Object[]> getMonthlyNetworkBookings(Integer year) {
        String sql = """
            SELECT 
                DATE_FORMAT(b.created_at, '%Y-%m') as v_month_label,
                COUNT(b.id) as booking_count,
                COALESCE(SUM(b.total_on_road), 0) as total_revenue
            FROM bookings b
            WHERE b.status IN ('BOOKED', 'DELIVERED')
              AND (? IS NULL OR YEAR(b.created_at) = ?)
            GROUP BY v_month_label
            ORDER BY v_month_label DESC
            LIMIT 12
        """;
        return jdbcTemplate.query(sql, (rs, rowNum) -> new Object[]{
            rs.getString("v_month_label"),
            rs.getLong("booking_count"),
            rs.getDouble("total_revenue")
        }, year, year);
    }

    public List<Object[]> getTopSellingModelsNetworkWide(Integer year, Integer month) {
        String sql = """
            SELECT 
                vm.model_name as model_name,
                COUNT(b.id) as booking_count,
                COALESCE(SUM(b.total_on_road), 0) as total_revenue
            FROM bookings b
            JOIN vehicle_variants vv ON b.variant_id = vv.id
            JOIN vehicle_models vm ON vv.model_id = vm.id
            WHERE b.status IN ('BOOKED', 'DELIVERED')
              AND (? IS NULL OR YEAR(b.created_at) = ?)
              AND (? IS NULL OR MONTH(b.created_at) = ?)
            GROUP BY vm.id, vm.model_name
            ORDER BY booking_count DESC
            LIMIT 5
        """;
        return jdbcTemplate.query(sql, (rs, rowNum) -> new Object[]{
            rs.getString("model_name"),
            rs.getLong("booking_count"),
            rs.getDouble("total_revenue")
        }, year, year, month, month);
    }

    public List<Object[]> getRegionalSalesPerformance(Integer year, Integer month) {
        String sql = """
            SELECT 
                d.state,
                COUNT(b.id) as total_sales,
                COALESCE(SUM(b.total_on_road), 0) as total_revenue
            FROM dealers d
            LEFT JOIN bookings b ON d.id = b.dealer_id AND b.status IN ('BOOKED', 'DELIVERED')
                AND (? IS NULL OR YEAR(b.created_at) = ?)
                AND (? IS NULL OR MONTH(b.created_at) = ?)
            GROUP BY d.state
            ORDER BY total_sales DESC
        """;
        return jdbcTemplate.query(sql, (rs, rowNum) -> new Object[]{
            rs.getString("state") != null ? rs.getString("state") : "Unknown",
            rs.getLong("total_sales"),
            rs.getDouble("total_revenue")
        }, year, year, month, month);
    }

    public List<Object[]> getDiscountMetrics(Integer year, Integer month) {
        String sql = """
            SELECT 
                DATE_FORMAT(b.created_at, '%Y-%m') as v_month_label,
                COALESCE(SUM(b.discount), 0) as total_discount,
                COALESCE(SUM(b.total_on_road), 0) as total_revenue
            FROM bookings b
            WHERE b.status IN ('BOOKED', 'DELIVERED')
              AND (? IS NULL OR YEAR(b.created_at) = ?)
            GROUP BY v_month_label
            ORDER BY v_month_label DESC
            LIMIT 12
        """;
        return jdbcTemplate.query(sql, (rs, rowNum) -> new Object[]{
            rs.getString("v_month_label"),
            rs.getDouble("total_discount"),
            rs.getDouble("total_revenue")
        }, year, year);
    }

    // --- INVENTORY ---
    public List<InventoryStatusDTO> getNetworkInventory() {
        String sql = """
            SELECT 
                status, 
                COUNT(id) as status_count 
            FROM vehicles 
            GROUP BY status
        """;
        return jdbcTemplate.query(sql, (rs, rowNum) -> new InventoryStatusDTO(
                rs.getString("status"),
                rs.getLong("status_count")
        ));
    }

    public List<Object[]> getStockByModelNetworkWide(Integer year, Integer month) {
        // Year/month filtering is less relevant for "current stock", but kept for method signature parity
        String sql = """
            SELECT 
                vm.model_name as model_name,
                COUNT(v.id) as count
            FROM vehicles v
            JOIN vehicle_variants vv ON v.variant_id = vv.id
            JOIN vehicle_models vm ON vv.model_id = vm.id
            WHERE v.status = 'IN_STOCK'
            GROUP BY vm.id, vm.model_name
            ORDER BY count DESC
        """;
        return jdbcTemplate.query(sql, (rs, rowNum) -> new Object[]{
            rs.getString("model_name"),
            rs.getLong("count")
        });
    }

    // --- LEADS ---
    public List<LeadVolumeDTO> getLeadEfficiency() {
        String sql = """
            SELECT 
                d.name as dealer_name, 
                COUNT(l.id) as total_leads 
            FROM dealers d
            LEFT JOIN leads l ON d.id = l.dealer_id
            GROUP BY d.id, d.name
            ORDER BY total_leads DESC
        """;
        return jdbcTemplate.query(sql, (rs, rowNum) -> new LeadVolumeDTO(
                rs.getString("dealer_name"),
                rs.getLong("total_leads")
        ));
    }

    public List<Object[]> getNetworkLeadPipeline(Integer year, Integer month) {
        String sql = """
            SELECT 
                l.status as stage,
                COUNT(l.id) as count
            FROM leads l
            WHERE (? IS NULL OR YEAR(l.created_at) = ?)
              AND (? IS NULL OR MONTH(l.created_at) = ?)
            GROUP BY l.status
            ORDER BY count DESC
        """;
        return jdbcTemplate.query(sql, (rs, rowNum) -> new Object[]{
            rs.getString("stage"),
            rs.getLong("count")
        }, year, year, month, month);
    }

    // --- SERVICE ---
    public List<Object[]> getDealershipServiceWorkload(Integer year, Integer month) {
        String sql = """
            SELECT 
                d.name as dealer_name,
                COUNT(sa.id) as total_jobs,
                SUM(CASE WHEN sa.status = 'COMPLETED' THEN 1 ELSE 0 END) as completed_jobs,
                0.0 as total_revenue
            FROM dealers d
            LEFT JOIN service_appointments sa ON sa.dealer_id = d.id 
                AND (? IS NULL OR YEAR(sa.appointment_date) = ?)
                AND (? IS NULL OR MONTH(sa.appointment_date) = ?)
            GROUP BY d.id, d.name
            ORDER BY total_jobs DESC
        """;
        return jdbcTemplate.query(sql, (rs, rowNum) -> new Object[]{
            rs.getString("dealer_name"),
            rs.getLong("total_jobs"),
            rs.getLong("completed_jobs"),
            rs.getDouble("total_revenue")
        }, year, year, month, month);
    }
}
