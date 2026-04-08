# 🧪 Exhaustive QA Test Cases (Jira Format)
## Project: DealerConnect DMS
## Type: Zephyr / Xray Test Cases (End-to-End Suite)
## Status: Ready for Jira Import/Execution

This is the exhaustive End-to-End (E2E) Test Suite. It covers all UI/Frontend validations, backend edge cases, database constraints, and module-specific workflows from the Login page to deep Master Data configurations.

---

### **Module 1: Authentication & UI Security**

| Summary (Jira Title) | Priority | Preconditions | Test Steps (Action) | Expected Result (Verification) |
| :--- | :--- | :--- | :--- | :--- |
| **TC-IAM-01:** Verify User Login with Valid Credentials | Highest | Application is deployed; User exists with status `isActive=true`. | 1. Navigate to `/login`.<br>2. Enter valid Email and Password.<br>3. Click 'Sign In'. | User is authenticated. A JWT token is stored securely. The user is redirected to the dashboard based on their role. |
| **TC-IAM-02:** Verify Account Lockout after 5 Failed Attempts. | High | User account exists and is unlocked. | 1. Navigate to `/login`.<br>2. Enter invalid credentials 5 times.<br>3. Attempt login with correct credentials. | 1-5 tries: "Invalid Credentials" error. <br>6th try: System blocks login and displays "Account Locked." Database `is_locked` flag is `true`. |
| **TC-IAM-03:** Verify Access Denial for Expired Accounts. | High | Admin sets the user's `expiry_date` to a past date. | 1. Enter valid credentials for the expired account.<br>2. Click 'Sign In'. | Login is denied with message "Account Expired". JWT token is NOT issued. |
| **TC-IAM-04:** Verify Multi-Role Permission Aggregation. | Medium | User is assigned both "Sales Manager" and "Inventory Staff" roles. | 1. Login with credentials.<br>2. Inspect UI navigation and API calls. | User successfully sees both Sales modules AND Inventory modules. JWT payload contains a flattened array of merged permissions. |
| **TC-UI-01:** Verify Frontend Form Validation on Login. | Medium | Navigate to `/login`. | 1. Leave Email and Password empty.<br>2. Click 'Login'. | Angular form prevents submission. Required field validation messages appear. |
| **TC-UI-02:** Verify Sidebar Navigation Rendering based on JWT. | High | User has `LEADS_VIEW` but lacks `PARTS_VIEW`. | 1. Login.<br>2. Check Sidebar. | "Leads" menu item is visible. "Spare Parts" menu item is completely hidden from the DOM. |
| **TC-UI-03:** Verify Route Guards prevent manual URL access. | High | User logged in without `PARTS_VIEW`. | 1. Manually type `http://localhost:4200/parts` into browser address bar. | Angular AuthGuard redirects user to `/unauthorized` or `/dashboard`. Route cannot be bypassed. |
| **Edge-IAM-05:** Verify Login Prevention for Deactivated Dealership. | High | Dealer entity status set to `DEACTIVATED`. | 1. Login with correct credentials acting as an employee of the deactivated dealership. | Login rejected. Specific `DisabledException`: "The dealership [Name] has been deactivated." |

---

### **Module 2: Customer Management (Master Data)**

| Summary (Jira Title) | Priority | Preconditions | Test Steps (Action) | Expected Result (Verification) |
| :--- | :--- | :--- | :--- | :--- |
| **TC-CUS-01:** Verify Customer Creation with required fields. | High | Logged in with Customer creation rights. | 1. Go to Customers -> Add New.<br>2. Enter First Name, Last Name, Phone.<br>3. Save. | Customer created. Auto-generated `customer_code` is assigned. |
| **TC-CUS-02:** Verify Phone Number Regex Validation. | Medium | Add New Customer form open. | 1. Enter an invalid phone (e.g., "123" or text). | UI prevents saving. Shows "Invalid phone number format." |
| **TC-CUS-03:** Verify duplicate Customer detection mapping. | Medium | Customer exists with Phone "9998887776". | 1. Create a new lead/customer with "9998887776". | System prompts that customer already exists or automatically maps the Lead to the existing Customer ID. |

---

### **Module 3: CRM & Lead Pipeline**

| Summary (Jira Title) | Priority | Preconditions | Test Steps (Action) | Expected Result (Verification) |
| :--- | :--- | :--- | :--- | :--- |
| **TC-CRM-01:** Verify Lead Capture Form Validations. | Medium | Lead creation form open. | 1. Attempt to save without selecting a Lead Source or Assigned Executive. | Application rejects the form locally informing user of required dropdowns. |
| **TC-CRM-02:** Verify Kanban Board visual drag-and-drop. | High | Lead exists in `NEW` state. | 1. Drag Lead card from `NEW` to `CONTACTED`. | API triggers `PATCH`. Lead updates visually. UI SnackBar shows "Lead Updated." |
| **TC-CRM-03:** Verify prevention of invalid pipeline skips. | Medium | Lead exists in `NEW` state. | 1. Attempt to force transition directly to `DELIVERED` status via API. | Backend rejects the transition. Validation Error: "Invalid state transition." |
| **Edge-CRM-04:** Verify Automatic Booking Hydration on Lead State BOOKED. | High | Lead exists in `NEGOTIATION`. | 1. Transition Lead to `BOOKED`. | Backend auto-generates a Booking record mapping vehicle variants uniquely. |
| **Edge-CRM-05:** Verify Cascading Deletion logic when Deleting a Lead. | High | Lead exists with linked Booking, Invoice, and Loan records. | 1. Execute `DELETE /leads/{id}`. | Lead deleted securely. Native JDBC queries cascade and sequentially delete Loan, Invoice, and Booking dependencies averting SQL foreign key errors. |

---

### **Module 4: Vehicle Inventory & Lookups**

| Summary (Jira Title) | Priority | Preconditions | Test Steps (Action) | Expected Result (Verification) |
| :--- | :--- | :--- | :--- | :--- |
| **TC-INV-01:** Verify Cascading Dropdowns for Vehicle Creation. | High | Reference models and variants exist. | 1. Go to Add Vehicle.<br>2. Select "Hyundai Creta".<br>3. Open Variant dropdown. | Variant dropdown isolates trims mathematically associated with "Creta". |
| **TC-INV-02:** Verify duplicate VIN constraint is enforced. | High | Vehicle with VIN "VIN123XYZ" exists. | 1. Create new vehicle with VIN "VIN123XYZ". | Database unique constraint fires, Controller translates to clean "VIN already registered" API error. |
| **TC-INV-03:** Verify Lookup Caching Headers. | Low | System running. | 1. Inspect Network Tab.<br>2. Hit `/lookup/vehicle-models`. | API responds with `Cache-Control: max-age` ensuring the frontend caches reference lists aggressively. |
| **Edge-INV-04:** Verify Vehicle Demolition securely un-allocates active Bookings. | Critical | Vehicle is `ALLOCATED` to Booking X. | 1. Execute `DELETE /vehicles/{id}`. | Vehicle deleted. Booking X `vehicle_id` sets correctly to NULL and Booking status resets safely to `BOOKED` via JDBC hook. |

---

### **Module 5: Sales, Bookings & Financials**

| Summary (Jira Title) | Priority | Preconditions | Test Steps (Action) | Expected Result (Verification) |
| :--- | :--- | :--- | :--- | :--- |
| **TC-SLS-01:** Verify accurate 'On-Road Price' UI Calculation. | Highest | Logged in as Sales Exec. Booking Form open. | 1. Enter: Ex-Showroom: 1000, Discount: 50, Accessories: 100, Taxes: 10.<br>2. Check UI real-time total block. | Client-side reactive form calculates sum dynamically before API submission exactly to 1060.00. |
| **TC-SLS-02:** Verify negative numbers are blocked in Financials. | High | Booking form open. | 1. Type "-500" into Discount or Accessories column. | Angular prevents negative numerical input, rejecting submission. |
| **TC-SLS-03:** Verify Vehicle Allocation shifts status correctly. | High | Vehicle #99 is `IN_STOCK`. Booking #55 is created. | 1. Allocate Vehicle #99 to Booking #55. | Vehicle #99 status automatically changes from `IN_STOCK` to `ALLOCATED` shielding it from double-sales. |
| **TC-SLS-04:** Verify Invoice Generation locks financial mutations. | High | Booking #55 is `ALLOCATED`. | 1. Generate Invoice.<br>2. Attempt to `PUT /bookings/{id}` modifying `discount`. | System rejects the API update: "Cannot alter financials, booking is already INVOICED." |
| **Edge-SLS-05:** Verify automatic Guest Customer provisioning. | Medium | API Booking creation missing `customerId`. | 1. Provide only `customerName` "John Smith" via API POST. | Intercepts missing ID. Injects a new Customer entity mapping the relationship silently. |

---

### **Module 6: Spare Parts & Workshop Operations**

| Summary (Jira Title) | Priority | Preconditions | Test Steps (Action) | Expected Result (Verification) |
| :--- | :--- | :--- | :--- | :--- |
| **TC-PRT-01:** Verify Spare Part unique part number enforcement. | Medium | Part "P123" exists. | 1. Add new Spare Part using "P123". | API rejects duplicate part saving local UI duplication. |
| **TC-SRV-01:** Verify Workshop Load visibility isolation. | High | User A is in Dealer 1. | 1. View Service Appointments calendar. | Only vehicles assigned to Dealer 1 show on the workflow. |
| **TC-SRV-02:** Verify Appointment status progression. | Low | Appointment is `SCHEDULED`. | 1. Move status via UI dropdown to `COMPLETED`. | Status transitions successfully update DB and UI immediately refreshes grid view. |

---

### **Module 7: Enterprise Audit & Dashboarding**

| Summary (Jira Title) | Priority | Preconditions | Test Steps (Action) | Expected Result (Verification) |
| :--- | :--- | :--- | :--- | :--- |
| **TC-AUD-01:** Verify abstract audit fields are auto-populated. | High | Logged in as user X (ID: 5). | 1. Create a Customer.<br>2. Query database. | `created_by` equals "5", `created_at` timestamp matches exact server time transparently. |
| **TC-AUD-02:** Verify detailed action logging in `audit_logs` table. | High | Lead exists. | 1. Change Lead status from `TEST_DRIVE` to `NEGOTIATION`. | Immutable log entry appears showing Entity: Lead, Action: UPDATE, Old Value: `TEST_DRIVE`, New Value: `NEGOTIATION`. |
| **TC-SAD-01:** Verify Super Admin vs Local Admin Chart Scope. | Highest | Super Admin and Local Admin users exist. | 1. Login as Super Admin... verify Top Models Chart.<br>2. Login as Local Admin... verify Top Models Chart. | Super Admin sees Network-wide aggregates across all DBs. Local Admin payload is strictly intercepted by `DealerContext` returning only local data. |
| **Edge-AUD-03:** Verify Audit Resilience on JSON Serialization Failure. | High | Complex Entity graph triggers StackOverflow during jackson `writeValueAsString`. | 1. Delete hierarchically complex Booking tree. | Service log catches `ObjectMapper` exception smoothly, logs warning, but fundamentally allows business-logic transaction to persist averting systemic deadlock. |
