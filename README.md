# DealerConnect Dealer Management System (DMS) — SaaS Edition

> **Production-Ready, Multi-Dealer, Full-Stack Automobile Showroom Platform.**
> This project is designed to manage every aspect of a DealerConnect dealership, from the first customer enquiry to the final vehicle delivery and long-term service maintenance.

---

## 🌟 Key Features

*   **Multi-Dealer Data Isolation**: Built on a multi-tenant architecture where every showroom's data (Leads, Sales, Service) is strictly isolated using `dealer_id`.
*   **Super Admin Dashboard**: Platform-level control to approve new dealer registrations, monitor network-wide inventory, and manage system roles.
*   **Professional Sales Funnel**: Tracks the entire journey: `Lead → Test Drive → Booking → Allocation → Invoice → Delivery`.
*   **Service Center Operations**: Comprehensive workshop management with Job Cards, Mechanic assignments, and Spare Part usage tracking.
*   **Historical Analytics**: Pre-loaded with 150+ professional historical records (2025-2026) to visualize Year-over-Year (YoY) growth and festive season trends.
*   **Audit Logging**: Every critical action (Created/Updated/Deleted) is logged with the user's name and IP address for full accountability.

---

## 🛠 Tech Stack

| Layer | Technology |
|:---|:---|
| **Frontend** | Angular 17+ (Material UI, Chart.js, RxJS) |
| **Backend** | Spring Boot 3.x (Java 17/21, Spring Security + JWT) |
| **Database** | MySQL 8.x (Third Normal Form, Stored Procedures) |
| **Observability** | Spring Boot Actuator (Health, Metrics, JSON Logging) |

---

## 🚀 Migration & Setup Guide (New Office Laptop)

Follow these 4 steps to set up the project on your new machine.

### 1. Database Initialization
Navigate to `database/laptop/` and run these 4 scripts in order on your MySQL instance:
1.  **[schema.sql](file:///Users/sgirishkumar/Documents/DealerConnect/database/laptop/schema.sql)**: Creates 37 tables, stored procedures, and initial roles.
2.  **[chennai_2025_historical.sql](file:///Users/sgirishkumar/Documents/DealerConnect/database/laptop/chennai_2025_historical.sql)**: Loads 150+ professional records for last year's reports.
3.  **[chennai_insert.sql](file:///Users/sgirishkumar/Documents/DealerConnect/database/laptop/chennai_insert.sql)**: Loads active 2026 showroom data and workshop workload.
4.  **[query.sql](file:///Users/sgirishkumar/Documents/DealerConnect/database/laptop/query.sql)**: Use this as a reference manual for all application queries.

### 2. Backend Setup
1. Open `backend/src/main/resources/application.properties`.
2. Update the `spring.datasource.username` and `password` to match your local MySQL credentials.
3. Run the application:
   ```bash
   ./mvnw spring-boot:run
   ```

### 3. Frontend Setup
1. Open a terminal in the `frontend/` directory.
2. Install dependencies:
   ```bash
   npm install
   ```
3. Start the application:
   ```bash
   npm start
   ```
4. Access the app at: `http://localhost:4200`

---

## 🔑 Access Credentials

| User Level | Email | Password |
|:---|:---|:---|
| **Platform Super Admin** | `superadmin@dealerconnect.com` | `SuperAdmin@123` |
| **Dealer Showroom Admin**| `admin@dealerconnect.com` | `Password@123` |
| **Sales Executive** | `rahul.v@dealerconnect.com` | `Password@123` |

---

## 📁 Project Structure

```text
DealerConnect/
├── database/laptop/      ← 100% Comprehensive Migration Scripts (REQUIRED)
├── backend/              ← Spring Boot APIs, Security, and Business Logic
│   ├── entity/           ← 30+ JPA Entities (Lead, Booking, Dealer, etc.)
│   ├── repository/       ← Data access with Stored Procedure mapping
│   └── service/          ← Core business rules and Audit Log tracking
└── frontend/             ← Angular UI
    ├── features/         ← Modular UI (Dashboard, Inventory, Leads, Service)
    └── core/             ← Auth Guards, JWT Interceptors, Global Error Handlers
```

---

## 📈 Analytical Stored Procedures
The following procedures are automatically installed:
*   `GetMonthlyBookings`: Monthly revenue and unit sales growth.
*   `GetTopSellingModels`: Performance by car model (Creta, Verna, etc.).
*   `GetLeadFunnelCounts`: Sales pipeline efficiency.
*   `GetInventoryStatusSummary`: Live stock vs. sold statistics.

---

> [!IMPORTANT]
> **Data Isolation Note**: By default, the `superadmin` manages the platform. Showroom-level data is only visible to users logged into that specific Dealer ID.