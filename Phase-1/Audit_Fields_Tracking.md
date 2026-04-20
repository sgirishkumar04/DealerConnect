# 🕯️ Phase 1: Audit Fields (Automated Tracking)

This document explains how **DealerConnect** automatically tracks "Who" did "What" and "When." We use **JPA Auditing** to ensure every piece of data has a transparent history without writing a single line of manual code in our business logic.

---

## 🏛️ 1. Tracking Philosophy

In a professional dealership system, accountability is key. Every time a car is sold or a lead is created, we must know:
1.  **Who created it?** (User Identity)
2.  **When was it created?** (Timestamp)
3.  **Who last updated it?**
4.  **When was it last updated?**

---

## ⚙️ 2. The Technical Handshake (Spring Data JPA)

We use a "Silent Listener" approach. Instead of the developer manually setting the current user's name, the system handles it automatically.

### 🍱 The User Identity Provider
**Key File**: [JpaConfig.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/config/JpaConfig.java)

| Line | Code Logic | Explanation |
| :--- | :--- | :--- |
| **13** | `@EnableJpaAuditing` | The master switch that activates automatic field populating. |
| **17-25** | `AuditorAware` | **The Brain**: This method looks at the `SecurityContext` (JWT) to identify the logged-in user. If no user is logged in (e.g., during system startup), it returns "SYSTEM." |

---

## 📄 3. The Blueprint (AbstractAuditable)

Every important table (Vehicles, Leads, Employees, etc.) extends a special base class.

**Key File**: [AbstractAuditable.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/entity/AbstractAuditable.java)

| Annotation | DB Column | Behavior |
| :--- | :--- | :--- |
| **`@CreatedDate`** | `created_at` | Only set once when the record is first saved. |
| **`@LastModifiedDate`** | `updated_at` | Automatically refreshed on every update. |
| **`@CreatedBy`** | `created_by` | Captured from the logged-in user's identity. |
| **`@LastModifiedBy`** | `updated_by` | Updated to the latest person who edited the record. |

---

## 📍 4. Where is the Code?

| Category | File Path |
| :--- | :--- |
| **Auditing Enablement** | `backend/src/main/java/com/dealerconnect/config/JpaConfig.java` |
| **Base Audit Fields** | `backend/src/main/java/com/dealerconnect/entity/AbstractAuditable.java` |
| **Entity Integration** | Any entity extending `AbstractAuditable` (e.g., `Vehicle.java`) |
| **SQL Definition** | Columns are named `created_at`, `updated_at`, etc., in the DB schema. |

---

### 💡 Phase 1 Auditing Summary
By automating these fields:
1.  **Cleaner Code**: Services like `LeadService` focus purely on sales logic, not bookkeeping.
2.  **Traceability**: You can instantly see who changed a vehicle's status to "Sold" directly from the database or UI.
3.  **Consistency**: Because it's handled by Hibernate/JPA, it's impossible for a developer to "forget" to save the timestamp.
