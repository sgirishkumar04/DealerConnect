# 👥 Phase 1: User Management (Identity & Access)

This document explains how **DealerConnect** manages its most important asset: its people. We cover how employees are created, assigned to departments, and given specific roles that control their access to the system.

---

## 🏗️ 1. The Employee Lifecycle

User management in our system is built around the `Employee` entity. Unlike a standard "User" table, our system ties employees to specific physical dimensions of the dealership.

| Stage | Action | Technical Logic |
| :--- | :--- | :--- |
| **Creation** | New Hire | Employee is created with a unique `employeeCode` (e.g., `DLR01-SALES-005`). |
| **Association** | Org Setup | Every user **must** belong to a `Department` and have at least one `Role`. |
| **Isolation** | Data Safety | Users are tied to a `Dealer ID`. A staff member at Dealer A can never see Dealer B's employees. |
| **Deactivation**| Offboarding | We never "Delete" employees (for audit reasons). We set `isActive = false` to block future logins. |

---

## 👮 2. Security Enforcement (The "ADMIN" Rule)

Managing users is a high-stakes task. We use **Spring Security Pre-Authorization** to ensure only authorized personnel can touch the employee list.

**Key File**: [EmployeeController.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/controller/EmployeeController.java)

| Line | Annotation | Business Rule |
| :--- | :--- | :--- |
| **43** | `@PreAuthorize("hasRole('ADMIN')")` | **Creation**: Only a Dealer Admin or Super Admin can register a new staff member. |
| **49** | `@PreAuthorize("hasAnyRole('ADMIN', 'SALES_MANAGER')")` | **Modification**: Allows Sales Managers to update their team's details, but not create new accounts. |
| **55** | `@PreAuthorize("hasRole('ADMIN')")` | **Termination**: Only an Admin can deactivate an employee account. |

---

## 🛠️ 3. Special Technical Features

### 🍱 The "Who am I?" Endpoint
**Line 21 (`/me`)**:
The frontend often needs to know the details of the *currently logged-in* user to show their name or profile picture. Instead of sending an ID, the frontend calls `/employees/me`, and the backend gets the identity directly from the secure **JWT Security Context**.

### 🍱 Account Recovery (Unlock)
**Line 61 (`/unlock`)**:
If a user enters their password incorrectly too many times (Rate Limiting), their account is locked. This endpoint allows an Admin to reset the lock status instantly.

---

## 📍 4. Where is the Code?

| Category | Component | File Path |
| :--- | :--- | :--- |
| **Data Model** | Employee Fields | `entity/Employee.java` |
| **API Logic** | User CRUD | `controller/EmployeeController.java` |
| **Business Rules**| Deactivate/Unlock | `service/impl/EmployeeService.java` |
| **UI List** | Team Directory | `features/admin/employee-list/` |
| **UI Forms** | Staff Onboarding | `features/admin/employee-form/` |

---

### 💡 Phase 1 User Management Summary
By centralizing user management:
1.  **Accountability**: Every action (Lead created, Car sold) is linked back to a specific `Employee ID`.
2.  **Granular Control**: Shift-based access can be implemented by simply toggling the `isActive` flag.
3.  **Audit Ready**: Because we use soft-deletes (deactivation), the history of who worked at the dealership is preserved for years.
