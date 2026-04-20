# 🛠️ Backend Code Review Guide

This guide provides a foundational understanding of the project structure and a line-by-line walkthrough of the core functionalities implemented in the **DealerConnect** backend.

---

## 📂 1. Backend Project Structure

Understanding the responsibility of each package is the first step in any code review. Our backend follows a standard **Layered Architecture**.

| Package / Directory | Purpose & Responsibility |
| :--- | :--- |
| **`com.dealerconnect.config`** | **Configuration Central**: Contains global settings for Spring Security, OpenAPI (Swagger), and JPA auditing. These files act as the "startup instructions" for the application. |
| **`com.dealerconnect.controller`** | **The Front Door**: Handles incoming HTTP requests. Its only job is to map URLs to methods, validate input data, and return HTTP status codes (like 200 OK or 404 Not Found). |
| **`com.dealerconnect.dto`** | **The Envelopes (Data Transfer Objects)**: These are simple Java classes used to carry data between the frontend and backend. Using DTOs prevents us from exposing sensitive database columns to the outside world. |
| **`com.dealerconnect.entity`** | **The Blueprint (Database Models)**: Java classes that map exactly to your MySQL tables. This is where your data structure and relationships (like One-to-Many) are defined. |
| **`com.dealerconnect.exception`** | **The Safety Net**: Contains logic for catching errors globally. It ensures that if something crashes, the user gets a clean error message instead of a confusing stack trace. |
| **`com.dealerconnect.repository`** | **The Data Librarians**: Interfaces that use Spring Data JPA to talk to the database. They contain the queries used to find, save, and delete data. |
| **`com.dealerconnect.security`** | **The Guards**: Logic for JWT token generation, password validation (BCrypt), and user authentication filters. This layer ensures that only authorized users can access the data. |
| **`com.dealerconnect.service`** | **The Brain (Business Logic)**: This is where the actual "work" happens. If you need to calculate a price, approve a dealer, or hash a password, the logic goes here. |
| **`com.dealerconnect.util`** | **The Toolbox**: Contains small helper classes used across the project (e.g., String formatters or date calculators). |
| **`src/main/resources`** | **The Manuals**: Contains `application.properties` (settings like DB password) and SQL scripts for seeding data. |

---

## 🔐 2. Security & Identity

### [SecurityConfig.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/config/SecurityConfig.java)
**Purpose**: The central security configuration that locks down the API and defines how users are authenticated.

| Line | Code Snippet | Explanation |
| :--- | :--- | :--- |
| 23 | `@EnableMethodSecurity` | Enables the use of `@PreAuthorize` on controller methods for granular access control. |
| 38 | `return new BCryptPasswordEncoder();` | Sets BCrypt (a strong hashing algorithm) as the default for storing passwords. |
| 51 | `.sessionCreationPolicy(SessionCreationPolicy.STATELESS)` | Disables JSESSIONID sessions. The backend relies purely on JWT tokens for every request. |
| 104 | `.addFilterBefore(jwtAuthFilter(), ...)` | Inserts a custom filter that intercepts every request to validate the JWT in the `Authorization` header. |

---

### [AuthenticationEventListener.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/security/AuthenticationEventListener.java)
**Purpose**: Implements the "Account Lock" requirement after 5 failed attempts.

| Line | Code Snippet | Explanation |
| :--- | :--- | :--- |
| 7 | `AuthenticationFailureBadCredentialsEvent` | This event is triggered by Spring Security whenever a login fails due to a wrong password. |
| 27 | `int newAttempts = ... + 1;` | Increments the `failedLoginAttempts` counter in the database for the user. |
| 29 | `if (newAttempts >= 5)` | Checks if the threshold (5) is reached. |
| 30 | `employee.setIsLocked(true);` | Changes the `isLocked` flag to true, preventing any future login attempts until an admin unlocks it. |

---

## 📊 2. Data Integrity & Auditing

### [AbstractAuditable.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/entity/AbstractAuditable.java)
**Purpose**: Automatically tracks who created/updated a record and when.

| Line | Code Snippet | Explanation |
| :--- | :--- | :--- |
| 11 | `@EntityListeners(AuditingEntityListener.class)` | Hooks into JPA lifecycle events to automatically populate fields during save/update. |
| 15 | `@CreatedDate` | Automatically sets the timestamp when the record is first inserted. |
| 23 | `@CreatedBy` | Automatically captures the username (from the JWT) of the person who created the record. |
| 27 | `@LastModifiedBy` | Updates the username every time a record is modified. |

---

### [Employee.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/entity/Employee.java)
**Purpose**: The core user entity, demonstrating indexing and complex relationships.

| Line | Code Snippet | Explanation |
| :--- | :--- | :--- |
| 15 | `@Index(columnList = "department_id")` | Creates a database index to speed up lookups when filtering employees by department. |
| 48 | `@ManyToMany(fetch = FetchType.EAGER)` | Connects employees to multiple roles. `EAGER` ensures roles are loaded immediately with the user. |
| 86 | `private LocalDate expiryDate;` | Used to implement the "Expire Account" requirement. |

---

## 🌐 3. API Patterns & Efficiency

### [VehicleController.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/controller/VehicleController.java)
**Purpose**: Shows standard REST practices, including pagination and validation.

| Line | Code Snippet | Explanation |
| :--- | :--- | :--- |
| 23 | `public ResponseEntity<Page<Vehicle>>` | Returns a `Page` object instead of a List, which includes metadata like `totalPages` and `totalElements`. |
| 26-27 | `@RequestParam(defaultValue = "0") int page...` | Captures URL parameters for pagination, providing sensible defaults if omitted. |
| 43 | `@Valid @RequestBody VehicleRequest req` | `@Valid` triggers server-side validation using the rules defined in the `VehicleRequest` DTO. |

---

### [LookupController.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/controller/LookupController.java)
**Purpose**: Optimized data retrieval for dropdowns using HTTP caching.

| Line | Code Snippet | Explanation |
| :--- | :--- | :--- |
| 25 | `.cacheControl(CacheControl.maxAge(1, TimeUnit.HOURS)...)` | Tells the browser/frontend to cache the dropdown data for 1 hour, reducing server load. |
| 39 | `@GetMapping("/vehicle-variants/{modelId}")` | Handles "Linked Dropdowns" by filtering variants based on the selected `modelId`. |

---

## 🛡️ 4. Robust Error Handling

### [GlobalExceptionHandler.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/exception/GlobalExceptionHandler.java)
**Purpose**: Centralizes error handling so the UI always receives a consistent JSON format.

| Line | Code Snippet | Explanation |
| :--- | :--- | :--- |
| 15 | `@RestControllerAdvice` | Makes this class a global interceptor for exceptions thrown across any controller. |
| 43 | `handleValidation(...)` | Specifically catches `@Valid` failures and returns a list of user-friendly field errors. |
| 71 | `INTERNAL_SERVER_ERROR... "An unexpected error occurred."` | A "Catch-All" that hides complex Java stack traces from the end user for security. |

---

## 🧠 5. Business Logic Flow

### [DealerRegistrationService.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/service/impl/DealerRegistrationService.java)
**Purpose**: Orchestrates complex workflows involving multiple database tables.

| Line | Code Snippet | Explanation |
| :--- | :--- | :--- |
| 27 | `@Transactional` | Ensures that if any step in the registration fail, all database changes are rolled back (Atomic operation). |
| 33 | `passwordEncoder.encode(...)` | Hashes the admin password before it ever touches the database. |
| 69 | `dealerRepo.save(...)` | First, creates the dealership record. |
| 97 | `employeeRepo.save(...)` | Then, creates the primary admin user and links them to the new dealership. |

---

### 💡 Code Review Pro-Tips
- **DTOs vs Entities**: We always use **DTOs** in controllers to avoid exposing internal database structure to the outside world.
- **Idempotency**: Notice that we use `PUT` for full updates and `PATCH` for field-specific updates (like `updateStatus`).
- **Soft Deletes**: We typically use `isActive` flags (e.g., in `Employee.java`) instead of hard-deleting records to maintain data integrity.
