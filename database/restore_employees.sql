-- ============================================================
--  DEALERCONNECT - Restore Missing Employees
--  All 9 employees present in original sample data.
--  Password for ALL accounts: Password@123
--  Hash: $2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW
-- ============================================================
USE dealerconnect;

INSERT INTO employees (id, employee_code, first_name, last_name, email, phone, password_hash, department_id, role_id, date_of_join, is_active)
VALUES
  (1,  'EMP001', 'S',       'GIRISH KUMAR', 'admin@dealerconnect.com',         '9876543210', '$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW', 1, 1, '2020-01-15', 1),
  (2,  'EMP002', 'Priya',   'Sharma',        'sales.mgr@dealerconnect.com',     '9876543211', '$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW', 2, 2, '2020-03-10', 1),
  (3,  'EMP003', 'Rahul',   'Verma',         'rahul.sales@dealerconnect.com',   '9876543212', '$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW', 2, 3, '2021-06-01', 1),
  (4,  'EMP004', 'Anita',   'Desai',         'anita.sales@dealerconnect.com',   '9876543213', '$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW', 2, 3, '2021-08-15', 1),
  (5,  'EMP005', 'Vikram',  'Singh',         'vikram.svc@dealerconnect.com',    '9876543214', '$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW', 3, 4, '2020-11-20', 1),
  (6,  'EMP006', 'Suresh',  'Babu',          'suresh.mech@dealerconnect.com',   '9876543215', '$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW', 3, 5, '2022-01-10', 1),
  (7,  'EMP007', 'Ramesh',  'Kumar',         'ramesh.mech@dealerconnect.com',   '9876543216', '$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW', 3, 5, '2022-02-15', 1),
  (8,  'EMP008', 'Karthik', 'Nair',          'karthik.sales@dealerconnect.com', '9876543217', '$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW', 2, 3, '2023-01-05', 1),
  (9,  'EMP009', 'Neha',    'Gupta',         'neha.inv@dealerconnect.com',      '9876543218', '$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW', 4, 6, '2024-05-10', 1),
  (10, 'EMP010', 'Deepa',   'Menon',         'deepa.accounts@dealerconnect.com','9876543219', '$2a$10$uHYn5GiNxBxHgyp3hxNA9eqHc2Puhy6NniF.C/gWZgqjdnKlRjyLW', 5, 7, '2021-04-01', 1)
ON DUPLICATE KEY UPDATE
  password_hash = VALUES(password_hash),
  is_active     = 1;

-- Restore mechanics table linking employees 6 & 7 to mechanic records
INSERT INTO mechanics (id, employee_id, speciality)
VALUES
  (1, 6, 'General Service'),
  (2, 7, 'Engine & Transmission')
ON DUPLICATE KEY UPDATE speciality = VALUES(speciality);
