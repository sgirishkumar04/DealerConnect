-- ============================================================
--  DEALERCONNECT - ADD AGING TEST VEHICLES PATCH
--  Adds 3 new IN_STOCK vehicles with specific manufacturing 
--  dates (relative to 2026-03-15) to demonstrate the Inventory
--  Aging highlights (Normal, Warning, Critical)
-- ============================================================
USE dealerconnect;
SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO vehicles (vin, engine_number, chassis_number, variant_id, color_id, location_id, status, created_at, mfg_date, arrival_date) VALUES
-- Normal Aging: 10 days old (mfg_date = 2026-03-05)
('VIN0000000010086', 'CRT-ENG-2026-0099', 'CRT-CHS-2026-0099', 1,  1, 2, 'IN_STOCK', '2026-03-08 09:00:00', '2026-03-05', '2026-03-10'),

-- Warning Aging: 45 days old (mfg_date = 2026-01-29)
('VIN0000000010087', 'VEN-ENG-2026-0088', 'VEN-CHS-2026-0088', 4,  4, 1, 'IN_STOCK', '2026-02-05 10:30:00', '2026-01-29', '2026-02-10'),

-- Critical Aging: 75 days old (mfg_date = 2025-12-30)
('VIN0000000010088', 'TUC-ENG-2026-0077', 'TUC-CHS-2026-0077', 8,  8, 2, 'IN_STOCK', '2026-01-05 14:15:00', '2025-12-30', '2026-01-15');

SET FOREIGN_KEY_CHECKS = 1;
