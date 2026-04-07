-- Seed Data for April 2026
USE dealerconnect;

-- 1. Customers
INSERT INTO customers (customer_code, first_name, last_name, email, phone, dealer_id, created_at) VALUES
('CUST-2026-001', 'Arjun', 'Reddy', 'arjun.reddy@example.com', '9876543210', 1, '2026-04-01 10:00:00'),
('CUST-2026-002', 'Lekha', 'Menon', 'lekha.m@example.com', '9876543211', 1, '2026-04-01 11:30:00'),
('CUST-2026-003', 'Vikram', 'Prabhu', 'v.prabhu@example.com', '9876543212', 1, '2026-04-01 14:15:00'),
('CUST-2026-004', 'Sanya', 'Gupta', 'sanya.g@example.com', '9876543213', 1, '2026-04-01 16:45:00'),
('CUST-2026-005', 'Karthik', 'S', 'karthik.s@example.com', '9876543214', 1, '2026-04-02 09:00:00');

-- 2. Leads (assigned_to: IDs 3, 4, 8 are Sales Execs/Admins)
-- Source IDs: 1-Showroom Walk-in, 2-Website, 3-Referral, 4-Social Media, 5-Call Center
INSERT INTO leads (lead_number, status, assigned_to, customer_id, preferred_model_id, source_id, dealer_id, created_at) VALUES
('LD-2026-001', 'NEGOTIATION', 3, (SELECT id FROM customers WHERE customer_code='CUST-2026-001'), 1, 1, 1, '2026-04-01 10:15:00'),
('LD-2026-002', 'CONTACTED', 4, (SELECT id FROM customers WHERE customer_code='CUST-2026-002'), 2, 2, 1, '2026-04-01 12:00:00'),
('LD-2026-003', 'TEST_DRIVE', 8, (SELECT id FROM customers WHERE customer_code='CUST-2026-003'), 3, 3, 1, '2026-04-01 14:30:00'),
('LD-2026-004', 'NEW', 3, (SELECT id FROM customers WHERE customer_code='CUST-2026-004'), 4, 4, 1, '2026-04-01 17:00:00'),
('LD-2026-005', 'BOOKED', 4, (SELECT id FROM customers WHERE customer_code='CUST-2026-005'), 5, 2, 1, '2026-04-02 09:30:00');

-- 3. Bookings
-- Color IDs: 1-Polar White, 4-Phantom Black, 5-Fiery Red
-- Variant IDs: 1 (Creta), 3 (Venue), 5 (Verna)
INSERT INTO bookings (booking_number, ex_showroom, total_on_road, status, color_id, customer_id, lead_id, sales_exec_id, variant_id, dealer_id, created_at) VALUES
('BKG-2026-04-001', 1087000.00, 1250000.00, 'BOOKED', 1, (SELECT id FROM customers WHERE customer_code='CUST-2026-005'), (SELECT id FROM leads WHERE lead_number='LD-2026-005'), 4, 1, 1, '2026-04-02 10:00:00'),
('BKG-2026-04-002', 794000.00, 920000.00, 'INVOICED', 4, (SELECT id FROM customers WHERE customer_code='CUST-2026-001'), (SELECT id FROM leads WHERE lead_number='LD-2026-001'), 3, 3, 1, '2026-04-01 15:30:00'),
('BKG-2026-04-003', 1850000.00, 2150000.00, 'DELIVERED', 5, (SELECT id FROM customers WHERE customer_code='CUST-2026-003'), (SELECT id FROM leads WHERE lead_number='LD-2026-003'), 8, 5, 1, '2026-04-01 16:00:00');

-- 4. Invoices (Revenue)
-- Vehicle IDs: 108, 109, 110 (Check existing vehicles if they exist, or just use these if seeded)
INSERT INTO invoices (invoice_number, invoice_date, status, sub_total, total_amount, booking_id, created_by, customer_id, vehicle_id, created_at) VALUES
('INV-2026-04-001', '2026-04-01', 'PAID', 1850000.00, 2150000.00, (SELECT id FROM bookings WHERE booking_number='BKG-2026-04-003'), 1, (SELECT id FROM customers WHERE customer_code='CUST-2026-003'), 108, '2026-04-01 16:15:00'),
('INV-2026-04-002', '2026-04-02', 'ISSUED', 794000.00, 920000.00, (SELECT id FROM bookings WHERE booking_number='BKG-2026-04-002'), 1, (SELECT id FROM customers WHERE customer_code='CUST-2026-001'), 109, '2026-04-02 11:00:00');

-- 5. Service Appointments
-- ServiceAdvisor ID: 5
INSERT INTO service_appointments (appointment_no, appointment_date, service_type, status, vehicle_reg_no, appointed_by, customer_id, dealer_id, created_at) VALUES
('SA-2026-001', '2026-04-01 10:00:00', 'PERIODIC', 'COMPLETED', 'TN-01-AB-1234', 5, (SELECT id FROM customers WHERE customer_code='CUST-2026-002'), 1, '2026-04-01 09:00:00'),
('SA-2026-002', '2026-04-01 11:30:00', 'REPAIR', 'IN_PROGRESS', 'TN-07-CD-5678', 5, (SELECT id FROM customers WHERE customer_code='CUST-2026-004'), 1, '2026-04-01 11:00:00'),
('SA-2026-003', '2026-04-02 14:00:00', 'WARRANTY', 'SCHEDULED', 'TN-05-XY-9012', 5, 2, 1, '2026-04-02 10:00:00');
