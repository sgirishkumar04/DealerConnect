# 🛡️ Phase 1: Method-Level & HTTP Security Configuration

This document explains the "Two-Gate Security" strategy in **DealerConnect**. We combine broad URL-level restrictions with fine-grained method-level permissions to create an impenetrable defense for dealership data.

---

## 🏗️ 1. The Two-Gate Security Strategy

We do not rely on a single lock. Instead, every request must pass through two specific gates:

1.  **Gate 1: HTTP Security** (The Perimeter): Checks "Is the user logged in?" and "Is this URL generally allowed for their role?"
2.  **Gate 2: Method Security** (The Vault): Checks "Does this specific user have the exact authority to perform this specific action (e.g., Delete)?"

---

## 🏛️ 2. Gate 1: HTTP Security (URL Rules)

This is the first line of defense, defined in the central security configuration.

**Key File**: [SecurityConfig.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/config/SecurityConfig.java)

| Line | Component | Responsibility |
| :--- | :--- | :--- |
| **47** | `filterChain()` | **The Perimeter**: Defines which URLs are public (e.g., `/auth/**`) and which require authentication. |
| **50** | `.csrf().disable()` | Since we use stateless JWTs, we disable CSRF to prevent unnecessary complexity. |
| **60** | `.hasRole("SUPER_ADMIN")` | Example of a broad perimeter rule: only Super Admins can even "touch" the `/dealers/**` route. |

---

## 🔒 3. Gate 2: Method Security (@PreAuthorize)

This is the second line of defense, applied directly to the Java code. Even if a user bypasses Gate 1, they will be stopped here if they lack specific authorities.

**Key File (Enabler)**: [SecurityConfig.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/config/SecurityConfig.java) (Line 23)
- `@EnableMethodSecurity`: This master switch allows us to use security annotations throughout the app.

**Key File (Usage)**: [VehicleController.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/controller/VehicleController.java)

| Annotation | Logic | Goal |
| :--- | :--- | :--- |
| **`@PreAuthorize("hasAuthority('INVENTORY_VIEW')")`** | Read Access | Any staff can look at cars if they have viewing rights. |
| **`@PreAuthorize("hasAuthority('INVENTORY_DELETE')")`**| Write Access | Only a high-level manager can physically remove a vehicle from the digital stock. |

---

## 📍 4. Where is the Code?

| Category | Component | File Path |
| :--- | :--- | :--- |
| **URL Security** | Global Filter Rules | `config/SecurityConfig.java` (Line 47) |
| **Method Security** | Enablement Switch | `config/SecurityConfig.java` (Line 23) |
| **Fine-Grained Check**| Controller Access | `controller/EmployeeController.java` (Line 43) |
| **Exceptions** | Public Endpoints | `config/SecurityConfig.java` (Line 53-56) |

---

### 💡 Phase 1 Security Summary
By combining both layers:
1.  **Fail-Safe Security**: If a developer accidentally makes a URL public in `SecurityConfig`, the `@PreAuthorize` on the method will still block unauthorized access.
2.  **Granular Control**: We can say "Everyone can see employees" (URL level) but "Only Admin can delete them" (Method level).
3.  **Readability**: Security is "self-documenting"—you can look at any controller method and instantly see exactly who is allowed to run it.
