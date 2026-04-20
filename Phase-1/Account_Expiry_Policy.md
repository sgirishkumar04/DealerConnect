# ⏳ Phase 1: Account Expiry Policy (Timed Access)

This document explains how **DealerConnect** handles time-bound user access. Whether for temporary staff, interns, or contract employees, the system can automatically revoke access once a specific date is reached.

---

## 🏗️ 1. Security Strategy: Time-Bound Access

In a high-security dealership environment, forgetting to deactivate a former employee's account is a major risk. Account Expiry solves this by putting a "Timer" on the account.

- **Automated Revocation**: No manual intervention is needed on the day the contract ends.
- **Graceful Handling**: The account remains in the database (for history and audits), but the user is blocked from logging in.
- **Permanent Access**: If the `expiryDate` is left empty (null), the account never expires.

---

## ⚙️ 2. The Technical Enforcement (UserPrincipal)

We enforce the expiry check at the moment of login using Spring Security's identity wrapper.

**Key File**: [UserPrincipal.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/security/UserPrincipal.java)

### 🍱 The Expiry Check Logic (Line 21)
```java
employee.getExpiryDate() == null || employee.getExpiryDate().isAfter(LocalDate.now())
```

| Component | Logic | Behavior |
| :--- | :--- | :--- |
| **Null Check** | `getExpiryDate() == null` | If no date is set, the account is considered valid. |
| **Comparison** | `.isAfter(LocalDate.now())` | The account is valid only if today's date is **before** the expiry date. |
| **Outcome** | `isAccountNonExpired` | If the check fails, Spring Security throws an `AccountExpiredException`, and the user is redirected to the login page with an error message. |

---

## 🛠️ 3. Administrative Management

Dealer Admins can manage these dates through the Employee Management forms.

**Key File**: [Employee.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/entity/Employee.java)
- **Line 86**: `private LocalDate expiryDate;`
- This field is mapped directly to the `employees` table, allowing for easy updates if an intern's contract is extended.

---

## 📍 4. Where is the Code?

| Category | Component | File Path |
| :--- | :--- | :--- |
| **Data Field** | Expiry Storage | `entity/Employee.java` (Line 86) |
| **Enforcement** | Security Check | `security/UserPrincipal.java` (Line 21) |
| **Identity Load**| User Details | `security/UserDetailsServiceImpl.java` |
| **UI Control** | Form Field | `features/admin/employee-form/` |

---

### 💡 Phase 1 Expiry Summary
By implementing automated account expiry:
1.  **Reduced Liability**: Accounts for seasonal staff automatically deactivate themselves, reducing the risk of "Orphaned" active accounts.
2.  **Compliance Ready**: Many security audits require evidence that temporary accounts have a predefined end date.
3.  **Low Maintenance**: Administrators set the date once during onboarding and don't need to remember to "unplug" the access later.
