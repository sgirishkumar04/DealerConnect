-- -----------------------------------------------------------------------------
-- DealerConnect DMS - Role Mapping Fix
-- Purpose: Restores the missing Many-To-Many mapping for employee roles after early database migrations.
-- Run this script in MySQL Workbench or via terminal on the new laptop.
-- -----------------------------------------------------------------------------

USE dealerconnect;

-- Clear any empty mappings just to be safe
DELETE FROM employee_roles WHERE role_id IS NULL;

-- Automatically map the core user accounts to their respective roles if they exist
INSERT IGNORE INTO employee_roles (employee_id, role_id) 
SELECT e.id, r.id FROM employees e JOIN roles r 
WHERE e.email = 'admin@dealerconnect.com' AND r.name = 'ADMIN';

INSERT IGNORE INTO employee_roles (employee_id, role_id) 
SELECT e.id, r.id FROM employees e JOIN roles r 
WHERE e.email = 'superadmin@dealerconnect.com' AND r.name = 'SUPER_ADMIN';

INSERT IGNORE INTO employee_roles (employee_id, role_id) 
SELECT e.id, r.id FROM employees e JOIN roles r 
WHERE e.email = 'sales.mgr@dealerconnect.com' AND r.name = 'SALES_MANAGER';

INSERT IGNORE INTO employee_roles (employee_id, role_id) 
SELECT e.id, r.id FROM employees e JOIN roles r 
WHERE e.email = 'rahul.sales@dealerconnect.com' AND r.name = 'SALES_EXECUTIVE';

INSERT IGNORE INTO employee_roles (employee_id, role_id) 
SELECT e.id, r.id FROM employees e JOIN roles r 
WHERE e.email = 'anita.sales@dealerconnect.com' AND r.name = 'SALES_EXECUTIVE';

-- Add a fallback mapping for any other employees who might be missing a role
-- (Defaults them to Sales Executive so they can at least view basic data)
INSERT IGNORE INTO employee_roles (employee_id, role_id) 
SELECT e.id, r.id FROM employees e JOIN roles r 
WHERE e.id NOT IN (SELECT employee_id FROM employee_roles)
AND r.name = 'SALES_EXECUTIVE';

-- -----------------------------------------------------------------------------
-- End of Script
-- -----------------------------------------------------------------------------
