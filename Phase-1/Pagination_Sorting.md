# 📄 Phase 1: Pagination & Sorting

This document explains how **DealerConnect** handles large datasets. We use **Pagination** to slice data into small pages and **Sorting** to allow users to organize information by price, date, or status.

---

## 🚀 1. Performance Architecture

Loading 10,000 vehicles at once would crash the browser. Our architecture ensures that only what is needed is processed at one time.

| Feature | Technical Implementation | Purpose |
| :--- | :--- | :--- |
| **Pagination** | `Spring Data Pageable` | Fetches a specific "slice" (e.g., records 11-20). |
| **Sorting** | `JPA Sort` | Injects `ORDER BY` into the SQL query dynamically. |
| **Client Control** | `MatPaginator` | Allows the user to select page size (10, 25, 50). |

---

## ⚙️ 2. Server-Side Strategy (Spring Boot)

The backend handles the calculation of "Offsets" and "Limits."

**Key File**: [VehicleController.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/controller/VehicleController.java)

| Line | Code Logic | Explanation |
| :--- | :--- | :--- |
| 26-27 | `@RequestParam` | The API accepts `page` (starting at 0) and `size`. |
| 29 | `PageRequest.of(page, size)` | Converts the raw numbers into a Spring **Pageable** object. |
| **Repository** | `JpaRepository<T, ID>` | **Automatic SQL**: Spring sees the `Pageable` object and automatically adds `LIMIT ? OFFSET ?` to the query. |

---

## 🎨 3. Client-Side Strategy (Angular)

We use **Angular Material** to provide a premium, smooth experience for organizing lists.

**Key File**: [vehicle-list.component.ts](file:///Users/sgirishkumar/Documents/DealerConnect/frontend/src/app/features/inventory/vehicle-list/vehicle-list.component.ts)

### 🍱 Components & Directives
- **`MatPaginator` (Line 213)**: Renders the page controls at the bottom of the table.
- **`MatSort` (Line 108)**: Enables clicking on headers like "Price" or "Model" to sort the data.
- **`load()` (Line 324)**: This method calls the API with the desired page size and attaches the paginator to the data source.

### 🍱 The "Live Search" Integration
**Line 280 (filterPredicate)**:
While the server handles the "Slice," the frontend handles the **Complex Filtering**. By combining pagination with a local `filterPredicate`, users can search through hundreds of records instantly without waiting for a server request for every keystroke.

---

## 📍 4. Where is the Code?

| Category | UI / Frontend Location | Logic / Backend Location |
| :--- | :--- | :--- |
| **Pagination UI** | `shared/components/` | `org.springframework.data.domain.Page` |
| **Inventory List** | `features/inventory/vehicle-list.ts` | `controller/VehicleController.java` |
| **Audit Log List** | `features/admin/audit-log.ts` | `controller/AuditLogController.java` |
| **Sorting logic** | `mat-sort` (in HTML) | `service/impl/VehicleService.java` |

---

### 💡 Phase 1 Scalability Summary
By implementing pagination early:
1.  **Speed**: The dashboard loads instantly because only the first 10-25 records are fetched initially.
2.  **Memory Efficiency**: The server uses very little RAM because it never loads the entire database into memory.
3.  **Better UX**: Users can find specific items faster by sorting high-to-low on price or date.
