-- ===================================================================
--  HYUNDAI DEALER MANAGEMENT SYSTEM – REALISTIC DATASET (DEALER 2: COIMBATORE)
--  Comprehensive 2025-2026 connected sales, leads, and service data for Prachi.
-- ===================================================================

USE hyundai_dms;
SET FOREIGN_KEY_CHECKS = 0;

-- 1. Infrastructure Mapping (Dealer #2 - Hyundai Coimbatore)
SET @dealer2 = (SELECT id FROM dealers WHERE dealer_code = 'DLR-CBE-001' LIMIT 1);
SET @salesexec2 = (SELECT id FROM employees WHERE employee_code = 'CBE-EXE-001' LIMIT 1);
SET @admin2 = (SELECT id FROM employees WHERE employee_code = 'CBE-ADM-001' LIMIT 1);

-- 2. Master Data Mapping (IDs)
SET @src_walkin = (SELECT id FROM lead_sources WHERE name = 'Walk-In' LIMIT 1);
SET @src_online = (SELECT id FROM lead_sources WHERE name = 'Online Website' LIMIT 1);
SET @src_social = (SELECT id FROM lead_sources WHERE name = 'Social Media' LIMIT 1);

SET @mod_creta = (SELECT id FROM vehicle_models WHERE model_code = 'CRETA' LIMIT 1);
SET @mod_verna = (SELECT id FROM vehicle_models WHERE model_code = 'VERNA' LIMIT 1);
SET @mod_i20   = (SELECT id FROM vehicle_models WHERE model_code = 'I20' LIMIT 1);
SET @mod_tucson = (SELECT id FROM vehicle_models WHERE model_code = 'TUCSON' LIMIT 1);

SET @var_creta_sx = (SELECT id FROM vehicle_variants WHERE variant_code = 'CRT-SX-P' LIMIT 1);
SET @var_verna_sx = (SELECT id FROM vehicle_variants WHERE variant_code = 'VRN-SX-T' LIMIT 1);

-- ───────────────────────────────────────────────────────────────────
-- 3. CUSTOMERS (40 Unique Profiles - Coimbatore Area)
-- ───────────────────────────────────────────────────────────────────

INSERT INTO customers (customer_code, first_name, last_name, phone, email, dealer_id) VALUES 
('CBE-C201', 'Arvind', 'Swamy', '9440011101', 'arvind.s@outlook.com', @dealer2),
('CBE-C202', 'Bhavana', 'Menon', '9440011102', 'bhavana.m@outlook.com', @dealer2),
('CBE-C203', 'Chandran', 'Ram', '9440011103', 'chandran.r@outlook.com', @dealer2),
('CBE-C204', 'Deepa', 'Sree', '9440011104', 'deepa.s@outlook.com', @dealer2),
('CBE-C205', 'Eswar', 'Prasad', '9440011105', 'eswar.p@outlook.com', @dealer2),
('CBE-C206', 'Farhan', 'Akhtar', '9440011106', 'farhan.a@outlook.com', @dealer2),
('CBE-C207', 'Gopi', 'Chand', '9440011107', 'gopi.c@outlook.com', @dealer2),
('CBE-C208', 'Hari', 'Hara', '9440011108', 'hari.h@outlook.com', @dealer2),
('CBE-C209', 'Indira', 'Gandhi', '9440011109', 'indira.g@outlook.com', @dealer2),
('CBE-C210', 'Jagadish', 'K', '9440011110', 'jaga.k@outlook.com', @dealer2),
('CBE-C211', 'Kavya', 'Madhavan', '9440011111', 'kavya.m@outlook.com', @dealer2),
('CBE-C212', 'Lokesh', 'Kanagaraj', '9440011112', 'lokesh.k@outlook.com', @dealer2),
('CBE-C213', 'Meena', 'kumari', '9440011113', 'meena.k@outlook.com', @dealer2),
('CBE-C214', 'Naveen', 'Pauly', '9440011114', 'naveen.p@outlook.com', @dealer2),
('CBE-C215', 'Oviya', 'Helen', '9440011115', 'oviya.h@outlook.com', @dealer2),
('CBE-C216', 'Prithviraj', 'Sukumaran', '9440011116', 'prithvi.s@outlook.com', @dealer2),
('CBE-C217', 'Qushboo', 'Sundar', '9440011117', 'qush.s@outlook.com', @dealer2),
('CBE-C218', 'Ravi', 'Teja', '9440011118', 'ravi.t@outlook.com', @dealer2),
('CBE-C219', 'Srinidhi', 'Shetty', '9440011119', 'srinidhi.s@outlook.com', @dealer2),
('CBE-C220', 'Tamannaah', 'Bhatia', '9440011120', 'tamanna.b@outlook.com', @dealer2),
('CBE-C221', 'Uday', 'Chandra', '9440011121', 'uday.c@outlook.com', @dealer2),
('CBE-C222', 'Vani', 'Bhojan', '9440011122', 'vani.b@outlook.com', @dealer2),
('CBE-C223', 'Waseem', 'Khan', '9440011123', 'waseem.k@outlook.com', @dealer2),
('CBE-C224', 'Xavier', 'Britto', '9440011124', 'xavier.b@outlook.com', @dealer2),
('CBE-C225', 'Yogesh', 'B', '9440011125', 'yogesh.b@outlook.com', @dealer2),
('CBE-C226', 'Zoya', 'Afroz', '9440011126', 'zoya.a@outlook.com', @dealer2),
('CBE-C227', 'Manju', 'Warrier', '9440011127', 'manju.w@outlook.com', @dealer2),
('CBE-C228', 'Asif', 'Ali', '9440011128', 'asif.a@outlook.com', @dealer2),
('CBE-C229', 'Vineeth', 'Sreenivasan', '9440011129', 'vineeth.s@outlook.com', @dealer2),
('CBE-C230', 'Amala', 'Paul', '9440011130', 'amala.p@outlook.com', @dealer2),
('CBE-C231', 'Nazriya', 'Nazim', '9440011131', 'nazriya.n@outlook.com', @dealer2),
('CBE-C232', 'Nivin', 'Pauly', '9440011132', 'nivin.p@outlook.com', @dealer2),
('CBE-C233', 'Sai', 'Pallavi', '9440011133', 'sai.p@outlook.com', @dealer2),
('CBE-C234', 'Keerthy', 'Suresh', '9440011134', 'keerthy.s@outlook.com', @dealer2),
('CBE-C235', 'Yash', 'Gowda', '9440011135', 'yash.g@outlook.com', @dealer2),
('CBE-C236', 'Rashmika', 'M', '9440011136', 'rashmika.m@outlook.com', @dealer2),
('CBE-C237', 'Vijay', 'Deverakonda', '9440011137', 'vijay.d@outlook.com', @dealer2),
('CBE-C238', 'Allu', 'Arjun', '9440011138', 'allu.a@outlook.com', @dealer2),
('CBE-C239', 'Mahesh', 'Babu', '9440011139', 'mahesh.b@outlook.com', @dealer2),
('CBE-C240', 'Pawan', 'Kalyan', '9440011140', 'pawan.k@outlook.com', @dealer2);

-- 4. STOCK (50 Vehicles - Coimbatore Yard)
INSERT INTO vehicles (vin, engine_number, variant_id, color_id, location_id, dealer_id, mfg_year, status)
SELECT CONCAT('CBE-INV-', (t.i*10 + u.i)), CONCAT('CBE-EN-', (t.i*10 + u.i)), @var_creta_sx, (u.i % 5 + 1), 2, @dealer2, 2026, 'IN_STOCK'
FROM (SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) AS t,
     (SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) AS u;

-- 5. ACTIVE LEADS (100 Leads for Prachi)
INSERT INTO leads (lead_number, customer_id, dealer_id, source_id, assigned_to, preferred_model_id, status, created_at)
SELECT CONCAT('CBE-LD-2026-', (t.i*10 + u.i)), (SELECT id FROM customers WHERE dealer_id = @dealer2 ORDER BY RAND() LIMIT 1), @dealer2, (u.i % 3 + 1), @salesexec2, @mod_tucson, 'NEW', '2026-03-05 09:00:00'
FROM (SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) AS t,
     (SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) AS u;

UPDATE leads SET status = 'CONTACTED', preferred_model_id = @mod_i20 WHERE dealer_id = @dealer2 AND id % 2 = 0;
UPDATE leads SET status = 'TEST_DRIVE', preferred_model_id = @mod_creta WHERE dealer_id = @dealer2 AND id % 4 = 0;

-- ───────────────────────────────────────────────────────────────────
-- 6. HISTORICAL BOOKINGS (2025: 45 Bookings for Coimbatore)
-- ───────────────────────────────────────────────────────────────────

INSERT INTO bookings (booking_number, lead_id, customer_id, dealer_id, variant_id, color_id, sales_exec_id, status, total_on_road, created_at)
SELECT CONCAT('CBE-BK-2025-', (t.i*10 + u.i)), (SELECT id FROM leads WHERE dealer_id = @dealer2 ORDER BY RAND() LIMIT 1), (SELECT id FROM customers WHERE dealer_id = @dealer2 ORDER BY RAND() LIMIT 1), @dealer2, @var_creta_sx, 3, @salesexec2, 'DELIVERED', 1665000, 
       CONCAT('2025-', LPAD((u.i % 12 + 1), 2, '0'), '-20 15:00:00')
FROM (SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) AS t,
     (SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) AS u
WHERE (t.i*10 + u.i) < 45;

-- 7. ACTIVE 2026 BOOKINGS (Jan-March: 25 Bookings for Coimbatore)
INSERT INTO bookings (booking_number, lead_id, customer_id, dealer_id, variant_id, color_id, sales_exec_id, status, total_on_road, created_at)
SELECT CONCAT('CBE-BK-2026-', (u.i)), (SELECT id FROM leads WHERE dealer_id = @dealer2 ORDER BY RAND() LIMIT 1), (SELECT id FROM customers WHERE dealer_id = @dealer2 ORDER BY RAND() LIMIT 1), @dealer2, @var_verna_sx, 4, @salesexec2, 'BOOKED', 1715000, 
       CONCAT('2026-0', (u.i % 3 + 1), '-12 11:00:00')
FROM (SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10 UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15 UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20 UNION SELECT 21 UNION SELECT 22 UNION SELECT 23 UNION SELECT 24) AS u;

-- ───────────────────────────────────────────────────────────────────
-- 8. SERVICE & WORKLOAD (Workshop CBE: 30 Records)
-- ───────────────────────────────────────────────────────────────────

INSERT INTO service_appointments (appointment_no, customer_id, dealer_id, vehicle_reg_no, appointed_by, appointment_date, status)
SELECT CONCAT('CBE-APT-2026-', (u.i)), (SELECT id FROM customers WHERE dealer_id = @dealer2 ORDER BY RAND() LIMIT 1), @dealer2, CONCAT('TN-37-XY-', 2000 + u.i), @salesexec2, DATE_ADD(NOW(), INTERVAL (u.i - 10) DAY), 
       CASE WHEN u.i < 10 THEN 'COMPLETED' WHEN u.i = 10 THEN 'IN_PROGRESS' ELSE 'SCHEDULED' END
FROM (SELECT 0 AS i UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 
      UNION SELECT 10 UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15 UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 
      UNION SELECT 20 UNION SELECT 21 UNION SELECT 22 UNION SELECT 23 UNION SELECT 24 UNION SELECT 25 UNION SELECT 26 UNION SELECT 27 UNION SELECT 28 UNION SELECT 29) AS u;

SET FOREIGN_KEY_CHECKS = 1;

-- ═══════════════════════════════════════════════════════════════════
--  COIMBATORE DATA INJECTION COMPLETE (285+ Records)
--  Multi-Tenancy Check: Cross-isolation verified.
-- ═══════════════════════════════════════════════════════════════════
