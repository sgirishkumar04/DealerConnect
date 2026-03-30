-- ===================================================================
--  HYUNDAI DEALER MANAGEMENT SYSTEM – REALISTIC DATASET (250+ RECORDS)
--  Comprehensive 2025-2026 connected sales, leads, and service data.
-- ===================================================================

USE hyundai_dms;
SET FOREIGN_KEY_CHECKS = 0;
SET SQL_SAFE_UPDATES = 0;

-- 1. Infrastructure Mapping (Dealer #1 - Hyundai Chennai)
SET @dealer1 = (SELECT id FROM dealers WHERE dealer_code = 'DLR-CHN-001' LIMIT 1);
SET @salesexec1 = (SELECT id FROM employees WHERE employee_code = 'CHN-EXE-001' LIMIT 1);
SET @admin1 = (SELECT id FROM employees WHERE employee_code = 'CHN-ADM-001' LIMIT 1);

-- 2. Master Data Mapping (IDs)
SET @src_walkin = (SELECT id FROM lead_sources WHERE name = 'Walk-In' LIMIT 1);
SET @src_online = (SELECT id FROM lead_sources WHERE name = 'Online Website' LIMIT 1);
SET @src_referral = (SELECT id FROM lead_sources WHERE name = 'Referral' LIMIT 1);

SET @mod_creta = (SELECT id FROM vehicle_models WHERE model_code = 'CRETA' LIMIT 1);
SET @mod_verna = (SELECT id FROM vehicle_models WHERE model_code = 'VERNA' LIMIT 1);
SET @mod_venue = (SELECT id FROM vehicle_models WHERE model_code = 'VENUE' LIMIT 1);
SET @mod_exter = (SELECT id FROM vehicle_models WHERE model_code = 'EXTER' LIMIT 1);

SET @var_creta_sx = (SELECT id FROM vehicle_variants WHERE variant_code = 'CRT-SX-P' LIMIT 1);
SET @var_verna_sx = (SELECT id FROM vehicle_variants WHERE variant_code = 'VRN-SX-T' LIMIT 1);

-- ───────────────────────────────────────────────────────────────────
-- 3. CUSTOMERS (40 Unique Profiles)
-- ───────────────────────────────────────────────────────────────────

INSERT INTO customers (customer_code, first_name, last_name, phone, email, dealer_id) VALUES 
('CHN-C101', 'Rajesh', 'Khanna', '9840011111', 'rajesh.k@gmail.com', @dealer1),
('CHN-C102', 'Mahesh', 'Babu', '9840011112', 'mahesh.b@gmail.com', @dealer1),
('CHN-C103', 'Sneha', 'Lata', '9840011113', 'sneha.l@gmail.com', @dealer1),
('CHN-C104', 'Ananya', 'Pandey', '9840011114', 'ananya.p@gmail.com', @dealer1),
('CHN-C105', 'Vikram', 'Prabhu', '9840011115', 'vikram.p@gmail.com', @dealer1),
('CHN-C106', 'Senthil', 'Kumar', '9840011116', 'senthil.k@gmail.com', @dealer1),
('CHN-C107', 'Gautham', 'Menon', '9840011117', 'gautham.m@gmail.com', @dealer1),
('CHN-C108', 'Karthik', 'Siva', '9840011118', 'karthik.s@gmail.com', @dealer1),
('CHN-C109', 'Divya', 'Sridhar', '9840011119', 'divya.s@gmail.com', @dealer1),
('CHN-C110', 'Pooja', 'Hegde', '9840011120', 'pooja.h@gmail.com', @dealer1),
('CHN-C111', 'Arjun', 'Sarja', '9840011121', 'arjun.s@gmail.com', @dealer1),
('CHN-C112', 'Nayani', 'Pavani', '9840011122', 'nayani.p@gmail.com', @dealer1),
('CHN-C113', 'Bala', 'Krishna', '9840011123', 'bala.k@gmail.com', @dealer1),
('CHN-C114', 'Chiranjeevi', 'Konidela', '9840011124', 'chiru.k@gmail.com', @dealer1),
('CHN-C115', 'Ram', 'Charan', '9840011125', 'ram.c@gmail.com', @dealer1),
('CHN-C116', 'Jr', 'NTR', '9840011126', 'ntr.jr@gmail.com', @dealer1),
('CHN-C117', 'Samantha', 'Ruth', '9840011127', 'samantha.r@gmail.com', @dealer1),
('CHN-C118', 'Rashmika', 'Mandanna', '9840011128', 'rashmika.m@gmail.com', @dealer1),
('CHN-C119', 'Vijay', 'Sethupathi', '9840011129', 'vijay.s@gmail.com', @dealer1),
('CHN-C120', 'Dhanush', 'K', '9840011130', 'dhanush.k@gmail.com', @dealer1),
('CHN-C121', 'Trisha', 'Krishnan', '9840011131', 'trisha.k@gmail.com', @dealer1),
('CHN-C122', 'Nayanthara', 'V', '9840011132', 'nayan.v@gmail.com', @dealer1),
('CHN-C123', 'Suriya', 'Sivakumar', '9840011133', 'suriya.s@gmail.com', @dealer1),
('CHN-C124', 'Jyothika', 'S', '9840011134', 'joy.s@gmail.com', @dealer1),
('CHN-C125', 'Ajith', 'Kumar', '9840011135', 'ajith.k@gmail.com', @dealer1),
('CHN-C126', 'Vijay', 'Joseph', '9840011136', 'vijay.j@gmail.com', @dealer1),
('CHN-C127', 'Rajini', 'Kanth', '9840011137', 'rajini.k@gmail.com', @dealer1),
('CHN-C128', 'Kamal', 'Haasan', '9840011138', 'kamal.h@gmail.com', @dealer1),
('CHN-C129', 'Mohanlal', 'V', '9840011139', 'mohan.v@gmail.com', @dealer1),
('CHN-C130', 'Mammootty', 'S', '9840011140', 'mammo.s@gmail.com', @dealer1),
('CHN-C131', 'Prithviraj', 'S', '9840011141', 'prithvi.s@gmail.com', @dealer1),
('CHN-C132', 'Fahadh', 'Faasil', '9840011142', 'fahadh.f@gmail.com', @dealer1),
('CHN-C133', 'Dulquer', 'Salmaan', '9840011143', 'dq.s@gmail.com', @dealer1),
('CHN-C134', 'Tovino', 'Thomas', '9840011144', 'tovino.t@gmail.com', @dealer1),
('CHN-C135', 'Yash', 'K', '9840011145', 'yash.k@gmail.com', @dealer1),
('CHN-C136', 'Rishab', 'Shetty', '9840011146', 'rishab.s@gmail.com', @dealer1),
('CHN-C137', 'Rakshit', 'Shetty', '9840011147', 'rakshit.s@gmail.com', @dealer1),
('CHN-C138', 'Puneeth', 'Raj', '9840011148', 'appu.r@gmail.com', @dealer1),
('CHN-C139', 'Darshan', 'T', '9840011149', 'darshan.t@gmail.com', @dealer1),
('CHN-C140', 'Sudeep', 'K', '9840011150', 'sudeep.k@gmail.com', @dealer1);

-- 4. CURRENT STOCK (Inventory - 50 Vehicles)
INSERT INTO vehicles (vin, engine_number, variant_id, color_id, location_id, dealer_id, mfg_year, status)
SELECT CONCAT('HND-INV-', (t.i*10 + u.i)), CONCAT('EN-', (t.i*10 + u.i)), @var_creta_sx, (u.i % 5 + 1), 1, @dealer1, 2026, 'IN_STOCK'
FROM (SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) AS t,
     (SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) AS u;

-- 5. ACTIVE LEADS (100 Leads)
INSERT INTO leads (lead_number, customer_id, dealer_id, source_id, assigned_to, preferred_model_id, status, created_at)
SELECT CONCAT('LD-2026-', (t.i*10 + u.i)), (SELECT id FROM customers WHERE dealer_id = @dealer1 ORDER BY RAND() LIMIT 1), @dealer1, (u.i % 3 + 1), @salesexec1, @mod_creta, 'NEW', '2026-03-01 10:00:00'
FROM (SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) AS t,
     (SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) AS u;

UPDATE leads SET status = 'CONTACTED', preferred_model_id = @mod_verna WHERE id % 3 = 0;
UPDATE leads SET status = 'TEST_DRIVE', preferred_model_id = @mod_venue WHERE id % 5 = 0;
UPDATE leads SET status = 'NEGOTIATION' WHERE id % 7 = 0;

-- ───────────────────────────────────────────────────────────────────
-- 6. HISTORICAL BOOKINGS (2025: 45 Bookings)
-- ───────────────────────────────────────────────────────────────────

-- Spread across months for YoY charts
INSERT INTO bookings (booking_number, lead_id, customer_id, dealer_id, variant_id, color_id, sales_exec_id, status, total_on_road, created_at)
SELECT CONCAT('BK-2025-', (t.i*10 + u.i)), (SELECT id FROM leads ORDER BY RAND() LIMIT 1), (SELECT id FROM customers ORDER BY RAND() LIMIT 1), @dealer1, @var_creta_sx, 1, @salesexec1, 'DELIVERED', 1650000, 
       CONCAT('2025-', LPAD((u.i % 12 + 1), 2, '0'), '-15 11:00:00')
FROM (SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) AS t,
     (SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) AS u
WHERE (t.i*10 + u.i) < 45;

-- 7. ACTIVE 2026 BOOKINGS (Jan-March: 25 Bookings)
INSERT INTO bookings (booking_number, lead_id, customer_id, dealer_id, variant_id, color_id, sales_exec_id, status, total_on_road, created_at)
SELECT CONCAT('BK-2026-', (u.i)), (SELECT id FROM leads ORDER BY RAND() LIMIT 1), (SELECT id FROM customers ORDER BY RAND() LIMIT 1), @dealer1, @var_creta_sx, 2, @salesexec1, 'BOOKED', 1680000, 
       CONCAT('2026-0', (u.i % 3 + 1), '-10 14:00:00')
FROM (SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15 UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20 UNION SELECT 21 UNION SELECT 22 UNION SELECT 23 UNION SELECT 24) AS u;

-- ───────────────────────────────────────────────────────────────────
-- 8. SERVICE & WORKLOAD (Workshop: 30 Records)
-- ───────────────────────────────────────────────────────────────────

INSERT INTO service_appointments (appointment_no, customer_id, dealer_id, vehicle_reg_no, appointed_by, appointment_date, status)
SELECT CONCAT('APT-2026-', (u.i)), (SELECT id FROM customers ORDER BY RAND() LIMIT 1), @dealer1, CONCAT('TN-01-AB-', 1000 + u.i), @salesexec1, DATE_ADD(NOW(), INTERVAL (u.i - 15) DAY), 
       CASE WHEN u.i < 15 THEN 'COMPLETED' WHEN u.i = 15 THEN 'IN_PROGRESS' ELSE 'SCHEDULED' END
FROM (SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 
      UNION SELECT 10 UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15 UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 
      UNION SELECT 20 UNION SELECT 21 UNION SELECT 22 UNION SELECT 23 UNION SELECT 24 UNION SELECT 25 UNION SELECT 26 UNION SELECT 27 UNION SELECT 28 UNION SELECT 29) AS u;

-- 9. AUDIT LOGS (20 Events)
INSERT INTO audit_logs (entity_name, entity_id, action, changed_by_name, dealer_id, created_at)
SELECT 'Lead', (SELECT id FROM leads ORDER BY RAND() LIMIT 1), 'UPDATE', 'Girish', @dealer1, NOW()
FROM (SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 
      UNION SELECT 10 UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15 UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19) AS u;

SET FOREIGN_KEY_CHECKS = 1;

-- ═══════════════════════════════════════════════════════════════════
--  DATA INJECTION COMPLETE (285+ Records)
--  2025 Trend Data: Enabled 
--  2026 Showroom Health: Ready
-- ═══════════════════════════════════════════════════════════════════
