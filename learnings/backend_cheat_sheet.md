# 🏆 DealerConnect Backend: Final Review Cheat Sheet

This document contains the "Killer Answers" and key technical highlights for your backend code review. Use this to demonstrate deep architectural knowledge.

---

## 🏗️ 1. Project Snapshot (The "Big Picture")
- **Tech Stack**: Spring Boot 3.2, MySQL 8.0, Spring Security (JWT), QueryDSL, Hibernate.
- **Architecture**: 3-Tier (Controller-Service-Repository) + Stateless Security.
- **Key Design Pattern**: Multi-Tenancy (Data Isolation via `dealer_id`).

---

## 🚀 2. Top 5 "Killer" Reviewer Questions & Answers

| Question | The Strategic Answer |
| :--- | :--- |
| **"Why did you choose JWT over Sessions?"** | "We chose a **Stateless JWT architecture** to ensure high scalability. Since the server doesn't store session state, we can easily scale horizontally. It also makes the API mobile-ready and immune to standard CSRF attacks." |
| **"How do you ensure Dealer A can't see Dealer B's data?"** | "We've implemented **Scoped Data Access**. Every core entity belongs to a `Dealer`. During every request, we extract the `dealerId` from the JWT token and inject it into our JPA/QueryDSL filters, ensuring strict data isolation." |
| **"Why use Stored Procedures for the dashboard?"** | "For complex analytics like 'Monthly Revenue' or 'Sales Funnel', processing millions of records in Java is inefficient. We use **Native Stored Procedures** to let the database handle the aggregation, providing millisecond response times for the UI." |
| **"How do you handle currency/price calculations?"** | "We never use `Double` or `Float` for money. We use **`BigDecimal`** with explicit scale and rounding. This prevents precision errors which are critical in a financial system like a DMS." |
| **"How do you secure your 'Delete' endpoints?"** | "We use **Dual-Layer Security**. We restrict HTTP DELETE methods in the `SecurityConfig` filter chain and apply granular `@PreAuthorize` annotations on the controller methods to check for specific authorities like `USER_DELETE`." |

---

## 📦 3. Module-Wise Key Highlights

### 🔐 Security & Auth
- **Password Safety**: BCrypt salted hashing.
- **Account Locking**: Automated lock after 5 failed attempts (Event-Driven via `AuthenticationEventListener`).
- **Rate Limiting**: Custom filter to prevent Bot/Brute-force attacks.

### 🚗 Inventory & Vehicle
- **Dynamic Filtering**: **QueryDSL `BooleanBuilder`** allowing high-precision searches (Model, Price, Status) with type-safe code.
- **Integrity**: Every car VIN is unique and tracked via a lifecycle Enum (`IN_STOCK` -> `ALLOCATED` -> `SOLD`).

### 💰 Sales & Booking
- **Auto-Conversion**: The service automatically creates a `Customer` record during a `Booking` if the user is new.
- **Atomic Allocation**: One transaction handles the booking creation AND marking the vehicle as 'Allocated' to prevent duplicate sales.

---

## 🛠️ 4. The "Engine Room" (Infrastructure)

- **Connection Pooling**: Uses **HikariCP** (Default in Spring Boot 3) tuned for 10 max connections and 5 minimum idle to ensure zero-latency DB access.
- **JPA Auditing**: Enabled via `JpaConfig`. Automatically populates `created_by` and `updated_at` by pulling the user from the `SecurityContext`.
- **Global Error Handling**: Uses `@RestControllerAdvice` to catch all exceptions and return a standardized JSON format.
- **OpenAPI**: Integrated Swagger UI for interactive API documentation and testing.

---

## 💡 5. Pro Tip: The "Performance" Pitch
If asked about performance, mention:
1. **Lazy Loading**: We use `FetchType.LAZY` for large relationships to avoid "N+1" query problems.
2. **Entity Graphs**: We use `@EntityGraph` for critical fetches (like finding a Vehicle with its Model) to get all data in exactly ONE database trip.
3. **Database Indexing**: We have explicitly indexed columns like `status`, `vin`, and `dealer_id` to ensure O(log n) search performance.

---
*Good luck with your review! You've built a production-grade backend.* 🚀
