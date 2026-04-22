# 🔐 Module 1: Authentication & Identity Flow

This module is the entry point of the application. It handles user verification, JWT generation, and brute-force protection.

---

## 🏛️ Architecture Components
1. **AuthController**: `backend/src/main/java/com/dealerconnect/controller/AuthController.java`
2. **AuthService**: `backend/src/main/java/com/dealerconnect/service/impl/AuthService.java`
3. **UserDetailsServiceImpl**: `backend/src/main/java/com/dealerconnect/security/UserDetailsServiceImpl.java`
4. **JwtTokenProvider**: `backend/src/main/java/com/dealerconnect/security/JwtTokenProvider.java`
5. **BCryptPasswordEncoder**: (Defined in `backend/src/main/java/com/dealerconnect/config/SecurityConfig.java`)
6. **AuthenticationEventListener**: `backend/src/main/java/com/dealerconnect/security/AuthenticationEventListener.java`

---

## 🌊 The Complete Login Flow

### 1. The Request
- The user sends their `email` and `password` to `/api/v1/auth/login`.

### 2. The Verification (`AuthService`)
- The `AuthService.login()` method calls `authManager.authenticate()`.
- Spring Security uses **`BCrypt`** to compare the raw password with the hashed password in the DB.
- **Fail Scenario**: If the password is wrong, the `AuthenticationEventListener` is triggered. It increments `failedLoginAttempts`. If it reaches **5**, it sets `isLocked = true`.

### 3. Account Status Checks
- If the password is correct, the `AuthService` performs custom business checks:
    - **Is Active?**: Is the employee deactivated by an Admin?
    - **Dealer Status?**: Is the entire dealership deactivated?

### 4. The "Passport" Creation (`JwtTokenProvider`)
- Once all checks pass, the `JwtTokenProvider` builds the token.
- **Claims**: We "bake" the `dealerId`, `permissions`, and `role` into the token.
- **Signing**: The token is signed with the `jwt.secret` from `application.properties`.

### 5. The Response
- The user receives an `AuthResponse` containing the **JWT Token**, their **FullName**, **Role**, and a list of **Permissions**.

---

## 🛡️ Key Security Features
- **Statelessness**: No sessions are saved on the server. Every request must carry the JWT.
- **Account Locking**: Protects against brute-force attacks.
- **Rate Limiting**: Custom filter prevents Bot spamming.
