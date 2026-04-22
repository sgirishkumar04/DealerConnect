# 📊 Module 5: Analytics & Dashboard Flow

This module is the "Business Intelligence" layer. It aggregates data from every other module to provide high-level insights for management.

---

## 🏛️ Architecture Components
1. **ReportController**: `backend/src/main/java/com/dealerconnect/controller/ReportController.java`
2. **Repositories**: (Uses `BookingRepository`, `VehicleRepository`, `LeadRepository`, `ServiceAppointmentRepository`)
3. **DealerContext**: `backend/src/main/java/com/dealerconnect/security/DealerContext.java`

---

## 🌊 The Complete Flow

### 1. Data Aggregation
- Unlike a standard CRUD page, the Dashboard page makes **5 to 10 small API calls** simultaneously.
- Every call flows into the `ReportController`. 

### 2. The Performance Choice (Native SQL)
- Calculating "Monthly Revenue" or "Service Workload" across thousands of records is slow in Java.
- **The Flow**: 
    1. Java sends a `CALL` command to MySQL.
    2. The MySQL **Stored Procedure** runs at the core of the database.
    3. It returns a tiny "Summary Row" (e.g., month, total_count).
- This ensures the UI remains snappy even as the database grows to millions of rows.

### 3. Permission Filtering
- The `ReportController` checks: *"Is this a Super Admin or a Dealer Admin?"*
- **If Dealer Admin**: The code automatically injects the logged-in user's `dealerId` into every reporting call.
- **Security Check**: This prevents a competitor from seeing another dealership's sales graphs.

### 4. Cross-Module Reporting
- The dashboard "Connects the Dots":
    - It pulls **Sales** data for the Revenue chart.
    - It pulls **Inventory** data for the Stock pie chart.
    - It pulls **Service** data for the Workload graph.

---

## 💡 "Reviewer Ready" Point
"The dashboard utilizes a **Database-First** reporting strategy. By offloading complex aggregations to native stored procedures, we reduce network latency and CPU load on the application server, allowing for a highly scalable analytics engine."
