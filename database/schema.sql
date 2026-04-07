-- ============================================================
--  HYUNDAI DEALER MANAGEMENT SYSTEM – MySQL 8.x Schema
--  Normalized to 3NF | All FKs & Indexes included
-- ============================================================

CREATE DATABASE IF NOT EXISTS dealerconnect CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE dealerconnect;

SET FOREIGN_KEY_CHECKS = 0;

-- ─────────────────────────────────────────────
--  LOOKUP / REFERENCE TABLES
-- ─────────────────────────────────────────────

CREATE TABLE roles (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(50)  NOT NULL UNIQUE COMMENT 'ADMIN, SALES_MANAGER, SALES_EXECUTIVE, SERVICE_ADVISOR, MECHANIC, INVENTORY_MANAGER, ACCOUNTS',
    description VARCHAR(255),
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE departments (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE lead_sources (
    id   BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE   COMMENT 'Walk-In, Online, Referral, Cold-Call …'
);

CREATE TABLE colors (
    id        BIGINT AUTO_INCREMENT PRIMARY KEY,
    name      VARCHAR(50)  NOT NULL,
    hex_code  VARCHAR(10),
    UNIQUE KEY uq_color_name (name)
);

CREATE TABLE engine_types (
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    name         VARCHAR(100) NOT NULL UNIQUE  COMMENT 'Petrol, Diesel, EV, Hybrid …',
    fuel_category VARCHAR(30)
);

CREATE TABLE inventory_locations (
    id       BIGINT AUTO_INCREMENT PRIMARY KEY,
    name     VARCHAR(100) NOT NULL UNIQUE,
    address  VARCHAR(255)
);

CREATE TABLE banks (
    id      BIGINT AUTO_INCREMENT PRIMARY KEY,
    name    VARCHAR(150) NOT NULL UNIQUE,
    ifsc_prefix VARCHAR(10),
    contact VARCHAR(20)
);

CREATE TABLE suppliers (
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

-- ─────────────────────────────────────────────
--  EMPLOYEE CORE
-- ─────────────────────────────────────────────

CREATE TABLE employees (
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
    date_of_join  DATE,
    is_active     BOOLEAN DEFAULT TRUE,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_emp_dept   FOREIGN KEY (department_id) REFERENCES departments(id),
    CONSTRAINT fk_emp_role   FOREIGN KEY (role_id)       REFERENCES roles(id),
    CONSTRAINT fk_emp_mgr    FOREIGN KEY (manager_id)    REFERENCES employees(id),
    INDEX idx_emp_dept   (department_id),
    INDEX idx_emp_role   (role_id),
    INDEX idx_emp_active (is_active)
);

-- ─────────────────────────────────────────────
--  VEHICLE CATALOGUE
-- ─────────────────────────────────────────────

CREATE TABLE vehicle_models (
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    model_code   VARCHAR(20) NOT NULL UNIQUE,
    model_name   VARCHAR(100) NOT NULL,
    segment      VARCHAR(50)  COMMENT 'Sedan, SUV, Hatchback …',
    launch_year  YEAR,
    is_active    BOOLEAN DEFAULT TRUE,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE vehicle_variants (
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    model_id      BIGINT NOT NULL,
    variant_code  VARCHAR(20) NOT NULL UNIQUE,
    variant_name  VARCHAR(100) NOT NULL,
    engine_type_id BIGINT NOT NULL,
    transmission  VARCHAR(30) COMMENT 'Manual, Automatic, DCT …',
    seating_capacity TINYINT DEFAULT 5,
    ex_showroom_price DECIMAL(12,2) NOT NULL,
    is_active     BOOLEAN DEFAULT TRUE,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_vv_model  FOREIGN KEY (model_id)       REFERENCES vehicle_models(id),
    CONSTRAINT fk_vv_engine FOREIGN KEY (engine_type_id) REFERENCES engine_types(id),
    INDEX idx_vv_model (model_id)
);

-- ─────────────────────────────────────────────
--  VEHICLE INVENTORY
-- ─────────────────────────────────────────────

CREATE TABLE vehicles (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    vin             VARCHAR(17) NOT NULL UNIQUE COMMENT 'Vehicle Identification Number',
    engine_number   VARCHAR(50) UNIQUE,
    chassis_number  VARCHAR(50) UNIQUE,
    variant_id      BIGINT NOT NULL,
    color_id        BIGINT NOT NULL,
    location_id     BIGINT NOT NULL,
    mfg_year        YEAR,
    mfg_date        DATE,
    arrival_date    DATE    COMMENT 'Dealer arrival date',
    status          ENUM('IN_STOCK','ALLOCATED','SOLD','IN_TRANSIT','DEMO') DEFAULT 'IN_STOCK',
    invoice_date    DATE    COMMENT 'Factory invoice date',
    dealer_cost     DECIMAL(12,2),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_v_variant  FOREIGN KEY (variant_id)  REFERENCES vehicle_variants(id),
    CONSTRAINT fk_v_color    FOREIGN KEY (color_id)    REFERENCES colors(id),
    CONSTRAINT fk_v_location FOREIGN KEY (location_id) REFERENCES inventory_locations(id),
    INDEX idx_v_status   (status),
    INDEX idx_v_variant  (variant_id),
    INDEX idx_v_location (location_id)
);

-- ─────────────────────────────────────────────
--  CUSTOMER
-- ─────────────────────────────────────────────

CREATE TABLE customers (
    id             BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_code  VARCHAR(20) NOT NULL UNIQUE,
    first_name     VARCHAR(80) NOT NULL,
    last_name      VARCHAR(80) NOT NULL,
    email          VARCHAR(150),
    phone          VARCHAR(20) NOT NULL,
    alternate_phone VARCHAR(20),
    date_of_birth  DATE,
    gender         ENUM('MALE','FEMALE','OTHER'),
    pan_number     VARCHAR(10),
    aadhaar_number VARCHAR(12),
    customer_type  ENUM('INDIVIDUAL','CORPORATE') DEFAULT 'INDIVIDUAL',
    company_name   VARCHAR(150),
    gst_number     VARCHAR(20),
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_cust_phone (phone),
    INDEX idx_cust_email (email)
);

CREATE TABLE customer_addresses (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    type        ENUM('HOME','OFFICE','OTHER') DEFAULT 'HOME',
    line1       VARCHAR(255) NOT NULL,
    line2       VARCHAR(255),
    city        VARCHAR(100) NOT NULL,
    state       VARCHAR(100) NOT NULL,
    pincode     VARCHAR(10) NOT NULL,
    is_primary  BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_ca_customer FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    INDEX idx_ca_customer (customer_id)
);

-- ─────────────────────────────────────────────
--  LEADS & ENQUIRIES
-- ─────────────────────────────────────────────

CREATE TABLE leads (
    id               BIGINT AUTO_INCREMENT PRIMARY KEY,
    lead_number      VARCHAR(20) NOT NULL UNIQUE,
    customer_id      BIGINT NOT NULL,
    source_id        BIGINT NOT NULL,
    assigned_to      BIGINT NOT NULL COMMENT 'Sales Executive employee id',
    preferred_model_id   BIGINT,
    preferred_variant_id BIGINT,
    preferred_color_id   BIGINT,
    status           ENUM('NEW','CONTACTED','TEST_DRIVE','NEGOTIATION','BOOKED','LOST','DELIVERED') DEFAULT 'NEW',
    remarks          TEXT,
    expected_close_date DATE,
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_lead_cust    FOREIGN KEY (customer_id)           REFERENCES customers(id),
    CONSTRAINT fk_lead_source  FOREIGN KEY (source_id)             REFERENCES lead_sources(id),
    CONSTRAINT fk_lead_exec    FOREIGN KEY (assigned_to)           REFERENCES employees(id),
    CONSTRAINT fk_lead_model   FOREIGN KEY (preferred_model_id)    REFERENCES vehicle_models(id),
    CONSTRAINT fk_lead_variant FOREIGN KEY (preferred_variant_id)  REFERENCES vehicle_variants(id),
    CONSTRAINT fk_lead_color   FOREIGN KEY (preferred_color_id)    REFERENCES colors(id),
    INDEX idx_lead_status   (status),
    INDEX idx_lead_exec     (assigned_to),
    INDEX idx_lead_customer (customer_id)
);

CREATE TABLE test_drives (
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    lead_id       BIGINT NOT NULL,
    vehicle_id    BIGINT NOT NULL,
    scheduled_at  DATETIME NOT NULL,
    conducted_by  BIGINT NOT NULL COMMENT 'Sales Executive',
    status        ENUM('SCHEDULED','COMPLETED','CANCELLED') DEFAULT 'SCHEDULED',
    feedback      TEXT,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_td_lead   FOREIGN KEY (lead_id)      REFERENCES leads(id),
    CONSTRAINT fk_td_vehicle FOREIGN KEY (vehicle_id)   REFERENCES vehicles(id),
    CONSTRAINT fk_td_exec    FOREIGN KEY (conducted_by) REFERENCES employees(id),
    INDEX idx_td_lead    (lead_id),
    INDEX idx_td_vehicle (vehicle_id)
);

-- ─────────────────────────────────────────────
--  BOOKINGS & SALES
-- ─────────────────────────────────────────────

CREATE TABLE bookings (
    id               BIGINT AUTO_INCREMENT PRIMARY KEY,
    booking_number   VARCHAR(20) NOT NULL UNIQUE,
    lead_id          BIGINT NOT NULL,
    customer_id      BIGINT NOT NULL,
    variant_id       BIGINT NOT NULL,
    color_id         BIGINT NOT NULL,
    sales_exec_id    BIGINT NOT NULL,
    ex_showroom      DECIMAL(12,2) NOT NULL,
    discount         DECIMAL(10,2) DEFAULT 0,
    accessories_amt  DECIMAL(10,2) DEFAULT 0,
    tcs_amt          DECIMAL(10,2) DEFAULT 0,
    registration_amt DECIMAL(10,2) DEFAULT 0,
    insurance_amt    DECIMAL(10,2) DEFAULT 0,
    total_on_road    DECIMAL(12,2) NOT NULL,
    status           ENUM('BOOKED','ALLOCATED','INVOICED','DELIVERED','CANCELLED') DEFAULT 'BOOKED',
    expected_delivery DATE,
    vehicle_id       BIGINT,
    remarks          TEXT,
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_bk_lead     FOREIGN KEY (lead_id)       REFERENCES leads(id),
    CONSTRAINT fk_bk_customer FOREIGN KEY (customer_id)   REFERENCES customers(id),
    CONSTRAINT fk_bk_variant  FOREIGN KEY (variant_id)    REFERENCES vehicle_variants(id),
    CONSTRAINT fk_bk_color    FOREIGN KEY (color_id)      REFERENCES colors(id),
    CONSTRAINT fk_bk_exec     FOREIGN KEY (sales_exec_id) REFERENCES employees(id),
    CONSTRAINT fk_bk_vehicle  FOREIGN KEY (vehicle_id)    REFERENCES vehicles(id),
    INDEX idx_bk_status   (status),
    INDEX idx_bk_customer (customer_id),
    INDEX idx_bk_exec     (sales_exec_id)
);

CREATE TABLE booking_payments (
    id             BIGINT AUTO_INCREMENT PRIMARY KEY,
    booking_id     BIGINT NOT NULL,
    amount         DECIMAL(12,2) NOT NULL,
    payment_mode   ENUM('CASH','CHEQUE','NEFT','RTGS','UPI','CARD') NOT NULL,
    payment_date   DATE NOT NULL,
    reference_no   VARCHAR(100),
    remarks        TEXT,
    recorded_by    BIGINT NOT NULL,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_bp_booking  FOREIGN KEY (booking_id) REFERENCES bookings(id),
    CONSTRAINT fk_bp_recorder FOREIGN KEY (recorded_by) REFERENCES employees(id),
    INDEX idx_bp_booking (booking_id)
);

CREATE TABLE vehicle_allocations (
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    booking_id   BIGINT NOT NULL UNIQUE,
    vehicle_id   BIGINT NOT NULL UNIQUE,
    allocated_by BIGINT NOT NULL,
    allocated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_va_booking  FOREIGN KEY (booking_id)   REFERENCES bookings(id),
    CONSTRAINT fk_va_vehicle  FOREIGN KEY (vehicle_id)   REFERENCES vehicles(id),
    CONSTRAINT fk_va_allocby  FOREIGN KEY (allocated_by) REFERENCES employees(id),
    INDEX idx_va_vehicle  (vehicle_id),
    INDEX idx_va_booking  (booking_id)
);

-- ─────────────────────────────────────────────
--  INVOICES
-- ─────────────────────────────────────────────

CREATE TABLE invoices (
    id             BIGINT AUTO_INCREMENT PRIMARY KEY,
    invoice_number VARCHAR(20) NOT NULL UNIQUE,
    booking_id     BIGINT NOT NULL UNIQUE,
    customer_id    BIGINT NOT NULL,
    vehicle_id     BIGINT NOT NULL,
    invoice_date   DATE NOT NULL,
    sub_total      DECIMAL(12,2) NOT NULL,
    gst_amount     DECIMAL(10,2) DEFAULT 0,
    total_amount   DECIMAL(12,2) NOT NULL,
    status         ENUM('DRAFT','ISSUED','PAID','CANCELLED') DEFAULT 'DRAFT',
    created_by     BIGINT NOT NULL,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_inv_booking  FOREIGN KEY (booking_id)  REFERENCES bookings(id),
    CONSTRAINT fk_inv_customer FOREIGN KEY (customer_id) REFERENCES customers(id),
    CONSTRAINT fk_inv_vehicle  FOREIGN KEY (vehicle_id)  REFERENCES vehicles(id),
    CONSTRAINT fk_inv_created  FOREIGN KEY (created_by)  REFERENCES employees(id),
    INDEX idx_inv_customer (customer_id),
    INDEX idx_inv_date     (invoice_date),
    INDEX idx_inv_status   (status)
);

CREATE TABLE invoice_items (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    invoice_id  BIGINT NOT NULL,
    description VARCHAR(255) NOT NULL,
    hsn_code    VARCHAR(10),
    quantity    DECIMAL(10,3) DEFAULT 1,
    unit_price  DECIMAL(12,2) NOT NULL,
    gst_rate    DECIMAL(5,2)  DEFAULT 0,
    total_price DECIMAL(12,2) NOT NULL,
    CONSTRAINT fk_ii_invoice FOREIGN KEY (invoice_id) REFERENCES invoices(id) ON DELETE CASCADE,
    INDEX idx_ii_invoice (invoice_id)
);

-- ─────────────────────────────────────────────
--  SERVICE CENTER
-- ─────────────────────────────────────────────

CREATE TABLE mechanics (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    employee_id BIGINT NOT NULL UNIQUE,
    speciality  VARCHAR(100),
    CONSTRAINT fk_mech_emp FOREIGN KEY (employee_id) REFERENCES employees(id)
);

CREATE TABLE service_appointments (
    id               BIGINT AUTO_INCREMENT PRIMARY KEY,
    appointment_no   VARCHAR(20) NOT NULL UNIQUE,
    customer_id      BIGINT NOT NULL,
    vehicle_reg_no   VARCHAR(20) NOT NULL COMMENT 'Customer''s already owned vehicle reg no',
    vehicle_variant_id  BIGINT,
    appointed_by     BIGINT NOT NULL COMMENT 'Service Advisor',
    appointment_date DATETIME NOT NULL,
    service_type     ENUM('PERIODIC','REPAIR','ACCIDENTAL','WARRANTY','RECALL') NOT NULL,
    status           ENUM('SCHEDULED','IN_PROGRESS','COMPLETED','CANCELLED') DEFAULT 'SCHEDULED',
    remarks          TEXT,
    created_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_sa_customer  FOREIGN KEY (customer_id)      REFERENCES customers(id),
    CONSTRAINT fk_sa_advisor   FOREIGN KEY (appointed_by)     REFERENCES employees(id),
    CONSTRAINT fk_sa_variant   FOREIGN KEY (vehicle_variant_id) REFERENCES vehicle_variants(id),
    INDEX idx_sa_customer (customer_id),
    INDEX idx_sa_date     (appointment_date),
    INDEX idx_sa_status   (status)
);

CREATE TABLE job_cards (
    id                  BIGINT AUTO_INCREMENT PRIMARY KEY,
    job_card_no         VARCHAR(20) NOT NULL UNIQUE,
    appointment_id      BIGINT NOT NULL UNIQUE,
    mechanic_id         BIGINT NOT NULL,
    odometer_in         INT,
    odometer_out        INT,
    diagnosis           TEXT,
    repair_details      TEXT,
    labour_cost         DECIMAL(10,2) DEFAULT 0,
    parts_cost          DECIMAL(10,2) DEFAULT 0,
    total_cost          DECIMAL(10,2) DEFAULT 0,
    status              ENUM('OPEN','IN_PROGRESS','PENDING_PARTS','COMPLETED','BILLED') DEFAULT 'OPEN',
    start_time          DATETIME,
    end_time            DATETIME,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_jc_appointment FOREIGN KEY (appointment_id) REFERENCES service_appointments(id),
    CONSTRAINT fk_jc_mechanic    FOREIGN KEY (mechanic_id)    REFERENCES mechanics(id),
    INDEX idx_jc_status   (status),
    INDEX idx_jc_mechanic (mechanic_id)
);

CREATE TABLE service_history (
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    job_card_id   BIGINT NOT NULL,
    description   VARCHAR(255) NOT NULL,
    action_taken  TEXT,
    recorded_by   BIGINT NOT NULL,
    recorded_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_sh_jobcard FOREIGN KEY (job_card_id) REFERENCES job_cards(id),
    CONSTRAINT fk_sh_recorded FOREIGN KEY (recorded_by) REFERENCES employees(id),
    INDEX idx_sh_jobcard (job_card_id)
);

-- ─────────────────────────────────────────────
--  SPARE PARTS
-- ─────────────────────────────────────────────

CREATE TABLE spare_parts (
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    part_number  VARCHAR(50) NOT NULL UNIQUE,
    name         VARCHAR(150) NOT NULL,
    description  TEXT,
    category     VARCHAR(80),
    unit         VARCHAR(20) DEFAULT 'Piece',
    unit_price   DECIMAL(12,2) NOT NULL,
    gst_rate     DECIMAL(5,2) DEFAULT 18.00,
    supplier_id  BIGINT,
    is_active    BOOLEAN DEFAULT TRUE,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_sp_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(id),
    INDEX idx_sp_category (category),
    INDEX idx_sp_supplier (supplier_id)
);

CREATE TABLE spare_part_inventory (
    id           BIGINT AUTO_INCREMENT PRIMARY KEY,
    part_id      BIGINT NOT NULL UNIQUE,
    location_id  BIGINT NOT NULL,
    quantity     DECIMAL(10,3) NOT NULL DEFAULT 0,
    reorder_level DECIMAL(10,3) DEFAULT 5,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_spi_part     FOREIGN KEY (part_id)     REFERENCES spare_parts(id),
    CONSTRAINT fk_spi_location FOREIGN KEY (location_id) REFERENCES inventory_locations(id),
    INDEX idx_spi_part     (part_id),
    INDEX idx_spi_location (location_id)
);

CREATE TABLE spare_part_usage (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    job_card_id BIGINT NOT NULL,
    part_id     BIGINT NOT NULL,
    quantity    DECIMAL(10,3) NOT NULL,
    unit_price  DECIMAL(12,2) NOT NULL,
    total_price DECIMAL(12,2) NOT NULL,
    used_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_spu_jobcard FOREIGN KEY (job_card_id) REFERENCES job_cards(id),
    CONSTRAINT fk_spu_part    FOREIGN KEY (part_id)     REFERENCES spare_parts(id),
    INDEX idx_spu_jobcard (job_card_id),
    INDEX idx_spu_part    (part_id)
);

-- ─────────────────────────────────────────────
--  FINANCE & INSURANCE
-- ─────────────────────────────────────────────

CREATE TABLE finance_loans (
    id             BIGINT AUTO_INCREMENT PRIMARY KEY,
    loan_number    VARCHAR(30) NOT NULL UNIQUE,
    booking_id     BIGINT NOT NULL,
    customer_id    BIGINT NOT NULL,
    bank_id        BIGINT NOT NULL,
    loan_amount    DECIMAL(12,2) NOT NULL,
    tenure_months  SMALLINT NOT NULL,
    interest_rate  DECIMAL(5,2) NOT NULL COMMENT 'Annual interest %',
    emi_amount     DECIMAL(10,2),
    disbursal_date DATE,
    status         ENUM('APPLIED','APPROVED','DISBURSED','REJECTED','CLOSED') DEFAULT 'APPLIED',
    remarks        TEXT,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_fl_booking  FOREIGN KEY (booking_id)  REFERENCES bookings(id),
    CONSTRAINT fk_fl_customer FOREIGN KEY (customer_id) REFERENCES customers(id),
    CONSTRAINT fk_fl_bank     FOREIGN KEY (bank_id)     REFERENCES banks(id),
    INDEX idx_fl_customer (customer_id),
    INDEX idx_fl_status   (status)
);

CREATE TABLE insurance_policies (
    id              BIGINT AUTO_INCREMENT PRIMARY KEY,
    policy_number   VARCHAR(50) NOT NULL UNIQUE,
    booking_id      BIGINT NOT NULL,
    customer_id     BIGINT NOT NULL,
    insurer_name    VARCHAR(150) NOT NULL,
    policy_type     ENUM('COMPREHENSIVE','THIRD_PARTY','OWN_DAMAGE') DEFAULT 'COMPREHENSIVE',
    premium_amount  DECIMAL(10,2) NOT NULL,
    start_date      DATE NOT NULL,
    end_date        DATE NOT NULL,
    status          ENUM('ACTIVE','EXPIRED','CANCELLED') DEFAULT 'ACTIVE',
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_ip_booking  FOREIGN KEY (booking_id)  REFERENCES bookings(id),
    CONSTRAINT fk_ip_customer FOREIGN KEY (customer_id) REFERENCES customers(id),
    INDEX idx_ip_customer (customer_id),
    INDEX idx_ip_end_date (end_date)
);

-- ─────────────────────────────────────────────
--  PAYMENTS & RECEIPTS
-- ─────────────────────────────────────────────

CREATE TABLE payments (
    id            BIGINT AUTO_INCREMENT PRIMARY KEY,
    payment_ref   VARCHAR(30) NOT NULL UNIQUE,
    invoice_id    BIGINT,
    job_card_id   BIGINT,
    customer_id   BIGINT NOT NULL,
    amount        DECIMAL(12,2) NOT NULL,
    payment_mode  ENUM('CASH','CHEQUE','NEFT','RTGS','UPI','CARD') NOT NULL,
    payment_date  DATE NOT NULL,
    reference_no  VARCHAR(100),
    status        ENUM('PENDING','COMPLETED','FAILED','REFUNDED') DEFAULT 'PENDING',
    recorded_by   BIGINT NOT NULL,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pay_invoice  FOREIGN KEY (invoice_id)  REFERENCES invoices(id),
    CONSTRAINT fk_pay_jobcard  FOREIGN KEY (job_card_id) REFERENCES job_cards(id),
    CONSTRAINT fk_pay_customer FOREIGN KEY (customer_id) REFERENCES customers(id),
    CONSTRAINT fk_pay_recorder FOREIGN KEY (recorded_by) REFERENCES employees(id),
    INDEX idx_pay_customer (customer_id),
    INDEX idx_pay_date     (payment_date),
    INDEX idx_pay_status   (status)
);

CREATE TABLE receipts (
    id             BIGINT AUTO_INCREMENT PRIMARY KEY,
    receipt_number VARCHAR(20) NOT NULL UNIQUE,
    payment_id     BIGINT NOT NULL UNIQUE,
    issued_date    DATE NOT NULL,
    issued_by      BIGINT NOT NULL,
    CONSTRAINT fk_rec_payment FOREIGN KEY (payment_id) REFERENCES payments(id),
    CONSTRAINT fk_rec_issuer  FOREIGN KEY (issued_by)  REFERENCES employees(id)
);


SET FOREIGN_KEY_CHECKS = 1;
