# 🔑 Phase 1: Password Hashing (BCrypt Strategy)

This document explains how **DealerConnect** protects user passwords. We use the industry-standard **BCrypt** algorithm to ensure that even if the database is compromised, user passwords remain safe and unreadable.

---

## 🏗️ 1. Security Philosophy: "One-Way Only"

We never store passwords in plain text. Instead, we store a **Hash**—a mathematically "jumbled" version of the password that cannot be reversed.

| Feature | Technical Standard | Benefit |
| :--- | :--- | :--- |
| **Algorithm** | **BCrypt** | Designed to be slow and secure against "Brute Force" attacks. |
| **Salting** | Automatic | BCrypt generates a unique "salt" for every password, so two users with the password "Welcome123" will have different hashes in the DB. |
| **Storage** | `password_hash` column | Lengthy strings (e.g., `$2a$10$...`) appear in the database instead of real passwords. |

---

## ⚙️ 2. The Technical Setup (Server-Side)

The encoding logic is centralized in the security configuration.

**Key File**: [SecurityConfig.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/config/SecurityConfig.java)

| Line | Code Logic | Explanation |
| :--- | :--- | :--- |
| **36-39** | `passwordEncoder()` bean | Defines the global `BCryptPasswordEncoder`. This bean is injected wherever hashing or verification is needed. |

---

## 🛠️ 3. The Lifecycle of a Password

### 🍱 Step A: Hashing at Registration
When a dealer or employee is created, the plain-text password is "encoded" before the `save()` command is called.

**Key File**: [DealerRegistrationService.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/service/impl/DealerRegistrationService.java)
- **Line 33**: `passwordEncoder.encode(request.getAdminPasswordHash())`
- This ensures the database **only** ever sees the scrambled version.

### 🍱 Step B: Verification at Login
During login, the system doesn't "decrypt" the password. Instead, it hashes the *provided* password and compares it to the hash in the DB.

**Key File**: `AuthController.java` (using `AuthenticationManager`)
- Spring Security's **AuthenticationManager** automatically uses the `BCryptPasswordEncoder` bean to perform this comparison securely.

---

## 📍 4. Where is the Code?

| Layer | Responsibility | Code Path |
| :--- | :--- | :--- |
| **Configuration** | Setup the encoder | `config/SecurityConfig.java` |
| **Hashing Logic** | Registration / Seeding | `service/impl/DealerRegistrationService.java` |
| **Verification** | Identity check at Login | `security/UserDetailsServiceImpl.java` |

---

### 💡 Phase 1 Hashing Summary
By implementing BCrypt hashing:
1.  **Security Compliance**: We follow ISO/SOC2 standards for data protection by never handling plain-text credentials in the persistence layer.
2.  **Zero Leakage**: Even developers with database access cannot see user passwords.
3.  **Future Proof**: As hardware gets faster, we can increase the "Work Factor" (strength) of BCrypt with a single number change in `SecurityConfig.java`.
