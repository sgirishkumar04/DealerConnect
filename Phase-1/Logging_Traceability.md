# 📝 Phase 1: Logging & Exception Traceability

This document explains how **DealerConnect** provides deep operational visibility through its logging stack and ensures every error can be traced back to its root cause using standardized exception handling.

---

## 🏛️ 1. The Logging Stack (SLF4J + Logback)

We use the industry-standard **SLF4J API** backed by the **Logback** implementation. This is the default high-performance logging stack for Spring Boot 3.

### 🍱 Standardized Logging with Lombok
To keep our code clean, we use the `@Slf4j` annotation. This automatically injects a `log` object into our Java classes.

**Key File**: [AuthenticationEventListener.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/security/AuthenticationEventListener.java)
- **Line 13**: `@Slf4j` enables structured logging.
- **Line 31**: `log.warn("Account locked for user: {}...")` — This uses **parameterized logging**, which is more efficient than string concatenation.

---

## 🔍 2. Exception Traceability Strategy

Traceability is the ability to connect a "Failure in the UI" to a "Line of Code in the Server."

### 🍱 Step 1: The Timestamp Anchor
**Key File**: [GlobalExceptionHandler.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/exception/GlobalExceptionHandler.java)
- **Line 76**: Every error response sent to the frontend includes a **precise timestamp**.
- When a user reports an error, they provide the timestamp, which allows an administrator to search the server logs for that exact millisecond to see the full stack trace.

### 🍱 Step 2: Global Catch-All
- **Line 66**: Any error that isn't specifically handled (like a database connection failure) is caught by the `handleGeneral` method.
- **Line 70**: `ex.printStackTrace()` ensures the full path of the error is dumped into the server log for deep debugging.

---

## ⚙️ 3. Logging Configurations

We control our "Visibility Level" via the application properties.

**Key File**: [application.properties](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/resources/application.properties)

| Level | Range | Target |
| :--- | :--- | :--- |
| **DEBUG** | `org.hibernate.SQL` | Logs every SQL query being sent to MySQL. |
| **WARN** | `org.springframework.security` | Logs unauthorized access attempts and token errors. |
| **INFO** | `com.dealerconnect` | Logs the business logic flow of our own application. |

---

## 📍 4. Where is the Code?

| Category | Component | File Path |
| :--- | :--- | :--- |
| **Error Format** | Standard JSON Error Response | `exception/GlobalExceptionHandler.java` |
| **Log Controls** | Filter Levels | `backend/src/main/resources/application.properties` |
| **Logic Logging** | `@Slf4j` Integration | Most Files in `service/impl/` and `security/` |
| **Stack Trace** | General Exception Capture | `exception/GlobalExceptionHandler.java` (Line 66) |

---

### 💡 Phase 1 Logging Summary
By implementing this logging strategy:
1.  **Refactor-Proof**: Because we use SLF4J, we can switch from Logback to Log4j2 in the future without changing a single line of Java code.
2.  **Audit Ready**: Critical events (like login failures) are logged with enough detail to recreate the exact timeline of a security event.
3.  **Low Performance Overhead**: We use log levels to ensure that in Production, only critical information is logged, keeping the server fast.
