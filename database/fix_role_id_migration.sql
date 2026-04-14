-- ============================================================
-- FIX: Drop orphaned role_id column from employees table
-- This column was left over from before the multi-role refactor.
-- Run this ONCE on any database that was imported from an old dump.
-- ============================================================

USE dealerconnect;

-- Step 1: Drop the foreign key constraint (if it exists)
SET @fk_name = (
    SELECT CONSTRAINT_NAME
    FROM information_schema.KEY_COLUMN_USAGE
    WHERE TABLE_NAME    = 'employees'
      AND COLUMN_NAME   = 'role_id'
      AND TABLE_SCHEMA  = 'dealerconnect'
      AND REFERENCED_TABLE_NAME IS NOT NULL
    LIMIT 1
);

SET @drop_fk = IF(
    @fk_name IS NOT NULL,
    CONCAT('ALTER TABLE employees DROP FOREIGN KEY ', @fk_name),
    'SELECT "No FK to drop" AS info'
);

PREPARE stmt FROM @drop_fk;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Step 2: Drop the column (if it exists)
SET @col_exists = (
    SELECT COUNT(*)
    FROM information_schema.COLUMNS
    WHERE TABLE_NAME   = 'employees'
      AND COLUMN_NAME  = 'role_id'
      AND TABLE_SCHEMA = 'dealerconnect'
);

SET @drop_col = IF(
    @col_exists > 0,
    'ALTER TABLE employees DROP COLUMN role_id',
    'SELECT "Column role_id not found, nothing to do" AS info'
);

PREPARE stmt2 FROM @drop_col;
EXECUTE stmt2;
DEALLOCATE PREPARE stmt2;

SELECT 'Done! The role_id column has been removed from employees.' AS result;
