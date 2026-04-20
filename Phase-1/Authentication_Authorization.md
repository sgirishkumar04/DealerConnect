# 🛡️ Phase 1: Authentication & Authorization

This document breaks down the two distinct pillars of our security architecture: **Authentication (Who are you?)** and **Authorization (What are you allowed to do?)**.

---

## 🏗️ 1. Authentication (AuthN) - Establishing Identity

Authentication is the process of verifying a user's credentials. In **DealerConnect**, we use a custom-built stateless JWT system.

### 🍱 The Verification Flow
1.  **Credential Check**: The user sends a username and password.
2.  **Bcrypt Verification**: We never store plain text. The provided password is hashed and compared against the stored hash in the database.
3.  **Token Issuance**: Once verified, a **Secret-Signed JWT** is generated and sent to the browser.

**Key File (Backend)**: [AuthController.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/controller/AuthController.java)
- **Line 26**: `authenticateUser` handles the core login logic.

**Key File (Frontend)**: [auth.service.ts](file:///Users/sgirishkumar/Documents/DealerConnect/frontend/src/app/core/services/api.service.ts)
- Manages the storage and retrieval of the JWT token from `localStorage`.

---

## 👮 2. Authorization (AuthO) - Enforcing Permissions

Authorization happens *after* the user is verified. It determines which buttons they can click and which APIs they can call.

### 🍱 Role-Based Access Control (RBAC)
We use a granular role system (SUPER_ADMIN, ADMIN, SALES_EXECUTIVE, etc.).

**Backend Enforcement**:
We use Spring Security's `@PreAuthorize` annotation on specific controller methods to block unauthorized access at the API level.
- **Example**: [VehicleController.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/controller/VehicleController.java)
- **Logic**: Only users with `ADMIN` or `INVENTORY_MANAGER` roles can delete a vehicle record.

**Frontend Enforcement**:
The UI dynamically hides or disables buttons based on the user's permissions.
- **Example**: [vehicle-list.component.ts](file:///Users/sgirishkumar/Documents/DealerConnect/frontend/src/app/features/inventory/vehicle-list/vehicle-list.component.ts)
- **Line 275-277**: `canCreate`, `canEdit`, and `canDelete` getters check the user's role before rendering the "Add" or "Edit" buttons.

---

## 📊 3. Technical Comparison

| Feature | Authentication (AuthN) | Authorization (AuthO) |
| :--- | :--- | :--- |
| **Question** | "Is this user who they say they are?" | "Is this user allowed to do X?" |
| **Identity Piece** | Username / Password | Roles / Privileges |
| **Logic Layer** | `JdbcUserDetailsManager` / `AuthController` | `@PreAuthorize` / `AuthService.hasPermission` |
| **Failure Code** | **401 Unauthorized** | **403 Forbidden** |

---

## 📍 4. Where is the Code?

| Category | Component | File Path |
| :--- | :--- | :--- |
| **Hashing** | Bcrypt Encoder | `com.dealerconnect.config.SecurityConfig` |
| **Session** | Stateless JWT Logic | `com.dealerconnect.security.JwtTokenProvider` |
| **Permissions** | Permission Check Utility | `com.dealerconnect.security.UserDetailsServiceImpl` |
| **UI Safety** | Guard / Permission Check | `frontend/src/app/core/services/auth.service.ts` |

---

### 💡 Phase 1 Auth Summary
By separating these concerns:
1.  **Strict Security**: A user might be authenticated (logged in) but still unauthorized to perform high-stakes actions like deleting a dealer.
2.  **Scalability**: We can add new roles (e.g., "Service Manager") in the database, and the system automatically applies the correct restrictions without code changes.
3.  **UX Clarity**: Users aren't confused by buttons that they can't use; the UI simply removes them based on their authorization profile.
