# 🚗 Module 3: Vehicle & Inventory Flow

This module manages the dealership's physical assets (cars) and their lifecycle from arrival to allocation.

---

## 🏛️ Architecture Components
1. **VehicleController**: `backend/src/main/java/com/dealerconnect/controller/VehicleController.java`
2. **VehicleService**: `backend/src/main/java/com/dealerconnect/service/impl/VehicleService.java`
3. **VehicleRepository**: `backend/src/main/java/com/dealerconnect/repository/VehicleRepository.java`
4. **Entities**: `backend/src/main/java/com/dealerconnect/entity/Vehicle.java`, `VehicleModel.java`, `VehicleVariant.java`

---

## 🌊 The Complete Flow

### 1. The Dynamic Search (QueryDSL)
- Unlike basic lists, the `VehicleService` uses a **`BooleanBuilder`**.
- As the user types in the Angular UI (Model, Price Range, Status), the service dynamically adds "AND" conditions to the SQL.
- **The Guard**: It always appends `WHERE dealer_id = X` to keep data isolated.

### 2. Vehicle Registration (The VIN)
- Every vehicle is identified by its **VIN** (Vehicle Identification Number).
- The `VehicleRepository` uses `existsByVin()` to ensure no duplicate car is entered into the system.

### 3. Lifecycle Status (The Enum)
- A car moves through states: `IN_STOCK` → `ALLOCATED` → `SOLD`.
- The code ensures a car in `ALLOCATED` state cannot be allocated to another customer.

### 4. Fetch Optimization (`@EntityGraph`)
- **Problem**: A car has a Variant, which has a Model. This can cause the "N+1 Problem" (too many database trips).
- **Solution**: We use an `@EntityGraph` in the repository to fetch the car, its variant, and its model in **exactly one** SQL query. This makes the inventory page extremely fast.

### 5. Management Reporting
- The repository calls **Stored Procedures** (`GetInventoryStatusSummary`) to calculate totals for the dashboard pie charts.

---

## 💡 "Reviewer Ready" Point
"Our inventory system uses **QueryDSL Predicates** for type-safe, dynamic searching. This allows us to handle complex user filters without writing messy, error-prone SQL strings in our Java code."
