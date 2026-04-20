# 🔍 Phase 1: Spring Service & QueryDSL (Type-Safe Search)

This document explains how **DealerConnect** handles complex database searches. Instead of writing messy SQL strings, we use **QueryDSL** to build dynamic, type-safe queries that change based on what the user is searching for.

---

## 🏗️ 1. Why QueryDSL? (Type-Safe Filtering)

In a professional dealership app, users need to filter data by 10+ different fields (e.g., Stock Status, Model, Price, Arrival Date). 

- **The Problem**: Writing manual SQL for every combination of these filters is impossible and prone to errors.
- **The Solution (QueryDSL)**: It allows us to build queries using Java objects. If you change a column name in the database, the Java code will catch the error at compile-time, not when the user tries to search.

---

## 🏛️ 2. Type-Safe "Q-Classes"

QueryDSL generates special classes (prefixed with "Q") based on our entities.

**Key File**: [VehicleService.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/service/impl/VehicleService.java)
- **Line 35**: `QVehicle v = QVehicle.vehicle;`
- This object `v` represents the "Vehicles" table in a fully type-safe way. You can access fields using `v.status`, `v.dealer.id`, etc.

---

## 🔒 3. The Dynamic Engine (BooleanBuilder)

We use a **BooleanBuilder** to "collect" filters. If a filter is empty (e.g., the user didn't search for a Model), we simply don't add it to the query.

### 🍱 The Service Logic (VehicleService Line 34)
```java
BooleanBuilder builder = new BooleanBuilder();

// 1. Mandatory Filter: Security (Always show only THIS dealer's cars)
builder.and(v.dealer.id.eq(dealerId));

// 2. Optional Filter: Status
if (status != null) {
    builder.and(v.status.eq(Vehicle.VehicleStatus.valueOf(status)));
}

// 3. Optional Filter: Model
if (modelId != null) {
    builder.and(v.variant.model.id.eq(modelId));
}

return vehicleRepo.findAll(builder, pageable);
```

---

## 📍 4. Where is the Code?

| Category | Component | File Path |
| :--- | :--- | :--- |
| **Repository Enabler**| `QuerydslPredicateExecutor` | `repository/VehicleRepository.java` (Line 13) |
| **Dynamic Logic** | `BooleanBuilder` Usage | `service/impl/VehicleService.java` (Line 34) |
| **Security Injector** | `DealerContext` Integration| `service/impl/VehicleService.java` (Line 38) |
| **Generated Code** | Q-Classes (Build Artifact) | `target/generated-sources/` |

---

### 💡 Phase 1 QueryDSL Summary
By using QueryDSL in our services:
1.  **Refactor-Proof**: You can rename `status` to `vehicleStatus` across the entire project, and the compiler will tell you every search query that needs fixing.
2.  **Clean Code**: No more long `if-else` blocks concatenating SQL strings.
3.  **Security by Default**: The Dealer ID filter is automatically "stitched" into every search query, ensuring no horizontal data leakage.
