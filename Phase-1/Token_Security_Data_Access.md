# 🎫 Phase 1: Token Security & Data Access

This document explains the "Silent Security" layer of **DealerConnect**. We use **JSON Web Tokens (JWT)** not just for login, but as a secure passport that ensures every dealer only sees their own data.

---

## 🏗️ 1. The Anatomy of a Token (JWT)

A token in our system is more than just a session; it is a **Stateless Passport**.

### 🍱 Secure Claims
**Key File**: [JwtTokenProvider.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/security/JwtTokenProvider.java)

When a user logs in, the server generates a token (Line 49) that contains:
1.  **Subject**: The user's email.
2.  **Role/Permissions**: What the user can do.
3.  **Dealer ID**: **The Security Key (Line 53)**—this binds the token to a specific dealership.
4.  **Signature**: Signed with a server-side secret (`jwt.secret`) using **HS256**. If a single character is changed in the token, the signature becomes invalid instantly.

---

## 🏛️ 2. Data Isolation (Multi-Tenancy)

Because **DealerConnect** is a multi-tenant platform, preventing "Data Leaks" between dealerships is our top priority.

### 🍱 The Extraction Logic
**Key File**: [DealerContext.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/security/DealerContext.java)

- **Line 20**: The system retrieves the `dealerId` directly from the authenticated `UserPrincipal`. 
- This ID is used as a global filter for the duration of the request.

### 🍱 Enforced Repository Logic
**Key File**: [VehicleRepository.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/repository/VehicleRepository.java)

- When fetching sensitive data (like Inventory Reports), the repository **enforces** the `dealerId` check.
- **Line 21**: `CALL GetInventoryStatusSummary(..., :dealerId)`
- By passing the `dealerId` from the token directly into SQL Procedures, we ensure that Dealer A can *never* query Dealer B's stock, even if they guess the correct API URL.

---

## 📍 3. Where is the Code?

| Category | Responsibility | File Path |
| :--- | :--- | :--- |
| **Token Generation** | Embedding Dealer ID | `security/JwtTokenProvider.java` |
| **Context Recovery** | Extracting ID from Auth | `security/DealerContext.java` |
| **Data Separation** | Multi-Tenant Queries | `repository/VehicleRepository.java` |
| **Filter Chain** | Token Validation | `security/JwtAuthFilter.java` |

---

### 💡 Phase 1 Data Access Summary
By using Token-Based Data Access:
1.  **Immune to URL Guessing**: A user cannot simply change an ID in the URL to see another dealer's data because the `dealerId` is pulled from the cryptographically signed token, not the URL.
2.  **Scalable Multi-Tenancy**: We can host 1,000 dealers on the same database, and the `dealerId` claims ensure they never "see" each other's records.
3.  **Stateless Performance**: The server doesn't need to look up the "Dealer ID" in the session store for every click; it's already present in the validated token.
