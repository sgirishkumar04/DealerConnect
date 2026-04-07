-- ============================================================
--  DEALERCONNECT – Important Named SQL Queries
--  Used by backend report endpoints (native/JPQL queries)
-- ============================================================
USE dealerconnect;

-- ─────────────────────────────────────────────
-- Q1: Vehicle Inventory Status Summary
-- ─────────────────────────────────────────────
SELECT
    v.status,
    COUNT(*)             AS total_vehicles,
    SUM(v.dealer_cost)   AS total_stock_value
FROM vehicles v
GROUP BY v.status
ORDER BY total_vehicles DESC;

-- ─────────────────────────────────────────────
-- Q2: Available Vehicles by Model (In Stock)
-- ─────────────────────────────────────────────
SELECT
    vm.model_name,
    vv.variant_name,
    c.name      AS color,
    et.name     AS engine,
    vv.ex_showroom_price,
    il.name     AS location,
    v.vin,
    v.mfg_year
FROM vehicles v
JOIN vehicle_variants vv   ON v.variant_id   = vv.id
JOIN vehicle_models   vm   ON vv.model_id    = vm.id
JOIN colors           c    ON v.color_id     = c.id
JOIN engine_types     et   ON vv.engine_type_id = et.id
JOIN inventory_locations il ON v.location_id = il.id
WHERE v.status = 'IN_STOCK'
ORDER BY vm.model_name, vv.variant_name;

-- ─────────────────────────────────────────────
-- Q3: Customer Purchase History
-- ─────────────────────────────────────────────
SELECT
    CONCAT(c.first_name,' ',c.last_name) AS customer_name,
    c.phone,
    inv.invoice_number,
    inv.invoice_date,
    vm.model_name,
    vv.variant_name,
    inv.total_amount,
    inv.status      AS invoice_status
FROM invoices inv
JOIN customers       c   ON inv.customer_id = c.id
JOIN vehicles        v   ON inv.vehicle_id  = v.id
JOIN vehicle_variants vv ON v.variant_id    = vv.id
JOIN vehicle_models  vm  ON vv.model_id     = vm.id
ORDER BY inv.invoice_date DESC;

-- ─────────────────────────────────────────────
-- Q4: Sales Pipeline Report (Lead funnel)
-- ─────────────────────────────────────────────
SELECT
    l.status,
    COUNT(*)                        AS lead_count,
    COUNT(b.id)                     AS bookings,
    SUM(b.total_on_road)            AS pipeline_value
FROM leads l
LEFT JOIN bookings b ON b.lead_id = l.id
GROUP BY l.status
ORDER BY FIELD(l.status,'NEW','CONTACTED','TEST_DRIVE','NEGOTIATION','BOOKED','LOST','DELIVERED');

-- ─────────────────────────────────────────────
-- Q5: Service Workload Report (per Mechanic)
-- ─────────────────────────────────────────────
SELECT
    CONCAT(e.first_name,' ',e.last_name) AS mechanic_name,
    COUNT(jc.id)                         AS total_jobs,
    SUM(CASE WHEN jc.status='COMPLETED' THEN 1 ELSE 0 END) AS completed,
    SUM(CASE WHEN jc.status='IN_PROGRESS' THEN 1 ELSE 0 END) AS in_progress,
    SUM(CASE WHEN jc.status='OPEN' THEN 1 ELSE 0 END) AS open,
    SUM(jc.total_cost)                   AS total_billed
FROM mechanics m
JOIN employees e ON m.employee_id = e.id
LEFT JOIN job_cards jc ON jc.mechanic_id = m.id
GROUP BY m.id, mechanic_name
ORDER BY total_jobs DESC;

-- ─────────────────────────────────────────────
-- Q6: Spare Parts Stock Report
-- ─────────────────────────────────────────────
SELECT
    sp.part_number,
    sp.name              AS part_name,
    sp.category,
    spi.quantity         AS stock_qty,
    spi.reorder_level,
    CASE WHEN spi.quantity <= spi.reorder_level THEN 'LOW STOCK' ELSE 'OK' END AS stock_status,
    sp.unit_price,
    (spi.quantity * sp.unit_price) AS stock_value,
    s.name               AS supplier
FROM spare_parts sp
JOIN spare_part_inventory spi ON sp.id = spi.part_id
JOIN suppliers s               ON sp.supplier_id = s.id
ORDER BY stock_status DESC, sp.category;

-- ─────────────────────────────────────────────
-- Q7: Monthly Revenue (Sales + Service)
-- ─────────────────────────────────────────────
SELECT
    DATE_FORMAT(pay.payment_date,'%Y-%m') AS month,
    SUM(CASE WHEN pay.invoice_id  IS NOT NULL THEN pay.amount ELSE 0 END) AS vehicle_sales_revenue,
    SUM(CASE WHEN pay.job_card_id IS NOT NULL THEN pay.amount ELSE 0 END) AS service_revenue,
    SUM(pay.amount) AS total_revenue
FROM payments pay
WHERE pay.status = 'COMPLETED'
GROUP BY month
ORDER BY month DESC;

-- ─────────────────────────────────────────────
-- Q8: Top Selling Vehicle Models (by Bookings)
-- ─────────────────────────────────────────────
SELECT
    vm.model_name,
    COUNT(b.id)         AS total_bookings,
    SUM(b.total_on_road) AS total_revenue,
    AVG(b.discount)      AS avg_discount
FROM bookings b
JOIN vehicle_variants vv ON b.variant_id = vv.id
JOIN vehicle_models   vm ON vv.model_id  = vm.id
WHERE b.status NOT IN ('CANCELLED')
GROUP BY vm.id, vm.model_name
ORDER BY total_bookings DESC
LIMIT 10;

-- ─────────────────────────────────────────────
-- Q9: Employee Performance (Sales Executives)
-- ─────────────────────────────────────────────
SELECT
    CONCAT(e.first_name,' ',e.last_name) AS executive_name,
    COUNT(DISTINCT l.id)   AS total_leads,
    COUNT(DISTINCT b.id)   AS total_bookings,
    ROUND(COUNT(DISTINCT b.id) * 100.0 / NULLIF(COUNT(DISTINCT l.id),0),2) AS conversion_pct,
    SUM(b.total_on_road)   AS total_sales_value
FROM employees e
JOIN roles r ON e.role_id = r.id AND r.name = 'SALES_EXECUTIVE'
LEFT JOIN leads    l ON l.assigned_to   = e.id
LEFT JOIN bookings b ON b.sales_exec_id = e.id AND b.status NOT IN ('CANCELLED')
GROUP BY e.id, executive_name
ORDER BY total_bookings DESC;

-- ─────────────────────────────────────────────
-- Q10: Daily Bookings for current month
-- ─────────────────────────────────────────────
SELECT
    DATE(created_at)     AS booking_date,
    COUNT(*)             AS bookings,
    SUM(total_on_road)   AS amt
FROM bookings
WHERE YEAR(created_at)  = YEAR(CURDATE())
  AND MONTH(created_at) = MONTH(CURDATE())
  AND status <> 'CANCELLED'
GROUP BY booking_date
ORDER BY booking_date;

-- ─────────────────────────────────────────────
-- Q11: Spare Parts Usage per Job Card
-- ─────────────────────────────────────────────
SELECT
    jc.job_card_no,
    sa.vehicle_reg_no,
    sp.name   AS part_name,
    spu.quantity,
    spu.unit_price,
    spu.total_price
FROM spare_part_usage spu
JOIN job_cards jc              ON spu.job_card_id = jc.id
JOIN service_appointments sa   ON jc.appointment_id = sa.id
JOIN spare_parts sp            ON spu.part_id = sp.id
ORDER BY jc.job_card_no, sp.name;
