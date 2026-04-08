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

#### **QA execution (Zephyr / Xray Test Cases)**

| TC ID | Summary (Jira Title) | Type | Preconditions | Test Steps | Expected Result |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **TC-IAM-001** | Verify Login with valid credentials. | Positive | Valid user exists. | 1. Go to `/login`<br>2. Enter correct email & password. | 200 OK. JWT generated. UI routes to `/dashboard`. |
| **TC-IAM-002** | Verify Account Lockout on 6th attempt. | Security | User exists. | 1. Fail login 5 times.<br>2. Try valid password on 6th. | Error "Account locked". DB boolean `is_locked` is TRUE. |
| **TC-IAM-003** | Auto-Expiring JWT Token verification. | Security | User is logged in. | 1. Wait out 10-hour JWT expiration.<br>2. Call API. | 401 Unauthorized via Angular Interceptor. Redirects to `/login`. |
| **TC-IAM-004** | Prevent Login for Deactivated Dealership. | Negative | Dealer is DEACTIVATED. | 1. Login with correct auth. | 403 Forbidden. "Dealership Deactivated" exception thrown. |

### 📝 Story: DC-102 - Dynamic Route Filtering via RBAC
**As a** System Administrator,
**I want** Angular and Spring Security to sync permission arrays,
**So that** employees physically cannot view components they lack access to.

*   **Story Points:** 8
*   **Priority:** High

#### **QA execution (Zephyr / Xray Test Cases)**

| TC ID | Summary (Jira Title) | Type | Preconditions | Test Steps | Expected Result |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **TC-SEC-005** | Verify AuthGuard blocks direct URL access. | Security | User lacks `ADMIN_VIEW`. | 1. Type `http://localhost:4200/employees` into browser. | Angular routes user to `/dashboard` instantly. No API call made. |
| **TC-SEC-006** | Verify Backend `@PreAuthorize` API rejection. | Security | Logged in as standard user. | 1. Execute `DELETE /api/v1/employees/1` via Postman. | Backend throws AccessDeniedException. Returns `403 Forbidden`. |
| **TC-SEC-007** | Verify UI Sidebar dynamic rendering. | UI | User lacks `PARTS_VIEW`. | 1. Login and inspect Sidebar. | The "Spare Parts" menu item is completely removed from the DOM. |

---

## 🚀 EPIC: DC-E200: Omni-Channel CRM & Lead Pipeline
**Epic Goal:** Modernize the lead acquisition phase via a unified interactive Kanban process where customer conversion is visually tracked up until Booked/Invoiced status.

### 📝 Story: DC-201 - Interactive Lead Kanban Board
**As a** Sales Manager,
**I want to** see a column-based Kanban interface for leads,
**So that** I drag-and-drop leads seamlessly from "New" to "Negotiation/Booked".

*   **Story Points:** 5
*   **Priority:** High

#### **QA execution (Zephyr / Xray Test Cases)**

| TC ID | Summary (Jira Title) | Type | Preconditions | Test Steps | Expected Result |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **TC-CRM-008** | Verify Kanban Drag & Drop API patch. | Positive | Lead in NEW column. | 1. Drag Lead card to CONTACTED. | UI updates smoothly. `PATCH /leads/{id}/status` completed. |
| **TC-CRM-009** | Prevent Invalid Kanban Transitions. | Negative | Lead is INVOICED. | 1. Drag INVOICED lead back to NEW via UI bypass. | API rejects transition throwing HTTP 400 "Invalid State Transition". |
| **TC-CRM-010** | Verify Dropdown Cascades in Add Lead. | UI | Add Lead dialog open. | 1. Select Model "Creta". | Variant dropdown isolates ONLY trims associated mathematically with Creta. |
| **TC-CRM-011** | Verify Guest Customer hydration during Lead entry. | Backend | New customer (no ID). | 1. Submit lead form with Name & Phone only. | Backend generates a new `Customer` entity and links it to the `Lead`. |
| **TC-CRM-012** | Cascading Delete on Abandoned Leads. | Database | Lead has multiple follow-up logs. | 1. Execute `DELETE /leads/{id}`. | Lead deleted securely. Native JDBC queries cascade and delete child logs without foreign key errors. |

---

## 🚀 EPIC: DC-E300: Live Inventory & Retail Operations
**Epic Goal:** Prevent double-booking via real-time vehicular state-machines and enforce high-fidelity financial locks on retail operations.

### 📝 Story: DC-301 - Inventory VIN Protection & Allocation Rules
**As an** Inventory Clerk,
**I want** strict database constraints on Vehicle Identification Numbers,
**So that** two dealerships cannot mistakenly ingest the exact same vehicle into stock.

*   **Story Points:** 3
*   **Priority:** Critical

#### **QA execution (Zephyr / Xray Test Cases)**

| TC ID | Summary (Jira Title) | Type | Preconditions | Test Steps | Expected Result |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **TC-INV-013** | Enforce Unique VIN across network. | Database | VIN `VIN123` in DB. | 1. API: `POST /vehicles` with `VIN123`. | 400 Bad Request. Controller catches DataIntegrityViolation and resolves cleanly. |
| **TC-INV-014** | Verify Auto-Allocation from Booking link. | E2E | Vehicle is IN_STOCK. | 1. Create a Booking attaching Vehicle. | Vehicle `status` column automatically shifts to `ALLOCATED` sealing it. |
| **TC-INV-015** | Vehicle Removal Un-Allocation Hook. | Edge | Vehicle is ALLOCATED to Booking X. | 1. Hardware loss. Delete Vehicle. | Vehicle dropped. Booking X `vehicle_id` resets to NULL. Booking reverts safely to `PENDING_STOCK`. |

### 📝 Story: DC-302 - Financial Booking & Retail Workflows
**As a** Sales Executive,
**I want** live reactive calculation of the vehicle Ex-Showroom + Accessories + Taxes,
**So that** I quote accurate On-Road prices natively on the Booking Form.

#### **QA execution (Zephyr / Xray Test Cases)**

| TC ID | Summary (Jira Title) | Type | Preconditions | Test Steps | Expected Result |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **TC-SLS-016** | Verify accurate 'On-Road Price' Calculation. | UI | Booking Form open. | 1. Input: Ex-Show: 1000, Disc: 50, Acc: 100, Tax: 10. | Angular Form computes exactly 1060.00 instantly. |
| **TC-SLS-017** | Block negative financial mutations. | Negative | Booking Form open. | 1. Input "-500" into Discount. | Angular validators trap and prevent submission. |
| **TC-SLS-018** | Verify Invoice Lock on Bookings. | Edge | Booking is marked `INVOICED`. | 1. Send API `PUT` to alter Booking discount. | API throws 409 Conflict. "Invoice generated. Financials locked." |

---

## 🚀 EPIC: DC-E400: Global Service & Workshop Management
**Epic Goal:** Segregate complex multi-branch workshop queues so mechanics only process local dealership cars while applying spare parts accurately.

### 📝 Story: DC-401 - Multi-Tenant Service Workload Isolation
**As a** Network Administrator,
**I want** Service Job Cards isolated tightly via JWT tenant variables,
**So that** a mechanic in Chennai cannot see or modify the open Job Cards of a mechanic in Mumbai.

#### **QA execution (Zephyr / Xray Test Cases)**

| TC ID | Summary (Jira Title) | Type | Preconditions | Test Steps | Expected Result |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **TC-SRV-019** | Multi-tenant Job Card containment. | Database | Dealer A and B Job Cards exist. | 1. Login to Dealer A. Search parts. | Query forcibly injected with `WHERE dealer_id=A`. Zero leak of Dealer B data. |
| **TC-SRV-020** | Duplicate Spare Part Number rejection. | Negative | Part `OIL-5W30` exists. | 1. Create part `OIL-5W30`. | 400 Bad Request. Item already registered. |
| **TC-SRV-021** | Ensure Service Job Card calculates Parts Total. | E2E | Job card open. | 1. Add Part 1 ($50) and Part 2 ($100). | Service total aggregates exactly to $150 before applying mechanic labor fees. |

---

## 🚀 EPIC: DC-E500: Enterprise Analytics & Global Dashboards
**Epic Goal:** Present real-time KPIs through highly optimized Stored Procedures eliminating computational bottlenecks at the JVM tier.

### 📝 Story: DC-501 - Dashboard Procedural Speed Up
**As a** General Manager,
**I want** the analytics dashboard to compute revenue from millions of records in milliseconds,
**So that** I don't face timeouts scanning historical data.

#### **QA execution (Zephyr / Xray Test Cases)**

| TC ID | Summary (Jira Title) | Type | Preconditions | Test Steps | Expected Result |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **TC-AUD-022** | Verify `GetMonthlyBookings` procedure output. | Database | DB contains April bookings. | 1. Load Dashboard. | UI populates. SQL Trace confirms `CALL GetMonthlyBookings(2026, id)` run natively. |
| **TC-AUD-023** | Ensure System Audit triggers fire. | Edge | User 5 updates Booking. | 1. Fire `PUT /bookings/1`. | Row seamlessly updates `updated_by` = 5 and `updated_at` = UTC NOW. |
| **TC-AUD-024** | Super Admin Cross-Branch Override. | Positive | SUPER_ADMIN user. | 1. View network charts. | API sends `dealerId = null` allowing calculation across entire network map. |
| **TC-AUD-025** | CSV Export integrity check. | Integrat. | Report view open. | 1. Click "Export CSV". | Browser downloads byte-stream. CSV headers perfectly match the SQL output schema. |
