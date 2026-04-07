import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { MatDialog } from '@angular/material/dialog';
import { ChartData, ChartOptions } from 'chart.js';
import { ApiService } from '../../core/services/api.service';
import { AuthService } from '../../core/services/auth.service';
import { StockDistributionDialogComponent } from './stock-distribution-dialog/stock-distribution-dialog.component';

@Component({
  selector: 'app-reports',
  template: `
    <!-- Page Header with Filters -->
    <div class="page-header" style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:16px;">
      <div>
        <h1 style="margin:0; display:flex; align-items:center; gap:8px;"><mat-icon>bar_chart</mat-icon> Reports & Analytics</h1>
        <p style="margin:4px 0 0; color:var(--text-muted)">Business intelligence across all departments</p>
      </div>
      <form [formGroup]="filterForm" style="display:flex; gap:12px; align-items:center; flex-wrap:wrap;">
        <button mat-flat-button color="primary" (click)="downloadSalesCsv()" style="margin-right:8px; background:var(--hd-blue);">
          <mat-icon>file_download</mat-icon> Export CSV
        </button>

        <mat-form-field *ngIf="auth.isSuperAdmin" appearance="outline" subscriptSizing="dynamic" style="width:200px">
          <mat-label>Select Dealer</mat-label>
          <mat-select formControlName="dealerId" (selectionChange)="loadAll()">
            <mat-option value="">All Dealers (Network-Wide)</mat-option>
            <mat-option *ngFor="let d of dealers" [value]="d.id">{{d.name}}</mat-option>
          </mat-select>
        </mat-form-field>

        <mat-form-field appearance="outline" subscriptSizing="dynamic" style="width:140px">
          <mat-label>Year</mat-label>
          <mat-select formControlName="year" (selectionChange)="loadAll()">
            <mat-option value="">All Years</mat-option>
            <mat-option *ngFor="let y of years" [value]="y">{{y}}</mat-option>
          </mat-select>
        </mat-form-field>

        <mat-form-field appearance="outline" subscriptSizing="dynamic" style="width:150px">
          <mat-label>Month</mat-label>
          <mat-select formControlName="month" (selectionChange)="loadAll()">
            <mat-option value="">All Months</mat-option>
            <mat-option *ngFor="let m of months" [value]="m.value">{{m.label}}</mat-option>
          </mat-select>
        </mat-form-field>
      </form>
    </div>

    <!-- KPI Summary Cards -->
    <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(180px,1fr));gap:16px;margin-bottom:24px">
      <mat-card *ngFor="let kpi of kpiCards; let i = index" 
                style="text-align:center;padding:20px 16px; transition: transform 0.2s, box-shadow 0.2s;"
                [ngStyle]="{'cursor': (kpi.label === 'In Stock' || kpi.label === 'Total Bookings') ? 'pointer' : 'default'}"
                (click)="kpi.label === 'In Stock' ? openStockDialog() : kpi.label === 'Total Bookings' ? openBookingsDialog() : null"
                [class.hover-card]="kpi.label === 'In Stock' || kpi.label === 'Total Bookings'">
        <mat-icon style="font-size:32px;color:var(--hd-blue);width:32px;height:32px">{{kpi.icon}}</mat-icon>
        <div style="font-size:1.8rem;font-weight:700;color:var(--hd-blue);margin:8px 0 4px">{{kpi.value}}</div>
        <div style="font-size:.78rem;color:var(--text-muted);text-transform:uppercase;letter-spacing:.5px">{{kpi.label}}</div>
      </mat-card>
    </div>

    <!-- Tab Navigation -->
    <mat-tab-group animationDuration="200ms" style="background:var(--surface)">

      <!-- ====== SALES TAB ====== -->
      <mat-tab label="📈 Sales">
        <div style="padding:20px">
          <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;margin-bottom:20px">
            <mat-card>
              <mat-card-header><mat-card-title>Monthly Booking Revenue</mat-card-title></mat-card-header>
              <mat-card-content style="padding:16px">
                <canvas *ngIf="revenueChart.labels?.length" baseChart [data]="revenueChart" [options]="revenueBarOpts" type="bar" style="max-height:280px"></canvas>
                <div *ngIf="!revenueChart.labels?.length" class="no-data">
                  <mat-icon color="disabled" style="font-size:40px; height:40px; width:40px; margin-bottom:8px;">query_stats</mat-icon><br>
                  No booking revenue data found
                </div>
              </mat-card-content>
            </mat-card>
            <mat-card>
              <mat-card-header><mat-card-title>Monthly Booking Count</mat-card-title></mat-card-header>
              <mat-card-content style="padding:16px">
                <canvas *ngIf="bookingsCountChart.labels?.length" baseChart [data]="bookingsCountChart" [options]="revenueBarOpts" type="bar" style="max-height:280px"></canvas>
                <div *ngIf="!bookingsCountChart.labels?.length" class="no-data">
                  <mat-icon color="disabled" style="font-size:40px; height:40px; width:40px; margin-bottom:8px;">analytics</mat-icon><br>
                  No booking volume data found
                </div>
              </mat-card-content>
            </mat-card>
          </div>
          <mat-card>
            <mat-card-header><mat-card-title>Top Selling Models</mat-card-title></mat-card-header>
            <mat-card-content style="padding:16px">
              <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;align-items:start">
                <canvas *ngIf="topModelsChart.labels?.length" baseChart [data]="topModelsChart" [options]="barOpts" type="bar" style="max-height:280px"></canvas>
                <table mat-table [dataSource]="topModelRows" style="width:100%">
                  <ng-container matColumnDef="model">
                    <th mat-header-cell *matHeaderCellDef>Model</th>
                    <td mat-cell *matCellDef="let r">{{r.model}}</td>
                  </ng-container>
                  <ng-container matColumnDef="bookings">
                    <th mat-header-cell *matHeaderCellDef>Bookings</th>
                    <td mat-cell *matCellDef="let r"><strong>{{r.bookings}}</strong></td>
                  </ng-container>
                  <ng-container matColumnDef="revenue">
                    <th mat-header-cell *matHeaderCellDef>Revenue (₹)</th>
                    <td mat-cell *matCellDef="let r">{{r.revenue | number:'1.0-0'}}</td>
                  </ng-container>
                  <tr mat-header-row *matHeaderRowDef="tableCols"></tr>
                  <tr mat-row *matRowDef="let r;columns:tableCols"></tr>
                </table>
              </div>
            </mat-card-content>
          </mat-card>

          <!-- New: Detailed Sales Analysis Table -->
          <mat-card style="margin-top:20px">
            <mat-card-header>
              <mat-card-title style="display:flex; align-items:center; gap:8px;">
                <mat-icon style="color:var(--hd-blue)">assessment</mat-icon> Detailed Sales Analysis
              </mat-card-title>
            </mat-card-header>
            <mat-card-content style="padding:16px">
              <table mat-table [dataSource]="detailedSalesRows" style="width:100%">
                <ng-container matColumnDef="month">
                  <th mat-header-cell *matHeaderCellDef>Month</th>
                  <td mat-cell *matCellDef="let r"><strong>{{formatMonth(r.month)}}</strong></td>
                </ng-container>
                <ng-container matColumnDef="volume">
                  <th mat-header-cell *matHeaderCellDef>Vehicles Sold</th>
                  <td mat-cell *matCellDef="let r">{{r.volume}}</td>
                </ng-container>
                <ng-container matColumnDef="revenue">
                  <th mat-header-cell *matHeaderCellDef>Total Revenue (₹)</th>
                  <td mat-cell *matCellDef="let r">{{r.revenue | number:'1.0-0'}}</td>
                </ng-container>
                <ng-container matColumnDef="avgPrice">
                  <th mat-header-cell *matHeaderCellDef>Avg. Price/Unit (₹)</th>
                  <td mat-cell *matCellDef="let r">{{(r.revenue / (r.volume || 1)) | number:'1.0-0'}}</td>
                </ng-container>
                <tr mat-header-row *matHeaderRowDef="salesAnalysisCols"></tr>
                <tr mat-row *matRowDef="let r;columns:salesAnalysisCols"></tr>
              </table>
              <div *ngIf="!detailedSalesRows.length" class="no-data">No sales data found for this period.</div>
            </mat-card-content>
          </mat-card>
        </div>
      </mat-tab>

      <!-- ====== INVENTORY TAB ====== -->
      <mat-tab label="🚗 Inventory">
        <div style="padding:20px">
          <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;margin-bottom:20px">
            <mat-card>
              <mat-card-header><mat-card-title>Vehicle Stock by Status</mat-card-title></mat-card-header>
              <mat-card-content style="padding:16px">
                <canvas *ngIf="inventoryChart.labels?.length" baseChart [data]="inventoryChart" [options]="pieOpts" type="doughnut" style="max-height:280px"></canvas>
                <div *ngIf="!inventoryChart.labels?.length" class="no-data">No inventory data found</div>
              </mat-card-content>
            </mat-card>
            <mat-card>
              <mat-card-header><mat-card-title>Inventory Summary</mat-card-title></mat-card-header>
              <mat-card-content style="padding:16px">
                <table mat-table [dataSource]="inventoryRows" style="width:100%">
                  <ng-container matColumnDef="status">
                    <th mat-header-cell *matHeaderCellDef>Status</th>
                    <td mat-cell *matCellDef="let r">
                      <span [class]="'badge ' + statusBadge(r.status)">{{r.status | titlecase}}</span>
                    </td>
                  </ng-container>
                  <ng-container matColumnDef="count">
                    <th mat-header-cell *matHeaderCellDef>Count</th>
                    <td mat-cell *matCellDef="let r"><strong>{{r.count}}</strong></td>
                  </ng-container>
                  <ng-container matColumnDef="value">
                    <th mat-header-cell *matHeaderCellDef>Dealer Value (₹)</th>
                    <td mat-cell *matCellDef="let r">{{r.value | number:'1.0-0'}}</td>
                  </ng-container>
                  <tr mat-header-row *matHeaderRowDef="invCols"></tr>
                  <tr mat-row *matRowDef="let r;columns:invCols"></tr>
                </table>
              </mat-card-content>
            </mat-card>
          </div>
        </div>
      </mat-tab>

      <!-- ====== LEADS TAB ====== -->
      <mat-tab label="🎯 Leads">
        <div style="padding:20px">
          <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px">
            <mat-card>
              <mat-card-header><mat-card-title>Lead Pipeline Funnel</mat-card-title></mat-card-header>
              <mat-card-content style="padding:16px">
                <canvas *ngIf="pipelineChart.labels?.length" baseChart [data]="pipelineChart" [options]="hBarOpts" type="bar" style="max-height:320px"></canvas>
                <div *ngIf="!pipelineChart.labels?.length" class="no-data">No leads data available.</div>
              </mat-card-content>
            </mat-card>
            <mat-card>
              <mat-card-header><mat-card-title>Leads by Stage – Summary</mat-card-title></mat-card-header>
              <mat-card-content style="padding:16px">
                <table mat-table [dataSource]="pipelineRows" style="width:100%">
                  <ng-container matColumnDef="stage">
                    <th mat-header-cell *matHeaderCellDef>Stage</th>
                    <td mat-cell *matCellDef="let r">{{r.stage}}</td>
                  </ng-container>
                  <ng-container matColumnDef="count">
                    <th mat-header-cell *matHeaderCellDef>Count</th>
                    <td mat-cell *matCellDef="let r"><strong>{{r.count}}</strong></td>
                  </ng-container>
                  <tr mat-header-row *matHeaderRowDef="leadCols"></tr>
                  <tr mat-row *matRowDef="let r;columns:leadCols"></tr>
                </table>
              </mat-card-content>
            </mat-card>
          </div>
        </div>
      </mat-tab>

      <!-- ====== SERVICE TAB ====== -->
      <mat-tab label="🔧 Service">
        <div style="padding:20px">
          <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px">
            <mat-card>
              <mat-card-header><mat-card-title>Mechanic Workload</mat-card-title></mat-card-header>
              <mat-card-content style="padding:16px">
                <canvas *ngIf="workloadChart.labels?.length" baseChart [data]="workloadChart" [options]="barOpts" type="bar" style="max-height:280px"></canvas>
                <div *ngIf="!workloadChart.labels?.length" class="no-data">No service data available.</div>
              </mat-card-content>
            </mat-card>
            <mat-card>
              <mat-card-header><mat-card-title>Workload Summary</mat-card-title></mat-card-header>
              <mat-card-content style="padding:16px">
                <table mat-table [dataSource]="workloadRows" style="width:100%">
                  <ng-container matColumnDef="mechanic">
                    <th mat-header-cell *matHeaderCellDef>Mechanic</th>
                    <td mat-cell *matCellDef="let r">{{r.mechanic}}</td>
                  </ng-container>
                  <ng-container matColumnDef="jobs">
                    <th mat-header-cell *matHeaderCellDef>Total Jobs</th>
                    <td mat-cell *matCellDef="let r"><strong>{{r.jobs}}</strong></td>
                  </ng-container>
                  <ng-container matColumnDef="completed">
                    <th mat-header-cell *matHeaderCellDef>Completed</th>
                    <td mat-cell *matCellDef="let r">{{r.completed}}</td>
                  </ng-container>
                  <ng-container matColumnDef="revenue">
                    <th mat-header-cell *matHeaderCellDef>Revenue (₹)</th>
                    <td mat-cell *matCellDef="let r">{{r.revenue | number:'1.0-0'}}</td>
                  </ng-container>
                  <tr mat-header-row *matHeaderRowDef="workCols"></tr>
                  <tr mat-row *matRowDef="let r;columns:workCols"></tr>
                </table>
              </mat-card-content>
            </mat-card>
          </div>
        </div>
      </mat-tab>

    </mat-tab-group>

    <style>
      .no-data { text-align:center; padding:40px; color:var(--text-muted); font-size:.9rem; }
      .hover-card:hover { transform: translateY(-3px); box-shadow: 0 6px 16px rgba(0,0,0,0.1); }
    </style>
  `
})
export class ReportsComponent implements OnInit {
  filterForm: FormGroup;
  years = [2026, 2025, 2024, 2023];
  months = [
    { value: 1, label: 'January' }, { value: 2, label: 'February' }, { value: 3, label: 'March' },
    { value: 4, label: 'April' }, { value: 5, label: 'May' }, { value: 6, label: 'June' },
    { value: 7, label: 'July' }, { value: 8, label: 'August' }, { value: 9, label: 'September' },
    { value: 10, label: 'October' }, { value: 11, label: 'November' }, { value: 12, label: 'December' }
  ];
  dealers: any[] = [];

  kpiCards: { label: string; value: string; icon: string }[] = [];

  // --- Sales ---
  tableCols = ['model', 'bookings', 'revenue'];
  topModelRows: any[] = [];

  revenueChart: ChartData<'bar'> = { labels: [], datasets: [{ data: [], label: 'Revenue (₹)', backgroundColor: '#002c5f', borderRadius: 4 }] };
  bookingsCountChart: ChartData<'bar'> = { labels: [], datasets: [{ data: [], label: 'Bookings', backgroundColor: '#00aad2', borderRadius: 4 }] };
  topModelsChart: ChartData<'bar'> = { labels: [], datasets: [{ data: [], label: 'Bookings', backgroundColor: '#00aad2', borderRadius: 4 }] };

  // Detailed Sales Analysis
  salesAnalysisCols = ['month', 'volume', 'revenue', 'avgPrice'];
  detailedSalesRows: any[] = [];

  // --- Inventory ---
  invCols = ['status', 'count', 'value'];
  inventoryRows: any[] = [];
  inventoryChart: ChartData<'doughnut'> = { labels: [], datasets: [{ data: [], backgroundColor: ['#2e7d32', '#1565c0', '#e65100', '#6a1b9a', '#c62828'] }] };
  stockByModelChart: ChartData<'bar'> = { labels: [], datasets: [{ data: [], label: 'In Stock', backgroundColor: '#00aad2', borderRadius: 4 }] };
  bookingsByModelChart: ChartData<'bar'> = { labels: [], datasets: [] };

  // --- Leads ---
  leadCols = ['stage', 'count'];
  pipelineRows: any[] = [];
  pipelineChart: ChartData<'bar'> = { labels: [], datasets: [{ data: [], label: 'Leads', backgroundColor: '#004080', borderRadius: 4 }] };

  // --- Service ---
  workCols = ['mechanic', 'jobs', 'completed', 'revenue'];
  workloadRows: any[] = [];
  workloadChart: ChartData<'bar'> = { labels: [], datasets: [{ data: [], label: 'Total Jobs', backgroundColor: '#00796b', borderRadius: 4 }] };

  // Chart Options
  barOpts: ChartOptions = { responsive: true, plugins: { legend: { display: false } } };
  revenueBarOpts: ChartOptions = {
    responsive: true,
    plugins: {
      legend: { display: false },
      tooltip: { callbacks: { label: (ctx) => '₹' + Number(ctx.raw).toLocaleString('en-IN') } }
    }
  };
  lineOpts: ChartOptions = { responsive: true, plugins: { legend: { display: false } } };
  hBarOpts: ChartOptions = { indexAxis: 'y' as const, responsive: true, plugins: { legend: { display: false } } };
  pieOpts: ChartOptions = { responsive: true, plugins: { legend: { position: 'right' } } };

  constructor(private api: ApiService, public auth: AuthService, private fb: FormBuilder, private dialog: MatDialog) {
    this.filterForm = this.fb.group({ 
      year: [''], 
      month: [''], 
      dealerId: [''] 
    });
  }

  ngOnInit() { 
    if (this.auth.isSuperAdmin) {
      this.api.getDealers().subscribe(d => this.dealers = d);
    }
    this.loadAll(); 
  }

  openStockDialog() {
    this.dialog.open(StockDistributionDialogComponent, {
      width: '700px',
      data: { chartData: this.stockByModelChart, options: this.hBarOpts }
    });
  }

  openBookingsDialog() {
    this.dialog.open(StockDistributionDialogComponent, {
      width: '700px',
      data: {
        chartData: this.bookingsByModelChart,
        options: { indexAxis: 'y' as const, responsive: true, plugins: { legend: { display: false }, title: { display: true, text: 'Bookings by Model' } } }
      }
    });
  }

  loadAll() {
    const { year, month, dealerId } = this.filterForm.value;
    const vYear = year || undefined;
    const vMonth = month || undefined;
    const vDealer = dealerId || undefined;

    this.loadSales(vYear, vMonth, vDealer);
    this.loadInventory(vYear, vMonth, vDealer);
    this.loadLeads(vYear, vMonth, vDealer);
    this.loadService(vYear, vMonth, vDealer);
  }

  loadSales(year: number | undefined, month: number | undefined, dealerId: number | undefined) {
    this.api.getMonthlyBookings(year, dealerId).subscribe({
      next: (d: any[]) => {
        const sorted = [...d].reverse(); // chronological
        this.revenueChart = {
          labels: sorted.map(r => r[0]),
          datasets: [{ data: sorted.map(r => Number(r[2])), label: 'Revenue (₹)', backgroundColor: '#002c5f', borderRadius: 4 }]
        };
        this.bookingsCountChart = {
          labels: sorted.map(r => r[0]),
          datasets: [{ data: sorted.map(r => Number(r[1])), label: 'Bookings', backgroundColor: '#00aad2', borderRadius: 4 }]
        };

        // KPI Calculation with Month Filtering
        let filteredSalesData = d;
        if (year && month) {
          const monthStr = `${year}-${month.toString().padStart(2, '0')}`;
          filteredSalesData = d.filter(r => r[0] === monthStr);
        }

        const totalRev = filteredSalesData.reduce((s, r) => s + Number(r[2]), 0);
        const totalBkgs = filteredSalesData.reduce((s, r) => s + Number(r[1]), 0);
        this.updateKpi('Total Bookings', String(totalBkgs), 'receipt_long', 0);
        this.updateKpi('Total Revenue', '₹' + (totalRev / 100000).toFixed(1) + 'L', 'currency_rupee', 1);

        this.detailedSalesRows = filteredSalesData.map(r => ({
          month: r[0],
          volume: r[1],
          revenue: r[2]
        }));
      },
      error: err => console.error('Error loading monthly bookings:', err)
    });

    this.api.getTopSellingModels(year, month, dealerId).subscribe({
      next: (d: any[]) => {
        this.topModelsChart = {
          labels: d.map(r => r[0]),
          datasets: [{ data: d.map(r => Number(r[1])), label: 'Bookings', backgroundColor: '#00aad2', borderRadius: 4 }]
        };
        this.topModelRows = d.map(r => ({ model: r[0], bookings: r[1], revenue: r[2] }));
      },
      error: err => console.error('Error loading top selling models:', err)
    });

    this.api.getBookingsByModel(year, month, dealerId).subscribe({
      next: (d: any[]) => {
        this.bookingsByModelChart = {
          labels: d.map(r => r[0]),
          datasets: [{ data: d.map(r => Number(r[1])), label: 'Bookings', backgroundColor: '#002c5f', borderRadius: 4 }]
        };
      },
      error: err => console.error('Error loading bookings by model:', err)
    });
  }

  loadInventory(year: number | undefined, month: number | undefined, dealerId: number | undefined) {
    this.api.getInventoryStatus(year, month, dealerId).subscribe({
      next: (d: any[]) => {
        this.inventoryChart = {
          labels: d.map(r => r[0]),
          datasets: [{ data: d.map(r => Number(r[1])), backgroundColor: ['#2e7d32', '#1565c0', '#e65100', '#6a1b9a', '#c62828'] }]
        };
        this.inventoryRows = d.map(r => ({ status: r[0], count: r[1], value: r[2] }));
        const inStock = d.find(r => r[0] === 'IN_STOCK');
        this.updateKpi('In Stock', String(inStock ? inStock[1] : 0), 'directions_car', 2);
      },
      error: err => console.error('Error loading inventory status:', err)
    });

    this.api.getStockByModel(year, month, dealerId).subscribe({
      next: (d: any[]) => {
        this.stockByModelChart = {
          labels: d.map(r => r[0]),
          datasets: [{ data: d.map(r => Number(r[1])), label: 'In Stock Units', backgroundColor: '#00aad2', borderRadius: 4 }]
        };
      },
      error: err => console.error('Error loading stock by model:', err)
    });
  }

  loadLeads(year: number | undefined, month: number | undefined, dealerId: number | undefined) {
    this.api.getSalesPipeline(year, month, dealerId).subscribe({
      next: (d: any[]) => {
        this.pipelineChart = {
          labels: d.map(r => r[0]),
          datasets: [{ data: d.map(r => Number(r[1])), label: 'Leads', backgroundColor: '#004080', borderRadius: 4 }]
        };
        this.pipelineRows = d.map(r => ({ stage: r[0], count: r[1] }));
        const total = d.reduce((s, r) => s + Number(r[1]), 0);
        this.updateKpi('Active Leads', String(total), 'trending_up', 3);
      },
      error: err => console.error('Error loading sales pipeline:', err)
    });
  }

  loadService(year: number | undefined, month: number | undefined, dealerId: number | undefined) {
    this.api.getServiceWorkload(year, month, dealerId).subscribe({
      next: (d: any[]) => {
        this.workloadChart = {
          labels: d.map(r => r[0]),
          datasets: [{ data: d.map(r => Number(r[1])), label: 'Total Jobs', backgroundColor: '#00796b', borderRadius: 4 }]
        };
        this.workloadRows = d.map(r => ({
          mechanic: r[0],
          jobs: r[1],
          completed: r[2],
          revenue: r[3]
        }));
      },
      error: err => console.error('Error loading service workload:', err)
    });
  }

  private updateKpi(label: string, value: string, icon: string, index: number) {
    this.kpiCards[index] = { label, value, icon };
    this.kpiCards = [...this.kpiCards];
  }

  statusBadge(s: string): string {
    const map: Record<string, string> = {
      IN_STOCK: 'badge-green', BOOKED: 'badge-blue', SOLD: 'badge-grey',
      ALLOCATED: 'badge-purple', IN_TRANSIT: 'badge-yellow', DEMO: 'badge-cyan'
    };
    return map[s] ?? 'badge-grey';
  }

  formatMonth(mStr: string) {
    if (!mStr) return '-';
    const [y, m] = mStr.split('-');
    const date = new Date(Number(y), Number(m) - 1);
    return date.toLocaleString('default', { month: 'long', year: 'numeric' });
  }

  downloadSalesCsv() {
    console.log('Generating CSV export...');
    const headers = ['Month', 'Vehicles Sold', 'Revenue (INR)'];
    const rows = this.detailedSalesRows.map(r => [this.formatMonth(r.month), r.volume, r.revenue]);
    
    let csvContent = "data:text/csv;charset=utf-8," 
      + headers.join(",") + "\n"
      + rows.map(e => e.join(",")).join("\n");

    const encodedUri = encodeURI(csvContent);
    const link = document.createElement("a");
    link.setAttribute("href", encodedUri);
    link.setAttribute("download", `DealerConnect_Sales_Report_${new Date().getTime()}.csv`);
    document.body.appendChild(link);
    link.click();
    
    // Cleanup
    document.body.removeChild(link);
    alert('Sales Report generated and download started!');
  }
}
