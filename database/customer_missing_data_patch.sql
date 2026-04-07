-- -----------------------------------------------------------------------------
-- SQL Script: add_customer_missing_data.sql
-- Description: Updates the 'customers' table and inserts into 'customer_addresses'
--              to populate missing data like Gender, PAN, City, etc. for the
--              first 45 existing seed customers in the DealerConnect.
-- -----------------------------------------------------------------------------

USE dealerconnect;

-- 1. Update Customers Table (Add Gender, DOB, PAN, Aadhaar)
UPDATE customers SET gender='MALE', pan_number='ABCDE1234F', date_of_birth='1985-06-15' WHERE customer_code='CUST0001';
UPDATE customers SET gender='FEMALE', pan_number='FGHIJ5678K', date_of_birth='1990-08-22' WHERE customer_code='CUST0002';
UPDATE customers SET gender='MALE', pan_number='KLMNO9012P', date_of_birth='1982-11-05' WHERE customer_code='CUST0003';
UPDATE customers SET gender='FEMALE', pan_number='PQRST3456U', date_of_birth='1995-03-30' WHERE customer_code='CUST0004';
UPDATE customers SET gender='MALE', pan_number='UVWXY7890Z', date_of_birth='1988-01-12' WHERE customer_code='CUST0005';
UPDATE customers SET gender='FEMALE', pan_number='ABCDE1234F', date_of_birth='1992-07-18' WHERE customer_code='CUST0006';
UPDATE customers SET gender='MALE', pan_number='FGHIJ5678K', date_of_birth='1980-09-25' WHERE customer_code='CUST0007';
UPDATE customers SET gender='FEMALE', pan_number='KLMNO9012P', date_of_birth='1998-04-10' WHERE customer_code='CUST0008';
UPDATE customers SET gender='MALE', pan_number='PQRST3456U', date_of_birth='1986-12-03' WHERE customer_code='CUST0009';
UPDATE customers SET gender='FEMALE', pan_number='UVWXY7890Z', date_of_birth='1994-05-20' WHERE customer_code='CUST0010';
UPDATE customers SET gender='MALE', pan_number='ABCDE1234F', date_of_birth='1983-02-14' WHERE customer_code='CUST0011';
UPDATE customers SET gender='FEMALE', pan_number='FGHIJ5678K', date_of_birth='1991-10-28' WHERE customer_code='CUST0012';
UPDATE customers SET gender='MALE', pan_number='KLMNO9012P', date_of_birth='1987-06-08' WHERE customer_code='CUST0013';
UPDATE customers SET gender='FEMALE', pan_number='PQRST3456U', date_of_birth='1996-01-16' WHERE customer_code='CUST0014';
UPDATE customers SET gender='MALE', pan_number='UVWXY7890Z', date_of_birth='1984-08-05' WHERE customer_code='CUST0015';
UPDATE customers SET gender='FEMALE', pan_number='ABCDE1234F', date_of_birth='1993-03-22' WHERE customer_code='CUST0016';
UPDATE customers SET gender='MALE', pan_number='FGHIJ5678K', date_of_birth='1981-11-09' WHERE customer_code='CUST0017';
UPDATE customers SET gender='FEMALE', pan_number='KLMNO9012P', date_of_birth='1997-04-27' WHERE customer_code='CUST0018';
UPDATE customers SET gender='MALE', pan_number='PQRST3456U', date_of_birth='1985-12-11' WHERE customer_code='CUST0019';
UPDATE customers SET gender='FEMALE', pan_number='UVWXY7890Z', date_of_birth='1990-07-04' WHERE customer_code='CUST0020';
UPDATE customers SET gender='MALE', pan_number='ABCDE1234F', date_of_birth='1982-01-25' WHERE customer_code='CUST0021';
UPDATE customers SET gender='FEMALE', pan_number='FGHIJ5678K', date_of_birth='1995-09-15' WHERE customer_code='CUST0022';
UPDATE customers SET gender='MALE', pan_number='KLMNO9012P', date_of_birth='1988-05-02' WHERE customer_code='CUST0023';
UPDATE customers SET gender='FEMALE', pan_number='PQRST3456U', date_of_birth='1992-12-20' WHERE customer_code='CUST0024';
UPDATE customers SET gender='MALE', pan_number='UVWXY7890Z', date_of_birth='1980-08-08' WHERE customer_code='CUST0025';
UPDATE customers SET gender='FEMALE', pan_number='ABCDE1234F', date_of_birth='1998-03-14' WHERE customer_code='CUST0026';
UPDATE customers SET gender='MALE', pan_number='FGHIJ5678K', date_of_birth='1986-10-30' WHERE customer_code='CUST0027';
UPDATE customers SET gender='FEMALE', pan_number='KLMNO9012P', date_of_birth='1994-06-18' WHERE customer_code='CUST0028';
UPDATE customers SET gender='MALE', pan_number='PQRST3456U', date_of_birth='1983-01-05' WHERE customer_code='CUST0029';
UPDATE customers SET gender='FEMALE', pan_number='UVWXY7890Z', date_of_birth='1991-09-22' WHERE customer_code='CUST0030';
UPDATE customers SET gender='MALE', pan_number='ABCDE1234F', date_of_birth='1987-04-12' WHERE customer_code='CUST0031';
UPDATE customers SET gender='FEMALE', pan_number='FGHIJ5678K', date_of_birth='1996-11-28' WHERE customer_code='CUST0032';
UPDATE customers SET gender='MALE', pan_number='KLMNO9012P', date_of_birth='1984-07-06' WHERE customer_code='CUST0033';
UPDATE customers SET gender='FEMALE', pan_number='PQRST3456U', date_of_birth='1993-02-14' WHERE customer_code='CUST0034';
UPDATE customers SET gender='MALE', pan_number='UVWXY7890Z', date_of_birth='1981-10-02' WHERE customer_code='CUST0035';
UPDATE customers SET gender='FEMALE', pan_number='ABCDE1234F', date_of_birth='1997-05-20' WHERE customer_code='CUST0036';
UPDATE customers SET gender='MALE', pan_number='FGHIJ5678K', date_of_birth='1985-12-08' WHERE customer_code='CUST0037';
UPDATE customers SET gender='FEMALE', pan_number='KLMNO9012P', date_of_birth='1990-08-25' WHERE customer_code='CUST0038';
UPDATE customers SET gender='MALE', pan_number='PQRST3456U', date_of_birth='1982-03-14' WHERE customer_code='CUST0039';
UPDATE customers SET gender='FEMALE', pan_number='UVWXY7890Z', date_of_birth='1995-10-02' WHERE customer_code='CUST0040';
UPDATE customers SET gender='MALE', pan_number='ABCDE1234F', date_of_birth='1988-06-20' WHERE customer_code='CUST0041';
UPDATE customers SET gender='FEMALE', pan_number='FGHIJ5678K', date_of_birth='1992-01-08' WHERE customer_code='CUST0042';
UPDATE customers SET gender='MALE', pan_number='KLMNO9012P', date_of_birth='1980-09-25' WHERE customer_code='CUST0043';
UPDATE customers SET gender='FEMALE', pan_number='PQRST3456U', date_of_birth='1998-04-14' WHERE customer_code='CUST0044';
UPDATE customers SET gender='MALE', pan_number='UVWXY7890Z', date_of_birth='1986-11-02' WHERE customer_code='CUST0045';

-- 2. Insert Customer Addresses
INSERT INTO customer_addresses (customer_id, type, line1, line2, city, state, pincode, is_primary) VALUES
(1, 'HOME', '101, Residency Road', 'MG Road Area', 'Bangalore', 'Karnataka', '560001', 1),
(2, 'HOME', 'A-5, Marine Drive', 'Chowpatty', 'Mumbai', 'Maharashtra', '400002', 1),
(3, 'HOME', '42, Park Street', 'New Market', 'Kolkata', 'West Bengal', '700016', 1),
(4, 'HOME', '15, Connaught Place', 'Rajiv Chowk', 'New Delhi', 'Delhi', '110001', 1),
(5, 'HOME', '24, Jubilee Hills', 'Road No 36', 'Hyderabad', 'Telangana', '500033', 1),
(6, 'HOME', 'Plot 55, Anna Nagar', 'East End', 'Chennai', 'Tamil Nadu', '600040', 1),
(7, 'HOME', 'B-12, Koregaon Park', 'North Main Road', 'Pune', 'Maharashtra', '411001', 1),
(8, 'HOME', '68, Vesu', 'Canal Road', 'Surat', 'Gujarat', '395007', 1),
(9, 'HOME', 'Block A, Satellite', 'SG Highway', 'Ahmedabad', 'Gujarat', '380015', 1),
(10, 'HOME', '11/2, Aliganj', 'Kapoorthala', 'Lucknow', 'Uttar Pradesh', '226024', 1),
(11, 'HOME', '23, Civil Lines', 'Mall Road', 'Kanpur', 'Uttar Pradesh', '208001', 1),
(12, 'HOME', '18, Indiranagar', '100 Feet Road', 'Bangalore', 'Karnataka', '560038', 1),
(13, 'HOME', 'C-4, Andheri West', 'Lokhandwala', 'Mumbai', 'Maharashtra', '400053', 1),
(14, 'HOME', '55, Salt Lake', 'Sector V', 'Kolkata', 'West Bengal', '700091', 1),
(15, 'HOME', '22, Vasant Kunj', 'Nelson Mandela Marg', 'New Delhi', 'Delhi', '110070', 1),
(16, 'HOME', '33, Banjara Hills', 'Road No 12', 'Hyderabad', 'Telangana', '500034', 1),
(17, 'HOME', 'Plot 66, T Nagar', 'Pondy Bazaar', 'Chennai', 'Tamil Nadu', '600017', 1),
(18, 'HOME', 'D-15, Kalyani Nagar', 'Gold Adlabs Area', 'Pune', 'Maharashtra', '411006', 1),
(19, 'HOME', '78, Adajan', 'Pal Road', 'Surat', 'Gujarat', '395009', 1),
(20, 'HOME', 'Block B, Navrangpura', 'CG Road', 'Ahmedabad', 'Gujarat', '380009', 1),
(21, 'HOME', '12/3, Gomti Nagar', 'Patrakarpuram', 'Lucknow', 'Uttar Pradesh', '226010', 1),
(22, 'HOME', '25, Swaroop Nagar', 'Motijheel', 'Kanpur', 'Uttar Pradesh', '208002', 1),
(23, 'HOME', '19, Koramangala', '80 Feet Road', 'Bangalore', 'Karnataka', '560034', 1),
(24, 'HOME', 'E-6, Bandra West', 'Linking Road', 'Mumbai', 'Maharashtra', '400050', 1),
(25, 'HOME', '56, Rajarhat', 'New Town', 'Kolkata', 'West Bengal', '700156', 1),
(26, 'HOME', '26, Dwarka', 'Sector 10', 'New Delhi', 'Delhi', '110075', 1),
(27, 'HOME', '35, HITEC City', 'Madhapur', 'Hyderabad', 'Telangana', '500081', 1),
(28, 'HOME', 'Plot 77, Adyar', 'Besant Nagar', 'Chennai', 'Tamil Nadu', '600020', 1),
(29, 'HOME', 'F-18, Viman Nagar', 'Phoenix Mall Area', 'Pune', 'Maharashtra', '411014', 1),
(30, 'HOME', '88, Piplod', 'Dumas Road', 'Surat', 'Gujarat', '395007', 1),
(31, 'HOME', 'Block C, Prahlad Nagar', 'Corporate Road', 'Ahmedabad', 'Gujarat', '380015', 1),
(32, 'HOME', '14/5, Hazratganj', 'Ashok Marg', 'Lucknow', 'Uttar Pradesh', '226001', 1),
(33, 'HOME', '28, Kakadeo', 'Geeta Nagar', 'Kanpur', 'Uttar Pradesh', '208025', 1),
(34, 'HOME', '21, Whitefield', 'ITPB Area', 'Bangalore', 'Karnataka', '560066', 1),
(35, 'HOME', 'G-8, Juhu', 'Juhu Tara Road', 'Mumbai', 'Maharashtra', '400049', 1),
(36, 'HOME', '59, Ballygunge', 'Gariahat Road', 'Kolkata', 'West Bengal', '700019', 1),
(37, 'HOME', '29, Rohini', 'Sector 15', 'New Delhi', 'Delhi', '110085', 1),
(38, 'HOME', '38, Gachibowli', 'Financial District', 'Hyderabad', 'Telangana', '500032', 1),
(39, 'HOME', 'Plot 88, Velachery', '100 Feet Bypass Road', 'Chennai', 'Tamil Nadu', '600042', 1),
(40, 'HOME', 'H-20, Hinjewadi', 'Phase 1', 'Pune', 'Maharashtra', '411057', 1),
(41, 'HOME', '90, Varachha', 'A K Road', 'Surat', 'Gujarat', '395006', 1),
(42, 'HOME', 'Block D, Bopal', 'Ambli Road', 'Ahmedabad', 'Gujarat', '380058', 1),
(43, 'HOME', '16/7, Mahanagar', 'Kapoorthala Road', 'Lucknow', 'Uttar Pradesh', '226006', 1),
(44, 'HOME', '30, Kidwai Nagar', 'South', 'Kanpur', 'Uttar Pradesh', '208011', 1),
(45, 'HOME', '24, Jayanagar', '4th Block', 'Bangalore', 'Karnataka', '560011', 1);
