# 🔐 DealerConnect Login & Role Permissions Explained (RBAC)

When you log into different accounts (like `Admin` vs. `Sales Manager`), the entire software physically reconstructs itself. Buttons disappear, pages get blocked, and the starting homepage changes entirely.

This is known as **Role-Based Access Control (RBAC)**. Here is the step-by-step breakdown of exactly how it happens.

---

## 1. The Moment of Login (The JWT Vault)
*Where it lives: `frontend/src/app/core/services/auth.service.ts`*

When you click "Login", the Spring Boot backend replies with a securely encrypted JSON Web Token (JWT). The frontend stores this token and unpacks the user profile information from it:
1.  **The User's Base Role** (e.g., `ROLE_SALES_MANAGER`)
2.  **The User's Dynamic Permissions Array** (e.g., `['SALES_VIEW', 'REPORTS_VIEW', 'EMPLOYEES_EDIT']`).

These two pieces of data dictate precisely what the user can see and do for the rest of their session.

---

## 2. Redirection: Why a Specific Page Opens First
*Where it lives: `frontend/src/app/core/guards/auth.guard.ts`*

The moment your login finishes, Angular's `LoginGuard` takes over. The guard asks: *"Where should this specific type of user start?"* 

It triggers the `roleHome(role)` function. It does not send everyone to the Dashboard:

| User Role | Initial Homepage Route (`roleHome()`) | Logic |
| :--- | :--- | :--- |
| **SUPER_ADMIN** | `/super-admin` | Directs the owner to the Network Dealership analytics. |
| **SALES_MANAGER** / **ADMIN** | `/dashboard` | Standard operational KPIs. |
| **SERVICE_ADVISOR** / **MECHANIC** | `/service` | Skips irrelevant sales data; goes straight to active Job Cards. |
| **INVENTORY_MANAGER** | `/inventory` | Skips sales metrics; forces them to the vehicle stock list. |

This provides a bespoke user experience instantly upon logging in.

---

## 3. How the UI Changes (The Dynamic Sidebar)
*Where it lives: `frontend/src/app/shared/components/sidebar/sidebar.component.ts`*

The sidebar on the left does not use static HTML. Instead, it holds a master array of all possible `NavItems` in the system, and each item has strict security rules attached.

```typescript
// Example from the NavItems array:
{ label: 'Employees', route: '/employees', permission: 'EMPLOYEES_VIEW' }
```

Before the Sidebar draws itself on your screen, it runs a `.filter()` function across the entire array. 
*   It asks the `AuthService`: *"Does this user's JWT contain the `EMPLOYEES_VIEW` permission?"* 
*   If **No**: It silently deletes the 'Employees' button from the DOM. The user doesn't even know the page exists.
*   If **Yes**: The button renders normally.

This is why logging in as a Sales Manager shows the *Employees* menu, but logging in as a Mechanic strips away almost all buttons except *Service Center* and *Spare Parts*.

---

## 4. How the URLs are Protected (The Role Guard)
*Where it lives: `frontend/src/app/app-routing.module.ts`*

What if a smart user realizes the "Employees" menu button is hidden, but decides to manually type `http://localhost:4200/employees` into their browser URL bar anyway?

They still wouldn't get in. We use the **Angular `RoleGuard`**.

**How the App Routing Module shields URLs:**
```typescript
{ path: 'employees', component: EmployeesComponent, canActivate: [RoleGuard], data: { permission: 'EMPLOYEES_VIEW' } }
```

When they hit `ENTER` on the URL bar, the `RoleGuard` intercepts the routing event mid-flight. 
1. The Guard extracts `{ permission: 'EMPLOYEES_VIEW' }` from the route data.
2. It cross-checks the user's JWT Permissions Array one last time.
3. If the user lacks the permission, the `RoleGuard` aborts the navigation entirely, violently yanking them safely back to their designated homepage via `this.router.navigate([roleHome(role)])`!

### Summary to tell your reviewers:
> *"Our software implements Enterprise RBAC simultaneously on three distinct layers. First, upon login, the **LoginGuard** calculates the mathematically ideal homepage for that specific worker (e.g. routing Mechanics straight to Service workflow). Second, the **Dynamic Sidebar Component** reads their JWT permissions token and literally erases restricted menu buttons out of existence. Finally, the **Angular Route Guard** provides a hard lock on the URL bar, physically preventing unauthorized users from accessing restricted web pages even if they have the direct link saved as a bookmark."*
