# 👥 Hyundai DMS Employee Management Explained

When explaining the Employee module, the focus shifts entirely from data processing (like the Dashboard) to **Data Security, Role-Based Access Control (RBAC), and Human Resources Policy Enforcement**. 

Here is exactly how you can break down the Employee Management workflow to an audience.

---

## 1. The Frontend Layer (The HR Dashboard)
*Where it lives: `frontend/src/app/features/employees/employee-list/employee-list.component.ts`*

The Angular frontend acts as the beautiful, smart interface for Branch Managers and Admins to manage their staff.

### Key Technical Operations:
1. **UX Polish (Dynamic Avatars & Badges)**:
   Instead of uploading physical profile pictures, the UI auto-generates a colored circle based on the employee's initials.
   ```typescript
   avatarColor(name) { return palette[(name.charCodeAt(0)) % palette.length]; }
   ```
   Furthermore, raw database roles like `ROLE_SALES_MANAGER` are intercepted and formatted on-the-fly (`formatRole()`) into clean text with color-coded `roleClass` badges (e.g., Red for Admin, Blue for Sales Manager).

2. **Client-Side Smart Search**:
   Similar to the Inventory module, typing into the search bar does not repeatedly ping the database. The `filterPredicate` runs locally, instantly indexing the employee's Name, Email, Phone, and Code simultaneously.

3. **Status Toggles & Account Locks**:
   The table visually highlights locked accounts. If an employee enters their password wrong 5 times, Spring Security locks them out. The frontend detects `e.isLocked` and paints an orange icon. An Admin can simply click the **Unlock Account** button without needing to mess with the database directly.

---

## 2. The Backend Controller (The Security Vault)
*Where it lives: `EmployeeController.java`*

The backend controller doesn't just pass data; it acts as a heavily-armed security checkpoint using Spring Security's `@PreAuthorize` protocol.

### Key Technical Operations:
1. **Endpoint Shielding**:
   You literally cannot touch the employee table without the mathematically correct JWT claims.
   *   `@PreAuthorize("hasRole('ADMIN')")` protects `POST /employees` and `DELETE /employees`.
   *   `@PreAuthorize("hasAnyRole('ADMIN', 'SALES_MANAGER')")` allows a Sales Manager to simply update phone numbers (`PUT /employees/{id}`) but mathematically blocks them from creating or deleting users.
   If a hacker intercepts the UI and tries to hit the API, Spring intercepts the request and throws an immediate `403 Forbidden` Exception.

---

## 3. The Backend Service & Database (Policy Engine & Soft Deletes)
*Where it lives: `EmployeeService.java`*

The service layer enforces strict, real-world Human Resources logic and prevents destructive database operations.

### Key Technical Operations:
1. **Cryptographic Password Hashing**:
   When an Admin creates an employee, the raw password like `"Password@123"` is immediately funneled through the `PasswordValidator` rule-engine (checking for symbols, numbers, and uppercase). If it passes, it is cryptographically scrambled using `BCrypt`:
   ```java
   passwordEncoder.encode(req.getPassword())
   ```
   The database never stores human-readable passwords, ensuring compliance with global security standards.

2. **Advanced Soft Deletions (Deactivate Protocol)**:
   When an employee quits, the dealership **cannot** run an SQL `DELETE` command. If they were deleted, it would break 5,000 historic invoices and job cards attached to their name via Foreign Keys!
   Instead, hitting the "Delete" button calls the `deactivate(Long id)` method. The system:
   *   Flips `isActive` to `false`.
   *   Injects the name of the Admin who performed the firing (`target.setDeactivatedByName`).
   *   Timestamps the exact second it happened (`setDeactivatedAt`).

3. **Hierarchical Business Rules**:
   Inside the `deactivate` method, we have coded strict, un-hackable policies:
   *   `Cannot deactivate a Super Admin. (Global Rule)`
   *   `Only a Super Admin can deactivate an Admin account.`
   These Java `if-blocks` guarantee that a rogue Branch Admin cannot maliciously deactivate their own boss or lock the software owner out of the system.

### Summary to tell your reviewers:
> *"Our Employee Management module is an implementation of Enterprise-Grade Security. The Angular frontend provides a polished, frictionless UI that auto-formats data and handles real-time searching. However, the true engineering feat is the Spring Boot backend. It utilizes strict endpoint `@PreAuthorize` shielding, forces cryptographic BCrypt password hashing, and executes Hierarchical Soft-Deletions—ensuring that historic dealership data is never corrupted by an employee firing, whilst guaranteeing that downstream Admins can never override or delete Super Admin architecture."*
