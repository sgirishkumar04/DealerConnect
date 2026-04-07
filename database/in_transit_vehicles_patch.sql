-- ============================================================
--  DEALERCONNECT - ADD "IN TRANSIT" VEHICLES PATCH
--  Adds 5 new vehicles currently in transit from factory
-- ============================================================
USE dealerconnect;
SET FOREIGN_KEY_CHECKS = 0;

INSERT INTO vehicles (vin, engine_number, chassis_number, variant_id, color_id, location_id, status, created_at, mfg_date, arrival_date) VALUES
('VIN0000000010081', 'EXT-ENG-2026-0030', 'EXT-CHS-2026-0030', 10, 2, 2, 'IN_TRANSIT', '2026-03-10 09:00:00', '2026-03-05', '2026-03-20'),
('VIN0000000010082', 'VEN-ENG-2026-0015', 'VEN-CHS-2026-0015', 5, 8, 1, 'IN_TRANSIT', '2026-03-11 10:30:00', '2026-03-08', '2026-03-22'),
('VIN0000000010083', 'CRT-ENG-2026-0045', 'CRT-CHS-2026-0045', 1, 1, 2, 'IN_TRANSIT', '2026-03-12 14:15:00', '2026-03-10', '2026-03-25'),
('VIN0000000010084', 'TUC-ENG-2026-0005', 'TUC-CHS-2026-0005', 7, 5, 1, 'IN_TRANSIT', '2026-03-13 11:00:00', '2026-03-01', '2026-03-28'),
('VIN0000000010085', 'I20-ENG-2026-0020', 'I20-CHS-2026-0020', 3, 3, 2, 'IN_TRANSIT', '2026-03-14 16:45:00', '2026-03-12', '2026-03-21');

SET FOREIGN_KEY_CHECKS = 1;
