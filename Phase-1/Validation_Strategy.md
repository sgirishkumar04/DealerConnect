# 🛡️ Phase 1: Validation Strategy (Client & Server)

This document explains our multi-layered approach to data integrity. We validate data at two critical points: in the **Browser (UX)** and on the **Server (Security)**.

---

## 🏗️ 1. The Dual-Layer Strategy

| Layer | Responsibility | Primary Goal |
| :--- | :--- | :--- |
| **Client-Side** (Angular) | Providing instant feedback while the user types. | **User Experience (UX)**: Stop bad data before it hits the network. |
| **Server-Side** (Spring) | Final gatekeeper for the database. | **Data Security**: Protect the system from direct API attacks or bypasses. |

---

## 🎨 2. Client-Side Validation (Angular 17)

We use **Reactive Forms** which allow us to define validation logic in TypeScript rather than the HTML template.

**Key File**: [customer-form.component.ts](file:///Users/sgirishkumar/Documents/DealerConnect/frontend/src/app/features/customers/customer-form/customer-form.component.ts)

| Line | Feature | Technical Implementation |
| :--- | :--- | :--- |
| 100-107 | `Validators` | Defines requirements: `Validators.required`, `Validators.email`, and `Validators.pattern` (regex). |
| 102 | Phone Validation | `Validators.pattern('^[0-9]{10}$')` - Ensures exactly 10 digits are entered. |
| 31 | `mat-error` | Displays a red error message instantly if the specific control fails its pattern check. |
| 138-142 | `onSubmit()` | Blocks the save action if the form is invalid, showing a "Please fix errors" snackbar. |

---

## ⚙️ 3. Server-Side Validation (Spring Boot 3)

The backend uses the **Jakarta Validation (JSR-380)** standard. This is the "Truth" of the data.

### 🍱 The DTO (Data Transfer Object)
**Key File**: [CustomerRequest.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/dto/request/CustomerRequest.java)

| Line | Code | Responsibility |
| :--- | :--- | :--- |
| 9 | `@NotBlank` | Ensures the string isn't null, empty (""), or only whitespace. |
| 10 | `@Size(max = 80)` | Enforces the exact database column length limit to prevent SQL errors. |
| 12 | `@Email` | Validates the email format according to standard RFC rules. |

### 👮 The Controller Enforcement
**Key File**: [CustomerController.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/controller/CustomerController.java)

| Line | Code | Explanation |
| :--- | :--- | :--- |
| 33 | `@Valid @RequestBody` | The `@Valid` annotation tells Spring: "Before running my code, check the annotations inside CustomerRequest. If they fail, throw an exception." |

---

## 🛡️ 4. Global Error Resilience (The Safety Net)

If the server-side validation fails, we don't want to return a "raw" Java error. We use a **Global Exception Interceptor** to format the response.

**Key File**: [GlobalExceptionHandler.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/exception/GlobalExceptionHandler.java)

- **Line 43 (`handleValidationErrors`)**: Catches the `MethodArgumentNotValidException` thrown by Spring.
- **Functionality**: It loops through all failed fields and builds a clean JSON object like this:
  ```json
  {
    "phone": "Valid 10-digit number required",
    "email": "Must be a valid email format"
  }
  ```
- This ensures the frontend can easily read and display the server's warnings.

---

## 📍 5. Where is the Code?

| Category | UI / Frontend Location | Logic / Backend Location |
| :--- | :--- | :--- |
| **Validators** | `Validators.*` (in feature modules) | `@NotBlank`, `@NotNull` (in DTOs) |
| **Feedback UI** | `mat-error` (in HTML templates) | `GlobalExceptionHandler.java` |
| **Regex Patterns** | Components (e.g., `^[0-9]{10}$`) | Entity Constraints (e.g., `length = 20`) |

---

### 💡 Phase 1 Validation Summary
By validating on both ends:
1.  **Fast UI**: Users corrected errors immediately without waiting for a server reload.
2.  **Trustless API**: The backend never "trusts" the frontend. Even if someone uses Postman to bypass the UI, the backend will still block invalid data.
3.  **Data Integrity**: Your database never receives "corrupt" data (like an 11-digit phone number or a missing first name).
