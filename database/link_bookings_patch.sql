-- ============================================================
--  DEALERCONNECT - LINK BOOKINGS TO SOLD/ALLOCATED VEHICLES
--  Links 35 specific vehicles to existing bookings
-- ============================================================
USE dealerconnect;

-- Link logic: Just mapping incrementally to booking IDs 1-35
UPDATE bookings SET vehicle_id = 1 WHERE id = 1;
UPDATE bookings SET vehicle_id = 2 WHERE id = 2;
UPDATE bookings SET vehicle_id = 6 WHERE id = 3;
UPDATE bookings SET vehicle_id = 7 WHERE id = 4;
UPDATE bookings SET vehicle_id = 11 WHERE id = 5;
UPDATE bookings SET vehicle_id = 12 WHERE id = 6;
UPDATE bookings SET vehicle_id = 13 WHERE id = 7;
UPDATE bookings SET vehicle_id = 14 WHERE id = 8;
UPDATE bookings SET vehicle_id = 15 WHERE id = 9;
UPDATE bookings SET vehicle_id = 16 WHERE id = 10;
UPDATE bookings SET vehicle_id = 17 WHERE id = 11;
UPDATE bookings SET vehicle_id = 18 WHERE id = 12;
UPDATE bookings SET vehicle_id = 19 WHERE id = 13;
UPDATE bookings SET vehicle_id = 20 WHERE id = 14;
UPDATE bookings SET vehicle_id = 32 WHERE id = 15;
UPDATE bookings SET vehicle_id = 34 WHERE id = 16;
UPDATE bookings SET vehicle_id = 39 WHERE id = 17;
UPDATE bookings SET vehicle_id = 41 WHERE id = 18;
UPDATE bookings SET vehicle_id = 43 WHERE id = 19;
UPDATE bookings SET vehicle_id = 47 WHERE id = 20;
UPDATE bookings SET vehicle_id = 49 WHERE id = 21;
UPDATE bookings SET vehicle_id = 51 WHERE id = 22;
UPDATE bookings SET vehicle_id = 53 WHERE id = 23;
UPDATE bookings SET vehicle_id = 57 WHERE id = 24;
UPDATE bookings SET vehicle_id = 58 WHERE id = 25;
UPDATE bookings SET vehicle_id = 60 WHERE id = 26;
UPDATE bookings SET vehicle_id = 62 WHERE id = 27;
UPDATE bookings SET vehicle_id = 64 WHERE id = 28;
UPDATE bookings SET vehicle_id = 66 WHERE id = 29;
UPDATE bookings SET vehicle_id = 70 WHERE id = 30;
UPDATE bookings SET vehicle_id = 72 WHERE id = 31;
UPDATE bookings SET vehicle_id = 74 WHERE id = 32;
UPDATE bookings SET vehicle_id = 76 WHERE id = 33;
UPDATE bookings SET vehicle_id = 78 WHERE id = 34;
UPDATE bookings SET vehicle_id = 80 WHERE id = 35;

-- Ensure these 35 vehicles are accurately reflecting the status of the bookings
UPDATE vehicles v 
JOIN bookings b ON v.id = b.vehicle_id 
SET v.status = CASE
    WHEN b.status = 'DELIVERED' THEN 'SOLD'
    WHEN b.status = 'ALLOCATED' THEN 'ALLOCATED'
    WHEN b.status = 'BOOKED' THEN 'ALLOCATED'
    WHEN b.status = 'INVOICED' THEN 'ALLOCATED'
    ELSE 'IN_STOCK'
END
WHERE b.id IN (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35);

-- Safety cleanup: If a vehicle is explicitly IN_STOCK, clear its booking id
UPDATE bookings SET vehicle_id = NULL WHERE id IN (
  SELECT b_id FROM (
    SELECT b.id AS b_id FROM bookings b 
    JOIN vehicles v ON b.vehicle_id = v.id 
    WHERE v.status = 'IN_STOCK'
  ) AS tmp
);
