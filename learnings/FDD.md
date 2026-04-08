# 📋 Functional Design Document (FDD)
## Project Name: DealerConnect DMS
## Version: 1.0 (Phase 1 MVP Release)
## Document Status: Approved
## Date: April 8, 2026

---

## 1. Introduction
### 1.1 Purpose
The purpose of this Functional Design Document (FDD) is to define the functional requirements and system behavior for the DealerConnect Dealer Management System (DMS). This document serves as the single source of truth for the development, testing, and QA teams throughout the software development lifecycle, strictly adhering to the Waterfall methodology. It details business rules, system workflows, and operational constraints.

### 1.2 Scope
DealerConnect is a multi-tenant Software-as-a-Service (SaaS) platform designed to digitize end-to-end automobile dealership operations. Phase 1 (MVP) scope includes:
- Security & Identity Management (Multi-Role RBAC).
- Multi-Dealer Data Isolation (Multi-Tenancy).
- Master Data Configuration (Lookups).
- Sales Pipeline (Leads, Bookings).
- Vehicle Inventory Management.
- Service Appointment Scheduling.
- Enterprise Audit Logging.

### 1.3 Target Audience
- Systems Analysts & Architects
- Development Team (Frontend & Backend)
- Quality Assurance (QA) Engineers
- Stakeholders & Product Owners

---

## 2. System Architecture Overview
The system follows a decoupled, three-tier architecture:
- **Presentation Layer**: Angular 17 SPA, utilizing Material UI components, reactive forms, and role-based dynamic DOM rendering.
- **Application Layer**: Spring Boot 3.x REST API, stateless JWT authentication via Spring Security, and method-level authorization barriers.
- **Data Layer**: MySQL 8.x Relational Database in 3rd Normal Form (3NF), optimized with HikariCP connection pooling, unique constraints, and QueryDSL dynamic querying.

### 2.1 Multi-Tenancy Strategy
A **Row-Level Isolation** strategy is enforced. Every transaction table (Leads, Bookings, Vehicles, Employees) contains a `dealer_id` foreign key. An interceptor/context object (`DealerContext`) transparently appends the `dealer_id` from the authenticated user's JWT to all database queries, physically preventing cross-tenant data leakage at the code level.

---

## 3. Functional Requirements by Module

### 3.1 Security & Identity Management (IAM)
#### 3.1.1 Authentication
- **FR_IAM_01**: The system shall authorize users via standard email and password credentials.
- **FR_IAM_02**: Passwords shall be cryptographically hashed using the BCrypt algorithm prior to database persistence. Plain text storage is strictly prohibited.
- **FR_IAM_03**: Upon successful authentication, the system shall issue a stateless JSON Web Token (JWT) signed with HMAC SHA-256. The token payload must contain the `userId`, `email`, `dealerId`, and an array of aggregated permissions.
- **FR_IAM_04**: Tokens shall have a predefined Time-to-Live (TTL) of 8 hours.

#### 3.1.2 Authorization & Role-Based Access Control (RBAC)
- **FR_IAM_05**: The system shall support Multiple Concurrent Roles per Employee (e.g., an employee can be both "Sales Manager" AND "Inventory Specialist") via a Many-to-Many mapping.
- **FR_IAM_06**: Permissions from all assigned roles shall be securely aggregated (Union) during the JWT generation phase.
- **FR_IAM_07**: Security shall be rigidly enforced at both the HTTP routing level (URL Patterns) and the Java Method level (`@PreAuthorize("hasAuthority(...)")`).
- **FR_IAM_08**: The GUI shall conditionally render navigation menus and action buttons based strictly on the user's aggregated permission set loaded from the JWT.

#### 3.1.3 Account Lifecycle & Brute Force Protection
- **FR_IAM_09**: The system shall track `failed_login_attempts`. On the 5th consecutive failure, the account's `is_locked` flag shall logically toggle to TRUE, explicitly denying further access regardless of credential correctness.
- **FR_IAM_10**: System Administrators shall possess the capability to manually unlock accounts. A successful login resets the failure counter to 0.
- **FR_IAM_11**: The system shall enforce an `expiry_date` on employee accounts. Authentication shall be denied if the current system date exceeds the account expiry.

### 3.2 Lead Management (CRM Front-End)
#### 3.2.1 Lead Capture
- **FR_LEAD_01**: Sales Executives shall capture leads with mandatory associations: Customer (Existing or New), Lead Source, and Assigned Executive.
- **FR_LEAD_02**: New Customer creation during Lead capture necessitates First Name, Last Name, and a valid Phone Number.
- **FR_LEAD_03**: The system shall programmatically generate a temporally unique `lead_number` sequentially upon initialization.

#### 3.2.2 Lead Pipeline & Kanban Board
- **FR_LEAD_04**: Leads shall progress through enumerated states: `NEW`, `CONTACTED`, `TEST_DRIVE`, `NEGOTIATION`, `BOOKED`, `LOST`, `DELIVERED`.
- **FR_LEAD_05**: A Kanban UI shall provide optimistic drag-and-drop state transitions, synchronizing with the backend API asynchronously.
- **FR_LEAD_06**: Invalid pipeline regressions (e.g., reverting from `DELIVERED` back to `TEST_DRIVE`) must be programmatically rejected by service layer logic.

### 3.3 Vehicle Inventory Management
#### 3.3.1 Stock Base Tracking
- **FR_INV_01**: The system shall record vehicles enforcing a mandatory 17-character Unique `vin`, an optional `engine_number`, `chassis_number`, and mandatory mapping to `variant_id`, `color_id`, and `dealer_id`.
- **FR_INV_02**: Vehicle status lifecycle must traverse: `IN_STOCK`, `ALLOCATED`, `SOLD`, `IN_TRANSIT`, `DEMO`.

#### 3.3.2 Dynamic Search & Cascading Workflows
- **FR_INV_03**: The UI shall implement cascading dropdowns: Selecting a `VehicleModel` dynamically triggers an API call (`/lookup/vehicle-variants/{modelId}`) to populate the dependent `VehicleVariant` dropdown, preventing orphaned constraints.
- **FR_INV_04**: The system shall facilitate complex, type-safe filtering (via QueryDSL predicate builders), allowing users to intersect multiple inventory constraints (Model AND Color AND Status).

### 3.4 Sales & Bookings Processing
#### 3.4.1 Booking Instantiation
- **FR_BKG_01**: A formally accepted booking shall inextricably link a valid `Customer`, chosen `VehicleVariant` & `Color`, assigned `Sales Executive`, and formulate a unique `booking_number`.
- **FR_BKG_02**: Financial derivations shall be calculated concurrently and consistently: `total_on_road` = `ex_showroom` - `discount` + `accessories_amt` + `tcs_amt` + `registration_amt` + `insurance_amt`.
- **FR_BKG_03**: All monetary fields require numeric precision to 2 decimal places to maintain accounting integrity.

#### 3.4.2 Allocation & Invoicing Logic
- **FR_BKG_04**: Allocating a physical vehicle to a booking must idempotently update the corresponding Vehicle entity's status to `ALLOCATED`. A vehicle must fundamentally be in the `IN_STOCK` status to be eligible for allocation.
- **FR_BKG_05**: Generating a system Invoice finalizes the booking status to `INVOICED` and perpetually "locks" the financial scalars from subsequent mutation.

### 3.5 Service & Workshop Floor
#### 3.5.1 Operations Scheduling
- **FR_SRV_01**: Service Advisors shall instantiate service appointments assigning a `Customer`, `vehicle_reg_no`, specific `appointment_date`, and categorized `service_type` (`PERIODIC`, `REPAIR`, `ACCIDENTAL`, `WARRANTY`, `RECALL`, `GENERAL_CHECKUP`).
- **FR_SRV_02**: Service tickets shall procedurally transition through `SCHEDULED`, `IN_PROGRESS`, `COMPLETED`, `CANCELLED`.

### 3.6 Automated Enterprise Auditing Framework
#### 3.6.1 JPA Framework Hooking
- **FR_AUD_01**: The system shall autonomously inject lifecycle metadata on all persistence flush events, abstracting the responsibility from individual service methods.
- **FR_AUD_02**: Architectural imperative: All core persistence entities (`Employee`, `Lead`, `Vehicle`, `Customer`, `Booking`, `ServiceAppointment`) must inherit from `AbstractAuditable`.
- **FR_AUD_03**: The auditing listener shall reliably populate `created_at` (LocalDateTime), `updated_at` (LocalDateTime), `created_by` (String resolver), and `updated_by` (String resolver) derived from the active `SecurityContext`.

#### 3.6.2 Granular Audit Log Aggregation
- **FR_AUD_04**: High-impact business events (CREATE, UPDATE, DELETE) shall trigger asynchronous event publishers to append an immutable record to the analytical `audit_logs` table, storing `entity_name`, `entity_id`, operational `action`, serialized `old_value`, and serialized `new_value`.

---

## 4. Master Data & Lookups (Reference Data Dictionary)
To ensure referential data integrity and eliminate rigid hard-coded values, the system accesses dictionaries via centralized `/lookup` API endpoints.
**Critical Dictionaries Include:**
- `/lookup/vehicle-models`: Defines manufacturing models (e.g., Hyundai Creta).
- `/lookup/vehicle-variants`: Defines specific engine/trim variants corresponding to Models.
- `/lookup/colors`: Defines manufacturer color codes.
- `/lookup/banks`: Authorized finance loan providers.
- `/lookup/lead-sources`: Marketing ingestion vectors (Walk-in, Digital, Referral).

*Architectural Constraint*: All lookup endpoints must apply cache-control headers (e.g., `Cache-Control: max-age=3600`) to mitigate redundant RDBMS throughput.

---

## 5. Non-Functional Requirements (NFR)
### 5.1 Performance Standards
- **API Latencies**: 95th Percentile (P95) of transactional read requests must resolve within 200ms round-trip.
- **Connection Telemetry**: HikariCP pooling must be tuned (min-idle, max-pool-size) to absorb connection bursts gracefully, preventing downstream database connection exhaustion.
- **Windowed Pagination**: Systemic design mandates that any query potentially projecting >50 records MUST enforce server-side pagination offsets to preserve memory bounds.

### 5.2 Security & Cyber Defense
- **XSS Mitigation**: Client-side frameworks (Angular) must enforce strict contextual DOM sanitization.
- **SQL Injection Prevention**: Data access patterns are strictly restricted to parameterized queries formulated via Hibernate/Spring Data JPA criteria. Raw SQL concatenation is forbidden.
- **Endpoint Protection**: No authenticated API endpoint shall leak unmasked Personally Identifiable Information (PII) beyond the consumer's privilege boundary.

### 5.3 Reliability, Consistency & Error Handling
- **Exception Facade**: The REST Controller layer must never emit raw Java Stack Traces in HTTP 500 Responses. All errors invoke a `@ControllerAdvice` global handler to return a normalized JSON payload detailing the logical HTTP status code and a sanitized, actionable message.
- **ACID Transaction Isolation**: Service mutations must run within rigid `@Transactional` boundaries. Repetitive read anomalies are suppressed using `REPEATABLE_READ` isolation protocols during high-concurrency dealership floor activity.

---

## 6. Document Sign-Off
By signing below, the project stakeholders agree that this Functional Design Document accurately represents the system requirements for the initial software development sprint.

| Project Role | Authorized Name | Date Addressed | Digital Signature |
| :--- | :--- | :--- | :--- |
| **Product Manager** | [TBD] | [Date] | ________________ |
| **Lead Developer Architect** | [TBD] | [Date] | ________________ |
| **Quality Assurance Lead** | [TBD] | [Date] | ________________ |

-- END OF DOCUMENT --
