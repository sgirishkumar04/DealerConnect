# 🛡️ Phase 1: Account Locking Policy (Brute Force Defense)

This document explains the security mechanism that protects **DealerConnect** user accounts from "Brute Force" attacks. If a user enters an incorrect password too many times, their account is automatically locked until an administrator reviews it.

---

## 🏛️ 1. Security Strategy: 5 In, 1 Out

To balance security and usability, the system allows exactly **5 unsuccessful login attempts**.

- **Why 5?**: It allows for human error (typos) while effectively stopping automated scripts from trying thousands of password combinations.
- **The "Silent Watcher"**: This logic runs in the background for every login attempt and does not rely on the frontend for enforcement.

---

## ⚙️ 2. The Technical Flow (Event-Driven)

We use **Spring Security Event Listeners** to track login activity.

**Key File**: [AuthenticationEventListener.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/security/AuthenticationEventListener.java)

### 🍱 Step A: The Failure Capture
- **Line 22 (`onAuthenticationFailure`)**: This method catches the `BadCredentials` event.
- **Line 27-28**: It increments the `failed_login_attempts` counter in the database.
- **Line 29-30**: If the counter reaches **5**, it sets `isLocked = true`.

### 🍱 Step B: The Success Reset
- **Line 39 (`onAuthenticationSuccess`)**: If a user logs in successfully *before* hitting the limit, their failure counter is immediately reset to **0**. This prevents old typos from adding up over several weeks.

---

## 🛠️ 3. Administrative Recovery (The Unlock)

Once an account is locked, the user cannot log in, even with the correct password. An administrator must verify their identity.

**Key File**: [EmployeeController.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/controller/EmployeeController.java)

- **The Unlock Gate (Line 61)**: An Admin can call the `/unlock` endpoint.
- **Behavior**: This resets the `isLocked` flag to `false` and clears the `failedLoginAttempts` counter, allowing the employee back into the system.

---

## 📍 4. Where is the Code?

| Category | Component | File Path |
| :--- | :--- | :--- |
| **Logic Engine** | Event Listener | `security/AuthenticationEventListener.java` |
| **Data Fields** | Entity Tracking | `entity/Employee.java` (Line 78-83) |
| **Admin Control**| Unlock Endpoint | `controller/EmployeeController.java` (Line 61) |
| **Constants** | Setting the "5" Limit | `security/AuthenticationEventListener.java` (Line 18) |

---

### 💡 Phase 1 Locking Summary
By implementing automated locking:
1.  **Stop Script Attacks**: Automated "bots" are halted instantly after the 5th attempt.
2.  **No Performance Lag**: Trackers are stored directly on the user record in the DB, requiring no complex third-party security tools.
3.  **Traceability**: Every lock event is logged in the system, allowing Super Admins to identify which accounts are being targeted by attackers.
