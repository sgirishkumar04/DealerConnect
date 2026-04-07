-- ═══════════════════════════════════════════════════════════════════
--  DEALERCONNECT – DASHBOARD FIX
--  Restores missing stored procedures with multi-dealer support.
-- ═══════════════════════════════════════════════════════════════════

USE dealerconnect;

-- 1. Monthly Bookings
DROP PROCEDURE IF EXISTS GetMonthlyBookings;
DELIMITER $$
CREATE PROCEDURE GetMonthlyBookings(IN p_year INT, IN p_dealer_id BIGINT)
BEGIN
    SELECT
        DATE_FORMAT(b.created_at, '%Y-%m') AS month_label,
        COUNT(*) AS booking_count,
        COALESCE(SUM(b.total_on_road), 0) AS total_revenue
    FROM bookings b
    WHERE (p_dealer_id IS NULL OR b.dealer_id = p_dealer_id)
      AND (p_year IS NULL OR YEAR(b.created_at) = p_year)
    GROUP BY month_label
    ORDER BY month_label DESC
    LIMIT 12;
END$$
DELIMITER ;

-- 2. Top Selling Models
DROP PROCEDURE IF EXISTS GetTopSellingModels;
DELIMITER $$
CREATE PROCEDURE GetTopSellingModels(IN p_year INT, IN p_month INT, IN p_dealer_id BIGINT)
BEGIN
    SELECT
        vm.model_name           AS model_name,
        COUNT(b.id)             AS booking_count
    FROM bookings b
    JOIN vehicle_variants vv ON b.variant_id = vv.id
    JOIN vehicle_models   vm ON vv.model_id  = vm.id
    WHERE (p_dealer_id IS NULL OR b.dealer_id = p_dealer_id)
      AND (p_year IS NULL  OR YEAR(b.created_at)  = p_year)
      AND (p_month IS NULL OR MONTH(b.created_at) = p_month)
    GROUP BY vm.model_name
    ORDER BY booking_count DESC
    LIMIT 8;
END$$
DELIMITER ;

-- 3. Bookings By Model Count
DROP PROCEDURE IF EXISTS GetBookingsByModelCount;
DELIMITER $$
CREATE PROCEDURE GetBookingsByModelCount(IN p_year INT, IN p_month INT, IN p_dealer_id BIGINT)
BEGIN
    SELECT
        vm.model_name           AS model_name,
        COUNT(b.id)             AS booking_count
    FROM bookings b
    JOIN vehicle_variants vv ON b.variant_id = vv.id
    JOIN vehicle_models   vm ON vv.model_id  = vm.id
    WHERE (p_dealer_id IS NULL OR b.dealer_id = p_dealer_id)
      AND (p_year IS NULL  OR YEAR(b.created_at)  = p_year)
      AND (p_month IS NULL OR MONTH(b.created_at) = p_month)
    GROUP BY vm.model_name
    ORDER BY booking_count DESC;
END$$
DELIMITER ;

-- 4. Lead Funnel Counts
DROP PROCEDURE IF EXISTS GetLeadFunnelCounts;
DELIMITER $$
CREATE PROCEDURE GetLeadFunnelCounts(IN p_year INT, IN p_month INT, IN p_dealer_id BIGINT)
BEGIN
    SELECT
        l.status                AS lead_status,
        COUNT(*)                AS lead_count
    FROM leads l
    WHERE (p_dealer_id IS NULL OR l.dealer_id = p_dealer_id)
      AND (p_year IS NULL  OR YEAR(l.created_at)  = p_year)
      AND (p_month IS NULL OR MONTH(l.created_at) = p_month)
    GROUP BY l.status
    ORDER BY lead_count DESC;
END$$
DELIMITER ;

-- 5. Inventory Status Summary
DROP PROCEDURE IF EXISTS GetInventoryStatusSummary;
DELIMITER $$
CREATE PROCEDURE GetInventoryStatusSummary(IN p_year INT, IN p_month INT, IN p_dealer_id BIGINT)
BEGIN
    SELECT
        v.status                AS vehicle_status,
        COUNT(*)                AS vehicle_count
    FROM vehicles v
    WHERE (p_dealer_id IS NULL OR v.dealer_id = p_dealer_id)
    GROUP BY v.status
    ORDER BY vehicle_count DESC;
END$$
DELIMITER ;

-- 6. Stock By Model Count
DROP PROCEDURE IF EXISTS GetStockByModelCount;
DELIMITER $$
CREATE PROCEDURE GetStockByModelCount(IN p_year INT, IN p_month INT, IN p_dealer_id BIGINT)
BEGIN
    SELECT
        vm.model_name           AS model_name,
        COUNT(v.id)             AS stock_count
    FROM vehicles v
    JOIN vehicle_variants vv ON v.variant_id = vv.id
    JOIN vehicle_models   vm ON vv.model_id  = vm.id
    WHERE (p_dealer_id IS NULL OR v.dealer_id = p_dealer_id)
      AND v.status = 'IN_STOCK'
    GROUP BY vm.model_name
    ORDER BY stock_count DESC;
END$$
DELIMITER ;

-- 7. Workload Summary
DROP PROCEDURE IF EXISTS GetWorkloadSummary;
DELIMITER $$
CREATE PROCEDURE GetWorkloadSummary(IN p_year INT, IN p_month INT, IN p_dealer_id BIGINT)
BEGIN
    SELECT
        sa.status               AS appointment_status,
        COUNT(*)                AS appointment_count
    FROM service_appointments sa
    WHERE (p_dealer_id IS NULL OR sa.dealer_id = p_dealer_id)
      AND (p_year IS NULL  OR YEAR(sa.appointment_date)  = p_year)
      AND (p_month IS NULL OR MONTH(sa.appointment_date) = p_month)
    GROUP BY sa.status
    ORDER BY appointment_count DESC;
END$$
DELIMITER ;
