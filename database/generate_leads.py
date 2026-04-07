import random

statuses = ['NEW', 'CONTACTED', 'TEST_DRIVE', 'NEGOTIATION', 'BOOKED', 'LOST', 'DELIVERED']

# Generate 15 leads for each status
print("USE dealerconnect;")
print("SET FOREIGN_KEY_CHECKS = 0;")
print("")

print("INSERT INTO leads (lead_number, customer_id, source_id, assigned_to, preferred_model_id, preferred_variant_id, status) VALUES ")

leads = []
lead_counter = 500 # Starting from 500 to assure no collision
booking_counter = 500

bookings = []

for status in statuses:
    for i in range(15):
        lead_no = f"LD0{lead_counter}"
        cust_id = random.randint(1, 45)
        src_id = random.randint(1, 5)
        assigned = random.choice([3, 4, 8]) # Sales execs
        
        # 30% chance to have NO preferred model/variant
        if random.random() < 0.3:
            model, variant = "NULL", "NULL"
        else:
            model = random.randint(1, 8)
            # Variants range from 1 to 12
            variant = random.randint(1, 12)
            
        leads.append(f"('{lead_no}', {cust_id}, {src_id}, {assigned}, {model}, {variant}, '{status}')")
        
        if status in ['BOOKED', 'DELIVERED']:
            bkg_no = f"BKG0{booking_counter}"
            # variant matching the lead, or fallback to 1
            v_id = variant if variant != "NULL" else 1
            c_id = random.randint(1, 9)
            ex_price = 1000000.00
            on_road = 1200000.00
            bookings.append(f"('{bkg_no}', (SELECT id FROM leads WHERE lead_number='{lead_no}'), {cust_id}, {v_id}, {c_id}, {assigned}, {ex_price}, {on_road}, '{status}')")
            booking_counter += 1
            
        lead_counter += 1

print(",\n".join(leads) + ";")
print("")

print("INSERT INTO bookings (booking_number, lead_id, customer_id, variant_id, color_id, sales_exec_id, ex_showroom, total_on_road, status) VALUES ")
print(",\n".join(bookings) + ";")
print("SET FOREIGN_KEY_CHECKS = 1;")
