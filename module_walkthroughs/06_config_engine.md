# ⚙️ Module 6: Infrastructure & Configuration Flow

This "Engine Room" module handles the underlying technologies that make the application secure, fast, and maintainable.

---

## 🏛️ Architecture Components
1. **SecurityConfig**: `backend/src/main/java/com/dealerconnect/config/SecurityConfig.java`
2. **JpaConfig**: `backend/src/main/java/com/dealerconnect/config/JpaConfig.java`
3. **GlobalExceptionHandler**: `backend/src/main/java/com/dealerconnect/exception/GlobalExceptionHandler.java`
4. **DataInitializer**: `backend/src/main/java/com/dealerconnect/config/DataInitializer.java`
5. **application.properties**: `backend/src/main/resources/application.properties`

---

## 🌊 The Complete Flow

### 1. Request Filtering (`SecurityConfig`)
- **Flow**: Every HTTP request hits the `SecurityFilterChain` first.
- It checks for CSRF disabling (stateless), applies CORS rules (allowing Angular), and verifies the JWT token before the request even reaches a single line of business logic.

### 2. Transparent Auditing (`JpaConfig`)
- **Flow**: When a developer writes `repo.save(entity)`, Spring Data JPA looks at this config.
- It reaches into the `SecurityContext` to find the logged-in user and automatically stamps the `created_by` field on the database row.

### 3. Graceful Crashing (`GlobalExceptionHandler`)
- **Flow**: If any method in the whole project throws an Error (e.g., "Car not found" or "Database Offline"):
    1. The error is intercepted by this global advisor.
    2. It is converted into a professional JSON response with a timestamp.
    3. The internal "Stack Trace" is hidden from the user for security.

### 4. Automatic Seeding (`DataInitializer`)
- **Flow**: On every system startup, this class checks: *"Is the database empty?"*
- It automatically builds the roles, permissions, department list, and car models. This ensures the app is 100% ready for a demo within seconds of being turned on.

### 5. Connection Pooling (HikariCP)
- **Flow**: Managed in `application.properties`. 
- It maintains a pool of 10 persistent database connections. When a request comes in, it "borrows" a connection, uses it, and returns it. This prevents the high cost of opening/closing the database pipe for every single user.

---

## 💡 "Reviewer Ready" Point
"Our infrastructure layer is designed for **Observability and Resilience**. By centralizing error handling, auditing, and configuration, we ensure that the application is not only secure but also easy to debug and manage in a production environment."
