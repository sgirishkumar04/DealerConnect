# 🧭 Phase 1: Menu Management & Role-Based Authorization

This document explains how **DealerConnect** dynamically adapts its user interface based on who is logged in. We use a **Permission-First** strategy to ensure that users only see the features they are authorized to use.

---

## 🏗️ 1. Dynamic Sidebar Logic (Frontend)

Instead of a hardcoded sidebar, our application uses a **Virtual Menu** that is filtered in real-time.

### 🍱 The Filtering Engine
**Key File**: [sidebar.component.ts](file:///Users/sgirishkumar/Documents/DealerConnect/frontend/src/app/shared/components/sidebar/sidebar.component.ts)

The `visibleNavItems()` method (Line 95) acts as the gatekeeper. For every possible menu link, it checks:
1.  **Granular Permission**: Does the user have `INVENTORY_VIEW`? (Line 105)
2.  **High-Level Role**: Is the user an `ADMIN` or `SALES_MANAGER`? (Line 106)
3.  **Special Access**: Is this a `SUPER_ADMIN` looking at cross-dealer reports? (Line 101)

### 🍱 The Menu Definition
Menu items are defined as a configuration array (Line 69).
```typescript
{ 
  label: 'Vehicle Inventory', 
  icon: 'directions_car', 
  route: '/inventory', 
  roles: ['ADMIN','SALES_MANAGER','INVENTORY_MANAGER'], 
  permission: 'INVENTORY_VIEW' 
}
```
*If a user lacks BOTH the role and the specific permission, the link is completely removed from the DOM.*

---

## 🏛️ 2. Layers of Authorization

Security in DealerConnect is implemented in a "Defense in Depth" strategy across three layers.

### Layer 1: The UI Layer (Visual)
- **Mechanism**: `*ngIf` and `visibleNavItems()`.
- **Goal**: Clean UX. Avoid showing users buttons they can't click (e.g., hiding "Delete" buttons for Sales Executives).

### Layer 2: The Routing Layer (Navigation)
- **Mechanism**: `AuthGuard` in Angular.
- **Goal**: Prevent users from manually typing a URL (e.g., `/admin/employees`) into the browser address bar if they aren't an Admin.

### Layer 3: The API Layer (Final Gatekeeper) 🛡️
- **Mechanism**: Spring Security `@PreAuthorize` on the Java server.
- **Goal**: Critical Security. Ensures that even if someone manages to bypass the UI, the server will block any unauthorized request with a **403 Forbidden** error.

---

## 📍 3. Where is the Code?

| Category | Component / Logic | File Path |
| :--- | :--- | :--- |
| **Menu Config** | Navigation Array | `shared/components/sidebar/sidebar.component.ts` |
| **Permission Check** | `hasPermission()` Logic | `core/services/auth.service.ts` |
| **Page Access** | Angular Route Guards | `core/guards/auth.guard.ts` |
| **Server Security** | URL & Method Security | `config/SecurityConfig.java` |

---

### 💡 Phase 1 Menu Summary
By using this dynamic approach:
1.  **Zero Guesswork**: Users never have to ask "Why is this button disabled?"—if they don't have permission, they simply don't see it.
2.  **Single Point of Control**: To add a new permission to a module, you only need to update the `navItems` array in one file.
3.  **Multi-Persona Support**: The app completely transforms between a "Sales View" for executives and a "Platform View" for Super Admins.
