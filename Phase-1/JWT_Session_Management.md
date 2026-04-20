# 🔑 Phase 1: JWT Authentication & Session Management

This document explains the technical lifecycle of a user session in **DealerConnect**. Because we use a **Stateless JWT** architecture, the server doesn't "remember" you; instead, the browser carries its own authenticated passport with every request.

---

## 🏗️ 1. Stateless Session Philosophy

Traditional web apps store sessions in the server's memory (`HttpSession`). This slows down the server as more users log in. 

In **DealerConnect**, we use **Stateless Sessions**:
- **Server**: Doesn't store anything about your login. It only checks if the token you sent is valid.
- **Client**: Responsible for keeping the token safe and sending it back on every "Save" or "View" action.

**Key File**: [SecurityConfig.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/config/SecurityConfig.java)
- **Line 51**: `.sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS))`
- This line strictly forbids the server from creating a cookie-based session.

---

## 🛠️ 2. Frontend Session Lifecycle

The frontend (Angular) handles the persistence of the session so users don't have to log in every time they refresh the page.

### 🍱 Step 1: Persistence
**Key File**: [auth.service.ts](file:///Users/sgirishkumar/Documents/DealerConnect/frontend/src/app/core/services/auth.service.ts)
- **Line 20**: After a successful login, the JWT token is saved to `localStorage`.
- **Line 33 (`refreshProfile`)**: On page load, the app calls the `/me` endpoint to re-verify the token and update the user's name and permissions in the UI.

### 🍱 Step 2: The Automator (Interceptor)
**Key File**: [jwt.interceptor.ts](file:///Users/sgirishkumar/Documents/DealerConnect/frontend/src/app/core/interceptors/jwt.interceptor.ts)
- This service acts like a "Mail Sorter." 
- **Line 13**: It peeks at every outgoing HTTP request and automatically snaps the `Authorization: Bearer <token>` header onto it. This ensures the backend always knows who is performing the action.

---

## 🏛️ 3. Token Integrity

The JWT token consists of three parts:
1.  **Header**: Algorithm used (HS256).
2.  **Payload**: User ID, Dealer ID, and Expiry Date.
3.  **Signature**: Generated using a secret key only the server knows.

If a user tries to change their `dealerId` inside the token (to see another dealer's data), the **Signature will no longer match**, and the backend will reject the request with a **401 Unauthorized** error.

---

## 📍 4. Where is the Code?

| Category | Component | File Path |
| :--- | :--- | :--- |
| **Session Policy** | Server Stateless Policy | `config/SecurityConfig.java` (Line 51) |
| **Token Storage** | Client-side persistence | `core/services/auth.service.ts` (Line 10) |
| **Auto-Injection** | HTTP Request Wrapper | `core/interceptors/jwt.interceptor.ts` (Line 10) |
| **Login Flow** | JWT Issuance | `controller/AuthController.java` |

---

### 💡 Phase 1 Session Summary
By using JWT-based session management:
1.  **Infinite Scalability**: Since the server doesn't store session data, it can handle 10,000+ simultaneous users without running out of RAM.
2.  **Reliability**: Even if the backend server restarts, users stay logged in because their session "lives" in their own browser's token.
3.  **Security**: The token is cryptographically signed, making it a tamper-proof passport for dealership staff.
