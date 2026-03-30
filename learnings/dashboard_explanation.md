# 📊 Hyundai DMS Dashboard Explained

When presenting or explaining the Dashboard module, the best approach is to start from what the user sees on the screen (Frontend), explain how it asks for data (Backend API), and finally show where that data actually comes from (Database). 

Here’s a layer-by-layer guide on how to explain the Dashboard feature.

---

## 1. The Frontend Layer (What the User Sees)
*Where it lives: `frontend/src/app/features/dashboard/dashboard.component.ts`*

The frontend is built using **Angular**, and it uses a library called **Chart.js** (via `ng2-charts`) to draw the beautiful graphs.

### How it works:
1. **Initialization (`ngOnInit`)**: When the dashboard page loads, the `ngOnInit()` method is triggered instantly.
2. **Fetching Data (`loadData()`)**: Inside this method, we make **5 parallel HTTP requests** to the backend using our `ApiService`. We don't wait for everything sequentially; they all load at once to make the page fast.
3. **The 5 KPIs (Key Performance Indicators)**:
   * **Vehicles in Stock**: Calls `getInventoryStatus()`. It looks for the row where status is `'IN_STOCK'` and updates the blue KPI box.
   * **Vehicles Sold (Month)** & **Revenue This Month**: Calls `getMonthlyBookings(year)`. It scans the data for the *current calendar month* and updates both the green box (sold count) and purple box (total revenue).
   * **Total Active Leads**: Calls `getSalesPipeline()`. It grabs all leads, filters out the ones that are "LOST" or "BOOKED", and sums up the rest to show the light blue KPI box.
   * **Active Service Jobs**: Calls `getServiceWorkload()`. It adds up all the job cards currently active in the service center and updates the orange box.
4. **Drawing the Charts**: Once the data arrives from the backend, we map it into `ChartData` objects. For example, the `serviceChart` labels become the mechanic names ("Suresh Babu"), and the datasets become the counts ("3"). Angular's HTML template then magically draws the bar and pie charts.

---

## 2. The Backend Layer (The Delivery Guy)
*Where it lives: `backend/src/main/java/com/hyundai/dms/controller/ReportController.java` & others*

The Spring Boot backend acts as the bridge. It receives the Angular requests, checks security, and asks the database for the numbers.

### How it works:
1. **Security & Multi-Tenancy**: Every request to the `ReportController` first checks: *"Who is this user?"* 
   ```java
   Long effectiveDealerId = DealerContext.getCurrentDealerId();
   ```
   This ensures that Dealer A never sees Dealer B's sales data. If a Super Admin logs in, they can pass a specific `dealerId` to view a specific dealership's dashboard.
2. **The API Endpoints**:
   * `GET /reports/monthly-bookings` → Returns an array of `['2026-03', 4, 4338000]` representing `[Month, Cars Sold, Revenue]`.
   * `GET /reports/top-selling-models` → Returns `['Creta', 12], ['Venue', 8]`.
   * `GET /reports/service-workload` → Returns `['Suresh Babu', 3], ['Ramesh Kumar', 2]`.
3. **Direct Database Calls**: Notice that the Controller doesn't do complex math. It doesn't fetch 10,000 rows and loop through them in Java. Instead, it delegates all the heavy lifting to the database repositories via Native SQL queries for maximum performance.

---

## 3. The Database Layer (The Heavy Lifter)
*Where it lives: Repositories and MySQL Stored Procedures*

To make the dashboard load instantly, the database calculates all the math using optimized **Native SQL Queries** and **Stored Procedures**.

### How it works:
1. **Aggregations in SQL (`BookingRepository.java`)**:
   For the *Monthly Bookings* chart, the database runs a native query grouped by month.
   ```sql
   SELECT DATE_FORMAT(b.created_at, '%Y-%m') AS month,
          COUNT(b.id) AS soldCount,
          SUM(b.total_on_road) AS revenue
   FROM bookings b
   WHERE b.status = 'DELIVERED' 
     AND b.dealer_id = :dealerId
   GROUP BY month;
   ```
   Instead of Java doing the math, MySQL counts the cars and `SUM`s the revenue in milliseconds.

2. **The Stored Procedure (`GetWorkloadSummary`)**:
   For the Service Workload, things get a bit more complex. A mechanic works on `job_cards`, but mechanics are just a specialized type of `employees`. 
   To get this cleanly, we created a native MySQL **Stored Procedure** called `CALL GetWorkloadSummary(:year, :month, :dealerId)`.
   * The database joins `job_cards` ↔ `mechanics` ↔ `employees`.
   * It specifically extracts the Employee's First and Last Name.
   * It `COUNT`s how many job cards are active per mechanic.
   * It returns the clean, formatted data directly back to Spring Boot.

### Summary to tell your reviewers:
> *"The Dashboard is engineered for high performance and strict multi-tenancy. The Angular frontend fires asynchronous requests to our Spring Boot backend. Instead of clogging the JVM memory by processing thousands of records in Java, we pushed all data aggregation (like revenue summations and funnel analytics) down to the MySQL Database layer using Native Queries and heavily optimized Stored Procedures. The API then returns perfectly formatted arrays that power our real-time Chart.js graphs."*
