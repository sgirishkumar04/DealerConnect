-- ============================================================
--  DEALERCONNECT - REALISTIC SAMPLE DATA (MANUAL INSERTS)
-- ============================================================
USE dealerconnect;
SET FOREIGN_KEY_CHECKS = 0;

-- 1. Reference Data
TRUNCATE TABLE roles;
INSERT INTO roles (id, name, description) VALUES 
(1, 'ADMIN', 'System Administrator'),
(2, 'SALES_MANAGER', 'Sales Manager'),
(3, 'SALES_EXECUTIVE', 'Sales Executive'),
(4, 'SERVICE_ADVISOR', 'Service Advisor'),
(5, 'MECHANIC', 'Mechanic'),
(6, 'INVENTORY_MANAGER', 'Inventory Manager'),
(7, 'ACCOUNTS', 'Accounts & Finance');

TRUNCATE TABLE permissions;
INSERT INTO permissions (id, name, description) VALUES 
(1, 'SALES_VIEW', 'View Customers, Leads, Bookings'), (2, 'SALES_CREATE', 'Create Leads, Bookings'), (3, 'SALES_EDIT', 'Edit Customers, Leads, Bookings'), (4, 'SALES_DELETE', 'Delete Sales Records'),
(5, 'INVENTORY_VIEW', 'View Vehicles'), (6, 'INVENTORY_CREATE', 'Add Vehicles'), (7, 'INVENTORY_EDIT', 'Edit Vehicles'), (8, 'INVENTORY_DELETE', 'Delete Vehicles'),
(9, 'SERVICE_VIEW', 'View Service Records'), (10, 'SERVICE_CREATE', 'Create Appointments'), (11, 'SERVICE_EDIT', 'Edit Service Status'), (12, 'SERVICE_DELETE', 'Delete Service Records'),
(13, 'PARTS_VIEW', 'View Parts'), (14, 'PARTS_CREATE', 'Add Parts'), (15, 'PARTS_EDIT', 'Edit Parts'), (16, 'PARTS_DELETE', 'Delete Parts'),
(17, 'EMPLOYEES_VIEW', 'View Staff'), (18, 'EMPLOYEES_CREATE', 'Add Staff'), (19, 'EMPLOYEES_EDIT', 'Edit Staff'), (20, 'EMPLOYEES_DELETE', 'Delete Staff'),
(21, 'REPORTS_VIEW', 'View Reports');

TRUNCATE TABLE role_permissions;
INSERT INTO role_permissions (role_id, permission_id) VALUES 
-- ADMIN: All permissions
(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10),(1,11),(1,12),(1,13),(1,14),(1,15),(1,16),(1,17),(1,18),(1,19),(1,20),(1,21),
-- SALES_MANAGER: Sales, Inventory View, Reports
(2,1),(2,5),(2,17),(2,21),
-- SALES_EXECUTIVE: Sales (CRUD), Inventory View, Reports (Dashboard)
(3,1),(3,2),(3,3),(3,4),(3,5),(3,17),(3,21),
-- SERVICE_ADVISOR: Service (View/Create), Parts (View/Create)
(4,9),(4,10),(4,13),(4,14),
-- MECHANIC: Service View/Edit, Parts View
(5,9),(5,11),(5,13),
-- INVENTORY_MANAGER: Inventory (View/Create), Parts (View/Create), Reports
(6,5),(6,6),(6,13),(6,14),(6,21),
-- ACCOUNTS: Sales View, Reports
(7,1),(7,3),(7,9),(7,13),(7,21);

TRUNCATE TABLE departments;
INSERT INTO departments (id, name) VALUES 
(1, 'Management'), (2, 'Sales'), (3, 'Service'), (4, 'Inventory'), (5, 'Accounts');

TRUNCATE TABLE lead_sources;
INSERT INTO lead_sources (id, name) VALUES 
(1, 'Showroom Walk-in'), (2, 'Website'), (3, 'Referral'), (4, 'Social Media'), (5, 'Call Center');

TRUNCATE TABLE colors;
INSERT INTO colors (id, name, hex_code) VALUES 
(1, 'Polar White', '#FFFFFF'), (2, 'Typhoon Silver', '#C0C0C0'), (3, 'Titan Grey', '#808080'), 
(4, 'Phantom Black', '#000000'), (5, 'Fiery Red', '#FF0000'), (6, 'Starry Night', '#000080'),
(7, 'Abyss Black', '#1A1A1A'), (8, 'Ranger Khaki', '#C3B091'), (9, 'Atlas White', '#F5F5DC');

TRUNCATE TABLE engine_types;
INSERT INTO engine_types (id, name, fuel_category) VALUES 
(1, '1.2L Kappa Petrol', 'Petrol'), (2, '1.5L MPi Petrol', 'Petrol'), 
(3, '1.5L U2 CRDi Diesel', 'Diesel'), (4, '1.0L Turbo GDi', 'Petrol'),
(5, 'Permanent Magnet Sync Motor', 'EV'), (6, '2.0L Nu Petrol', 'Petrol');

TRUNCATE TABLE inventory_locations;
INSERT INTO inventory_locations (id, name, address) VALUES 
(1, 'Main Showroom', 'Block A, City Center'), (2, 'City Warehouse', 'Industrial Area Phase 1'), 
(3, 'Service Center Stock', 'Behind Showroom'), (4, 'Yard B', 'Outskirts Storage Facility');

-- 2. Employees (Password is: Password@123)
TRUNCATE TABLE employees;
INSERT INTO employees (id, employee_code, first_name, last_name, email, phone, password_hash, department_id, role_id, date_of_join, is_active) VALUES 
(1, 'EMP001', 'S', 'GIRISH KUMAR', 'admin@dealerconnect.com', '9876543210', '$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW', 1, 1, '2020-01-15', 1),
(2, 'EMP002', 'Priya', 'Sharma', 'sales.mgr@dealerconnect.com', '9876543211', '$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW', 2, 2, '2020-03-10', 1),
(3, 'EMP003', 'Rahul', 'Verma', 'rahul.sales@dealerconnect.com', '9876543212', '$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW', 2, 3, '2021-06-01', 1),
(4, 'EMP004', 'Anita', 'Desai', 'anita.sales@dealerconnect.com', '9876543213', '$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW', 2, 3, '2021-08-15', 1),
(5, 'EMP005', 'Vikram', 'Singh', 'vikram.svc@dealerconnect.com', '9876543214', '$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW', 3, 4, '2020-11-20', 1),
(6, 'EMP006', 'Suresh', 'Babu', 'suresh.mech@dealerconnect.com', '9876543215', '$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW', 3, 5, '2022-01-10', 1),
(7, 'EMP007', 'Ramesh', 'Kumar', 'ramesh.mech@dealerconnect.com', '9876543216', '$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW', 3, 5, '2022-02-15', 1),
(8, 'EMP008', 'Karthik', 'Nair', 'karthik.sales@dealerconnect.com', '9876543217', '$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW', 2, 3, '2023-01-05', 1),
(9, 'EMP009', 'Neha', 'Gupta', 'neha.inv@dealerconnect.com', '9876543218', '$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW', 4, 6, '2024-05-10', 1);

-- TRUNCATE TABLE mechanics;
-- INSERT INTO mechanics (id, employee_id, speciality) VALUES 
-- (1, 6, 'General Service'), (2, 7, 'Engine & Transmission');

-- 3. Vehicle Models & Variants
TRUNCATE TABLE vehicle_models;
INSERT INTO vehicle_models (id, model_code, model_name, segment, launch_year) VALUES 
(1, 'CRETA', 'Creta', 'SUV', 2020),
(2, 'VENUE', 'Venue', 'Compact SUV', 2019),
(3, 'VERNA', 'Verna', 'Sedan', 2023),
(4, 'I20', 'i20', 'Premium Hatchback', 2020),
(5, 'TUCSON', 'Tucson', 'Premium SUV', 2022),
(6, 'IONIQ5', 'Ioniq 5', 'EV SUV', 2023),
(7, 'EXTER', 'Exter', 'Micro SUV', 2023),
(8, 'AURA', 'Aura', 'Compact Sedan', 2020);

TRUNCATE TABLE vehicle_variants;
INSERT INTO vehicle_variants (id, model_id, variant_code, variant_name, engine_type_id, transmission, ex_showroom_price) VALUES 
(1, 1, 'CRT-E', 'E 1.5 Petrol MT', 2, 'Manual', 1087000),
(2, 1, 'CRT-SX', 'SX 1.5 Diesel AT', 3, 'Automatic', 1900000),
(3, 2, 'VEN-S', 'S 1.2 Petrol MT', 1, 'Manual', 894000),
(4, 2, 'VEN-SX', 'SX (O) 1.0 Turbo DCT', 4, 'DCT', 1318000),
(5, 3, 'VRN-SX', 'SX 1.5 Petrol CVT', 2, 'CVT', 1423000),
(6, 4, 'I20-ASTA', 'Asta (O) 1.2 Petrol IVT', 1, 'IVT', 1116000),
(7, 5, 'TUC-SIG', 'Signature 2.0 Diesel AT', 3, 'Automatic', 3546000),
(8, 6, 'ION-RWD', 'RWD 72.6 kWh', 5, 'Automatic', 4495000),
(9, 7, 'EXT-S', 'S 1.2 Kappa MT', 1, 'Manual', 738000),
(10, 7, 'EXT-SX', 'SX 1.2 AMT', 1, 'AMT', 896000),
(11, 8, 'AUR-S', 'S 1.2 Petrol MT', 1, 'Manual', 722000),
(12, 1, 'CRT-SXO', 'SX (O) 1.5 Turbo DCT', 4, 'DCT', 2000000);

-- 4. Customers
TRUNCATE TABLE customers;
INSERT INTO customers (id, customer_code, first_name, last_name, email, phone, created_at) VALUES 
(1, 'CUST0001', 'Arvind', 'Narayanan', 'arvind@example.com', '9800000001', '2025-01-10 10:00:00'),
(2, 'CUST0002', 'Sunita', 'Reddy', 'sunita@example.com', '9800000002', '2025-01-15 11:30:00'),
(3, 'CUST0003', 'Rohan', 'Das', 'rohan@example.com', '9800000003', '2025-02-20 14:15:00'),
(4, 'CUST0004', 'Kavya', 'Menon', 'kavya@example.com', '9800000004', '2025-03-05 09:45:00'),
(5, 'CUST0005', 'Nitin', 'Shah', 'nitin@example.com', '9800000005', '2025-04-12 16:20:00'),
(6, 'CUST0006', 'Meera', 'Rao', 'meera.rao@example.com', '9800000006', '2025-05-18 10:15:00'),
(7, 'CUST0007', 'Sanjay', 'Patil', 'sanjay.p@example.com', '9800000007', '2025-06-22 11:45:00'),
(8, 'CUST0008', 'Anjali', 'Kumar', 'anjali.k@example.com', '9800000008', '2025-07-30 09:30:00'),
(9, 'CUST0009', 'Vikash', 'Jain', 'vikash.jain@example.com', '9800000009', '2025-08-14 14:10:00'),
(10, 'CUST0010', 'Priya', 'Chatterjee', 'priya.c@example.com', '9800000010', '2025-09-05 16:50:00'),
(11, 'CUST0011', 'Amit', 'Dubey', 'amit.d@example.com', '9800000011', '2025-10-01 10:20:00'),
(12, 'CUST0012', 'Sneha', 'Iyer', 'sneha.iyer@example.com', '9800000012', '2025-11-12 12:40:00'),
(13, 'CUST0013', 'Gaurav', 'Mishra', 'gaurav.m@example.com', '9800000013', '2025-12-25 10:15:00'),
(14, 'CUST0014', 'Ritu', 'Agarwal', 'ritu.a@example.com', '9800000014', '2026-01-05 14:00:00'),
(15, 'CUST0015', 'Tariq', 'Khan', 'tariq.k@example.com', '9800000015', '2026-02-18 09:00:00');

-- 5. Leads
TRUNCATE TABLE leads;
INSERT INTO leads (id, lead_number, customer_id, source_id, assigned_to, preferred_variant_id, status, created_at) VALUES 
(1, 'LD0001', 1, 1, 3, 1, 'BOOKED', '2025-09-12 10:30:00'),
(2, 'LD0002', 2, 2, 3, 4, 'CONTACTED', '2025-10-16 11:00:00'),
(3, 'LD0003', 3, 3, 4, 2, 'TEST_DRIVE', '2025-11-22 15:00:00'),
(4, 'LD0004', 4, 1, 4, 6, 'BOOKED', '2025-12-06 10:00:00'),
(5, 'LD0005', 5, 2, 3, 8, 'NEGOTIATION', '2026-01-13 14:30:00'),
(6, 'LD0006', 6, 4, 8, 9, 'NEW', '2026-02-15 10:15:00'),
(7, 'LD0007', 7, 5, 8, 10, 'LOST', '2025-09-05 16:30:00'),
(8, 'LD0008', 8, 1, 3, 12, 'BOOKED', '2025-10-20 11:00:00'),
(9, 'LD0009', 9, 2, 4, 5, 'TEST_DRIVE', '2025-11-10 14:00:00'),
(10, 'LD0010', 10, 3, 8, 7, 'BOOKED', '2025-12-15 10:45:00'),
(11, 'LD0011', 11, 4, 3, 3, 'NEW', '2026-01-20 09:30:00'),
(12, 'LD0012', 12, 1, 4, 2, 'BOOKED', '2026-02-05 15:20:00'),
(13, 'LD0013', 13, 2, 8, 1, 'NEGOTIATION', '2026-02-28 11:10:00'),
(14, 'LD0014', 14, 5, 3, 4, 'CONTACTED', '2026-03-05 10:00:00'),
(15, 'LD0015', 15, 3, 4, 8, 'TEST_DRIVE', '2026-03-10 14:15:00');

-- 6. Bookings
TRUNCATE TABLE bookings;
INSERT INTO bookings (id, booking_number, lead_id, customer_id, variant_id, color_id, sales_exec_id, vehicle_id, ex_showroom, total_on_road, status, created_at) VALUES 
(1, 'BKG0001', 1, 1, 1, 1, 3, 1, 1087000, 1250000, 'DELIVERED', '2025-09-20 11:00:00'),
(2, 'BKG0002', 4, 4, 6, 2, 4, 2, 1116000, 1285000, 'ALLOCATED', '2025-12-10 14:00:00'),
(3, 'BKG0003', 8, 8, 12, 7, 3, 6, 2000000, 2300000, 'INVOICED', '2025-10-25 10:30:00'),
(4, 'BKG0004', 10, 10, 7, 5, 8, 7, 3546000, 4070000, 'DELIVERED', '2025-12-20 15:45:00'),
(5, 'BKG0005', 12, 12, 2, 8, 4, NULL, 1900000, 2185000, 'BOOKED', '2026-02-10 11:20:00');

-- 7. Vehicles (Inventory)
TRUNCATE TABLE vehicles;
INSERT INTO vehicles (id, vin, engine_number, chassis_number, variant_id, color_id, location_id, mfg_year, mfg_date, arrival_date, status, dealer_cost, created_at) VALUES 
(1, 'VIN0000000010001', 'ENG0001', 'CHA0001', 1, 1, 1, 2025, '2025-08-15', '2025-08-25', 'SOLD', 1000000, '2025-09-05 10:00:00'),
(2, 'VIN0000000010002', 'ENG0002', 'CHA0002', 6, 2, 1, 2025, '2025-10-10', '2025-10-20', 'ALLOCATED', 1050000, '2025-11-01 10:00:00'),
(3, 'VIN0000000010003', 'ENG0003', 'CHA0003', 2, 4, 2, 2025, '2025-11-05', '2025-11-15', 'IN_STOCK', 1750000, '2025-12-01 10:00:00'),
(4, 'VIN0000000010004', 'ENG0004', 'CHA0004', 4, 5, 2, 2025, '2025-12-10', '2025-12-20', 'IN_STOCK', 1200000, '2026-01-05 10:00:00'),
(5, 'VIN0000000010005', 'ENG0005', 'CHA0005', 8, 1, 1, 2026, '2026-01-15', '2026-01-25', 'IN_STOCK', 4100000, '2026-02-10 10:00:00'),
(6, 'VIN0000000010006', 'ENG0006', 'CHA0006', 12, 7, 1, 2025, '2025-09-20', '2025-09-30', 'SOLD', 1850000, '2025-10-15 10:00:00'),
(7, 'VIN0000000010007', 'ENG0007', 'CHA0007', 7, 5, 2, 2025, '2025-11-15', '2025-11-25', 'SOLD', 3250000, '2025-12-10 10:00:00'),
(8, 'VIN0000000010008', 'ENG0008', 'CHA0008', 9, 8, 1, 2026, '2026-01-01', '2026-01-10', 'IN_STOCK', 680000, '2026-01-20 10:00:00'),
(9, 'VIN0000000010009', 'ENG0009', 'CHA0009', 10, 9, 2, 2026, '2026-02-01', '2026-02-10', 'IN_STOCK', 820000, '2026-02-15 10:00:00'),
(10, 'VIN0000000010010', 'ENG0010', 'CHA0010', 3, 1, 1, 2026, '2026-02-15', '2026-02-25', 'IN_STOCK', 800000, '2026-03-01 10:00:00');

-- 8. Service Appointments & Job Cards
TRUNCATE TABLE service_appointments;
INSERT INTO service_appointments (id, appointment_no, customer_id, vehicle_reg_no, appointed_by, appointment_date, service_type, status, created_at) VALUES 
(1, 'SRV0001', 1, 'KA01AB1234', 5, '2025-10-15 10:00:00', 'PERIODIC', 'COMPLETED', '2025-10-10 10:00:00'),
(2, 'SRV0002', 2, 'KA03CD5678', 5, '2025-11-20 14:00:00', 'REPAIR', 'IN_PROGRESS', '2025-11-18 10:00:00'),
(3, 'SRV0003', 3, 'KA05EF9012', 5, '2025-12-05 09:30:00', 'ACCIDENTAL', 'COMPLETED', '2025-12-01 10:00:00'),
(4, 'SRV0004', 4, 'KA02GH3456', 5, '2026-01-10 11:00:00', 'WARRANTY', 'COMPLETED', '2026-01-05 10:00:00'),
(5, 'SRV0005', 5, 'KA04IJ7890', 5, '2026-02-25 10:30:00', 'PERIODIC', 'SCHEDULED', '2026-02-20 10:00:00'),
(6, 'SRV0006', 6, 'KA01KL1212', 5, '2026-03-15 14:00:00', 'REPAIR', 'SCHEDULED', '2026-03-10 10:00:00'),
(7, 'SRV0007', 7, 'KA03MN3434', 5, '2025-09-22 15:30:00', 'PERIODIC', 'COMPLETED', '2025-09-18 10:00:00'),
(8, 'SRV0008', 10, 'KA05OP5656', 5, '2026-01-20 09:00:00', 'REPAIR', 'COMPLETED', '2026-01-15 10:00:00');

-- TRUNCATE TABLE job_cards;
-- INSERT INTO job_cards (id, job_card_no, appointment_id, mechanic_id, labour_cost, parts_cost, total_cost, status, created_at) VALUES 
-- (1, 'JC0001', 1, 1, 1500, 3500, 5000, 'COMPLETED', '2025-10-15 10:30:00'),
-- (2, 'JC0002', 2, 2, 2000, 8000, 10000, 'IN_PROGRESS', '2025-11-20 14:30:00'),
-- (3, 'JC0003', 3, 1, 12000, 45000, 57000, 'COMPLETED', '2025-12-05 10:00:00'),
-- (4, 'JC0004', 4, 2, 0, 0, 0, 'COMPLETED', '2026-01-10 11:30:00'),
-- (5, 'JC0005', 7, 1, 1800, 4200, 6000, 'COMPLETED', '2025-09-22 16:00:00'),
-- (6, 'JC0006', 8, 2, 3500, 15000, 18500, 'COMPLETED', '2026-01-20 09:30:00');

SET FOREIGN_KEY_CHECKS = 1;

-- -------------------------------------------------------------
-- EXTENDED DATA FOR A MORE REALISTIC DASHBOARD
-- -------------------------------------------------------------

-- 30 MORE CUSTOMERS
INSERT INTO customers (id, customer_code, first_name, last_name, email, phone, created_at) VALUES 
(16, 'CUST0016', 'Rahul', 'Nair', 'rahul.n@example.com', '9800000016', '2025-09-01 10:00:00'),
(17, 'CUST0017', 'Kavita', 'Singh', 'kavita.s@example.com', '9800000017', '2025-09-05 11:30:00'),
(18, 'CUST0018', 'Anita', 'Reddy', 'anita.r@example.com', '9800000018', '2025-09-10 14:15:00'),
(19, 'CUST0019', 'Vijay', 'Verma', 'vijay.v@example.com', '9800000019', '2025-09-15 09:45:00'),
(20, 'CUST0020', 'Sonia', 'Gupta', 'sonia.g@example.com', '9800000020', '2025-09-20 16:20:00'),
(21, 'CUST0021', 'Deepak', 'Sharma', 'deepak.s@example.com', '9800000021', '2025-10-01 10:15:00'),
(22, 'CUST0022', 'Riya', 'Patil', 'riya.p@example.com', '9800000022', '2025-10-05 11:45:00'),
(23, 'CUST0023', 'Aman', 'Kumar', 'aman.k@example.com', '9800000023', '2025-10-10 09:30:00'),
(24, 'CUST0024', 'Simran', 'Jain', 'simran.j@example.com', '9800000024', '2025-10-15 14:10:00'),
(25, 'CUST0025', 'Naveen', 'Chatterjee', 'naveen.c@example.com', '9800000025', '2025-10-20 16:50:00'),
(26, 'CUST0026', 'Meghna', 'Dubey', 'meghna.d@example.com', '9800000026', '2025-11-01 10:20:00'),
(27, 'CUST0027', 'Karan', 'Iyer', 'karan.i@example.com', '9800000027', '2025-11-05 12:40:00'),
(28, 'CUST0028', 'Puja', 'Mishra', 'puja.m@example.com', '9800000028', '2025-11-10 10:15:00'),
(29, 'CUST0029', 'Rohit', 'Agarwal', 'rohit.a@example.com', '9800000029', '2025-11-15 14:00:00'),
(30, 'CUST0030', 'Aisha', 'Khan', 'aisha.k@example.com', '9800000030', '2025-11-20 09:00:00'),
(31, 'CUST0031', 'Ravi', 'Menon', 'ravi.m@example.com', '9800000031', '2025-12-01 10:00:00'),
(32, 'CUST0032', 'Snehlata', 'Rao', 'snehalata.r@example.com', '9800000032', '2025-12-05 11:30:00'),
(33, 'CUST0033', 'Arjun', 'Das', 'arjun.d@example.com', '9800000033', '2025-12-10 14:15:00'),
(34, 'CUST0034', 'Divya', 'Shah', 'divya.s@example.com', '9800000034', '2025-12-15 09:45:00'),
(35, 'CUST0035', 'Siddharth', 'Bose', 'siddharth.b@example.com', '9800000035', '2025-12-20 16:20:00'),
(36, 'CUST0036', 'Nisha', 'Tiwari', 'nisha.t@example.com', '9800000036', '2026-01-01 10:15:00'),
(37, 'CUST0037', 'Varun', 'Yadav', 'varun.y@example.com', '9800000037', '2026-01-05 11:45:00'),
(38, 'CUST0038', 'Kajal', 'Chauhan', 'kajal.c@example.com', '9800000038', '2026-01-10 09:30:00'),
(39, 'CUST0039', 'Harsh', 'Pandey', 'harsh.p@example.com', '9800000039', '2026-01-15 14:10:00'),
(40, 'CUST0040', 'Tanvi', 'Mukherjee', 'tanvi.m@example.com', '9800000040', '2026-01-20 16:50:00'),
(41, 'CUST0041', 'Gagan', 'Sinha', 'gagan.s@example.com', '9800000041', '2026-02-01 10:20:00'),
(42, 'CUST0042', 'Swati', 'Bhatia', 'swati.b@example.com', '9800000042', '2026-02-05 12:40:00'),
(43, 'CUST0043', 'Manish', 'Saxena', 'manish.s@example.com', '9800000043', '2026-02-10 10:15:00'),
(44, 'CUST0044', 'Preeti', 'Kaur', 'preeti.k@example.com', '9800000044', '2026-02-15 14:00:00'),
(45, 'CUST0045', 'Vikas', 'Chawla', 'vikas.c@example.com', '9800000045', '2026-02-20 09:00:00');

-- 30 MORE LEADS
INSERT INTO leads (id, lead_number, customer_id, source_id, assigned_to, preferred_variant_id, status, created_at) VALUES 
(16, 'LD0016', 16, 1, 3, 5, 'BOOKED', '2025-09-02 10:30:00'),
(17, 'LD0017', 17, 2, 4, 1, 'CONTACTED', '2025-09-06 11:00:00'),
(18, 'LD0018', 18, 3, 8, 3, 'TEST_DRIVE', '2025-09-11 15:00:00'),
(19, 'LD0019', 19, 4, 3, 2, 'BOOKED', '2025-09-16 10:00:00'),
(20, 'LD0020', 20, 5, 4, 6, 'NEGOTIATION', '2025-09-21 14:30:00'),
(21, 'LD0021', 21, 1, 8, 4, 'NEW', '2025-10-02 10:15:00'),
(22, 'LD0022', 22, 2, 3, 8, 'LOST', '2025-10-06 16:30:00'),
(23, 'LD0023', 23, 3, 4, 7, 'BOOKED', '2025-10-11 11:00:00'),
(24, 'LD0024', 24, 4, 8, 5, 'TEST_DRIVE', '2025-10-16 14:00:00'),
(25, 'LD0025', 25, 5, 3, 1, 'BOOKED', '2025-10-21 10:45:00'),
(26, 'LD0026', 26, 1, 4, 3, 'NEW', '2025-11-02 09:30:00'),
(27, 'LD0027', 27, 2, 8, 2, 'BOOKED', '2025-11-06 15:20:00'),
(28, 'LD0028', 28, 3, 3, 6, 'NEGOTIATION', '2025-11-11 11:10:00'),
(29, 'LD0029', 29, 4, 4, 4, 'CONTACTED', '2025-11-16 10:00:00'),
(30, 'LD0030', 30, 5, 8, 8, 'TEST_DRIVE', '2025-11-21 14:15:00'),
(31, 'LD0031', 31, 1, 3, 7, 'BOOKED', '2025-12-02 10:30:00'),
(32, 'LD0032', 32, 2, 4, 5, 'CONTACTED', '2025-12-06 11:00:00'),
(33, 'LD0033', 33, 3, 8, 1, 'TEST_DRIVE', '2025-12-11 15:00:00'),
(34, 'LD0034', 34, 4, 3, 3, 'BOOKED', '2025-12-16 10:00:00'),
(35, 'LD0035', 35, 5, 4, 2, 'NEGOTIATION', '2025-12-21 14:30:00'),
(36, 'LD0036', 36, 1, 8, 6, 'NEW', '2026-01-02 10:15:00'),
(37, 'LD0037', 37, 2, 3, 4, 'LOST', '2026-01-06 16:30:00'),
(38, 'LD0038', 38, 3, 4, 8, 'BOOKED', '2026-01-11 11:00:00'),
(39, 'LD0039', 39, 4, 8, 7, 'TEST_DRIVE', '2026-01-16 14:00:00'),
(40, 'LD0040', 40, 5, 3, 5, 'BOOKED', '2026-01-21 10:45:00'),
(41, 'LD0041', 41, 1, 4, 1, 'NEW', '2026-02-02 09:30:00'),
(42, 'LD0042', 42, 2, 8, 3, 'BOOKED', '2026-02-06 15:20:00'),
(43, 'LD0043', 43, 3, 3, 2, 'NEGOTIATION', '2026-02-11 11:10:00'),
(44, 'LD0044', 44, 4, 4, 6, 'CONTACTED', '2026-02-16 10:00:00'),
(45, 'LD0045', 45, 5, 8, 4, 'TEST_DRIVE', '2026-02-21 14:15:00');

-- MORE BOOKINGS
-- 20 MORE VEHICLES IN INVENTORY
INSERT INTO vehicles (id, vin, engine_number, chassis_number, variant_id, color_id, location_id, mfg_year, mfg_date, arrival_date, status, dealer_cost, created_at) VALUES 
(11, 'VIN0000000010011', 'ENG0011', 'CHA0011', 1, 2, 1, 2025, '2025-08-20', '2025-08-30', 'SOLD', 1000000, '2025-09-15 10:00:00'),
(12, 'VIN0000000010012', 'ENG0012', 'CHA0012', 2, 1, 1, 2025, '2025-08-25', '2025-09-05', 'SOLD', 1750000, '2025-09-20 10:00:00'),
(13, 'VIN0000000010013', 'ENG0013', 'CHA0013', 7, 7, 2, 2025, '2025-09-20', '2025-09-30', 'SOLD', 3250000, '2025-10-15 10:00:00'),
(14, 'VIN0000000010014', 'ENG0014', 'CHA0014', 1, 5, 2, 2025, '2025-10-10', '2025-10-15', 'ALLOCATED', 1000000, '2025-10-25 10:00:00'),
(15, 'VIN0000000010015', 'ENG0015', 'CHA0015', 2, 8, 1, 2025, '2025-10-15', '2025-10-25', 'SOLD', 1750000, '2025-11-10 10:00:00'),
(16, 'VIN0000000010016', 'ENG0016', 'CHA0016', 7, 1, 1, 2025, '2025-11-10', '2025-11-20', 'SOLD', 3250000, '2025-12-05 10:00:00'),
(17, 'VIN0000000010017', 'ENG0017', 'CHA0017', 3, 2, 2, 2025, '2025-11-25', '2025-11-30', 'ALLOCATED', 800000, '2025-12-20 10:00:00'),
(18, 'VIN0000000010018', 'ENG0018', 'CHA0018', 8, 7, 1, 2026, '2025-12-20', '2025-12-30', 'SOLD', 4100000, '2026-01-15 10:00:00'),
(19, 'VIN0000000010019', 'ENG0019', 'CHA0019', 5, 5, 2, 2026, '2026-01-05', '2026-01-15', 'SOLD', 1300000, '2026-01-25 10:00:00'),
(20, 'VIN0000000010020', 'ENG0020', 'CHA0020', 3, 8, 1, 2026, '2026-01-15', '2026-01-25', 'ALLOCATED', 800000, '2026-02-10 10:00:00'),
(21, 'VIN0000000010021', 'ENG0021', 'CHA0021', 12, 1, 1, 2026, '2026-02-01', '2026-02-10', 'IN_STOCK', 1850000, '2026-03-01 10:00:00'),
(22, 'VIN0000000010022', 'ENG0022', 'CHA0022', 9, 2, 1, 2026, '2026-02-10', '2026-02-20', 'IN_STOCK', 680000, '2026-03-05 10:00:00'),
(23, 'VIN0000000010023', 'ENG0023', 'CHA0023', 10, 4, 2, 2026, '2026-02-20', '2026-03-01', 'IN_STOCK', 820000, '2026-03-10 10:00:00'),
(24, 'VIN0000000010024', 'ENG0024', 'CHA0024', 2, 5, 2, 2026, '2026-03-01', '2026-03-10', 'IN_STOCK', 1750000, '2026-03-15 10:00:00'),
(25, 'VIN0000000010025', 'ENG0025', 'CHA0025', 4, 1, 1, 2026, '2026-03-05', '2026-03-15', 'IN_STOCK', 1200000, '2026-03-20 10:00:00'),
(26, 'VIN0000000010026', 'ENG0026', 'CHA0026', 8, 2, 1, 2026, '2026-03-10', '2026-03-20', 'IN_STOCK', 4100000, '2026-03-25 10:00:00'),
(27, 'VIN0000000010027', 'ENG0027', 'CHA0027', 5, 5, 2, 2026, '2026-03-15', '2026-03-25', 'IN_STOCK', 1300000, '2026-03-30 10:00:00'),
(28, 'VIN0000000010028', 'ENG0028', 'CHA0028', 1, 8, 1, 2026, '2026-03-20', '2026-03-30', 'IN_STOCK', 1000000, '2026-04-01 10:00:00'),
(29, 'VIN0000000010029', 'ENG0029', 'CHA0029', 7, 9, 2, 2026, '2026-03-25', '2026-04-01', 'IN_STOCK', 3250000, '2026-04-05 10:00:00'),
(30, 'VIN0000000010030', 'ENG0030', 'CHA0030', 3, 1, 1, 2026, '2026-03-30', '2026-04-08', 'IN_STOCK', 800000, '2026-04-10 10:00:00');

-- MORE BOOKINGS
INSERT INTO bookings (id, booking_number, lead_id, customer_id, variant_id, color_id, sales_exec_id, vehicle_id, ex_showroom, total_on_road, status, created_at) VALUES 
(6, 'BKG0006', 16, 16, 5, 1, 3, 11, 1423000, 1650000, 'DELIVERED', '2025-09-10 11:00:00'),
(7, 'BKG0007', 19, 19, 2, 2, 3, 12, 1900000, 2185000, 'DELIVERED', '2025-09-25 14:00:00'),
(8, 'BKG0008', 23, 23, 7, 7, 4, 13, 3546000, 4070000, 'INVOICED', '2025-10-20 10:30:00'),
(9, 'BKG0009', 25, 25, 1, 5, 3, 14, 1087000, 1250000, 'ALLOCATED', '2025-10-30 15:45:00'),
(10, 'BKG0010', 27, 27, 2, 8, 8, 15, 1900000, 2185000, 'DELIVERED', '2025-11-15 11:20:00'),
(11, 'BKG0011', 31, 31, 7, 1, 3, 16, 3546000, 4070000, 'DELIVERED', '2025-12-10 11:00:00'),
(12, 'BKG0012', 34, 34, 3, 2, 3, 17, 894000, 1030000, 'ALLOCATED', '2025-12-25 14:00:00'),
(13, 'BKG0013', 38, 38, 8, 7, 4, 18, 4495000, 5170000, 'INVOICED', '2026-01-20 10:30:00'),
(14, 'BKG0014', 40, 40, 5, 5, 3, 19, 1423000, 1650000, 'DELIVERED', '2026-01-30 15:45:00'),
(15, 'BKG0015', 42, 42, 3, 8, 8, NULL, 894000, 1030000, 'BOOKED', '2026-02-15 11:20:00');


-- MORE SERVICE APPOINTMENTS & JOB CARDS
INSERT INTO service_appointments (id, appointment_no, customer_id, vehicle_reg_no, appointed_by, appointment_date, service_type, status, created_at) VALUES 
(9, 'SRV0009', 16, 'KA01AB1111', 5, '2025-10-05 10:00:00', 'PERIODIC', 'COMPLETED', '2025-10-01 10:00:00'),
(10, 'SRV0010', 17, 'KA03CD2222', 5, '2025-11-10 14:00:00', 'REPAIR', 'IN_PROGRESS', '2025-11-05 10:00:00'),
(11, 'SRV0011', 18, 'KA05EF3333', 5, '2025-12-15 09:30:00', 'ACCIDENTAL', 'COMPLETED', '2025-12-10 10:00:00'),
(12, 'SRV0012', 19, 'KA02GH4444', 5, '2026-01-20 11:00:00', 'WARRANTY', 'COMPLETED', '2026-01-15 10:00:00'),
(13, 'SRV0013', 20, 'KA04IJ5555', 5, '2026-02-05 10:30:00', 'PERIODIC', 'SCHEDULED', '2026-02-01 10:00:00'),
(14, 'SRV0014', 21, 'KA01KL6666', 5, '2026-03-25 14:00:00', 'REPAIR', 'SCHEDULED', '2026-03-20 10:00:00'),
(15, 'SRV0015', 22, 'KA03MN7777', 5, '2025-09-12 15:30:00', 'PERIODIC', 'COMPLETED', '2025-09-08 10:00:00'),
(16, 'SRV0016', 23, 'KA05OP8888', 5, '2026-01-30 09:00:00', 'REPAIR', 'COMPLETED', '2026-01-25 10:00:00');

-- INSERT INTO job_cards (id, job_card_no, appointment_id, mechanic_id, labour_cost, parts_cost, total_cost, status, created_at) VALUES 
-- (7, 'JC0007', 9, 1, 1500, 3500, 5000, 'COMPLETED', '2025-10-05 10:30:00'),
-- (8, 'JC0008', 10, 2, 2000, 8000, 10000, 'IN_PROGRESS', '2025-11-10 14:30:00'),
-- (9, 'JC0009', 11, 1, 12000, 45000, 57000, 'COMPLETED', '2025-12-15 10:00:00'),
-- (10, 'JC0010', 12, 2, 0, 0, 0, 'COMPLETED', '2026-01-20 11:30:00'),
-- (11, 'JC0011', 15, 1, 1800, 4200, 6000, 'COMPLETED', '2025-09-12 16:00:00'),
-- (12, 'JC0012', 16, 2, 3500, 15000, 18500, 'COMPLETED', '2026-01-30 09:30:00');



-- 50 MORE DIVERSE VEHICLES FOR TESTING/DEMO (ID 31 to 80)
INSERT INTO vehicles (id, vin, engine_number, chassis_number, variant_id, color_id, location_id, mfg_year, mfg_date, arrival_date, status, dealer_cost, invoice_date, created_at) VALUES 
(31, 'VIN1A2B3C4D5E6F7', 'ENG1031', 'CHA2031', 1, 1, 1, 2026, '2025-11-01', '2025-11-15', 'IN_STOCK', 923950.00, '2025-11-20', '2025-11-20 09:00:00'),
(32, 'VIN2A3B4C5D6E7F8', 'ENG1032', 'CHA2032', 2, 2, 2, 2025, '2025-08-15', '2025-09-01', 'ALLOCATED', 1615000.00, '2025-09-15', '2025-09-15 10:15:00'),
(33, 'VIN3A4B5C6D7E8F9', 'ENG1033', 'CHA2033', 3, 3, 3, 2026, '2025-12-20', '2026-01-05', 'IN_STOCK', 759900.00, '2026-01-10', '2026-01-10 11:30:00'),
(34, 'VIN4A5B6C7D8E9F0', 'ENG1034', 'CHA2034', 4, 4, 1, 2025, '2025-09-10', '2025-09-25', 'SOLD', 1120300.00, '2025-10-05', '2025-10-05 14:00:00'),
(35, 'VIN5A6B7C8D9E0F1', 'ENG1035', 'CHA2035', 5, 5, 2, 2026, '2026-01-20', '2026-02-10', 'IN_STOCK', 1209550.00, '2026-02-18', '2026-02-18 09:45:00'),
(36, 'VIN6A7B8C9D0E1F2', 'ENG1036', 'CHA2036', 6, 6, 3, 2025, '2025-08-01', '2025-08-15', 'DEMO', 948600.00, '2025-08-22', '2025-08-22 16:20:00'),
(37, 'VIN7A8B9C0D1E2F3', 'ENG1037', 'CHA2037', 7, 7, 1, 2026, '2026-02-10', '2026-02-25', 'IN_STOCK', 3014100.00, '2026-03-01', '2026-03-01 10:00:00'),
(38, 'VIN8A9B0C1D2E3F4', 'ENG1038', 'CHA2038', 8, 8, 2, 2026, '2026-02-15', '2026-03-01', 'IN_STOCK', 3820750.00, '2026-03-05', '2026-03-05 11:15:00'),
(39, 'VIN9A0B1C2D3E4F5', 'ENG1039', 'CHA2039', 9, 9, 3, 2025, '2025-10-15', '2025-11-01', 'SOLD', 627300.00, '2025-11-12', '2025-11-12 15:30:00'),
(40, 'VIN0A1B2C3D4E5F6', 'ENG1040', 'CHA2040', 10, 1, 1, 2026, '2026-01-25', '2026-02-15', 'IN_STOCK', 761600.00, '2026-02-28', '2026-02-28 09:10:00'),
(41, 'VIN1B2C3D4E5F6G7', 'ENG1041', 'CHA2041', 11, 2, 2, 2025, '2025-11-10', '2025-11-25', 'ALLOCATED', 613700.00, '2025-12-05', '2025-12-05 10:40:00'),
(42, 'VIN2B3C4D5E6F7G8', 'ENG1042', 'CHA2042', 12, 3, 3, 2026, '2025-12-25', '2026-01-10', 'IN_STOCK', 1700000.00, '2026-01-20', '2026-01-20 12:00:00'),
(43, 'VIN3B4C5D6E7F8G9', 'ENG1043', 'CHA2043', 1, 4, 1, 2025, '2025-08-20', '2025-09-10', 'SOLD', 923950.00, '2025-09-30', '2025-09-30 14:15:00'),
(44, 'VIN4B5C6D7E8F9G0', 'ENG1044', 'CHA2044', 2, 5, 2, 2026, '2026-01-05', '2026-01-25', 'IN_STOCK', 1615000.00, '2026-02-10', '2026-02-10 16:30:00'),
(45, 'VIN5B6C7D8E9F0G1', 'ENG1045', 'CHA2045', 3, 6, 3, 2025, '2025-07-20', '2025-08-05', 'DEMO', 759900.00, '2025-08-15', '2025-08-15 09:20:00'),
(46, 'VIN6B7C8D9E0F1G2', 'ENG1046', 'CHA2046', 4, 7, 1, 2026, '2026-02-15', '2026-03-01', 'IN_STOCK', 1120300.00, '2026-03-08', '2026-03-08 11:45:00'),
(47, 'VIN7B8C9D0E1F2G3', 'ENG1047', 'CHA2047', 5, 8, 2, 2025, '2025-09-30', '2025-10-15', 'ALLOCATED', 1209550.00, '2025-10-25', '2025-10-25 10:10:00'),
(48, 'VIN8B9C0D1E2F3G4', 'ENG1048', 'CHA2048', 6, 9, 3, 2026, '2025-12-20', '2026-01-05', 'IN_STOCK', 948600.00, '2026-01-15', '2026-01-15 15:50:00'),
(49, 'VIN9B0C1D2E3F4G5', 'ENG1049', 'CHA2049', 7, 1, 1, 2025, '2025-09-25', '2025-10-15', 'SOLD', 3014100.00, '2025-11-05', '2025-11-05 13:25:00'),
(50, 'VIN0B1C2D3E4F5G6', 'ENG1050', 'CHA2050', 8, 2, 2, 2026, '2026-02-01', '2026-02-15', 'IN_STOCK', 3820750.00, '2026-02-22', '2026-02-22 10:05:00'),
(51, 'VIN1C2D3E4F5G6H7', 'ENG1051', 'CHA2051', 9, 3, 3, 2025, '2025-08-25', '2025-09-10', 'ALLOCATED', 627300.00, '2025-09-20', '2025-09-20 14:40:00'),
(52, 'VIN2C3D4E5F6G7H8', 'ENG1052', 'CHA2052', 10, 4, 1, 2026, '2026-02-20', '2026-03-05', 'IN_STOCK', 761600.00, '2026-03-12', '2026-03-12 11:30:00'),
(53, 'VIN3C4D5E6F7G8H9', 'ENG1053', 'CHA2053', 11, 5, 2, 2025, '2025-08-05', '2025-08-20', 'SOLD', 613700.00, '2025-08-30', '2025-08-30 09:15:00'),
(54, 'VIN4C5D6E7F8G9H0', 'ENG1054', 'CHA2054', 12, 6, 3, 2026, '2025-12-10', '2025-12-25', 'IN_STOCK', 1700000.00, '2026-01-05', '2026-01-05 16:10:00'),
(55, 'VIN5C6D7E8F9G0H1', 'ENG1055', 'CHA2055', 1, 7, 1, 2025, '2025-07-01', '2025-07-15', 'DEMO', 923950.00, '2025-07-28', '2025-07-28 10:50:00'),
(56, 'VIN6C7D8E9F0G1H2', 'ENG1056', 'CHA2056', 2, 8, 2, 2026, '2026-01-25', '2026-02-05', 'IN_STOCK', 1615000.00, '2026-02-14', '2026-02-14 14:20:00'),
(57, 'VIN7C8D9E0F1G2H3', 'ENG1057', 'CHA2057', 3, 9, 3, 2025, '2025-09-25', '2025-10-10', 'ALLOCATED', 759900.00, '2025-10-18', '2025-10-18 11:05:00'),
(58, 'VIN8C9D0E1F2G3H4', 'ENG1058', 'CHA2058', 4, 1, 1, 2025, '2025-11-01', '2025-11-15', 'SOLD', 1120300.00, '2025-11-25', '2025-11-25 15:45:00'),
(59, 'VIN9C0D1E2F3G4H5', 'ENG1059', 'CHA2059', 5, 2, 2, 2026, '2026-02-15', '2026-03-01', 'IN_STOCK', 1209550.00, '2026-03-10', '2026-03-10 09:30:00'),
(60, 'VIN0C1D2E3F4G5H6', 'ENG1060', 'CHA2060', 6, 3, 3, 2025, '2025-11-20', '2025-12-05', 'ALLOCATED', 948600.00, '2025-12-12', '2025-12-12 13:15:00'),
(61, 'VIN1D2E3F4G5H6I7', 'ENG1061', 'CHA2061', 7, 4, 1, 2026, '2026-01-10', '2026-01-22', 'IN_STOCK', 3014100.00, '2026-01-28', '2026-01-28 10:40:00'),
(62, 'VIN2D3E4F5G6H7I8', 'ENG1062', 'CHA2062', 8, 5, 2, 2025, '2025-07-15', '2025-07-30', 'SOLD', 3820750.00, '2025-08-05', '2025-08-05 14:50:00'),
(63, 'VIN3D4E5F6G7H8I9', 'ENG1063', 'CHA2063', 9, 6, 3, 2026, '2026-01-20', '2026-02-01', 'IN_STOCK', 627300.00, '2026-02-08', '2026-02-08 11:20:00'),
(64, 'VIN4D5E6F7G8H9I0', 'ENG1064', 'CHA2064', 10, 7, 1, 2025, '2025-09-30', '2025-10-20', 'ALLOCATED', 761600.00, '2025-10-30', '2025-10-30 09:00:00'),
(65, 'VIN5D6E7F8G9H0I1', 'ENG1065', 'CHA2065', 11, 8, 2, 2026, '2026-02-10', '2026-02-25', 'IN_STOCK', 613700.00, '2026-03-02', '2026-03-02 16:30:00'),
(66, 'VIN6D7E8F9G0H1I2', 'ENG1066', 'CHA2066', 12, 9, 3, 2025, '2025-08-30', '2025-09-10', 'SOLD', 1700000.00, '2025-09-18', '2025-09-18 10:15:00'),
(67, 'VIN7D8E9F0G1H2I3', 'ENG1067', 'CHA2067', 1, 1, 1, 2026, '2025-12-15', '2026-01-01', 'IN_STOCK', 923950.00, '2026-01-12', '2026-01-12 14:00:00'),
(68, 'VIN8D9E0F1G2H3I4', 'ENG1068', 'CHA2068', 2, 2, 2, 2025, '2025-10-15', '2025-10-30', 'DEMO', 1615000.00, '2025-11-08', '2025-11-08 11:45:00'),
(69, 'VIN9D0E1F2G3H4I5', 'ENG1069', 'CHA2069', 3, 3, 3, 2026, '2026-02-05', '2026-02-18', 'IN_STOCK', 759900.00, '2026-02-25', '2026-02-25 09:20:00'),
(70, 'VIN0E1F2G3H4I5J6', 'ENG1070', 'CHA2070', 4, 4, 1, 2025, '2025-11-30', '2025-12-15', 'SOLD', 1120300.00, '2025-12-20', '2025-12-20 15:10:00'),
(71, 'VIN1F2G3H4I5J6K7', 'ENG1071', 'CHA2071', 5, 5, 2, 2026, '2026-02-25', '2026-03-10', 'IN_STOCK', 1209550.00, '2026-03-14', '2026-03-14 10:30:00'),
(72, 'VIN2F3G4H5I6J7K8', 'ENG1072', 'CHA2072', 6, 6, 3, 2025, '2025-09-05', '2025-09-18', 'ALLOCATED', 948600.00, '2025-09-25', '2025-09-25 13:40:00'),
(73, 'VIN3F4G5H6I7J8K9', 'ENG1073', 'CHA2073', 7, 7, 1, 2026, '2026-01-05', '2026-01-18', 'IN_STOCK', 3014100.00, '2026-01-22', '2026-01-22 09:50:00'),
(74, 'VIN4F5G6H7I8J9K0', 'ENG1074', 'CHA2074', 8, 8, 2, 2025, '2025-09-15', '2025-09-30', 'SOLD', 3820750.00, '2025-10-12', '2025-10-12 16:00:00'),
(75, 'VIN5F6G7H8I9J0K1', 'ENG1075', 'CHA2075', 9, 9, 3, 2026, '2026-01-15', '2026-01-30', 'IN_STOCK', 627300.00, '2026-02-05', '2026-02-05 11:15:00'),
(76, 'VIN6F7G8H9I0J1K2', 'ENG1076', 'CHA2076', 10, 1, 1, 2025, '2025-08-10', '2025-08-22', 'ALLOCATED', 761600.00, '2025-08-28', '2025-08-28 14:30:00'),
(77, 'VIN7F8G9H0I1J2K3', 'ENG1077', 'CHA2077', 11, 2, 2, 2026, '2026-02-20', '2026-03-05', 'IN_STOCK', 613700.00, '2026-03-11', '2026-03-11 10:10:00'),
(78, 'VIN8F9G0H1I2J3K4', 'ENG1078', 'CHA2078', 12, 3, 3, 2025, '2025-10-25', '2025-11-10', 'SOLD', 1700000.00, '2025-11-22', '2025-11-22 15:50:00'),
(79, 'VIN9F0G1H2I3J4K5', 'ENG1079', 'CHA2079', 1, 4, 1, 2026, '2025-12-25', '2026-01-10', 'IN_STOCK', 923950.00, '2026-01-18', '2026-01-18 09:40:00'),
(80, 'VIN0F1G2H3I4J5K6', 'ENG1080', 'CHA2080', 2, 5, 2, 2025, '2025-11-15', '2025-11-30', 'ALLOCATED', 1615000.00, '2025-12-08', '2025-12-08 12:20:00');

-- REAL-TIME DATA FOR MARCH 2026 (For Live Dashboard)
INSERT INTO leads (lead_number, customer_id, source_id, assigned_to, preferred_variant_id, status, created_at) VALUES 
('LD0046', 1, 1, 3, 1, 'NEW', '2026-03-01 10:00:00'),
('LD0047', 2, 2, 4, 3, 'CONTACTED', '2026-03-02 11:30:00'),
('LD0048', 3, 3, 8, 2, 'TEST_DRIVE', '2026-03-05 14:15:00'),
('LD0049', 4, 1, 3, 6, 'CONTACTED', '2026-03-10 09:45:00'),
('LD0050', 5, 2, 4, 12, 'NEW', '2026-03-12 16:20:00');

INSERT INTO service_appointments (appointment_no, customer_id, vehicle_reg_no, appointed_by, appointment_date, service_type, status, created_at) VALUES 
('SRV0017', 1, 'KA01AB1234', 5, '2026-03-14 10:00:00', 'PERIODIC', 'SCHEDULED', '2026-03-11 10:00:00'),
('SRV0018', 2, 'KA03CD5678', 5, '2026-03-14 14:00:00', 'REPAIR', 'IN_PROGRESS', '2026-03-12 11:30:00'),
('SRV0019', 3, 'KA05EF9012', 5, '2026-03-15 09:30:00', 'ACCIDENTAL', 'SCHEDULED', '2026-03-13 14:15:00'),
('SRV0020', 4, 'KA02GH3456', 5, '2026-03-16 11:00:00', 'WARRANTY', 'SCHEDULED', '2026-03-14 09:45:00');

-- INSERT INTO job_cards (job_card_no, appointment_id, mechanic_id, labour_cost, parts_cost, total_cost, status, created_at) VALUES 
-- ('JC0013', 17, 1, 1500, 3500, 5000, 'OPEN', '2026-03-14 10:15:00'),
-- ('JC0014', 18, 2, 2000, 1500, 3500, 'IN_PROGRESS', '2026-03-14 11:30:00');

INSERT INTO bookings (id, booking_number, lead_id, customer_id, variant_id, color_id, sales_exec_id, vehicle_id, ex_showroom, total_on_road, status, created_at) VALUES 
(16, 'BK0016', 46, 1, 1, 1, 3, NULL, 1087000.00, 1250000.00, 'BOOKED', '2026-03-01 10:30:00'),
(17, 'BK0017', 47, 2, 3, 2, 4, NULL, 894000.00, 1050000.00, 'BOOKED', '2026-03-05 11:45:00'),
(18, 'BK0018', 49, 4, 6, 4, 3, NULL, 1116000.00, 1300000.00, 'BOOKED', '2026-03-12 09:20:00');


