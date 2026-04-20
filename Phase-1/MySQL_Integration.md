# 🗄️ Phase 1: MySQL Integration

This document explains how **DealerConnect** interacts with the **MySQL** database. We use **Spring Data JPA** (powered by Hibernate) to bridge the gap between Java objects and MySQL tables.

---

## 🏛️ 1. Persistence Architecture

Our data persistence layer is designed for speed and reliability.

```mermaid
graph TD
    App[Java Application] -->|@Transactional| Svc[Service Layer]
    Svc -->|Calls| Repo[JPA Repository]
    Repo -->|Hibernate ORM| SQL[MySQL Queries]
    SQL -->|Writes/Reads| DB[(MySQL 8.0)]
    
    subgraph Logging
        SQL -.->|Show-SQL| Console[Developer Log]
    end
```

---

## ⚙️ 2. Database Connection

The application connects to MySQL using the properties defined in the backend resources.

**Key File**: [application.properties](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/resources/application.properties)

| Property | Value | Explanation |
| :--- | :--- | :--- |
| `spring.datasource.url` | `jdbc:mysql://localhost:3306/dealerconnect` | Defines the address, port, and name of our database. |
| `spring.datasource.driver-class-name` | `com.mysql.cj.jdbc.Driver` | The "translator" that allows Java to speak to the specific MySQL 8 core. |
| `spring.jpa.hibernate.ddl-auto` | `update` | **Auto-Schema Engine**: Automatically creates or updates your tables whenever you add a new `@Entity` in Java. |

---

## 💎 3. The ORM Engine (Hibernate)

Instead of writing manual `INSERT` or `SELECT` strings, we use **Entities**.

### 📄 Entity Mapping
**Key File**: [Employee.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/entity/Employee.java)

| Annotation | Responsibility |
| :--- | :--- |
| `@Entity` | Tells Spring this class represents a table in MySQL. |
| `@Table(name = "employees")` | Explicitly names the table. |
| `@Column(unique = true)` | Enforces a database constraint (e.g., no two employees can have the same email). |
| `@ManyToOne` | Handles complex relationships (e.g., many employees belong to one Dealer). |

---

## 🔍 4. The Repository Pattern

We use **Spring Data JPA Repositories** to handle all CRUD (Create, Read, Update, Delete) operations.

**Key Interface**: `EmployeeRepository.java`
- By extending `JpaRepository<Employee, Long>`, the system automatically provides methods like `save()`, `findById()`, and `delete()`.
- **Dynamic Queries**: You can write `findByEmail(String email)` and Spring will automatically generate the correct SQL query for you.

---

## 🛡️ 5. Transaction Safety

To ensure data integrity, we use the `@Transactional` annotation in our Service layer.

**Key File**: [DealerRegistrationService.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/service/impl/DealerRegistrationService.java)
- **All or Nothing**: If a process involves saving a Dealer **AND** an Employee, and the Employee save fails, `@Transactional` ensures the Dealer is also deleted. This prevents "half-saved" data or broken records.

---

## 📍 6. Database Location Map

| Category | File Path |
| :--- | :--- |
| **Connection Settings** | `backend/src/main/resources/application.properties` |
| **Java Models (Entities)** | `backend/src/main/java/com/dealerconnect/entity/` |
| **SQL Queries (Repositories)** | `backend/src/main/java/com/dealerconnect/repository/` |
| **Liquibase / SQL Seeds** | `backend/src/main/resources/sql/` |

---

### 💡 Phase 1 Persistence Summary
By integrating MySQL this way, we gain:
1.  **Type Safety**: Every database column is represented by a Java variable (String, Long, Date).
2.  **Performance**: Hibernate uses connection pooling to ensure the DB stays fast even with 100+ simultaneous users.
3.  **Flexibility**: Because we use JPA, we could switch from MySQL to PostgreSQL or Oracle in the future by changing just one line in the configuration.
