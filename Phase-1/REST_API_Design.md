# 🌐 Phase 1: REST API Design

This document explains the standards and conventions used in the **DealerConnect API**. Our goal is to create a predictable, scalable, and secure interface for the frontend.

---

## 🏗️ 1. API Versioning

We use **URL-based versioning** to ensure that changes to the backend don't break existing frontend releases.

**Configuration**: `server.servlet.context-path=/api/v1` in `application.properties`.

- **Example**: `http://localhost:8080/api/v1/vehicles`
- **Benefit**: If we need to make a "breaking change" in the future, we can create `/api/v2` while keeping `/api/v1` running for older clients.

---

## 🏷️ 2. Naming Conventions

Our API follows the **Resource-Oriented Design** principle.

| Entity | Endpoint | Pattern |
| :--- | :--- | :--- |
| **Plural Nouns** | `/employees`, `/vehicles` | We always use plural nouns for collections. |
| **Specific Item** | `/vehicles/{id}` | Accesses one specific record by its Unique ID. |
| **Sub-Resources** | `/vehicles/{id}/details` | Used for actions or data nested within an object. |
| **Operations** | `/leads/next-number` | Used for specific utility actions that don't fit CRUD. |

---

## 🚦 3. HTTP Methods & Idempotency

We use the correct HTTP verbs to ensure the API is **Idempotent** (predictable).

| Verb | Usage | Idempotent? | Explanation |
| :--- | :--- | :--- | :--- |
| **GET** | Read | **YES** | Fetching data 100 times doesn't change anything on the server. |
| **POST** | Create | **NO** | Calling POST twice creates two different records (e.g., two bookings). |
| **PUT** | Update | **YES** | Replaces the whole record. Updating the same name twice has the same result as doing it once. |
| **PATCH** | Partial Update | **NO¹** | Updates only one field (like `status`). (¹Technically non-idempotent in specs, but used predictably here). |
| **DELETE** | Remove | **YES** | After the first deletion, the resource is gone. Future deletes result in the same "gone" state. |

---

## 🛡️ 4. OpenAPI / Swagger Integration

We use **OpenAPI 3.0** to provide interactive documentation.

**Key File**: [OpenApiConfig.java](file:///Users/sgirishkumar/Documents/DealerConnect/backend/src/main/java/com/dealerconnect/config/OpenApiConfig.java)

- **Interactive UI**: Navigate to `/api/v1/swagger-ui/index.html` to see every available API.
- **JWT Support**: The `Authorize` button allows you to paste your token, enabling you to test secured routes (like `/employees`) directly from the browser.
- **Validation Sync**: Swagger automatically picks up `@Valid` or `@NotBlank` annotations from your Java code and shows them as requirements in the UI.

---

## 📈 5. Standard Status Codes

Our API communicates results using industry-standard HTTP codes.

| Code | Meaning | Used In |
| :--- | :--- | :--- |
| **200 OK** | Success | GET, PUT, PATCH |
| **201 Created** | Created | POST (e.g., creating a new vehicle) |
| **204 No Content** | Deleted | DELETE |
| **400 Bad Request** | Validation Fail | Incorrect data sent by frontend |
| **401 Unauthorized** | Token Required | Missing or expired JWT |
| **403 Forbidden** | No Permission | Logged in user doesn't have the required Role. |
| **404 Not Found** | Missing Record | Search for an ID that doesn't exist. |

---

### 💡 Phase 1 API Summary
By strictly following these REST standards:
1.  **Developer Friendly**: Any backend/frontend developer can guess the URL structure without reading documentation (Predictability).
2.  **Scalable**: The stateless and idempotent nature makes the API easy to cache and load-balance.
3.  **Self-Documenting**: Swagger ensures that the UI team always knows exactly what fields to send and what to expect in return.
