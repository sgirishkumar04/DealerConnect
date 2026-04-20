# ⚡ Phase 1: DB Connection Pooling (HikariCP)

This document explains the high-performance database management strategy used in **DealerConnect**. To ensure the app can handle hundreds of concurrent requests without lag, we use **HikariCP**, the industry-standard for connection pooling.

---

## 🏗️ 1. Pooling vs. Spawning

In a basic application, every time a user clicks "Save," the app creates a new connection to MySQL. 
- **The Problem**: Opening a connection is expensive. It requires a TCP handshake, SSL negotiation, and MySQL authentication, which can take 50ms–200ms every single time.
- **The Solution (Pooling)**: DealerConnect maintains a "Warm Pool" of connections that stay open at all times. When an API needs to talk to the DB, it simply "borrows" an existing connection and returns it instantly when done.

---

## 🏛️ 2. HikariCP: The Performance Engine

We use **HikariCP** because it is the fastest and most lightweight connection pooler available for Java.

### 🍱 Standard Tuning
By default, Spring Boot 3 configures Hikari with production-ready settings:
- **Maximum Pool Size**: 10 (Allows for 10 simultaneous database operations per server instance).
- **Minimum Idle**: 10 (Keeps the connections "warm" even during low traffic).
- **Connection Timeout**: 30 seconds (Prevents the app from hanging if MySQL is busy).

**Key File**: [application.properties](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/resources/application.properties)
- While the defaults are used, this is where you would override the pool size as the dealership scales (e.g., `spring.datasource.hikari.maximum-pool-size=20`).

---

## 🔒 3. Connection lifecycle

1.  **App Startup**: Hikari creates the initial pool of connections.
2.  **API Request**: A Service (e.g., `VehicleService`) requests a connection to save a car.
3.  **Borrowing**: Hikari hands over a "warm" connection in under 1ms.
4.  **Returning**: Once the `@Transactional` method finishes, the connection is returned to the pool, ready for the next user.

---

## 📍 4. Where is the Config?

| Category | Component | File Path |
| :--- | :--- | :--- |
| **Dependency** | Hikari Inclusion | `pom.xml` (via `spring-boot-starter-data-jpa`) |
| **Connection Info** | DB URL & Credentials | `application.properties` (Line 4-7) |
| **Advanced Tuning** | Pool Size/Timeouts | `application.properties` (Optional overrides) |
| **Health Monitor** | Pool Statistics | `/monitor/health` (via Actuator) |

---

### 💡 Phase 1 Pooling Summary
By implementing HikariCP:
1.  **Instant Response**: Users don't experience the "lag" of the database waking up or handshaking.
2.  **Resource Safety**: We prevent "Connection Exhaustion" by setting a hard limit (Max Pool Size), ensuring the database never crashes due to too many open connections.
3.  **Zero-Leak Policy**: Hikari automatically detects and kills "Zombie" connections that were accidentally left open by buggy code.
