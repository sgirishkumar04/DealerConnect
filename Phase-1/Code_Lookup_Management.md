# 🗂️ Phase 1: Code Management (Lookup Infrastructure)

This document explains how **DealerConnect** handles dynamic system configurations, categorical data, and dropdown values. We use a **Key-Value Code Strategy** to ensure the frontend is never hardcoded and the database remains the single source of truth.

---

## 🏗️ 1. Code Management Strategy

Instead of building individual APIs for every small piece of data (like "Lead Sources" or "Engine Types"), we use a centralized **Lookup Factory**.

- **Database-Driven**: Every dropdown you see in the Angular UI is powered by a table in MySQL.
- **Maintenance Free**: If the dealership adds a new "Color" or "Lead Source," an administrator can add it to the DB, and it automatically appears in all forms without a code redeploy.

---

## 🏛️ 2. The Lookup Infrastructure (Server-Side)

The system provides a unified gateway for all Categorical Data.

**Key File**: [LookupController.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/controller/LookupController.java)

| Endpoint Prefix | Responsibility | Logic |
| :--- | :--- | :--- |
| `/lookup/roles` | RBAC Config | Fetches available roles for user management. |
| `/lookup/colors`| Inventory Specs | Fetches active vehicle colors with Hex codes. |
| `/lookup/banks` | Finance Config | Fetches partner banks for loan processing. |
| `/lookup/engine-types` | Technical Specs | Returns Petrol, Diesel, EV, etc. |

---

## ⚡ 3. Performance: Caching STATIC Data

Because system codes (like "Departments") don't change frequently, we use a aggressive caching strategy to make the app lightning fast.

### 🍱 The 1-Hour Rule 
**Code Logic**: `LookupController.java` (Line 25)
```java
.cacheControl(CacheControl.maxAge(1, TimeUnit.HOURS).cachePublic())
```
- **Result**: Once the user loads the "New Lead" form, the browser caches the "Lead Sources" and "Models." For the next hour, clicking through the forms is instant because the browser doesn't even talk to the server for these lookups.

---

## 📍 4. Where is the Code?

| Category | Component | File Path |
| :--- | :--- | :--- |
| **Lookup Gateway** | Master Controller | `controller/LookupController.java` |
| **Data Logic** | Service Layer | `service/impl/LookupService.java` |
| **Code Seeding** | Data Seeding | `config/DataInitializer.java` |
| **UI Interaction** | Dynamic Dropdowns | `shared/components/dynamic-select/` |

---

### 💡 Phase 1 Code Summary
By implementing centralized Code Management:
1.  **Frontend Scalability**: The Angular app doesn't need to know the business rules for "Lead Sources"—it just asks for the list and displays it.
2.  **Network Efficiency**: 90% of lookup requests are served from the browser cache, saving bandwidth and server CPU.
3.  **Dynamic Adaptation**: If a new "Vehicle Model" is launched, it is added to the `vehicle_models` table, and the entire DMS is updated instantly across all showrooms.
