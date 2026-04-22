# 💰 Module 4: Sales & Bookings Flow

This module is the transaction engine. It handles lead conversion, car allocation, and financial price calculations.

---

## 🏛️ Architecture Components
1. **BookingController**: `backend/src/main/java/com/dealerconnect/controller/BookingController.java`
2. **BookingService**: `backend/src/main/java/com/dealerconnect/service/impl/BookingService.java`
3. **BookingRepository**: `backend/src/main/java/com/dealerconnect/repository/BookingRepository.java`
4. **Entities**: `backend/src/main/java/com/dealerconnect/entity/Booking.java`, `Customer.java`, `Lead.java`

---

## 🌊 The Complete Flow

### 1. Lead Conversion
- When a customer is interested, a **Lead** is created. 
- When they decide to buy, the `BookingService` converts that interest into a **Booking**. 

### 2. The "Atomic" Handshake (Allocation)
- This is a critical business rule. When a `Booking` is created, it must pick a real car with a VIN.
- In the same database transaction, the code:
    1. Saves the `Booking` record.
    2. Updates the `Vehicle` status to **`ALLOCATED`**.
- This ensures that two salespersons cannot sell the same car at the exact same moment.

### 3. Financial Calculations (`BigDecimal`)
- All car prices (Showroom, Insurance, Registration, TCS) are calculated in the `BookingService`.
- We use **`BigDecimal`** to ensure 100% accuracy in decimals, as float/double can cause "rounding leaks" in currency.

### 4. Search & Filters
- The `BookingRepository` uses custom JPQL to allow managers to search by **Customer Name**, **Booking Number**, or **Sales Executive Name** across multiple tables simultaneously.

### 5. Sales Performance (Stored Procedures)
- How do we know the "Top Selling Model"?
- The repository calls `CALL GetTopSellingModels()`. This native SQL query performs high-speed grouping in the database to drive the dashboard charts.

---

## 💡 "Reviewer Ready" Point
"Our sales module ensures data integrity by performing atomic vehicle allocations. We utilize `BigDecimal` for all financial logic to prevent precision errors, making the system production-ready for highly regulated automotive accounting."
