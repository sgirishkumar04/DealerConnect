# 👥 Module 2: Employee & User Management Flow

This module handles the internal staff of the dealership, their roles, and their data isolation (Multi-Tenancy).

---

## 🏛️ Architecture Components
1. **EmployeeController**: `backend/src/main/java/com/dealerconnect/controller/EmployeeController.java`
2. **EmployeeService**: `backend/src/main/java/com/dealerconnect/service/impl/EmployeeService.java`
3. **EmployeeRepository**: `backend/src/main/java/com/dealerconnect/repository/EmployeeRepository.java`
4. **DealerContext**: `backend/src/main/java/com/dealerconnect/security/DealerContext.java`
5. **Entities**: `backend/src/main/java/com/dealerconnect/entity/Employee.java`, `Role.java`, `Department.java`

---

## 🌊 The Complete Flow

### 1. Data Isolation (Multi-Tenancy)
- Every time a request comes in, the `JwtAuthFilter` extracts the `dealerId`.
- This ID is stored in the **`DealerContext`**.
- **The Result**: Every service call automatically knows which dealership it is working for.

### 2. Creating an Employee
- **Path**: `POST /api/v1/employees`.
- **Validation**:
    - Checks if `email` is already taken.
    - Checks if `employeeCode` is unique.
- **Auto-Logic**: The system automatically assigns the user to the current `dealerId` from the context.
- **Hiring**: The password is hashed using BCrypt before saving.

### 3. Permissions & Roles
- An Employee is linked to a **`Role`** via a Many-to-Many table.
- When an employee is loaded, their roles are fetched **EAGERLY** so that security checks can happen instantly.

### 4. Hierarchical Deactivation (Security Rule)
- A **Dealer Admin** can deactivate their own staff.
- However, an Admin cannot deactivate another Admin or a Super Admin. 
- This logic is enforced in `EmployeeService.deactivate()`.

### 5. Soft Delete Pattern
- We don't use the SQL `DELETE` command for staff.
- We flip the **`isActive`** flag to `false`.
- **Why?**: To preserve audit history (e.g., "Who sold this car in 2024?").

---

## 💡 "Reviewer Ready" Point
"Our employee module uses a **Scoped Repository** pattern. Every search for an employee is filtered by `dealer_id`, ensuring that an Admin from Dealership A can never accidentally or maliciously manage employees from Dealership B."
