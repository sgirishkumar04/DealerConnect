-- ============================================================
--  DEALERCONNECT - 35 Connected Sales Booking Records
--  All FKs: lead (DELIVERED/BOOKED) → booking → vehicle
--  Booking Statuses: DELIVERED(15), INVOICED(10), ALLOCATED(10)
-- ============================================================
USE dealerconnect;
SET FOREIGN_KEY_CHECKS = 0;

-- ─── Leads (use only customer IDs 1 through 10) ─────────────────
INSERT INTO leads (lead_number, customer_id, source_id, assigned_to, preferred_variant_id, status) VALUES
('BL26-001', 1, 1, 3, 3,  'DELIVERED'), ('BL26-002', 2, 2, 4, 6,  'DELIVERED'),
('BL26-003', 3, 3, 8, 9,  'DELIVERED'), ('BL26-004', 4, 1, 3, 10, 'DELIVERED'),
('BL26-005', 5, 2, 4, 11, 'DELIVERED'), ('BL26-006', 6, 3, 8, 3,  'DELIVERED'),
('BL26-007', 7, 1, 3, 6,  'DELIVERED'), ('BL26-008', 8, 2, 4, 9,  'DELIVERED'),
('BL26-009', 9, 3, 8, 10, 'DELIVERED'), ('BL26-010', 10,1, 3, 11, 'DELIVERED'),
('BL26-011', 1, 2, 4, 3,  'DELIVERED'), ('BL26-012', 2, 3, 8, 6,  'DELIVERED'),
('BL26-013', 3, 1, 3, 9,  'DELIVERED'), ('BL26-014', 4, 2, 4, 10, 'DELIVERED'),
('BL26-015', 5, 3, 8, 11, 'DELIVERED'),
('BL26-016', 6, 1, 3, 3,  'DELIVERED'), ('BL26-017', 7, 2, 4, 6,  'DELIVERED'),
('BL26-018', 8, 3, 8, 9,  'DELIVERED'), ('BL26-019', 9, 1, 3, 10, 'DELIVERED'),
('BL26-020', 10,2, 4, 11, 'DELIVERED'), ('BL26-021', 1, 3, 8, 3,  'DELIVERED'),
('BL26-022', 2, 1, 3, 6,  'DELIVERED'), ('BL26-023', 3, 2, 4, 9,  'DELIVERED'),
('BL26-024', 4, 3, 8, 10, 'DELIVERED'), ('BL26-025', 5, 1, 3, 11, 'DELIVERED'),
('BL26-026', 6, 2, 4, 3,  'BOOKED'),    ('BL26-027', 7, 3, 8, 6,  'BOOKED'),
('BL26-028', 8, 1, 3, 9,  'BOOKED'),    ('BL26-029', 9, 2, 4, 10, 'BOOKED'),
('BL26-030', 10,3, 8, 11, 'BOOKED'),    ('BL26-031', 1, 1, 3, 3,  'BOOKED'),
('BL26-032', 2, 2, 4, 6,  'BOOKED'),    ('BL26-033', 3, 3, 8, 9,  'BOOKED'),
('BL26-034', 4, 1, 3, 10, 'BOOKED'),    ('BL26-035', 5, 2, 4, 11, 'BOOKED');

-- ─── Vehicles ────────────────────────────────────────────────
INSERT INTO vehicles (vin, engine_number, chassis_number, variant_id, color_id, location_id, mfg_year, mfg_date, arrival_date, status, dealer_cost) VALUES
('VBKG26D001','ED001','CD001',3, 7,1,2025,'2025-09-01','2025-09-20','SOLD',    880000),
('VBKG26D002','ED002','CD002',6, 9,1,2025,'2025-09-01','2025-09-20','SOLD',    770000),
('VBKG26D003','ED003','CD003',9, 5,1,2025,'2025-10-01','2025-10-15','SOLD',   1120000),
('VBKG26D004','ED004','CD004',10,4,1,2025,'2025-10-01','2025-10-15','SOLD',   1090000),
('VBKG26D005','ED005','CD005',11,1,1,2025,'2025-10-10','2025-10-25','SOLD',   1350000),
('VBKG26D006','ED006','CD006',3, 9,1,2025,'2025-11-01','2025-11-15','SOLD',    880000),
('VBKG26D007','ED007','CD007',6, 7,1,2025,'2025-11-01','2025-11-15','SOLD',    770000),
('VBKG26D008','ED008','CD008',9, 4,1,2025,'2025-11-10','2025-11-25','SOLD',   1120000),
('VBKG26D009','ED009','CD009',10,1,1,2025,'2025-12-01','2025-12-15','SOLD',   1090000),
('VBKG26D010','ED010','CD010',11,5,1,2025,'2025-12-01','2025-12-15','SOLD',   1350000),
('VBKG26D011','ED011','CD011',3, 4,1,2025,'2025-12-10','2026-01-05','SOLD',    880000),
('VBKG26D012','ED012','CD012',6, 1,1,2026,'2026-01-01','2026-01-20','SOLD',    770000),
('VBKG26D013','ED013','CD013',9, 9,1,2026,'2026-01-01','2026-01-20','SOLD',   1120000),
('VBKG26D014','ED014','CD014',10,7,1,2026,'2026-01-15','2026-02-01','SOLD',   1090000),
('VBKG26D015','ED015','CD015',11,4,1,2026,'2026-01-15','2026-02-01','SOLD',   1350000),
('VBKG26I001','EI001','CI001',3, 5,1,2026,'2026-01-20','2026-02-05','SOLD',    880000),
('VBKG26I002','EI002','CI002',6, 7,1,2026,'2026-01-20','2026-02-05','SOLD',    770000),
('VBKG26I003','EI003','CI003',9, 9,1,2026,'2026-02-01','2026-02-15','SOLD',   1120000),
('VBKG26I004','EI004','CI004',10,1,1,2026,'2026-02-01','2026-02-15','SOLD',   1090000),
('VBKG26I005','EI005','CI005',11,4,1,2026,'2026-02-05','2026-02-20','SOLD',   1350000),
('VBKG26I006','EI006','CI006',3, 9,1,2026,'2026-02-05','2026-02-20','SOLD',    880000),
('VBKG26I007','EI007','CI007',6, 4,1,2026,'2026-02-10','2026-02-25','SOLD',    770000),
('VBKG26I008','EI008','CI008',9, 1,1,2026,'2026-02-10','2026-02-25','SOLD',   1120000),
('VBKG26I009','EI009','CI009',10,7,1,2026,'2026-02-15','2026-03-01','SOLD',   1090000),
('VBKG26I010','EI010','CI010',11,5,1,2026,'2026-02-15','2026-03-01','SOLD',   1350000),
('VBKG26A001','EA001','CA001',3, 7,1,2026,'2026-03-01','2026-03-10','ALLOCATED', 880000),
('VBKG26A002','EA002','CA002',6, 9,1,2026,'2026-03-01','2026-03-10','ALLOCATED', 770000),
('VBKG26A003','EA003','CA003',9, 5,1,2026,'2026-03-05','2026-03-15','ALLOCATED',1120000),
('VBKG26A004','EA004','CA004',10,4,1,2026,'2026-03-05','2026-03-15','ALLOCATED',1090000),
('VBKG26A005','EA005','CA005',11,1,1,2026,'2026-03-08','2026-03-18','ALLOCATED',1350000),
('VBKG26A006','EA006','CA006',3, 9,1,2026,'2026-03-08','2026-03-18','ALLOCATED', 880000),
('VBKG26A007','EA007','CA007',6, 4,1,2026,'2026-03-10','2026-03-20','ALLOCATED', 770000),
('VBKG26A008','EA008','CA008',9, 7,1,2026,'2026-03-10','2026-03-20','ALLOCATED',1120000),
('VBKG26A009','EA009','CA009',10,9,1,2026,'2026-03-12','2026-03-22','ALLOCATED',1090000),
('VBKG26A010','EA010','CA010',11,5,1,2026,'2026-03-12','2026-03-22','ALLOCATED',1350000);

-- ─── Bookings linking leads → vehicles using subqueries ──────
INSERT INTO bookings (booking_number, lead_id, customer_id, variant_id, color_id, sales_exec_id, vehicle_id, ex_showroom, discount, total_on_road, status, expected_delivery)
SELECT CONCAT('BKG26-D', LPAD(t.rn,3,'0')), t.lid, t.cid, t.vid, t.colid, t.exec, t.vehid, t.cost+50000, 15000, t.cost+150000, 'DELIVERED', DATE_ADD(t.arr, INTERVAL 30 DAY)
FROM (
  SELECT l.id lid, l.customer_id cid, l.preferred_variant_id vid, l.assigned_to exec,
         v.id vehid, v.dealer_cost cost, v.color_id colid, v.arrival_date arr,
         SUBSTRING(l.lead_number, 6) + 0 as rn
  FROM leads l 
  JOIN vehicles v ON v.vin = CONCAT('VBKG26D', LPAD(SUBSTRING(l.lead_number, 6) + 0, 3, '0'))
  WHERE l.lead_number BETWEEN 'BL26-001' AND 'BL26-015'
) t;

INSERT INTO bookings (booking_number, lead_id, customer_id, variant_id, color_id, sales_exec_id, vehicle_id, ex_showroom, discount, total_on_road, status, expected_delivery)
SELECT CONCAT('BKG26-I', LPAD(t.rn,3,'0')), t.lid, t.cid, t.vid, t.colid, t.exec, t.vehid, t.cost+50000, 10000, t.cost+150000, 'INVOICED', DATE_ADD(t.arr, INTERVAL 30 DAY)
FROM (
  SELECT l.id lid, l.customer_id cid, l.preferred_variant_id vid, l.assigned_to exec,
         v.id vehid, v.dealer_cost cost, v.color_id colid, v.arrival_date arr,
         SUBSTRING(l.lead_number, 6) - 15 as rn
  FROM leads l 
  JOIN vehicles v ON v.vin = CONCAT('VBKG26I', LPAD(SUBSTRING(l.lead_number, 6) - 15, 3, '0'))
  WHERE l.lead_number BETWEEN 'BL26-016' AND 'BL26-025'
) t;

INSERT INTO bookings (booking_number, lead_id, customer_id, variant_id, color_id, sales_exec_id, vehicle_id, ex_showroom, discount, total_on_road, status, expected_delivery)
SELECT CONCAT('BKG26-A', LPAD(t.rn,3,'0')), t.lid, t.cid, t.vid, t.colid, t.exec, t.vehid, t.cost+50000, 5000, t.cost+150000, 'ALLOCATED', DATE_ADD(t.arr, INTERVAL 45 DAY)
FROM (
  SELECT l.id lid, l.customer_id cid, l.preferred_variant_id vid, l.assigned_to exec,
         v.id vehid, v.dealer_cost cost, v.color_id colid, v.arrival_date arr,
         SUBSTRING(l.lead_number, 6) - 25 as rn
  FROM leads l 
  JOIN vehicles v ON v.vin = CONCAT('VBKG26A', LPAD(SUBSTRING(l.lead_number, 6) - 25, 3, '0'))
  WHERE l.lead_number BETWEEN 'BL26-026' AND 'BL26-035'
) t;

SET FOREIGN_KEY_CHECKS = 1;
