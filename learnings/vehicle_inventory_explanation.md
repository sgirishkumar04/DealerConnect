# 🚗 Hyundai DMS Vehicle Inventory Explained

The Vehicle Inventory module is the heart of the dealership's operations. When explaining this to a technical team or stakeholder, you should focus on three main technical pillars: **Client-Side Filtering**, **Dynamic Aging Calculation**, and **Role-Based Access Control (RBAC)**.

Here is a layer-by-layer breakdown of how the module works.

---

## 1. The Frontend Layer (The Smart Table)
*Where it lives: `frontend/src/app/features/inventory/vehicle-list/vehicle-list.component.ts`*

The frontend uses Angular Material's **`MatTableDataSource`** to render the highly responsive grid of vehicles. Instead of constantly pinging the backend every time the user types a search query, the table does "Smart Client-Side Filtering".

### Key Technical Tour:
1. **Fetching the Stock**: 
   When the component initializes (`ngOnInit`), it makes a single API call to `GET /vehicles?page=0&size=200`. The backend returns a massive JSON array of all vehicles.
   
2. **The "God" Filter (`filterPredicate`)**:
   Instead of just searching by pure text, we wrote a custom filtering algorithm in Angular. When a user selects a dropdown (like "Color", "Status", or types a "Max Price"), Angular runs the `filterPredicate` function on *every single row*.
   *   It checks exact matches for Dropdowns (e.g. `row.status === filter.status`).
   *   It checks greater/less than conditions for Prices (e.g. `price <= filter.maxPrice`).
   *   It performs a universal text search across VINs, Model names, and Variants.
   *   Because this happens in the browser's memory, the UI filters hundreds of cars **instantly** without lagging the server.

3. **Dynamic Inventory Aging**:
   Cars sitting in the lot lose value. The UI calculates "Days in Stock" dynamically precisely in the user's browser:
   ```typescript
   calculateAging(mfgDate: string) {
       // Math: Current Date minus Manufacturing Date divided by 24 hours
       // Returns exact integer days.
   }
   ```
   *   **0–30 Days**: Normal (`badge-green`)
   *   **31–60 Days**: Warning (`badge-orange`)
   *   **60+ Days**: Critical Stock (`badge-red`)

4. **Role-Based Access Control (RBAC)**:
   Notice the action buttons (Edit/Delete/Add). They are wrapped in Angular `*ngIf` structural directives.
   ```html
   <button *ngIf="canDelete" (click)="confirmDelete(v)">
   ```
   If the logged-in user is just a Sales Representative without `INVENTORY_DELETE` permission, that button is physically stripped from the DOM. They can look at the cars, but they cannot accidentally delete them.

---

## 2. The Backend Layer (Structured API)
*Where it lives: `VehicleController.java` and `VehicleService.java`*

The Spring Boot backend is straightforward but highly structured to ensure data integrity.

### Key Technical Tour:
1. **Pagination & Validation (`@Valid`)**:
   When a user adds a new vehicle (`POST /vehicles`), the Controller intercepts the JSON payload. Before touching the database, it runs through standard Jakarta `@Valid` checks (ensuring the VIN is correct, prices are positive, etc.).

2. **The Details DTO (`VehicleDetailsDTO`)**:
   When a user clicks on a row in the frontend table, a popup dialog opens. To make this fast, the frontend calls `GET /vehicles/{id}/details`. 
   Instead of sending back a raw database entity, the backend uses a **DTO (Data Transfer Object)**. This allows us to bundle not just the vehicle data, but also relational data (like *Who booked this car?*, *What accessories are attached?*) seamlessly into one secure JSON package without exposing raw database passwords or user hashes.

3. **Status Enums**:
   The backend enforces strict `VehicleStatus` ENUMs (`IN_STOCK`, `ALLOCATED`, `SOLD`, `DEMO`, `IN_TRANSIT`). This ensures that a bug in the frontend can never accidentally save a vehicle with a typo'd status like `"S0LD"`.

---

## 3. The Database Layer (The Source of Truth)
*Where it lives: `VehicleRepository.java`*

The database stores all relationship keys. A single `Vehicle` row actually links to several other tables to maintain a normalized, healthy schema.

### Key Technical Tour:
1. **Foreign Key Relations (`@ManyToOne`)**:
   The `vehicles` table doesn't store the literal text "Creta Phantom Black". Instead, it stores `variant_id` and `color_id`.
   *   This ensures that if Hyundai renames exactly how "Phantom Black" is spelled, the database only needs to update *one* row in the `colors` table, and immediately all 50 black cars in the inventory will display the updated name.
   
2. **Preventing Duplicates (`existsByVin`)**:
   Every car has a unique 17-character VIN. The `VehicleRepository` utilizes an ultra-fast `existsByVin(String vin)` method. Before doing an `INSERT`, the database confirms the VIN is truly unique across the whole system, guaranteeing zero duplicate inventory collisions.

### Summary to tell your reviewers:
> *"The Vehicle Inventory module demonstrates how we manage complex user interfaces intelligently. By pushing heavy searching and complex aging math to the Angular Client (using smart table predicates), our Spring Boot backend stays completely unburdened and simply acts as a secure, normalized data streaming pipeline. Best of all, strict RBAC guarantees absolute security over our multi-million rupee dealership assets."*
