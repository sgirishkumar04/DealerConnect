# 👥 Phase 1: Multiple Roles per User

This document explains why and how **DealerConnect** supports assigning multiple roles to a single employee. This flexibility ensures that the system can adapt to different dealership sizes, where one staff member might handle multiple responsibilities.

---

## 🏗️ 1. Flexible Authority Model

In a small dealership, a **Sales Manager** might also handle **Inventory** tasks. Instead of creating a new "Hybrid" role, our system allows you to simply assign both roles to the user.

### 🍱 The Multi-Role Equation
- **User Permission Set** = Permissions from (Role A) + Permissions from (Role B) + Permissions from (Role C)
- This "Union" of permissions ensures the user has access to everything they need across different modules.

---

## 🛠️ 2. Data Persistence (Many-to-Many)

We use a **Many-to-Many** relationship in the database. This allows one employee to have multiple roles, and one role to belong to many employees.

**Key File**: [Employee.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/entity/Employee.java)

| Line | Code Logic | Explanation |
| :--- | :--- | :--- |
| **48** | `@ManyToMany(fetch = FetchType.EAGER)` | Tells Hibernate to fetch all roles immediately when a user logs in. |
| **49-54** | `@JoinTable(name = "employee_roles")` | Specifies the hidden join table that links `employee_id` to `role_id`. |

---

## 👮 3. Security Aggregation (The Bouncer)

When a user logs in, the **Security Layer** gathers all roles and all their associated permissions into a single, unified list of "Authorities."

**Key Logic**: [UserDetailsServiceImpl.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/security/UserDetailsServiceImpl.java)

- The backend takes a user's role set (e.g., `ADMIN`, `SALES`) and extracts every individual permission (e.g., `INVENTORY_VIEW`, `SALES_CREATE`).
- This makes `@PreAuthorize` extremely powerful: if *any* of the user's roles has the required permission, the action is allowed.

---

## 📍 4. Where is the Code?

| Category | Component | File Path |
| :--- | :--- | :--- |
| **Relationship** | Many-to-Many Mapping | `entity/Employee.java` |
| **Logic Layer** | Authority Aggregation | `security/UserDetailsServiceImpl.java` |
| **Join Table** | SQL Relationship | Database Table: `employee_roles` |
| **UI Selection** | Multi-Select Dropdown | `features/admin/employee-form/` |

---

### 💡 Phase 1 Multi-Role Summary
By supporting multiple roles:
1.  **Showroom Flexibility**: Large dealerships can keep roles "Thin" (one job per person), while small ones can keep roles "Thick" (many jobs per person).
2.  **No Code Duplication**: We don't need to create specialized "Sales-And-Inventory-Manager" roles; we just combine existing ones.
3.  **Atomic Permissions**: Security remains granular because it checks the specific permission string, regardless of which role it came from.
