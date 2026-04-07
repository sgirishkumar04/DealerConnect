USE dealerconnect;
SET FOREIGN_KEY_CHECKS = 0;

-- 1. Create a Supplier
INSERT INTO suppliers (id, name, contact_name, phone, email, address, gst_number) 
VALUES (999, 'Auto Parts Co.', 'John Doe', '9998887776', 'supply@autoparts.com', '123 Industrial Area', '27AABCU9603R1Z2')
ON DUPLICATE KEY UPDATE name=name;

-- 2. Create a Spare Part and Inventory
INSERT INTO spare_parts (id, part_number, name, description, category, unit, unit_price, gst_rate, supplier_id) 
VALUES (999, 'PART-999', 'High-Performance Engine Oil', 'Synthetic Oil', 'Fluids', 'Liters', 1500.00, 18.00, 999)
ON DUPLICATE KEY UPDATE name=name;

INSERT INTO spare_part_inventory (id, part_id, location_id, quantity, reorder_level) 
VALUES (999, 999, 1, 50, 10)
ON DUPLICATE KEY UPDATE quantity=50;

-- 3. Create a Customer and Address
INSERT INTO customers (id, customer_code, first_name, last_name, email, phone) 
VALUES (999, 'CUST0999', 'Demo', 'User', 'demo.user@example.com', '9999999999')
ON DUPLICATE KEY UPDATE first_name=first_name;

INSERT INTO customer_addresses (id, customer_id, type, line1, city, state, pincode, is_primary)
VALUES (999, 999, 'HOME', 'Sample Demo Address', 'Bangalore', 'Karnataka', '560001', TRUE)
ON DUPLICATE KEY UPDATE line1=line1;

-- 4. Create a Lead and Test Drive
INSERT INTO leads (id, lead_number, customer_id, source_id, assigned_to, preferred_variant_id, status) 
VALUES (999, 'LD0999', 999, 1, 3, 1, 'DELIVERED')
ON DUPLICATE KEY UPDATE lead_number=lead_number;

INSERT INTO vehicles (id, vin, engine_number, chassis_number, variant_id, color_id, location_id, mfg_year, mfg_date, arrival_date, status, dealer_cost) 
VALUES (999, 'VIN999TESTDRIVE12', 'ENG999', 'CHA999', 1, 1, 1, 2026, '2026-03-01', '2026-03-10', 'SOLD', 1000000)
ON DUPLICATE KEY UPDATE vin=vin;

INSERT INTO test_drives (id, lead_id, vehicle_id, scheduled_at, conducted_by, status, feedback)
VALUES (999, 999, 999, '2026-03-25 10:00:00', 3, 'COMPLETED', 'Excellent Drive')
ON DUPLICATE KEY UPDATE feedback=feedback;

-- 5. Create a Booking, Booking Payment, and Allocation
INSERT INTO bookings (id, booking_number, lead_id, customer_id, variant_id, color_id, sales_exec_id, vehicle_id, ex_showroom, total_on_road, status)
VALUES (999, 'BKG0999', 999, 999, 1, 1, 3, 999, 1087000.00, 1250000.00, 'DELIVERED')
ON DUPLICATE KEY UPDATE booking_number=booking_number;

INSERT INTO booking_payments (id, booking_id, amount, payment_mode, payment_date, reference_no, recorded_by)
VALUES (999, 999, 50000.00, 'UPI', '2026-03-26', 'UPI999888', 7)
ON DUPLICATE KEY UPDATE amount=amount;

INSERT INTO vehicle_allocations (id, booking_id, vehicle_id, allocated_by)
VALUES (999, 999, 999, 3)
ON DUPLICATE KEY UPDATE allocated_by=allocated_by;

-- 6. Create Finance and Insurance
INSERT INTO finance_loans (id, loan_number, booking_id, customer_id, bank_id, loan_amount, tenure_months, interest_rate, status)
VALUES (999, 'LOAN0999', 999, 999, 1, 1000000.00, 60, 8.5, 'APPROVED')
ON DUPLICATE KEY UPDATE loan_number=loan_number;

INSERT INTO insurance_policies (id, policy_number, booking_id, customer_id, insurer_name, premium_amount, start_date, end_date, status)
VALUES (999, 'POL0999', 999, 999, 'XYZ Insurance', 25000.00, '2026-03-26', '2027-03-25', 'ACTIVE')
ON DUPLICATE KEY UPDATE policy_number=policy_number;

-- 7. Create Invoice and Invoice Items
INSERT INTO invoices (id, invoice_number, booking_id, customer_id, vehicle_id, invoice_date, sub_total, gst_amount, total_amount, status, created_by)
VALUES (999, 'INV0999', 999, 999, 999, '2026-03-27', 1060000.00, 190000.00, 1250000.00, 'ISSUED', 7)
ON DUPLICATE KEY UPDATE invoice_number=invoice_number;

INSERT INTO invoice_items (id, invoice_id, description, quantity, unit_price, total_price)
VALUES (999, 999, 'Base Vehicle Price', 1, 1060000.00, 1060000.00)
ON DUPLICATE KEY UPDATE description=description;

-- 8. Create Payment and Receipt
INSERT INTO payments (id, payment_ref, invoice_id, customer_id, amount, payment_mode, payment_date, status, recorded_by)
VALUES (999, 'PAY0999', 999, 999, 1200000.00, 'NEFT', '2026-03-28', 'COMPLETED', 7)
ON DUPLICATE KEY UPDATE payment_ref=payment_ref;

INSERT INTO receipts (id, receipt_number, payment_id, issued_date, issued_by)
VALUES (999, 'REC0999', 999, '2026-03-28', 7)
ON DUPLICATE KEY UPDATE receipt_number=receipt_number;

-- 9. Create Service Appointment, Job Card, Spare Part Usage, and Service History
INSERT INTO service_appointments (id, appointment_no, customer_id, vehicle_reg_no, appointed_by, appointment_date, service_type, status)
VALUES (999, 'SRV0999', 999, 'KA01TEST99', 5, '2026-06-25 10:00:00', 'PERIODIC', 'COMPLETED')
ON DUPLICATE KEY UPDATE appointment_no=appointment_no;

INSERT INTO job_cards (id, job_card_no, appointment_id, mechanic_id, labour_cost, parts_cost, total_cost, status)
VALUES (999, 'JC0999', 999, 1, 1500.00, 1500.00, 3000.00, 'COMPLETED')
ON DUPLICATE KEY UPDATE job_card_no=job_card_no;

INSERT INTO spare_part_usage (id, job_card_id, part_id, quantity, unit_price, total_price)
VALUES (999, 999, 999, 1, 1500.00, 1500.00)
ON DUPLICATE KEY UPDATE quantity=quantity;

INSERT INTO service_history (id, job_card_id, description, action_taken, recorded_by)
VALUES (999, 999, 'First Free Service', 'Oil changed, general checkup', 5)
ON DUPLICATE KEY UPDATE description=description;

SET FOREIGN_KEY_CHECKS = 1;

