# 🧱 Phase 1: Database Transaction Isolation

This document explains how **DealerConnect** handles data integrity and concurrency using **Transaction Isolation Levels**. We ensure that when multiple users are updating the system at the same time, the data remains consistent and reliable.

---

## 🚦 1. Core Concepts: The "Anomalies"

When two users (Transactions) access the same data simultaneously, three types of "errors" can occur if the isolation is weak:

| Anomaly | Explanation | Analogy |
| :--- | :--- | :--- |
| **Dirty Read** | Scenario where Transaction A reads data that Transaction B has changed but **not yet saved (committed)**. | Reading a draft of a letter that might still be deleted. |
| **Non-repeatable Read** | When you read a row twice in the same transaction, but the data changes between reads because someone else saved an update. | You look at the price of a car (₹10L), then 5 seconds later it shows (₹11L) in the same session. |
| **Phantom Read** | When you search for a range of records twice, but new rows appear (or disappear) in between because someone else inserted/deleted data. | You search for "All SUVs", find 5. You search again 5 seconds later and find 6. |

---

## 🛠️ 2. Project Implementation (MySQL / InnoDB)

By default, **DealerConnect** uses the **InnoDB** storage engine in MySQL, which provides the **`REPEATABLE READ`** isolation level.

### 🍱 How the Code handles it
**Key File**: [DealerRegistrationService.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/service/impl/DealerRegistrationService.java)

| Line | Feature | Technical Implementation |
| :--- | :--- | :--- |
| 50 | `@Transactional` | **Implicit Isolation**: Because no level is specified, Spring uses the database default (`REPEATABLE_READ`). |
| 59-114 | Atomic Workflow | The "Dealer Approval" flow creates a **Dealer**, an **Employee**, and updates a **Registration**. All three must succeed together. |

**Why `REPEATABLE READ` is the best choice for us?**
- It prevents **Dirty Reads** and **Non-repeatable Reads**.
- It ensures that once you start the Dealer Approval process, the data you're looking at won't change until you finish, even if someone else is editing the same dealer profile.

---

## 🔍 3. Real-world Scenario: Dealer Approval

Let's look at what happens in the code during an **Approval** (Line 51):

1.  **Transaction Starts**: The system "snapshots" the current state of the database.
2.  **Step 1**: It saves the `Dealer` record.
3.  **Step 2**: It saves the `Employee` record.
4.  **Step 3**: It marks the `Registration` as active.
5.  **Transaction Ends (Commit)**: Only now do other users see the new Dealer.

**If Transaction Isolation was missing**:
A "Sales Manager" might see the new `Dealer` (Step 1) before the `Employee` is created (Step 2). If the system crashed at Step 2, the Sales Manager would be left with a "Broken Dealer" with no admin user. **Transaction Isolation prevents this "Atomic Failure."**

---

## 📍 4. Where is the Logic?

| Role | Responsibility | Code Path |
| :--- | :--- | :--- |
| **Transaction Manager** | Orchestrates Starts/Commits/Rollbacks | Spring Boot (Auto-configured) |
| **Enforcer** | The annotation that triggers isolation | `@Transactional` |
| **Database Engine** | Physically locks rows to prevent dirty reads | MySQL InnoDB |

---

## 📊 5. Comparison of Isolation Levels

| Level | Dirty Reads | Non-Repeatable | Phantom Reads | Used In DealerConnect? |
| :--- | :--- | :--- | :--- | :--- |
| **Read Uncommitted**| Permitted | Permitted | Permitted | ❌ No (Too risky) |
| **Read Committed** | Prevented | Permitted | Permitted | ❌ No |
| **Repeatable Read** | Prevented | Prevented | Prevented* | ✅ **Default (MySQL)** |
| **Serializable** | Prevented | Prevented | Prevented | ❌ Overkill (Too slow) |

*\*MySQL InnoDB uses "Next-Key Locking" to prevent most phantom reads even in Repeatable Read mode.*

---

### 💡 Phase 1 Integrity Summary
By using robust transaction isolation:
1.  **Zero "Ghost" Data**: Users never see half-finished or unsaved data.
2.  **Financial Accuracy**: Calculations (like Lead funnel counts or Booking totals) stay consistent and don't change while a report is being generated.
3.  **Stability**: The system handles multiple users making simultaneous changes without data corruption.
