-- ============================================================
--  DEALERCONNECT – Stored Procedures for Reports
-- ============================================================
USE dealerconnect;

DELIMITER //

DROP PROCEDURE IF EXISTS GetMonthlyBookings//
CREATE PROCEDURE GetMonthlyBookings(IN p_year INT)
BEGIN
    SELECT DATE_FORMAT(created_at, '%Y-%m') AS month,
           COUNT(*) AS bookings,
           SUM(total_on_road) AS amt
    FROM bookings
    WHERE status <> 'CANCELLED'
      AND (p_year IS NULL OR YEAR(created_at) = p_year)
    GROUP BY month
    ORDER BY month DESC
    LIMIT 12;
END //

DROP PROCEDURE IF EXISTS GetTopSellingModels//
CREATE PROCEDURE GetTopSellingModels(IN p_year INT, IN p_month INT)
BEGIN
    SELECT vm.model_name,
           COUNT(b.id) AS total_bookings,
           SUM(b.total_on_road) AS total_revenue
    FROM bookings b
    JOIN vehicle_variants vv ON b.variant_id = vv.id
    JOIN vehicle_models vm ON vv.model_id = vm.id
    WHERE b.status <> 'CANCELLED'
      AND (p_year IS NULL OR YEAR(b.created_at) = p_year)
      AND (p_month IS NULL OR MONTH(b.created_at) = p_month)
    GROUP BY vm.id, vm.model_name
    ORDER BY total_bookings DESC
    LIMIT 10;
END //

DROP PROCEDURE IF EXISTS GetLeadFunnelCounts//
CREATE PROCEDURE GetLeadFunnelCounts(IN p_year INT, IN p_month INT)
BEGIN
    SELECT l.status, COUNT(l.id)
    FROM leads l
    WHERE (p_year IS NULL OR YEAR(l.created_at) = p_year)
      AND (p_month IS NULL OR MONTH(l.created_at) = p_month)
    GROUP BY l.status;
END //

DROP PROCEDURE IF EXISTS GetInventoryStatusSummary//
CREATE PROCEDURE GetInventoryStatusSummary(IN p_year INT, IN p_month INT)
BEGIN
    -- If no year/month provided, show global inventory status (useful for stock count)
    SELECT v.status, COUNT(v.id), SUM(v.dealer_cost)
    FROM vehicles v
    WHERE (p_year IS NULL OR YEAR(v.created_at) <= p_year)
      AND (p_month IS NULL OR (p_year < YEAR(CURRENT_DATE) OR MONTH(v.created_at) <= p_month OR p_year IS NULL))
    GROUP BY v.status;
END //

DROP PROCEDURE IF EXISTS GetWorkloadSummary//
CREATE PROCEDURE GetWorkloadSummary(IN p_year INT, IN p_month INT)
BEGIN
    SELECT CONCAT(e.first_name, ' ', e.last_name) AS mechanicName,
           COUNT(jc.id) AS total_jobs,
           SUM(CASE WHEN jc.status = 'COMPLETED' THEN 1 ELSE 0 END) AS completed,
           SUM(jc.total_cost) AS revenue
    FROM job_cards jc
    JOIN mechanics m ON jc.mechanic_id = m.id
    JOIN employees e ON m.employee_id = e.id
    WHERE (p_year IS NULL OR YEAR(jc.created_at) = p_year)
      AND (p_month IS NULL OR MONTH(jc.created_at) = p_month)
    GROUP BY e.id, mechanicName;
END //

DELIMITER ;

DELIMITER //

DROP PROCEDURE IF EXISTS GetStockByModelCount//
CREATE PROCEDURE GetStockByModelCount(IN p_year INT, IN p_month INT)
BEGIN
    SELECT m.model_name, COUNT(v.id)
    FROM vehicles v
    JOIN vehicle_variants vv ON v.variant_id = vv.id
    JOIN vehicle_models m ON vv.model_id = m.id
    WHERE v.status = 'IN_STOCK'
      AND (p_year IS NULL OR YEAR(v.created_at) <= p_year)
      AND (p_month IS NULL OR (p_year < YEAR(CURRENT_DATE) OR MONTH(v.created_at) <= p_month OR p_year IS NULL))
    GROUP BY m.model_name
    ORDER BY COUNT(v.id) DESC;
END //

DELIMITER ;
