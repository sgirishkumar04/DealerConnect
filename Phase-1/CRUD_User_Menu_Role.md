# 👥 Phase 1: CRUD - User, Role & Menu Management

This document explains the architecture and implementation of Identity and Access Management (IAM) in **DealerConnect**.

---

## 👤 1. User Management (Employee CRUD)

In DealerConnect, "Users" are modeled as **Employees**. Every employee is linked to a specific Dealer.

### 🍱 The CRUD Logic
**Backend Controller**: [EmployeeController.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/controller/EmployeeController.java)

| Line | Feature | Technical Implementation |
| :--- | :--- | :--- |
| 54 | `getMe()` | A special GET endpoint that returns the current logged-in user's profile and permissions. |
| 76 | `unlockEmployee()` | Provides a way for admins to unlock an account if a user hits the 5-failure limit. |
| - | **Multi-Tenancy** | All `save()` and `find()` operations automatically filter by the `DealerId` stored in the `DealerContext`. |

---

## 🎭 2. Role & Permission Management

Roles are the high-level grouping of what a user can do (e.g., "Sales Manager"). Permissions are the granular actions (e.g., "INVENTORY_VIEW").

### 🏗️ Mapping Logic
**Backend Controller**: [RoleController.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/controller/RoleController.java)

- **Roles & Permissions**: Roles have a **Many-to-Many** relationship with Permissions.
- **Admin Control**: The Super Admin can create new roles and assign specific permission checkboxes to them.
- **Verification**: When a user logs in, the `UserDetailsServiceImpl` gathers all their roles and permissions into the JWT token.

---

## 🧭 3. The Dynamic Menu (The Clever Logic)

**IMPORTANT: There is no "Menu" table in the database.**

Instead of storing menu items in a table (which is slow and hard to maintain), the application uses **Dynamic Permission Checks**.

### 💻 How the Sidebar works
**Frontend Logic**: The Sidebar component iterates through the available menu items and checks them against the user's permissions:

```typescript
// Conceptual logic in the Frontend Sidebar
const menuItems = [
  { label: 'Inventory', route: '/inventory', permission: 'INVENTORY_VIEW' },
  { label: 'Sales', route: '/sales', permission: 'SALES_VIEW' },
  { label: 'Employees', route: '/employees', permission: 'EMPLOYEES_VIEW' }
];

// Inside the Sidebar template
<mat-list-item *ngIf="authService.hasPermission(item.permission)">
  {{ item.label }}
</mat-list-item>
```

**Benefit**: If an employee's role is updated to remove "SALES_VIEW", the "Sales" menu item **automatically disappears** from their screen on the next refresh, even if they try to bookmark the URL.

---

## 📍 4. Where is the Code? (Location Map)

| Category | UI / Frontend Location | Logic / Backend Location |
| :--- | :--- | :--- |
| **Employee CRUD** | `app/features/employees/` | `service/impl/EmployeeService.java` |
| **Role CRUD** | `app/features/super-admin/role-mgmt/` | `repository/RoleRepository.java` |
| **Identity Service** | `app/core/services/auth.service.ts` | `security/UserDetailsServiceImpl.java` |
| **Auto-Increment IDs** | — | `config/DataInitializer.java` (Seeds initial roles) |

---

### 💡 Phase 1 Security Summary
By using this **Role-Permissions-Dynamic Menu** architecture:
1.  **Security**: Access is enforced at both the UI level (menu hidden) and API level (403 Forbidden).
2.  **Clean Code**: You don't need a separate "Menu Management" module because your Role management handles it automatically.
3.  **Traceability**: Every creation and update of a User or Role is captured by our **Auditing Engine**.
