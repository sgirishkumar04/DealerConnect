-- ===================================================================
--  HYUNDAI DEALER MANAGEMENT SYSTEM – COMPLETE SETUP (LAPTOP)
--  Multi-Dealer SaaS Edition | Production-Ready Schema | Stored Procedures
-- ===================================================================

SET FOREIGN_KEY_CHECKS = 0;
DROP DATABASE IF EXISTS hyundai_dms;
CREATE DATABASE hyundai_dms CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE hyundai_dms;

-- ───────────────────────────────────────────────────────────────────
-- 1. BASE LOOKUP / REFERENCE TABLES
-- ───────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS roles (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(50)  NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS departments (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS lead_sources (
    id   BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS colors (
    id        BIGINT AUTO_INCREMENT PRIMARY KEY,
    name      VARCHAR(50)  NOT NULL,
    hex_code  VARCHAR(10),
    UNIQUE KEY uq_color_name (name)
);

CREATE TABLE IF NOT EXISTS engine_types (
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    name         VARCHAR(100) NOT NULL UNIQUE,
    fuel_category VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS inventory_locations (
    id       BIGINT AUTO_INCREMENT PRIMARY KEY,
    name     VARCHAR(100) NOT NULL UNIQUE,
    address  VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS banks (
    id      BIGINT AUTO_INCREMENT PRIMARY KEY,
    name    VARCHAR(150) NOT NULL UNIQUE,
    ifsc_prefix VARCHAR(10),
    contact VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS suppliers (
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    name         VARCHAR(150) NOT NULL,
    contact_name VARCHAR(100),
    phone        VARCHAR(20),
    email        VARCHAR(100),
    address      VARCHAR(255),
    gst_number   VARCHAR(20),
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_supplier_name (name)
);

-- ───────────────────────────────────────────────────────────────────
-- 2. MULTI-DEALER CORE
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
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS dealer_registrations (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    dealer_name     VARCHAR(150) NOT NULL,
    city            VARCHAR(100) NOT NULL,
    state           VARCHAR(100) NOT NULL,
    address         TEXT,
    gst_number      VARCHAR(20),
    contact_name    VARCHAR(150) NOT NULL,
    contact_phone   VARCHAR(20)  NOT NULL,
    admin_email     VARCHAR(150) NOT NULL UNIQUE,
    admin_full_name VARCHAR(150) NOT NULL,
    admin_password_hash VARCHAR(255) NOT NULL,
    status          ENUM('PENDING','APPROVED','DECLINED') NOT NULL DEFAULT 'PENDING',
    rejection_reason TEXT,
    reviewed_at     DATETIME,
    dealer_id       BIGINT,
    created_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ───────────────────────────────────────────────────────────────────
-- 3. EMPLOYEE & PERMISSIONS
-- ───────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS employees (
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    employee_code VARCHAR(20) NOT NULL UNIQUE,
    first_name    VARCHAR(80) NOT NULL,
    last_name     VARCHAR(80) NOT NULL,
    email         VARCHAR(150) NOT NULL UNIQUE,
    phone         VARCHAR(20),
    password_hash VARCHAR(255) NOT NULL,
    department_id BIGINT NOT NULL,
    role_id       BIGINT NOT NULL,
    manager_id    BIGINT,
    dealer_id     BIGINT,   -- Global admins have NULL dealer_id
    date_of_join  DATE,
    is_active     BOOLEAN DEFAULT TRUE,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_emp_dept   FOREIGN KEY (department_id) REFERENCES departments(id),
    CONSTRAINT fk_emp_role   FOREIGN KEY (role_id)       REFERENCES roles(id),
    CONSTRAINT fk_emp_dealer FOREIGN KEY (dealer_id)     REFERENCES dealers(id),
    INDEX idx_emp_dealer (dealer_id)
);

CREATE TABLE IF NOT EXISTS permissions (
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(100) NOT NULL UNIQUE,
    description   VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS role_permissions (
    role_id       BIGINT NOT NULL,
    permission_id BIGINT NOT NULL,
    PRIMARY KEY (role_id, permission_id),
    CONSTRAINT fk_rp_role FOREIGN KEY (role_id) REFERENCES roles(id),
    CONSTRAINT fk_rp_perm FOREIGN KEY (permission_id) REFERENCES permissions(id)
);

CREATE TABLE IF NOT EXISTS mechanics (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    employee_id BIGINT NOT NULL UNIQUE,
    speciality  VARCHAR(100),
    CONSTRAINT fk_mech_emp FOREIGN KEY (employee_id) REFERENCES employees(id)
);

-- ───────────────────────────────────────────────────────────────────
-- 4. VEHICLE CATALOG & INVENTORY
-- ───────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS vehicle_models (
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    model_code   VARCHAR(20) NOT NULL UNIQUE,
    model_name   VARCHAR(100) NOT NULL,
    segment      VARCHAR(50),
    launch_year  YEAR,
    is_active    BOOLEAN DEFAULT TRUE,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS vehicle_variants (
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    model_id      BIGINT NOT NULL,
    variant_code  VARCHAR(20) NOT NULL UNIQUE,
    variant_name  VARCHAR(100) NOT NULL,
    engine_type_id BIGINT NOT NULL,
    transmission  VARCHAR(30),
    seating_capacity TINYINT DEFAULT 5,
    ex_showroom_price DECIMAL(12,2) NOT NULL,
    is_active     BOOLEAN DEFAULT TRUE,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_vv_model  FOREIGN KEY (model_id)       REFERENCES vehicle_models(id),
    CONSTRAINT fk_vv_engine FOREIGN KEY (engine_type_id) REFERENCES engine_types(id)
);

CREATE TABLE IF NOT EXISTS vehicles (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    vin             VARCHAR(17) NOT NULL UNIQUE,
    engine_number   VARCHAR(50) UNIQUE,
    chassis_number  VARCHAR(50) UNIQUE,
    variant_id      BIGINT NOT NULL,
    color_id        BIGINT NOT NULL,
    location_id     BIGINT NOT NULL,
    dealer_id       BIGINT NOT NULL,
    mfg_year        YEAR,
    mfg_date        DATE,
    arrival_date    DATE,
    status          ENUM('IN_STOCK','ALLOCATED','SOLD','IN_TRANSIT','DEMO') DEFAULT 'IN_STOCK',
    invoice_date    DATE,
    dealer_cost     DECIMAL(12,2),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_v_variant  FOREIGN KEY (variant_id)  REFERENCES vehicle_variants(id),
    CONSTRAINT fk_v_color    FOREIGN KEY (color_id)    REFERENCES colors(id),
    CONSTRAINT fk_v_location FOREIGN KEY (location_id) REFERENCES inventory_locations(id),
    CONSTRAINT fk_v_dealer   FOREIGN KEY (dealer_id)   REFERENCES dealers(id),
    INDEX idx_v_dealer (dealer_id)
);

-- ───────────────────────────────────────────────────────────────────
-- 5. LEADS & BOOKINGS
-- ───────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS customers (
    id             BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_code  VARCHAR(20) NOT NULL UNIQUE,
    first_name     VARCHAR(80) NOT NULL,
    last_name      VARCHAR(80) NOT NULL,
    email          VARCHAR(150),
    phone          VARCHAR(20) NOT NULL,
    dealer_id      BIGINT NOT NULL,
    customer_type  ENUM('INDIVIDUAL','CORPORATE') DEFAULT 'INDIVIDUAL',
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_cust_dealer FOREIGN KEY (dealer_id) REFERENCES dealers(id),
    INDEX idx_cust_dealer (dealer_id)
);

CREATE TABLE IF NOT EXISTS leads (
    id               BIGINT AUTO_INCREMENT PRIMARY KEY,
    lead_number      VARCHAR(20) NOT NULL UNIQUE,
    customer_id      BIGINT NOT NULL,
    dealer_id        BIGINT NOT NULL,
    source_id        BIGINT NOT NULL,
    assigned_to      BIGINT NOT NULL,
    preferred_model_id   BIGINT,
    status           ENUM('NEW','CONTACTED','TEST_DRIVE','NEGOTIATION','BOOKED','LOST','DELIVERED') DEFAULT 'NEW',
    expected_close_date DATE,
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_lead_cust    FOREIGN KEY (customer_id) REFERENCES customers(id),
    CONSTRAINT fk_lead_dealer  FOREIGN KEY (dealer_id)   REFERENCES dealers(id),
    CONSTRAINT fk_lead_source  FOREIGN KEY (source_id)   REFERENCES lead_sources(id),
    CONSTRAINT fk_lead_exec    FOREIGN KEY (assigned_to) REFERENCES employees(id),
    INDEX idx_lead_dealer (dealer_id)
);

CREATE TABLE IF NOT EXISTS bookings (
    id               BIGINT AUTO_INCREMENT PRIMARY KEY,
    booking_number   VARCHAR(20) NOT NULL UNIQUE,
    lead_id          BIGINT NOT NULL,
    customer_id      BIGINT NOT NULL,
    dealer_id        BIGINT NOT NULL,
    variant_id       BIGINT NOT NULL,
    color_id         BIGINT NOT NULL,
    sales_exec_id    BIGINT NOT NULL,
    status           ENUM('BOOKED','ALLOCATED','INVOICED','DELIVERED','CANCELLED') DEFAULT 'BOOKED',
    total_on_road    DECIMAL(12,2) NOT NULL,
    vehicle_id       BIGINT,
    expected_delivery DATE,
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_bk_lead     FOREIGN KEY (lead_id)     REFERENCES leads(id),
    CONSTRAINT fk_bk_dealer   FOREIGN KEY (dealer_id)   REFERENCES dealers(id),
    CONSTRAINT fk_bk_variant  FOREIGN KEY (variant_id)  REFERENCES vehicle_variants(id),
    CONSTRAINT fk_bk_vehicle  FOREIGN KEY (vehicle_id)  REFERENCES vehicles(id),
    INDEX idx_bk_dealer (dealer_id)
);

-- ───────────────────────────────────────────────────────────────────
-- 6. SERVICE & SPARE PARTS
-- ───────────────────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS service_appointments (
    id               BIGINT AUTO_INCREMENT PRIMARY KEY,
    appointment_no   VARCHAR(20) NOT NULL UNIQUE,
    customer_id      BIGINT NOT NULL,
    dealer_id        BIGINT NOT NULL,
    vehicle_reg_no   VARCHAR(20) NOT NULL,
    appointed_by     BIGINT NOT NULL,
    appointment_date DATETIME NOT NULL,
    status           ENUM('SCHEDULED','IN_PROGRESS','COMPLETED','CANCELLED') DEFAULT 'SCHEDULED',
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_sa_customer FOREIGN KEY (customer_id) REFERENCES customers(id),
    CONSTRAINT fk_sa_dealer   FOREIGN KEY (dealer_id)   REFERENCES dealers(id),
    INDEX idx_sa_dealer (dealer_id)
);

CREATE TABLE IF NOT EXISTS spare_parts (
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    part_number  VARCHAR(50) NOT NULL UNIQUE,
    name         VARCHAR(150) NOT NULL,
    category     VARCHAR(80),
    unit_price   DECIMAL(12,2) NOT NULL,
    dealer_id    BIGINT NOT NULL,
    supplier_id  BIGINT,
    is_active    BOOLEAN DEFAULT TRUE,
    CONSTRAINT fk_sp_dealer   FOREIGN KEY (dealer_id) REFERENCES dealers(id),
    CONSTRAINT fk_sp_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(id),
    INDEX idx_sp_dealer (dealer_id)
);

-- ───────────────────────────────────────────────────────────────────
-- 7. AUDIT LOGGING
-- ───────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS audit_logs (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    entity_name     VARCHAR(50) NOT NULL,
    entity_id       BIGINT NOT NULL,
    action          VARCHAR(20) NOT NULL, -- CREATE, UPDATE, DELETE
    old_value       JSON,
    new_value       JSON,
    changed_by_id   BIGINT,
    changed_by_name VARCHAR(150),
    dealer_id       BIGINT,
    ip_address      VARCHAR(45),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ───────────────────────────────────────────────────────────────────
-- 8. ANALYTICS STORED PROCEDURES
-- ───────────────────────────────────────────────────────────────────

DELIMITER $$
CREATE PROCEDURE GetMonthlyBookings(IN p_year INT)
BEGIN
    SELECT DATE_FORMAT(created_at, '%Y-%m') AS month_label, COUNT(*) AS booking_count, SUM(total_on_road) AS total_revenue
    FROM bookings WHERE YEAR(created_at) = p_year GROUP BY month_label ORDER BY month_label;
END$$

CREATE PROCEDURE GetLeadFunnelCounts(IN p_year INT, IN p_month INT, IN p_dealer_id BIGINT)
BEGIN
    SELECT status AS lead_status, COUNT(*) AS lead_count 
    FROM leads WHERE (p_dealer_id IS NULL OR dealer_id = p_dealer_id) GROUP BY status;
END$$

CREATE PROCEDURE GetInventoryStatusSummary(IN p_year INT, IN p_month INT, IN p_dealer_id BIGINT)
BEGIN
    SELECT status AS vehicle_status, COUNT(*) AS vehicle_count 
    FROM vehicles WHERE (p_dealer_id IS NULL OR dealer_id = p_dealer_id) GROUP BY status;
END$$
DELIMITER ;

-- ───────────────────────────────────────────────────────────────────
-- 9. INITIAL SEED DATA (Expanded & Professional)
-- ───────────────────────────────────────────────────────────────────

-- 1. Master Data: Departments & Roles
INSERT INTO departments (name) VALUES ('Sales'), ('Service'), ('Inventory'), ('Administration'), ('Accounts');
INSERT INTO roles (name, description) VALUES 
('SUPER_ADMIN', 'Platform Global Administrator'),
('DEALER_ADMIN', 'Showroom Manager / Dealer Owner'),
('SALES_MANAGER', 'Sales Department Head'),
('SALES_EXECUTIVE', 'Car Salesperson'),
('SERVICE_ADVISOR', 'Workshop Front-end / Job Cards'),
('MECHANIC', 'Workshop Technician'),
('INVENTORY_MANAGER', 'Stock and Yard Controller'),
('ACCOUNTS', 'Finance and Billing Head');

-- 2. Permissions & Role Mapping
INSERT INTO permissions (name, description) VALUES 
('LEADS_READ', 'View leads'), ('LEADS_CREATE', 'Create leads'), ('LEADS_EDIT', 'Edit leads'), ('LEADS_DELETE', 'Delete leads'),
('VEHICLE_READ', 'View stock'), ('VEHICLE_CREATE', 'Add stock'), ('VEHICLE_EDIT', 'Edit stock'),
('BOOKING_READ', 'View bookings'), ('BOOKING_CREATE', 'Create bookings'), ('BOOKING_EDIT', 'Edit bookings'),
('SERVICE_READ', 'View service'), ('SERVICE_CREATE', 'Create job card'),
('REPORT_READ', 'View analytics');

-- Map Permissions to Roles
INSERT INTO role_permissions (role_id, permission_id) 
SELECT r.id, p.id FROM roles r, permissions p WHERE r.name = 'DEALER_ADMIN'; -- Admin gets everything

INSERT INTO role_permissions (role_id, permission_id) 
SELECT r.id, p.id FROM roles r, permissions p WHERE r.name = 'SALES_EXECUTIVE' AND p.name LIKE 'LEADS%';
INSERT INTO role_permissions (role_id, permission_id) 
SELECT r.id, p.id FROM roles r, permissions p WHERE r.name = 'SALES_EXECUTIVE' AND p.name IN ('VEHICLE_READ', 'BOOKING_CREATE', 'REPORT_READ');

-- 3. Reference Data
INSERT INTO lead_sources (name) VALUES ('Walk-In'), ('Online Website'), ('Social Media'), ('Referral'), ('Outdoor Event'), ('Google Search');
INSERT INTO colors (name, hex_code) VALUES 
('Abyss Black', '#000000'), ('Atlas White', '#FFFFFF'), ('Titan Grey', '#808080'), 
('Fiery Red', '#FF0000'), ('Starry Night', '#00008B'), ('Amazon Grey', '#4B5320');

INSERT INTO engine_types (name, fuel_category) VALUES 
('1.2L Kappa Petrol', 'PETROL'), ('1.5L MPi Petrol', 'PETROL'), ('1.5L U2 CRDi Diesel', 'DIESEL'), 
('1.5L Turbo GDi Petrol', 'PETROL'), ('Permanent Magnet Motor', 'ELECTRIC'), ('SmartStream Petrol', 'PETROL');

INSERT INTO inventory_locations (name, address) VALUES 
('Main Showroom Floor', 'Anna Salai, Chennai'), ('Primary Warehouse', 'Kanchipuram Yard'), ('Service Bay', 'Chennai Hub');

INSERT INTO banks (name, ifsc_prefix) VALUES ('HDFC Bank', 'HDFC'), ('ICICI Bank', 'ICIC'), ('SBI', 'SBIN'), ('Axis Bank', 'UTIB');

INSERT INTO suppliers (name, contact_name, phone, email) VALUES 
('Hyundai Mobis', 'Parts Head', '9000010001', 'mobis.parts@hyundai.com'),
('Castrol India', 'Sales Rep', '9000010002', 'support@castrol.in');

-- 4. Dealers
INSERT INTO dealers (dealer_code, name, city, state, contact_name, contact_email, status)
VALUES ('DLR-CHN-001', 'Hyundai Chennai', 'Chennai', 'Tamil Nadu', 'S Girish Kumar', 'admin@hyundaidms.in', 'APPROVED'),
       ('DLR-CBE-001', 'Hyundai Coimbatore', 'Coimbatore', 'Tamil Nadu', 'Prachi Sharma', 'prachi.admin@hyundaidms.in', 'APPROVED');

SET @dealer1 = (SELECT id FROM dealers WHERE dealer_code = 'DLR-CHN-001' LIMIT 1);
SET @dealer2 = (SELECT id FROM dealers WHERE dealer_code = 'DLR-CBE-001' LIMIT 1);

-- 5. Users (Credentials)
-- Super Admin (Global - Platform Level)
INSERT INTO employees (employee_code, first_name, last_name, email, password_hash, department_id, role_id, is_active)
SELECT 'SUP-ADM-001', 'DMS', 'SuperAdmin', 'superadmin@hyundaidms.in', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBZAVHLdmY6/Ky', 4, 1, 1;

-- Dealer 1 (Chennai) - Professional Staff Roster
INSERT INTO employees (employee_code, first_name, last_name, email, password_hash, department_id, role_id, dealer_id, is_active)
VALUES 
('CHN-ADM-001', 'Girish', 'ShowroomAdmin', 'admin@hyundaidms.in', '$2a$10$fV3zbeF.CshdKWhv.idCqe5VOfZ6/9S6F5WbZt.S/Ypbe8L6H9Z.i', 4, 2, @dealer1, 1),
('CHN-MGR-001', 'Vikram', 'Rao', 'vikram.sm@hyundaidms.in', '$2a$10$fV3zbeF.CshdKWhv.idCqe5VOfZ6/9S6F5WbZt.S/Ypbe8L6H9Z.i', 1, 3, @dealer1, 1),
('CHN-EXE-001', 'Rahul', 'Varma', 'rahul.v@hyundaidms.in', '$2a$10$fV3zbeF.CshdKWhv.idCqe5VOfZ6/9S6F5WbZt.S/Ypbe8L6H9Z.i', 1, 4, @dealer1, 1),
('CHN-EXE-002', 'Priya', 'Dharshini', 'priya.d@hyundaidms.in', '$2a$10$fV3zbeF.CshdKWhv.idCqe5VOfZ6/9S6F5WbZt.S/Ypbe8L6H9Z.i', 1, 4, @dealer1, 1),
('CHN-ADV-001', 'Murali', 'Krishnan', 'murali.sa@hyundaidms.in', '$2a$10$fV3zbeF.CshdKWhv.idCqe5VOfZ6/9S6F5WbZt.S/Ypbe8L6H9Z.i', 2, 5, @dealer1, 1),
('CHN-TEC-001', 'Suresh', 'Mechanic', 'suresh.mech@hyundaidms.in', '$2a$10$fV3zbeF.CshdKWhv.idCqe5VOfZ6/9S6F5WbZt.S/Ypbe8L6H9Z.i', 2, 6, @dealer1, 1),
('CHN-ACC-001', 'Lakshmi', 'Iyer', 'lakshmi.ac@hyundaidms.in', '$2a$10$fV3zbeF.CshdKWhv.idCqe5VOfZ6/9S6F5WbZt.S/Ypbe8L6H9Z.i', 5, 8, @dealer1, 1),
('CHN-INV-001', 'Manikandan', 'S', 'mani.im@hyundaidms.in', '$2a$10$fV3zbeF.CshdKWhv.idCqe5VOfZ6/9S6F5WbZt.S/Ypbe8L6H9Z.i', 3, 7, @dealer1, 1);

-- Dealer 2 (Coimbatore) - Professional Staff Roster
INSERT INTO employees (employee_code, first_name, last_name, email, password_hash, department_id, role_id, dealer_id, is_active)
VALUES 
('CBE-ADM-001', 'Prachi', 'ShowroomAdmin', 'prachi.admin@hyundaidms.in', '$2a$10$fV3zbeF.CshdKWhv.idCqe5VOfZ6/9S6F5WbZt.S/Ypbe8L6H9Z.i', 4, 2, @dealer2, 1),
('CBE-MGR-002', 'Senthil', 'Raj', 'senthil.sm@hyundaidms.in', '$2a$10$fV3zbeF.CshdKWhv.idCqe5VOfZ6/9S6F5WbZt.S/Ypbe8L6H9Z.i', 1, 3, @dealer2, 1),
('CBE-EXE-001', 'Ananya', 'Shree', 'ananya.s@hyundaidms.in', '$2a$10$fV3zbeF.CshdKWhv.idCqe5VOfZ6/9S6F5WbZt.S/Ypbe8L6H9Z.i', 1, 4, @dealer2, 1),
('CBE-EXE-002', 'Karthik', 'Govind', 'karthik.g@hyundaidms.in', '$2a$10$fV3zbeF.CshdKWhv.idCqe5VOfZ6/9S6F5WbZt.S/Ypbe8L6H9Z.i', 1, 4, @dealer2, 1),
('CBE-ADV-001', 'Deepa', 'Lakshmi', 'deepa.sa@hyundaidms.in', '$2a$10$fV3zbeF.CshdKWhv.idCqe5VOfZ6/9S6F5WbZt.S/Ypbe8L6H9Z.i', 2, 5, @dealer2, 1),
('CBE-TEC-001', 'Rajesh', 'Tech', 'rajesh.mc@hyundaidms.in', '$2a$10$fV3zbeF.CshdKWhv.idCqe5VOfZ6/9S6F5WbZt.S/Ypbe8L6H9Z.i', 2, 6, @dealer2, 1),
('CBE-ACC-001', 'Vijay', 'Kumar', 'vijay.ac@hyundaidms.in', '$2a$10$fV3zbeF.CshdKWhv.idCqe5VOfZ6/9S6F5WbZt.S/Ypbe8L6H9Z.i', 5, 8, @dealer2, 1),
('CBE-INV-001', 'Sundar', 'Ram', 'sundar.im@hyundaidms.in', '$2a$10$fV3zbeF.CshdKWhv.idCqe5VOfZ6/9S6F5WbZt.S/Ypbe8L6H9Z.i', 3, 7, @dealer2, 1);

-- Link Mechanics to Mechanic table
INSERT INTO mechanics (employee_id, speciality) 
SELECT id, 'Engine & Transmission' FROM employees WHERE employee_code IN ('CHN-TEC-001', 'CBE-TEC-001');

-- 6. Full Hyundai 2024/2025 Model Catalog
INSERT INTO vehicle_models (model_code, model_name, segment, launch_year) VALUES 
('EXTER', 'Hyundai Exter', 'Micro SUV', 2023), ('NIOD-I10', 'Hyundai Grand i10 Nios', 'Hatchback', 2023),
('I20', 'Hyundai i20', 'Premium Hatchback', 2023), ('VENUE', 'Hyundai Venue', 'Compact SUV', 2023),
('VERNA', 'Hyundai Verna', 'Premium Sedan', 2023), ('CRETA', 'Hyundai Creta', 'Mid-SUV', 2024),
('ALCAZAR', 'Hyundai Alcazar', 'SUV', 2024), ('TUCSON', 'Hyundai Tucson', 'Premium SUV', 2024),
('IONIQ5', 'Hyundai IONIQ 5', 'Electric SUV', 2023);

-- Variants (Sample Trims)
INSERT INTO vehicle_variants (model_id, variant_code, variant_name, engine_type_id, transmission, ex_showroom_price)
SELECT id, 'CRT-SX-P', 'SX 1.5L MPi Petrol', 2, 'Manual', 1485000 FROM vehicle_models WHERE model_code = 'CRETA';
SET @v_creta_sx = LAST_INSERT_ID();

INSERT INTO vehicle_variants (model_id, variant_code, variant_name, engine_type_id, transmission, ex_showroom_price)
SELECT id, 'VRN-SX-T', 'SX(O) Turbo DCT', 4, 'DCT', 1735000 FROM vehicle_models WHERE model_code = 'VERNA';
SET @v_verna_sx = LAST_INSERT_ID();

-- 7. Spare Parts Inventory
INSERT INTO spare_parts (part_number, name, category, unit_price, dealer_id, supplier_id)
VALUES ('99999-00001', 'Oil Filter (Diesel)', 'MAINTENANCE', 450.00, @dealer1, 1),
       ('99999-00002', 'Brake Pad Set - Front', 'BRAKES', 2850.00, @dealer1, 1);

-- 8. SHOWROOM RECORDS (Data Presence)
SET @salesexec1 = (SELECT id FROM employees WHERE employee_code = 'CHN-EXE-001' LIMIT 1);

INSERT INTO customers (customer_code, first_name, last_name, phone, email, dealer_id) 
VALUES ('CHN-C001', 'Arun', 'Kumar', '9840012345', 'arun@test.com', @dealer1),
       ('CHN-C002', 'Priya', 'Sundar', '9840067890', 'priya@test.com', @dealer1);
SET @cust1 = (SELECT id FROM customers WHERE customer_code = 'CHN-C001');

-- Leads (Active)
INSERT INTO leads (lead_number, customer_id, dealer_id, source_id, assigned_to, preferred_model_id, status)
SELECT 'LD-2026-001', @cust1, @dealer1, 1, @salesexec1, id, 'NEW' FROM vehicle_models WHERE model_code = 'CRETA';

-- Historical Sales (Essential for Charts!)
INSERT INTO bookings (booking_number, lead_id, customer_id, dealer_id, variant_id, color_id, sales_exec_id, status, total_on_road, created_at)
SELECT 'BK-2025-H88', 1, @cust1, @dealer1, @v_creta_sx, 1, @salesexec1, 'DELIVERED', 1650000, '2025-08-15 10:00:00';
INSERT INTO bookings (booking_number, lead_id, customer_id, dealer_id, variant_id, color_id, sales_exec_id, status, total_on_road, created_at)
SELECT 'BK-2025-H99', 1, @cust1, @dealer1, @v_verna_sx, 2, @salesexec1, 'DELIVERED', 1980000, '2025-11-20 14:00:00';

-- Current Stock (Inventory)
INSERT INTO vehicles (vin, engine_number, variant_id, color_id, location_id, dealer_id, mfg_year, status)
VALUES ('HNDCRETA123456789', 'EN-CR-78901', @v_creta_sx, 1, 1, @dealer1, 2026, 'IN_STOCK'),
       ('HNDVERNA987654321', 'EN-VR-45678', @v_verna_sx, 2, 1, @dealer1, 2026, 'IN_STOCK');

-- Service Workload
INSERT INTO service_appointments (appointment_no, customer_id, dealer_id, vehicle_reg_no, appointed_by, appointment_date, status)
VALUES ('APT-001', @cust1, @dealer1, 'TN-01-AB-1234', @salesexec1, DATE_ADD(NOW(), INTERVAL 1 DAY), 'SCHEDULED');

SET FOREIGN_KEY_CHECKS = 1;

-- ═══════════════════════════════════════════════════════════════════
--  INITIALIZATION COMPLETE
--  Admin Login: admin@hyundaidms.in / Password@123
-- ═══════════════════════════════════════════════════════════════════