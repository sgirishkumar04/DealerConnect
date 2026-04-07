-- ============================================================
-- 2025 HISTORICAL SALES DATA (FIXED SCHEMA)
-- ============================================================
USE dealerconnect;
SET FOREIGN_KEY_CHECKS = 0;

-- 1. Insert a Pool of 200 Vehicles for 2025 Sales
-- We'll use a loop-like structure using a temporary table or cross joins
INSERT INTO vehicles (vin, engine_number, chassis_number, variant_id, color_id, location_id, mfg_year, mfg_date, arrival_date, status, dealer_cost)
SELECT 
    CONCAT('VIN25HIST', LPAD(n, 3, '0')),
    CONCAT('ENG25HIST', LPAD(n, 3, '0')),
    CONCAT('CHA25HIST', LPAD(n, 3, '0')),
    (n % 12 + 1), -- variant_id
    (n % 9 + 1),  -- color_id
    2,            -- location_id (Warehouse)
    2024,
    '2024-11-15',
    '2024-12-01',
    'SOLD',
    1000000 + (n * 5000)
FROM (
    SELECT a.N + b.N * 10 + c.N * 100 AS n
    FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
         (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b,
         (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2) c
) x
WHERE n BETWEEN 1 AND 200;

-- 2. Insert Corresponding Leads (required for bookings)
INSERT INTO leads (lead_number, customer_id, source_id, assigned_to, status, created_at)
SELECT 
    CONCAT('LD25-HIST-', LPAD(n, 3, '0')),
    (n % 19 + 1), -- Loop through existing customers
    (n % 5 + 1),  -- source_id
    (CASE WHEN n % 3 = 0 THEN 3 WHEN n % 3 = 1 THEN 4 ELSE 8 END), -- assigned_to (Sales Execs)
    'DELIVERED',
    CONCAT('2025-', LPAD(FLOOR((n-1)/17) + 1, 2, '0'), '-', LPAD((n % 28) + 1, 2, '0'))
FROM (
    SELECT a.N + b.N * 10 + c.N * 100 AS n
    FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
         (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b,
         (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2) c
) x
WHERE n BETWEEN 1 AND 200;

-- 3. Insert Bookings with Varied Monthly Distribution
-- Total: ~180 bookings spread across months
-- We'll use the created_at to control the report appearance

-- Jan: 12
-- Feb: 15
-- Mar: 22
-- Apr: 10
-- May: 14
-- Jun: 8
-- Jul: 12
-- Aug: 18
-- Sep: 14
-- Oct: 25
-- Nov: 20
-- Dec: 14

INSERT INTO bookings (booking_number, lead_id, customer_id, variant_id, color_id, sales_exec_id, ex_showroom, total_on_road, status, vehicle_id, created_at)
SELECT 
    CONCAT('BKG25-', LPAD(n, 3, '0')),
    n, -- link to lead
    (n % 19 + 1),
    (n % 12 + 1),
    (n % 9 + 1),
    (CASE WHEN n % 3 = 0 THEN 3 WHEN n % 3 = 1 THEN 4 ELSE 8 END),
    1200000,
    1400000,
    'DELIVERED',
    n + 45, -- link to vehicle (assuming ~45 exist, n starts at 1)
    CASE 
        WHEN n <= 12  THEN CONCAT('2025-01-', LPAD(n, 2, '0'), ' 10:00:00')
        WHEN n <= 27  THEN CONCAT('2025-02-', LPAD(n-12, 2, '0'), ' 11:00:00')
        WHEN n <= 49  THEN CONCAT('2025-03-', LPAD(n-27, 2, '0'), ' 12:00:00')
        WHEN n <= 59  THEN CONCAT('2025-04-', LPAD(n-49, 2, '0'), ' 10:00:00')
        WHEN n <= 73  THEN CONCAT('2025-05-', LPAD(n-59, 2, '0'), ' 14:00:00')
        WHEN n <= 81  THEN CONCAT('2025-06-', LPAD(n-73, 2, '0'), ' 15:00:00')
        WHEN n <= 93  THEN CONCAT('2025-07-', LPAD(n-81, 2, '0'), ' 16:00:00')
        WHEN n <= 111 THEN CONCAT('2025-08-', LPAD(n-93, 2, '0'), ' 10:00:00')
        WHEN n <= 125 THEN CONCAT('2025-09-', LPAD(n-111, 2, '0'), ' 11:00:00')
        WHEN n <= 150 THEN CONCAT('2025-10-', LPAD(n-125, 2, '0'), ' 12:00:00')
        WHEN n <= 170 THEN CONCAT('2025-11-', LPAD(n-150, 2, '0'), ' 14:00:00')
        ELSE               CONCAT('2025-12-', LPAD(n-170, 2, '0'), ' 15:00:00')
    END
FROM (
    SELECT a.N + b.N * 10 + c.N * 100 AS n
    FROM (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
         (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b,
         (SELECT 0 AS N UNION SELECT 1 UNION SELECT 2) c
) x
WHERE n BETWEEN 1 AND 184;

SET FOREIGN_KEY_CHECKS = 1;
