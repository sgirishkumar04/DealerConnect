# 🚨 Phase 1: Exception & Error Handling

This document explains how **DealerConnect** handles failures. We ensure that when something goes wrong, the user gets a clear message, and the developer gets the technical details.

---

## 🛡️ 1. Server-Side Safety Net (Spring Boot)

We use a **Global Exception Handler** to catch every error before it leaves the server. This prevents the "Whitelabel Error Page" and ensures every error is returned as clean JSON.

**Key File**: [GlobalExceptionHandler.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/exception/GlobalExceptionHandler.java)

### 🍱 The Mapping Logic
The handler maps technical Java exceptions to user-friendly HTTP Status Codes.

| Exception Class | Status Code | Explanation |
| :--- | :--- | :--- |
| `ResourceNotFoundException` | **404** Not Found | User searched for an ID that doesn't exist. |
| `BadCredentialsException` | **401** Unauthorized | Incorrect password or invalid JWT. |
| `AccessDeniedException` | **403** Forbidden | Logged in user doesn't have the right role. |
| `MethodArgumentNotValidException` | **400** Bad Request | Fails validation (e.g., missing phone number). |
| `DataIntegrityViolationException` | **409** Conflict | Database collision (e.g., duplicate Email). |
| `Exception.class` | **500** Internal Error | Anything unexpected (logged for developers). |

---

## 🎨 2. Client-Side Resilience (Angular)

The frontend intercepts these errors before they can crash the UI.

### 👮 The Error Interceptor
**Key File**: [error.interceptor.ts](file:///Users/sgirishkumar/Documents/DealerConnect/frontend/src/app/core/interceptors/error.interceptor.ts)

- **Line 14**: If the server returns a **401 (Unauthorized)**, the intercepter knows the user's session has expired. It automatically calls `auth.logout()` to redirect them to the login page.
- **Line 21**: For all other errors, it passes the full technical response down to the component that made the request.

---

## 💬 3. User Feedback Patterns

When a component (like the Customer Form) receives an error from the Interceptor, it uses the **MatSnackBar** to show a toast message.

**Example Logic**:
```typescript
error: (err) => {
  // Line 182 of customer-form.component.ts
  const msg = err.error?.message || 'Error saving customer.'; 
  this.snack.open(msg, 'Close', { duration: 5000 });
}
```

- **Clean Messages**: The user sees: "Duplicate Email found."
- **Fallback**: If the server doesn't give a specific reason, the UI shows a generic: "An unexpected error occurred."

---

## 📍 4. Where is the Code?

| Layer | Responsibility | Code Path |
| :--- | :--- | :--- |
| **Backend Catch-all** | Global Controller Advice | `exception/GlobalExceptionHandler.java` |
| **Custom Errors** | Specific Business Exceptions | `exception/ResourceNotFoundException.java` |
| **Frontend Monitor** | Global HTTP Interceptor | `core/interceptors/error.interceptor.ts` |
| **User Alerting** | Material Toast Notifications | `MatSnackBar` (in Components) |

---

### 💡 Phase 1 Error Summary
By implementing this unified strategy:
1.  **Stability**: No raw Java tracebacks ever reach the user's browser (Security).
2.  **Graceful Recovery**: If a token expires, the user is logged out automatically instead of seeing broken tables.
3.  **Actionable Feedback**: Because the backend provides the exact field that failed, the user knows exactly what to fix in a form.
