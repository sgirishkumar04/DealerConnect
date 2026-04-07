import { Component, OnInit, ViewChild } from '@angular/core';
import { MatPaginator } from '@angular/material/paginator';
import { MatSort } from '@angular/material/sort';
import { MatTableDataSource } from '@angular/material/table';
import { MatDialog } from '@angular/material/dialog';
import { MatSnackBar } from '@angular/material/snack-bar';
import { ApiService } from '../../../core/services/api.service';
import { ConfirmDialogComponent } from '../../../shared/components/confirm-dialog/confirm-dialog.component';
import { VehicleDetailsDialogComponent } from '../vehicle-details-dialog/vehicle-details-dialog.component';
import { Router } from '@angular/router';
import { AuthService } from '../../../core/services/auth.service';

@Component({
  selector: 'app-vehicle-list',
  template: `
    <div>
      <!-- Page Header -->
      <div class="page-header mb-4">
        <div class="page-title">
          <h1>Vehicle Inventory</h1>
          <p>Manage your dealership vehicle stock</p>
        </div>
        <button mat-raised-button style="background:var(--hd-blue);color:#fff"
                *ngIf="canCreate"
                (click)="router.navigate(['/inventory/new'])">
          <mat-icon>add</mat-icon> Add Vehicle
        </button>
      </div>

      <!-- Table Card -->
      <div class="table-container">
        <!-- Toolbar -->
        <div class="table-toolbar">
          <mat-form-field appearance="outline" class="search-field">
            <mat-label>Search vehicles…</mat-label>
            <mat-icon matPrefix style="color:var(--text-muted)">search</mat-icon>
            <input matInput #searchInput (keyup)="applyFilter($event)" placeholder="VIN, model, variant…">
          </mat-form-field>
          
          <button mat-icon-button (click)="resetFilters()" matTooltip="Reset Filters" style="margin-right: 8px; color: var(--text-muted)">
            <mat-icon>refresh</mat-icon>
          </button>

          <mat-form-field appearance="outline" style="max-width:180px">
            <mat-label>Status</mat-label>
            <mat-select [(value)]="statusFilter" (selectionChange)="updateFilter()">
              <mat-option value="">All</mat-option>
              <mat-option value="IN_STOCK">In Stock</mat-option>
              <mat-option value="ALLOCATED">Allocated</mat-option>
              <mat-option value="SOLD">Sold</mat-option>
              <mat-option value="DEMO">Demo</mat-option>
              <mat-option value="IN_TRANSIT">In Transit</mat-option>
            </mat-select>
          </mat-form-field>

          <mat-form-field appearance="outline" style="max-width:150px">
            <mat-label>Color</mat-label>
            <mat-select [(value)]="colorFilter" (selectionChange)="updateFilter()">
              <mat-option value="">All Colors</mat-option>
              <mat-option *ngFor="let c of uniqueColors" [value]="c">{{c}}</mat-option>
            </mat-select>
          </mat-form-field>

          <mat-form-field appearance="outline" style="max-width:120px">
            <mat-label>Year</mat-label>
            <mat-select [(value)]="yearFilter" (selectionChange)="updateFilter()">
              <mat-option value="">All</mat-option>
              <mat-option *ngFor="let y of uniqueYears" [value]="y">{{y}}</mat-option>
            </mat-select>
          </mat-form-field>

          <mat-form-field appearance="outline" style="max-width:150px">
            <mat-label>Aging</mat-label>
            <mat-select [(value)]="agingFilter" (selectionChange)="updateFilter()">
              <mat-option value="">All</mat-option>
              <mat-option value="0-30">0–30 Days (Normal)</mat-option>
              <mat-option value="31-60">31–60 Days (Warning)</mat-option>
              <mat-option value="60+">60+ Days (Critical)</mat-option>
            </mat-select>
          </mat-form-field>

          <mat-form-field appearance="outline" style="max-width:180px">
            <mat-label>Location</mat-label>
            <mat-select [(value)]="locationFilter" (selectionChange)="updateFilter()">
              <mat-option value="">All Locations</mat-option>
              <mat-option *ngFor="let l of uniqueLocations" [value]="l">{{l}}</mat-option>
            </mat-select>
          </mat-form-field>
          
          <mat-form-field appearance="outline" style="max-width:140px">
            <mat-label>Min Price (₹)</mat-label>
            <input matInput type="number" [(ngModel)]="minPriceFilter" (keyup)="updateFilter()" (change)="updateFilter()">
          </mat-form-field>

          <mat-form-field appearance="outline" style="max-width:140px">
            <mat-label>Max Price (₹)</mat-label>
            <input matInput type="number" [(ngModel)]="maxPriceFilter" (keyup)="updateFilter()" (change)="updateFilter()">
          </mat-form-field>

          <div class="flex-1"></div>
          <span class="text-sm text-secondary">{{dataSource.filteredData.length}} records</span>
        </div>

        <!-- Loading bar -->
        <mat-progress-bar mode="indeterminate" *ngIf="loading"></mat-progress-bar>

        <!-- Table -->
        <table mat-table [dataSource]="dataSource" matSort class="data-table">

          <ng-container matColumnDef="vin">
            <th mat-header-cell *matHeaderCellDef mat-sort-header>VIN</th>
            <td mat-cell *matCellDef="let v">
              <span style="font-family:monospace;font-size:.8rem;color:var(--hd-blue)">{{v.vin}}</span>
            </td>
          </ng-container>

          <ng-container matColumnDef="model">
            <th mat-header-cell *matHeaderCellDef mat-sort-header>Model</th>
            <td mat-cell *matCellDef="let v">
              <div style="font-weight:600">{{v.variant?.model?.modelName ?? '—'}}</div>
              <div class="text-xs text-secondary">{{v.variant?.variantName}}</div>
            </td>
          </ng-container>

          <ng-container matColumnDef="color">
            <th mat-header-cell *matHeaderCellDef>Color</th>
            <td mat-cell *matCellDef="let v">
              <div style="display:flex;align-items:center;gap:8px">
                <div [style.background]="v.color?.hexCode ?? '#999'"
                     style="width:14px;height:14px;border-radius:50%;border:1px solid #ccc;flex-shrink:0"></div>
                {{v.color?.name ?? '—'}}
              </div>
            </td>
          </ng-container>

          <ng-container matColumnDef="year">
            <th mat-header-cell *matHeaderCellDef mat-sort-header>Year</th>
            <td mat-cell *matCellDef="let v">{{v.mfgYear}}</td>
          </ng-container>

          <ng-container matColumnDef="status">
            <th mat-header-cell *matHeaderCellDef mat-sort-header>Status</th>
            <td mat-cell *matCellDef="let v">
              <div (click)="$event.stopPropagation()" style="min-width: 120px">
                <mat-select *ngIf="canEdit; else staticStatus"
                            [value]="v.status"
                            (selectionChange)="updateVehicleStatus(v, $event.value)"
                            class="inline-status-select"
                            [class]="statusClass(v.status)">
                  <mat-option value="IN_STOCK">In Stock</mat-option>
                  <mat-option value="ALLOCATED">Allocated</mat-option>
                  <mat-option value="SOLD">Sold</mat-option>
                  <mat-option value="DEMO">Demo</mat-option>
                  <mat-option value="IN_TRANSIT">In Transit</mat-option>
                </mat-select>
                <ng-template #staticStatus>
                  <span [class]="'badge ' + statusClass(v.status)">{{v.status | titlecase}}</span>
                </ng-template>
              </div>
            </td>
          </ng-container>

          <ng-container matColumnDef="aging">
            <th mat-header-cell *matHeaderCellDef>Days In Stock</th>
            <td mat-cell *matCellDef="let v">
              <ng-container *ngIf="v.status === 'IN_STOCK' && v.mfgDate; else emptyAging">
                <span [class]="'badge ' + getAgingClass(calculateAging(v.mfgDate))">
                  {{ calculateAging(v.mfgDate) }} Days
                </span>
              </ng-container>
              <ng-template #emptyAging>—</ng-template>
            </td>
          </ng-container>

          <ng-container matColumnDef="location">
            <th mat-header-cell *matHeaderCellDef>Location</th>
            <td mat-cell *matCellDef="let v">{{v.location?.name ?? '—'}}</td>
          </ng-container>

          <ng-container matColumnDef="price">
            <th mat-header-cell *matHeaderCellDef mat-sort-header>Ex-Showroom</th>
            <td mat-cell *matCellDef="let v" style="text-align:right;font-weight:600">
              {{v.variant?.exShowroomPrice | currency:'INR':'symbol':'1.0-0'}}
            </td>
          </ng-container>

          <ng-container matColumnDef="actions">
            <th mat-header-cell *matHeaderCellDef style="text-align:center">Actions</th>
            <td mat-cell *matCellDef="let v">
              <div class="action-btns">
                <button *ngIf="canEdit" mat-icon-button matTooltip="Edit" (click)="router.navigate(['/inventory', v.id, 'edit']); $event.stopPropagation()">
                  <mat-icon style="font-size:18px;color:var(--hd-blue)">edit</mat-icon>
                </button>
                <button *ngIf="canDelete" mat-icon-button matTooltip="Delete" (click)="confirmDelete(v); $event.stopPropagation()">
                  <mat-icon style="font-size:18px;color:var(--hd-red)">delete_outline</mat-icon>
                </button>
              </div>
            </td>
          </ng-container>

          <tr mat-header-row *matHeaderRowDef="columns; sticky: true"></tr>
          <tr mat-row *matRowDef="let row; columns: columns;" 
              class="clickable-row"
              (click)="viewDetails(row)"></tr>

          <tr class="mat-mdc-no-data-row" *matNoDataRow>
            <td colspan="8" style="text-align:center;padding:32px;color:var(--text-muted)">
              <mat-icon>search_off</mat-icon><br>No vehicles found
            </td>
          </tr>
        </table>

        <mat-paginator [pageSizeOptions]="[10, 25, 50]" showFirstLastButtons></mat-paginator>
      </div>
    </div>
  `,
  styles: [`
    .clickable-row { cursor: pointer; transition: background 0.2s ease; }
    .clickable-row:hover { background-color: rgba(0, 43, 92, 0.04) !important; }
    .action-btns button { transition: transform 0.2s; }
    .action-btns button:hover { transform: scale(1.1); }
    
    ::ng-deep .inline-status-select .mat-mdc-select-value { 
      font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px;
    }
    ::ng-deep .inline-status-select {
      padding: 4px 10px; border-radius: 6px; border: none; height: auto !important;
    }
    ::ng-deep .inline-status-select.badge-green { background: #dcfce7; color: #166534; }
    ::ng-deep .inline-status-select.badge-blue { background: #dbeafe; color: #1e40af; }
    ::ng-deep .inline-status-select.badge-grey { background: #f3f4f6; color: #374151; }
    ::ng-deep .inline-status-select.badge-cyan { background: #ecfeff; color: #0891b2; }
    ::ng-deep .inline-status-select.badge-yellow { background: #fef9c3; color: #854d0e; }
    ::ng-deep .inline-status-select.badge-purple { background: #f3e8ff; color: #6b21a8; }
  `]
})
export class VehicleListComponent implements OnInit {
  @ViewChild(MatPaginator) paginator!: MatPaginator;
  @ViewChild(MatSort) sort!: MatSort;
  @ViewChild('searchInput') searchInput!: any;

  columns = ['vin','model','color','year','status','aging','location','price','actions'];
  dataSource = new MatTableDataSource<any>([]);
  loading = false;
  searchText = '';
  statusFilter = '';
  colorFilter = '';
  yearFilter = '';
  agingFilter = '';
  locationFilter = '';
  minPriceFilter: number | null = null;
  maxPriceFilter: number | null = null;

  resetFilters() {
    this.searchText = '';
    this.statusFilter = '';
    this.colorFilter = '';
    this.yearFilter = '';
    this.agingFilter = '';
    this.locationFilter = '';
    this.minPriceFilter = null;
    this.maxPriceFilter = null;
    if (this.searchInput) this.searchInput.nativeElement.value = '';
    this.updateFilter();
  }

  get uniqueColors() { return [...new Set(this.dataSource.data.map((v: any) => v.color?.name).filter(Boolean))].sort(); }
  get uniqueYears() { return [...new Set(this.dataSource.data.map((v: any) => v.mfgYear).filter(Boolean))].sort(); }
  get uniqueLocations() { return [...new Set(this.dataSource.data.map((v: any) => v.location?.name).filter(Boolean))].sort(); }

  constructor(private api: ApiService, private dialog: MatDialog,
              private snack: MatSnackBar, public router: Router,
              private auth: AuthService) {}

  get canCreate(): boolean { return this.auth.hasPermission('INVENTORY_CREATE'); }
  get canEdit(): boolean { return this.auth.hasPermission('INVENTORY_EDIT'); }
  get canDelete(): boolean { return this.auth.hasPermission('INVENTORY_DELETE'); }

  ngOnInit() {
    this.dataSource.filterPredicate = (row: any, filter: string) => {
      const f = JSON.parse(filter);
      
      const matchStatus = !f.status || row.status === f.status;
      const matchColor = !f.color || row.color?.name === f.color;
      const matchYear = !f.year || row.mfgYear?.toString() === f.year?.toString();
      const matchLocation = !f.location || row.location?.name === f.location;
      
      const price = row.variant?.exShowroomPrice;
      const matchMinPrice = (f.minPrice == null || f.minPrice === '') || (price >= Number(f.minPrice));
      const matchMaxPrice = (f.maxPrice == null || f.maxPrice === '') || (price <= Number(f.maxPrice));

      let matchAging = true;
      if (f.aging && row.status === 'IN_STOCK' && row.mfgDate) {
        const days = this.calculateAging(row.mfgDate);
        if (f.aging === '0-30') matchAging = days <= 30;
        else if (f.aging === '31-60') matchAging = days > 30 && days <= 60;
        else if (f.aging === '60+') matchAging = days > 60;
      } else if (f.aging && (row.status !== 'IN_STOCK' || !row.mfgDate)) {
        matchAging = false; // If filtering by aging, only show in-stock vehicles with mfgDate
      }

      if (!matchStatus || !matchColor || !matchYear || !matchLocation || !matchMinPrice || !matchMaxPrice || !matchAging) {
        return false;
      }
      
      const text = f.text?.toLowerCase() || '';
      if (!text) return true;

      const searchableString = [
        row.vin,
        row.variant?.model?.modelName,
        row.variant?.variantName,
        row.color?.name,
        row.mfgYear,
        row.status,
        row.location?.name
      ].join(' ').toLowerCase();

      return searchableString.includes(text);
    };
    this.load();
  }

  load() {
    this.loading = true;
    this.api.getVehicles({ page: 0, size: 200 }).subscribe({
      next: res => {
        this.dataSource.data = res.content ?? [];
        this.dataSource.paginator = this.paginator;
        this.dataSource.sort = this.sort;
        this.loading = false;
      },
      error: () => { this.loading = false; }
    });
  }

  applyFilter(event: Event) {
    this.searchText = (event.target as HTMLInputElement).value.trim();
    this.updateFilter();
  }

  updateFilter() {
    this.dataSource.filter = JSON.stringify({
      text: this.searchText,
      status: this.statusFilter,
      color: this.colorFilter,
      year: this.yearFilter,
      aging: this.agingFilter,
      location: this.locationFilter,
      minPrice: this.minPriceFilter,
      maxPrice: this.maxPriceFilter
    });
  }

  calculateAging(mfgDate: string): number {
    if (!mfgDate) return 0;
    const diffTime = Math.abs(new Date().getTime() - new Date(mfgDate).getTime());
    return Math.floor(diffTime / (1000 * 60 * 60 * 24));
  }

  getAgingClass(days: number): string {
    if (days <= 30) return 'badge-green';
    if (days <= 60) return 'badge-orange';
    return 'badge-red';
  }

  updateVehicleStatus(v: any, newStatus: string) {
    this.api.updateVehicleStatus(v.id, newStatus).subscribe({
      next: () => {
        v.status = newStatus;
        this.snack.open('Status updated successfully', 'Close', { duration: 2000 });
      },
      error: (err) => {
        this.snack.open('Failed to update status', 'Close', { duration: 3000 });
        console.error(err);
      }
    });
  }

  statusClass(s: string): string {
    const map: Record<string, string> = {
      IN_STOCK: 'badge-green', BOOKED: 'badge-blue', SOLD: 'badge-grey',
      DEMO: 'badge-cyan', IN_TRANSIT: 'badge-yellow', ALLOCATED: 'badge-purple'
    };
    return map[s] ?? 'badge-grey';
  }

  viewDetails(v: any) {
    this.dialog.open(VehicleDetailsDialogComponent, {
      width: '850px',
      maxWidth: '95vw',
      data: v,
      panelClass: 'details-dialog-panel'
    });
  }

  confirmDelete(v: any) {
    this.dialog.open(ConfirmDialogComponent, {
      data: {
        title: 'Delete Vehicle',
        message: `Remove ${v.variant?.model?.modelName} (VIN: ${v.vin}) from inventory? This action cannot be undone.`,
        confirmText: 'Delete', danger: true
      }
    }).afterClosed().subscribe(ok => {
      if (!ok) return;
      this.api.deleteVehicle(v.id).subscribe({
        next: () => { this.snack.open('Vehicle deleted', 'Close', { duration: 3000 }); this.load(); },
        error: () => { this.snack.open('Delete failed', 'Close', { duration: 3000 }); }
      });
    });
  }
}
