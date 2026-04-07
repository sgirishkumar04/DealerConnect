-- ═══════════════════════════════════════════════════════════════════
--  DEALERCONNECT – MULTI-DEALER MIGRATION
--  Run this script ONCE against the dealerconnect database.
--  Converts single-dealer to multi-dealer architecture.
-- ═══════════════════════════════════════════════════════════════════

USE dealerconnect;

-- ───────────────────────────────────────────────────────────────────
-- 1. DEALERS TABLE
-- ───────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS dealers (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    dealer_code     VARCHAR(20)  NOT NULL UNIQUE,
    name            VARCHAR(150) NOT NULL,
    city            VARCHAR(100) NOT NULL,
    state           VARCHAR(100) NOT NULL,
    address         TEXT,
    gst_number      VARCHAR(20)  UNIQUE,
    contact_name    VARCHAR(150),
    contact_phone   VARCHAR(20),
    contact_email   VARCHAR(150),
    status          ENUM('PENDING','APPROVED','DECLINED') NOT NULL DEFAULT 'PENDING',
    created_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ───────────────────────────────────────────────────────────────────
-- 2. DEALER REGISTRATIONS TABLE (approval queue)
-- ───────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS dealer_registrations (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    -- Dealer info
    dealer_name     VARCHAR(150) NOT NULL,
    city            VARCHAR(100) NOT NULL,
    state           VARCHAR(100) NOT NULL,
    address         TEXT,
    gst_number      VARCHAR(20),
    contact_name    VARCHAR(150) NOT NULL,
    contact_phone   VARCHAR(20)  NOT NULL,
    -- Admin credentials requested
    admin_email     VARCHAR(150) NOT NULL UNIQUE,
    admin_full_name VARCHAR(150) NOT NULL,
    admin_password_hash VARCHAR(255) NOT NULL,
    -- Status
    status          ENUM('PENDING','APPROVED','DECLINED') NOT NULL DEFAULT 'PENDING',
    rejection_reason TEXT,
    reviewed_by     BIGINT,                   -- FK to employees (super admin)
    reviewed_at     DATETIME,
    -- linked dealer after approval
    dealer_id       BIGINT,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ───────────────────────────────────────────────────────────────────
-- 3. ADD dealer_id FOREIGN KEY TO EXISTING TABLES
--    (nullable so existing data migrates without errors)
-- ───────────────────────────────────────────────────────────────────

-- employees
ALTER TABLE employees
    ADD COLUMN IF NOT EXISTS dealer_id BIGINT NULL,
    ADD INDEX IF NOT EXISTS idx_emp_dealer (dealer_id);

-- customers
ALTER TABLE customers
    ADD COLUMN IF NOT EXISTS dealer_id BIGINT NULL,
    ADD INDEX IF NOT EXISTS idx_cust_dealer (dealer_id);

-- leads
ALTER TABLE leads
    ADD COLUMN IF NOT EXISTS dealer_id BIGINT NULL,
    ADD INDEX IF NOT EXISTS idx_leads_dealer (dealer_id);

-- bookings
ALTER TABLE bookings
    ADD COLUMN IF NOT EXISTS dealer_id BIGINT NULL,
    ADD INDEX IF NOT EXISTS idx_bookings_dealer (dealer_id);

-- service_appointments
ALTER TABLE service_appointments
    ADD COLUMN IF NOT EXISTS dealer_id BIGINT NULL,
    ADD INDEX IF NOT EXISTS idx_svc_dealer (dealer_id);

-- spare_parts
ALTER TABLE spare_parts
    ADD COLUMN IF NOT EXISTS dealer_id BIGINT NULL,
    ADD INDEX IF NOT EXISTS idx_parts_dealer (dealer_id);

-- vehicles stays SHARED (no dealer_id)
-- but we add an optional "allocated_dealer_id" for tracking
ALTER TABLE vehicles
    ADD COLUMN IF NOT EXISTS allocated_dealer_id BIGINT NULL;

-- ───────────────────────────────────────────────────────────────────
-- 4. INSERT: Hyundai Chennai as Dealer #1 (already existing data)
-- ───────────────────────────────────────────────────────────────────
INSERT IGNORE INTO dealers (dealer_code, name, city, state, address, gst_number, contact_name, contact_phone, contact_email, status)
VALUES ('DLR-CHN-001', 'Hyundai Chennai', 'Chennai', 'Tamil Nadu',
        'No.1, Anna Salai, Chennai, TN 600002',
        '33AABCH1234A1Z5', 'S Girish Kumar', '9000000001', 'admin@dealerconnect.com', 'APPROVED');

-- ───────────────────────────────────────────────────────────────────
-- 5. ASSIGN existing employees/customers/etc. to Dealer #1
-- ───────────────────────────────────────────────────────────────────
SET @dealer1_id = (SELECT id FROM dealers WHERE dealer_code = 'DLR-CHN-001');

UPDATE employees          SET dealer_id = @dealer1_id WHERE dealer_id IS NULL;
UPDATE customers          SET dealer_id = @dealer1_id WHERE dealer_id IS NULL;
UPDATE leads              SET dealer_id = @dealer1_id WHERE dealer_id IS NULL;
UPDATE bookings           SET dealer_id = @dealer1_id WHERE dealer_id IS NULL;
UPDATE service_appointments SET dealer_id = @dealer1_id WHERE dealer_id IS NULL;
UPDATE spare_parts        SET dealer_id = @dealer1_id WHERE dealer_id IS NULL;

-- ───────────────────────────────────────────────────────────────────
-- 6. INSERT: SUPER_ADMIN role
-- ───────────────────────────────────────────────────────────────────
INSERT IGNORE INTO roles (name, description, created_at)
VALUES ('SUPER_ADMIN', 'DealerConnect Platform Administrator', NOW());

-- ───────────────────────────────────────────────────────────────────
-- 7. INSERT: SUPER_ADMIN employee (platform owner, no dealer)
--    Default password: SuperAdmin@123  (BCrypt hash below)
-- ───────────────────────────────────────────────────────────────────
INSERT IGNORE INTO employees (employee_code, first_name, last_name, email, phone, password_hash,
                               department_id, role_id, date_of_join, is_active, dealer_id, created_at, updated_at)
SELECT 'SA001', 'DMS', 'SuperAdmin',
       'superadmin@dealerconnect.com', '9000000000',
       '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBZAVHLdmY6/Ky',   -- SuperAdmin@123
       d.id, r.id,
       '2024-01-01', 1, NULL, NOW(), NOW()
FROM departments d, roles r
WHERE d.name = 'Administration' AND r.name = 'SUPER_ADMIN'
LIMIT 1;

-- ───────────────────────────────────────────────────────────────────
-- 8. STORED PROCEDURES (Dashboard Reports)
--    These fix the SQLGrammarException errors in the dashboard.
-- ───────────────────────────────────────────────────────────────────

DROP PROCEDURE IF EXISTS GetMonthlyBookings;
DELIMITER $$
CREATE PROCEDURE GetMonthlyBookings(IN p_year INT)
BEGIN
    SELECT
        DATE_FORMAT(b.created_at, '%Y-%m')  AS month_label,
        COUNT(*)                             AS booking_count,
        COALESCE(SUM(b.total_on_road), 0)   AS total_revenue
    FROM bookings b
    WHERE (p_year IS NULL OR YEAR(b.created_at) = p_year)
    GROUP BY DATE_FORMAT(b.created_at, '%Y-%m')
    ORDER BY month_label DESC
    LIMIT 12;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS GetTopSellingModels;
DELIMITER $$
CREATE PROCEDURE GetTopSellingModels(IN p_year INT, IN p_month INT)
BEGIN
    SELECT
        vm.model_name           AS model_name,
        COUNT(b.id)             AS booking_count
    FROM bookings b
    JOIN vehicle_variants vv ON b.variant_id = vv.id
    JOIN vehicle_models   vm ON vv.model_id  = vm.id
    WHERE (p_year IS NULL  OR YEAR(b.created_at)  = p_year)
      AND (p_month IS NULL OR MONTH(b.created_at) = p_month)
    GROUP BY vm.model_name
    ORDER BY booking_count DESC
    LIMIT 8;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS GetBookingsByModelCount;
DELIMITER $$
CREATE PROCEDURE GetBookingsByModelCount(IN p_year INT, IN p_month INT)
BEGIN
    SELECT
        vm.model_name           AS model_name,
        COUNT(b.id)             AS booking_count
    FROM bookings b
    JOIN vehicle_variants vv ON b.variant_id = vv.id
    JOIN vehicle_models   vm ON vv.model_id  = vm.id
    WHERE (p_year IS NULL  OR YEAR(b.created_at)  = p_year)
      AND (p_month IS NULL OR MONTH(b.created_at) = p_month)
    GROUP BY vm.model_name
    ORDER BY booking_count DESC;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS GetLeadFunnelCounts;
DELIMITER $$
CREATE PROCEDURE GetLeadFunnelCounts(IN p_year INT, IN p_month INT)
BEGIN
    SELECT
        l.status                AS lead_status,
        COUNT(*)                AS lead_count
    FROM leads l
    WHERE (p_year IS NULL  OR YEAR(l.created_at)  = p_year)
      AND (p_month IS NULL OR MONTH(l.created_at) = p_month)
    GROUP BY l.status
    ORDER BY lead_count DESC;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS GetInventoryStatusSummary;
DELIMITER $$
CREATE PROCEDURE GetInventoryStatusSummary(IN p_year INT, IN p_month INT)
BEGIN
    SELECT
        v.status                AS vehicle_status,
        COUNT(*)                AS vehicle_count
    FROM vehicles v
    GROUP BY v.status
    ORDER BY vehicle_count DESC;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS GetStockByModelCount;
DELIMITER $$
CREATE PROCEDURE GetStockByModelCount(IN p_year INT, IN p_month INT)
BEGIN
    SELECT
        vm.model_name           AS model_name,
        COUNT(v.id)             AS stock_count
    FROM vehicles v
    JOIN vehicle_variants vv ON v.variant_id = vv.id
    JOIN vehicle_models   vm ON vv.model_id  = vm.id
    WHERE v.status = 'IN_STOCK'
    GROUP BY vm.model_name
    ORDER BY stock_count DESC;
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS GetWorkloadSummary;
DELIMITER $$
CREATE PROCEDURE GetWorkloadSummary(IN p_year INT, IN p_month INT)
BEGIN
    SELECT
        sa.status               AS appointment_status,
        COUNT(*)                AS appointment_count
    FROM service_appointments sa
    WHERE (p_year IS NULL  OR YEAR(sa.appointment_date)  = p_year)
      AND (p_month IS NULL OR MONTH(sa.appointment_date) = p_month)
    GROUP BY sa.status
    ORDER BY appointment_count DESC;
END$$
DELIMITER ;

-- ═══════════════════════════════════════════════════════════════════
--  MIGRATION COMPLETE
--  SUPER_ADMIN login: superadmin@dealerconnect.com / SuperAdmin@123
-- ═══════════════════════════════════════════════════════════════════
