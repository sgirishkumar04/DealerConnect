# 📊 Enterprise Jira Agile Suite: User Stories & QA Scenarios
## Project: DealerConnect DMS
## Type: Master Product Backlog (Epics, Stories, BDD Criteria & Test Cases)
## Status: Finalized for Jira Import

This document strictly follows the industry-standard Agile tracking framework utilized by enterprise software engineering teams. It organizes the DealerConnect DMS into **Epics**, granular **User Stories**, **BDD (Behavior-Driven Development) Acceptance Criteria**, and explicit **QA Test Cases (ready for Zephyr scale / Xray)**.

---

## 🚀 EPIC: DC-E100: Enterprise Identity & RBAC Security
**Epic Goal:** Establish a zero-trust security framework with Role-Based Access Control (RBAC) ensuring employees interact only with permitted scopes across multiple dealership branches.

### 📝 Story: DC-101 - Core Employee Authentication
**As a** Dealership Employee,
**I want to** log in securely using my institutional email and encrypted password,
**So that** I restrict unauthorized access to dealership financial and operational data.

*   **Story Points:** 5 
*   **Priority:** Highest / Blocker
*   **Assignee:** Backend / Frontend Teams

#### **Acceptance Criteria (BDD Approach)**
*   **Scenario 1: Valid Login.** `Given` the user is on the login page, `When` they enter valid credentials, `Then` the system issues an HTTP-Only JWT and routes them to the Dashboard.
*   **Scenario 2: Account Lockout.** `Given` the user tries to login, `When` they fail 5 consecutive times, `Then` they are locked out and a flag is updated in the database.
*   **Scenario 3: Deactivated Dealer.** `Given` a user belongs to a deactivated dealership, `When` they attempt to login, `Then` they are rejected with an explicit "Dealership Deactivated" exception regardless of a correct password.

#### **QA execution (Zephyr / Xray Test Cases)**

| TC ID | Summary (Jira Title) | Priority | Preconditions | Test Steps | Expected Result |
| :--- | :--- | :--- | :--- | :--- |
| **TC-IAM-001** | Verify Login via valid credentials. | Highest | Valid user exists. | 1. Go to `/login`. <br>2. Enter email & password. | 200 OK. JWT mapped securely. UI route changes securely to `/dashboard`. |
| **TC-IAM-002** | Verify Account Lockout on 6th attempt. | High | Valid user exists. | 1. Fail login 5 times.<br>2. Try with valid password on 6th time. | Error "Account locked". DB boolean `is_locked` is TRUE. |
| **TC-IAM-003** | Auto-Expiring JWT Token verification. | Medium | User is logged in. | 1. Wait out the 10-hour JWT expiration.<br>2. Attempt an API call. | 401 Unauthorized via Angular Interceptor, forces user back to `/login`. |

---

### 📝 Story: DC-102 - Dynamic Route Filtering via RBAC
**As a** System Administrator,
**I want** Angular and Spring Security to sync permission arrays,
**So that** employees physically cannot view components they lack access to.

*   **Story Points:** 8
*   **Priority:** High

#### **Acceptance Criteria (BDD Approach)**
*   **Scenario 1: Component Hiding.** `Given` a user lacks `LEADS_VIEW` permission, `When` the DOM renders, `Then` the "Leads" menu item is stripped entirely from the Sidebar.
*   **Scenario 2: Route Guarding.** `Given` a user lacks `PARTS_VIEW`, `When` they manually type `/parts` in the address bar, `Then` the front-end AuthGuard routes them to an Unauthorized page.

#### **QA execution (Zephyr / Xray Test Cases)**

| TC ID | Summary (Jira Title) | Priority | Preconditions | Test Steps | Expected Result |
| :--- | :--- | :--- | :--- | :--- |
| **TC-SEC-004** | Verify AuthGuard blocks direct URL access. | Highest | User lacks admin scopes. | 1. Type `http://localhost:4200/employees` in browser URL. | Angular routes user to `/dashboard` instantly. No API call is made. |
| **TC-SEC-005** | Verify Backend `@PreAuthorize` API rejection. | Highest | Logged in as base user. | 1. Execute `DELETE /api/v1/employees/1` via Postman targeting another user. | Backend returns explicit `403 Forbidden` response. |

---

## 🚀 EPIC: DC-E200: Omni-Channel CRM & Lead Pipeline
**Epic Goal:** Modernize the lead acquisition phase via a unified interactive Kanban process where customer conversion is visually tracked up until Booked/Invoiced status.

### 📝 Story: DC-201 - Interactive Lead Kanban Board
**As a** Sales Manager,
**I want to** see a column-based Kanban interface for leads,
**So that** I drag-and-drop leads seamlessly from "New" to "Negotiation/Booked".

*   **Story Points:** 5
*   **Priority:** High

#### **Acceptance Criteria (BDD Approach)**
*   **Scenario 1: Drag & Drop.** `Given` the Lead Kanban is open, `When` a user drags card "Lead X" to "Contacted", `Then` an automatic `PATCH` API call is fired executing the state transition.
*   **Scenario 2: State Restrictions.** `Given` a lead is marked `DELIVERED`, `When` a user attempts to drag it back to `NEW`, `Then` the UI rejects the drop action and shows an invalid transition error.

#### **QA execution (Zephyr / Xray Test Cases)**

| TC ID | Summary (Jira Title) | Priority | Preconditions | Test Steps | Expected Result |
| :--- | :--- | :--- | :--- | :--- |
| **TC-CRM-001** | Verify Kanban Drag & Drop API patch. | High | Lead in NEW column. | 1. Drag Lead card to CONTACTED column. | UI updates smoothly. Console confirms `PATCH /leads/{id}/status` completed. |
| **TC-CRM-002** | Verify Dropdown Cascades in Add Lead Form. | Medium | Add Lead dialog open. | 1. Select Model "Creta".<br>2. Open Variant dropdown. | Only Creta variants are visible. Dropdown disabled if no model picked. |
| **TC-CRM-003** | Verify Guest Customer hydration during Lead creation. | Medium | New customer. | 1. Fill out lead without hitting "search existing customer". | Backend automatically generates a `Customer` entity linking it to the newly formed `Lead`. |

---

## 🚀 EPIC: DC-E300: Live Inventory & Service Workflow Automation
**Epic Goal:** Prevent double-booking via real-time vehicular state-machines and isolate mechanical Service Workloads strictly by dealership branch.

### 📝 Story: DC-301 - Inventory VIN Protection & Allocation Rules
**As an** Inventory Clerk,
**I want** strict database constraints on Vehicle Identification Numbers,
**So that** two dealerships cannot mistakenly ingest the exact same vehicle into stock.

*   **Story Points:** 3
*   **Priority:** High

#### **Acceptance Criteria (BDD Approach)**
*   **Scenario 1: Global VIN Tracking.** `Given` a vehicle exists with VIN "123", `When` another user attempts to add VIN "123", `Then` a database constraint fires blocking it.
*   **Scenario 2: Automated Allocation.** `Given` a vehicle is "IN_STOCK", `When` it gets linked to a "BOOKED" transaction, `Then` its internal state immediately mutations to "ALLOCATED".

#### **QA execution (Zephyr / Xray Test Cases)**

| TC ID | Summary (Jira Title) | Priority | Preconditions | Test Steps | Expected Result |
| :--- | :--- | :--- | :--- | :--- |
| **TC-INV-001** | Enforce Unique VIN across network. | Blocker | Vehicle with VIN `XXX` in DB. | 1. API: `POST /vehicles` with VIN `XXX`. | 400 Bad Request. Controller catches JDBC DataIntegrityViolation and returns "VIN exists". |
| **TC-INV-002** | Verify Auto-Allocation from Booking link. | High | Vehicle #5 is IN_STOCK. | 1. Create a Booking attaching Vehicle #5. | Vehicle #5 `status` column automatically shifts to `ALLOCATED` via a core business service wrapper. |

---

### 📝 Story: DC-302 - Multi-Tenant Service Workload Isolation
**As a** Network Administrator,
**I want** Service Job Cards isolated tightly via JWT tenant variables,
**So that** a mechanic in Chennai cannot see or modify the open Job Cards of a mechanic in Mumbai.

#### **Acceptance Criteria (BDD Approach)**
*   **Scenario 1: Tenant Injection.** `Given` a local admin views Service Appointments, `When` the SQL queries run, `Then` they are automatically injected with `AND dealer_id = X` intercepting all reads/writes.

#### **QA execution (Zephyr / Xray Test Cases)**

| TC ID | Summary (Jira Title) | Priority | Preconditions | Test Steps | Expected Result |
| :--- | :--- | :--- | :--- | :--- |
| **TC-SRV-001** | Verify cross-dealer Job Card containment. | Highest | 1 DB holds Dealer A and B Job Cards. | 1. Login to Dealer A. Go to Service Jobs. | List strictly returns Dealer A vehicles. `GET /jobs/dealer/A` |

---

## 🚀 EPIC: DC-E400: Enterprise Analytics & Global Dashboards
**Epic Goal:** Present real-time KPIs through highly optimized Stored Procedures eliminating computational bottlenecks at the JVM tier.

### 📝 Story: DC-401 - Dashboard Procedural Speed Up
**As a** General Manager,
**I want** the analytics dashboard to compute revenue from millions of records in milliseconds,
**So that** I don't face timeouts scanning historical data.

*   **Story Points:** 13
*   **Priority:** High
*   **Assignee:** DBA Team / Analytics

#### **Acceptance Criteria (BDD Approach)**
*   **Scenario 1: Stored Procedure Logic.** `Given` a dashboard request for "Top Selling Models", `When` the controller resolves, `Then` the JVM does not process logic; instead it invokes `CALL GetTopSellingModels()` pushing math to MySQL natively.

#### **QA execution (Zephyr / Xray Test Cases)**

| TC ID | Summary (Jira Title) | Priority | Preconditions | Test Steps | Expected Result |
| :--- | :--- | :--- | :--- | :--- |
| **TC-AUD-001** | Verify `GetMonthlyBookings` procedure execution. | Highest | Routine exists on DB Server. | 1. Load Dashboard. | UI charts populate properly. SQL Trace shows `CALL GetMonthlyBookings()` running at ~0.005ms execution speed. |
| **TC-AUD-002** | Scope-Bypass for Super Admin. | Medium | User is SUPER_ADMIN. | 1. View network charts. | API sends `dealerId = null` to the stored procedure, allowing it to aggregate the parent franchise network natively. |
