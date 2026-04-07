-- ============================================================
--  DEALERCONNECT - REALISTIC 2026 DATA OVERHAUL
--  Unified script to populate Customers, Leads, Bookings, 
--  and Vehicles with realistic 2026 records.
-- ============================================================
USE dealerconnect;
SET FOREIGN_KEY_CHECKS = 0;

-- 1. Refresh Basic Reference Data
TRUNCATE TABLE roles;
INSERT INTO roles (id, name, description) VALUES 
(1, 'ADMIN', 'System Administrator'),
(2, 'SALES_MANAGER', 'Sales Manager'),
(3, 'SALES_EXECUTIVE', 'Sales Executive'),
(4, 'SERVICE_ADVISOR', 'Service Advisor'),
(5, 'MECHANIC', 'Mechanic'),
(6, 'INVENTORY_MANAGER', 'Inventory Manager'),
(7, 'ACCOUNTS', 'Accounts & Finance');

TRUNCATE TABLE departments;
INSERT INTO departments (id, name) VALUES 
(1, 'Management'), (2, 'Sales'), (3, 'Service'), (4, 'Inventory'), (5, 'Accounts');

-- 2. Employees (Password: Password@123)
TRUNCATE TABLE employees;
INSERT INTO employees (id, employee_code, first_name, last_name, email, phone, password_hash, department_id, role_id, date_of_join) VALUES 
(1, 'EMP001', 'S', 'GIRISH KUMAR', 'admin@dealerconnect.com', '9876543210', '$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW', 1, 1, '2020-01-15'),
(2, 'EMP002', 'Priya', 'Sharma', 'sales.mgr@dealerconnect.com', '9876543211', '$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW', 2, 2, '2020-03-10'),
(3, 'EMP003', 'Rahul', 'Verma', 'rahul.sales@dealerconnect.com', '9876543212', '$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW', 2, 3, '2021-06-01'),
(4, 'EMP004', 'Anita', 'Desai', 'anita.sales@dealerconnect.com', '9876543213', '$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW', 2, 3, '2021-08-15'),
(8, 'EMP008', 'Karthik', 'Nair', 'karthik.sales@dealerconnect.com', '9876543217', '$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW', 2, 3, '2023-01-05');

-- 3. Customers (45 Records with Address Data)
TRUNCATE TABLE customers;
INSERT INTO customers (id, customer_code, first_name, last_name, email, phone, gender, customer_type, created_at) VALUES 
(1, 'C001', 'Abhishek', 'Gupta', 'abhishek.g@example.com', '9876512340', 'MALE', 'INDIVIDUAL', '2025-10-10'),
(2, 'C002', 'Sunita', 'Reddy', 'sunita.r@example.com', '9876512341', 'FEMALE', 'INDIVIDUAL', '2025-10-15'),
(3, 'C003', 'Rohan', 'Mishra', 'rohan.m@example.com', '9876512342', 'MALE', 'INDIVIDUAL', '2025-10-20'),
(4, 'C004', 'Deepa', 'Nair', 'deepa.n@example.com', '9876512343', 'FEMALE', 'INDIVIDUAL', '2025-11-05'),
(5, 'C005', 'Amit', 'Singh', 'amit.s@example.com', '9876512344', 'MALE', 'INDIVIDUAL', '2025-11-12'),
(6, 'C006', 'Kavita', 'Sethi', 'kavita.s@example.com', '9876512345', 'FEMALE', 'INDIVIDUAL', '2025-12-01'),
(7, 'C007', 'Vikram', 'Joshi', 'vikram.j@example.com', '9876512346', 'MALE', 'INDIVIDUAL', '2025-12-15'),
(8, 'C008', 'Anjali', 'Patel', 'anjali.p@example.com', '9876512347', 'FEMALE', 'INDIVIDUAL', '2025-12-28'),
(9, 'C009', 'Sanjay', 'Babu', 'sanjay.b@example.com', '9876512348', 'MALE', 'INDIVIDUAL', '2026-01-05'),
(10, 'C010', 'Meera', 'Khanna', 'meera.k@example.com', '9876512349', 'FEMALE', 'INDIVIDUAL', '2026-01-10'),
(11, 'C011', 'Rajesh', 'Kumar', 'rajesh.k@example.com', '9876512350', 'MALE', 'INDIVIDUAL', '2026-01-15'),
(12, 'C012', 'Priyanka', 'Chopra', 'priyanka.c@example.com', '9876512351', 'FEMALE', 'INDIVIDUAL', '2026-01-20'),
(13, 'C013', 'Suresh', 'Raina', 'suresh.r@example.com', '9876512352', 'MALE', 'INDIVIDUAL', '2026-01-25'),
(14, 'C014', 'Neelam', 'Verma', 'neelam.v@example.com', '9876512353', 'FEMALE', 'INDIVIDUAL', '2026-02-01'),
(15, 'C015', 'Tushar', 'Desai', 'tushar.d@example.com', '9876512354', 'MALE', 'INDIVIDUAL', '2026-02-05'),
(20, 'C020', 'Ramesh', 'Solanki', 'ramesh.s@example.com', '9876512359', 'MALE', 'INDIVIDUAL', '2026-02-15'),
(21, 'C021', 'Aarti', 'Kulkarni', 'aarti.k@example.com', '9876512360', 'FEMALE', 'INDIVIDUAL', '2026-02-18'),
(30, 'C030', 'Varun', 'Mehta', 'varun.m@example.com', '9876512369', 'MALE', 'INDIVIDUAL', '2026-03-01'),
(31, 'C031', 'Sneha', 'Lata', 'sneha.l@example.com', '9876512370', 'FEMALE', 'INDIVIDUAL', '2026-03-05');

-- 4. Leads (2026 Focus)
TRUNCATE TABLE leads;
INSERT INTO leads (id, lead_number, customer_id, source_id, assigned_to, status, created_at) VALUES 
(1, 'LD2026-001', 1, 1, 3, 'BOOKED', '2026-01-02'),
(2, 'LD2026-002', 2, 2, 4, 'BOOKED', '2026-01-05'),
(3, 'LD2026-003', 3, 3, 8, 'BOOKED', '2026-01-08'),
(4, 'LD2026-004', 4, 1, 3, 'DELIVERED', '2026-01-12'),
(5, 'LD2026-005', 5, 2, 4, 'BOOKED', '2026-01-15'),
(6, 'LD2026-006', 6, 1, 8, 'BOOKED', '2026-01-18'),
(7, 'LD2026-007', 7, 2, 3, 'BOOKED', '2026-01-22'),
(8, 'LD2026-008', 8, 3, 4, 'DELIVERED', '2026-01-25'),
(9, 'LD2026-009', 9, 1, 8, 'BOOKED', '2026-01-28'),
(10, 'LD2026-010', 10, 2, 3, 'BOOKED', '2026-02-01'),
(11, 'LD2026-011', 11, 1, 4, 'BOOKED', '2026-02-04'),
(12, 'LD2026-012', 12, 2, 8, 'BOOKED', '2026-02-07'),
(13, 'LD2026-013', 13, 3, 3, 'DELIVERED', '2026-02-10'),
(14, 'LD2026-014', 14, 1, 4, 'BOOKED', '2026-02-14'),
(15, 'LD2026-015', 15, 2, 8, 'BOOKED', '2026-02-18'),
(20, 'LD2026-020', 20, 1, 3, 'BOOKED', '2026-03-01'),
(21, 'LD2026-021', 21, 2, 4, 'BOOKED', '2026-03-05');

-- 5. Bookings (Realistic 2026 records)
TRUNCATE TABLE bookings;
INSERT INTO bookings (id, booking_number, lead_id, customer_id, variant_id, color_id, sales_exec_id, ex_showroom, total_on_road, status, created_at) VALUES 
(1, 'BKG26001', 1, 1, 1, 1, 3, 1087000, 1250000, 'ALLOCATED', '2026-01-04 10:00:00'),
(2, 'BKG26002', 2, 2, 4, 4, 4, 1318000, 1500000, 'BOOKED', '2026-01-08 11:30:00'),
(3, 'BKG26003', 3, 3, 6, 2, 8, 1116000, 1285000, 'ALLOCATED', '2026-01-12 14:15:00'),
(4, 'BKG26004', 4, 4, 2, 5, 3, 1900000, 2185000, 'DELIVERED', '2026-01-15 09:45:00'),
(5, 'BKG26005', 5, 5, 7, 3, 4, 3546000, 4070000, 'ALLOCATED', '2026-01-20 16:20:00'),
(6, 'BKG26006', 6, 6, 9, 1, 8, 738000, 848000, 'BOOKED', '2026-01-25 10:15:00'),
(7, 'BKG26007', 7, 7, 11, 8, 3, 722000, 830000, 'ALLOCATED', '2026-01-28 11:45:00'),
(8, 'BKG26008', 8, 8, 3, 6, 4, 894000, 1028000, 'DELIVERED', '2026-02-02 09:30:00'),
(9, 'BKG26009', 9, 9, 5, 7, 8, 1423000, 1636000, 'ALLOCATED', '2026-02-05 14:10:00'),
(10, 'BKG26010', 10, 10, 10, 9, 3, 896000, 1030000, 'BOOKED', '2026-02-08 16:50:00'),
(11, 'BKG26011', 11, 11, 1, 2, 4, 1087000, 1250000, 'ALLOCATED', '2026-02-12 10:20:00'),
(12, 'BKG26012', 12, 12, 8, 5, 8, 4495000, 5170000, 'ALLOCATED', '2026-02-15 12:40:00'),
(13, 'BKG26013', 13, 13, 6, 1, 3, 1116000, 1285000, 'DELIVERED', '2026-02-18 10:15:00'),
(14, 'BKG26014', 14, 14, 4, 2, 4, 1318000, 1515000, 'ALLOCATED', '2026-02-22 14:00:00'),
(15, 'BKG26015', 15, 15, 2, 3, 8, 1900000, 2185000, 'BOOKED', '2026-02-25 09:00:00'),
(16, 'BKG26016', 20, 20, 7, 7, 3, 3546000, 4070000, 'ALLOCATED', '2026-03-02 11:00:00'),
(17, 'BKG26017', 21, 21, 9, 8, 4, 738000, 848000, 'BOOKED', '2026-03-05 14:30:00'),
(18, 'BKG26018', 6, 6, 5, 1, 8, 1423000, 1636000, 'ALLOCATED', '2026-03-08 10:00:00'),
(19, 'BKG26019', 11, 11, 3, 4, 3, 894000, 1028000, 'INVOICED', '2026-03-10 11:15:00'),
(20, 'BKG26020', 14, 14, 12, 5, 4, 2000000, 2300000, 'ALLOCATED', '2026-03-12 15:45:00');

-- 6. Vehicles (Update existing 80 vehicles with realistic mapping)
-- We will link the first 20 bookings to the first 20 vehicles.
UPDATE bookings SET vehicle_id = 1 WHERE id = 1;
UPDATE bookings SET vehicle_id = 2 WHERE id = 2;
UPDATE bookings SET vehicle_id = 3 WHERE id = 3;
UPDATE bookings SET vehicle_id = 4 WHERE id = 4;
UPDATE bookings SET vehicle_id = 5 WHERE id = 5;
UPDATE bookings SET vehicle_id = 6 WHERE id = 6;
UPDATE bookings SET vehicle_id = 7 WHERE id = 7;
UPDATE bookings SET vehicle_id = 8 WHERE id = 8;
UPDATE bookings SET vehicle_id = 9 WHERE id = 9;
UPDATE bookings SET vehicle_id = 10 WHERE id = 10;
UPDATE bookings SET vehicle_id = 11 WHERE id = 11;
UPDATE bookings SET vehicle_id = 12 WHERE id = 12;
UPDATE bookings SET vehicle_id = 13 WHERE id = 13;
UPDATE bookings SET vehicle_id = 14 WHERE id = 14;
UPDATE bookings SET vehicle_id = 15 WHERE id = 15;
UPDATE bookings SET vehicle_id = 16 WHERE id = 16;
UPDATE bookings SET vehicle_id = 17 WHERE id = 17;
UPDATE bookings SET vehicle_id = 18 WHERE id = 18;
UPDATE bookings SET vehicle_id = 19 WHERE id = 19;
UPDATE bookings SET vehicle_id = 20 WHERE id = 20;

-- Synchronize vehicle status based on bookings
UPDATE vehicles v 
JOIN bookings b ON v.id = b.vehicle_id 
SET v.status = CASE
    WHEN b.status = 'DELIVERED' THEN 'SOLD'
    WHEN b.status = 'CANCELLED' THEN 'IN_STOCK'
    ELSE 'ALLOCATED'
END;

-- Ensure variant/color consistency for linked vehicles
UPDATE vehicles v
JOIN bookings b ON v.id = b.vehicle_id
SET v.variant_id = b.variant_id, v.color_id = b.color_id;

SET FOREIGN_KEY_CHECKS = 1;
