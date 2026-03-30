import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators, FormControl } from '@angular/forms';
import { Router } from '@angular/router';
import { ApiService } from '../../../core/services/api.service';
import { MatSnackBar } from '@angular/material/snack-bar';
import { Observable, of } from 'rxjs';
import { debounceTime, distinctUntilChanged, switchMap, map, catchError } from 'rxjs/operators';

@Component({
  selector: 'app-booking-form',
  template: `
    <div class="page-container" style="max-width:1100px;margin:0 auto; padding: 20px;">
      <div class="page-header mb-4" style="display:flex; align-items:center; gap:16px">
        <button mat-icon-button (click)="router.navigate(['/sales'])" style="background: #f1f5f9">
          <mat-icon>arrow_back</mat-icon>
        </button>
        <div>
          <h1 style="margin:0; font-size: 1.75rem; font-weight: 800; color: #1e293b">New Vehicle Booking</h1>
          <p style="margin:0; color: #64748b">Secure a sale and allocate vehicle inventory</p>
        </div>
      </div>

      <form [formGroup]="form" (ngSubmit)="onSubmit()">
        <div class="booking-grid">
          
          <!-- Left Column: Details -->
          <div class="details-section">
            <mat-card class="premium-card mb-4">
              <mat-card-header>
                <mat-card-title>Customer Selection</mat-card-title>
              </mat-card-header>
              <mat-card-content class="pt-4">
                <div class="mb-4">
                  <mat-button-toggle-group [(ngModel)]="customerMode" [ngModelOptions]="{standalone:true}" (change)="onModeChange()" class="premium-toggle">
                    <mat-button-toggle value="NEW">New Inquiry (Guest)</mat-button-toggle>
                    <mat-button-toggle value="EXISTING">Existing Customer</mat-button-toggle>
                  </mat-button-toggle-group>
                </div>

                <div class="form-row" *ngIf="customerMode === 'EXISTING'">
                  <mat-form-field appearance="outline" class="w-full">
                    <mat-label>Search Customer (Name or Phone)</mat-label>
                    <input type="text" matInput [formControl]="customerSearchCtrl" [matAutocomplete]="auto">
                    <mat-icon matPrefix color="primary" style="margin-right:8px">search</mat-icon>
                    <mat-autocomplete #auto="matAutocomplete" [displayWith]="displayCustomer" (optionSelected)="onCustomerSelect($event.option.value)">
                      <mat-option *ngIf="searchingCustomers" class="is-loading">Searching...</mat-option>
                      <mat-option *ngFor="let c of filteredCustomers$ | async" [value]="c">
                        {{c.firstName}} {{c.lastName}} ({{c.phone}})
                      </mat-option>
                    </mat-autocomplete>
                  </mat-form-field>
                </div>

                <div class="form-row" *ngIf="customerMode === 'NEW'">
                  <mat-form-field appearance="outline">
                    <mat-label>Full Name</mat-label>
                    <input matInput formControlName="customerName">
                  </mat-form-field>
                  <mat-form-field appearance="outline">
                    <mat-label>Phone Number</mat-label>
                    <input matInput formControlName="customerPhone">
                    <mat-error *ngIf="form.get('customerPhone')?.hasError('pattern')">Valid 10-digit number required</mat-error>
                  </mat-form-field>
                </div>
              </mat-card-content>
            </mat-card>

            <mat-card class="premium-card mb-4">
              <mat-card-header>
                <mat-card-title>Vehicle Allocation</mat-card-title>
              </mat-card-header>
              <mat-card-content class="pt-4">
                <mat-form-field appearance="outline" class="w-full mb-3">
                  <mat-label>Select Vehicle (In Stock)</mat-label>
                  <mat-select formControlName="vehicleId" required (selectionChange)="onVehicleSelect($event.value)">
                    <mat-option *ngFor="let v of vehicles" [value]="v.id">
                      {{v.variant?.model?.modelName}} {{v.variant?.variantName}} – {{v.color?.name}}
                    </mat-option>
                  </mat-select>
                  <mat-icon matSuffix color="primary">directions_car</mat-icon>
                </mat-form-field>

                <div class="vehicle-pill" *ngIf="selectedVehicle">
                  <div class="pill-info">
                    <strong>VIN:</strong> {{selectedVehicle.vin}}
                  </div>
                  <div class="pill-info">
                    <strong>Engine:</strong> {{selectedVehicle.engineNumber}}
                  </div>
                </div>

                <div class="form-row mt-3">
                  <mat-form-field appearance="outline">
                    <mat-label>Sales Executive</mat-label>
                    <mat-select formControlName="salesExecId" required>
                      <mat-option *ngFor="let e of execs" [value]="e.id">
                        {{e.firstName}} {{e.lastName}}
                      </mat-option>
                    </mat-select>
                  </mat-form-field>
                  <mat-form-field appearance="outline">
                    <mat-label>Expected Delivery</mat-label>
                    <input matInput type="date" formControlName="expectedDelivery" required>
                  </mat-form-field>
                </div>
              </mat-card-content>
            </mat-card>
          </div>

          <!-- Right Column: Price Breakdown -->
          <div class="price-section">
            <mat-card class="premium-card price-card">
              <mat-card-header>
                <mat-card-title>Price Breakdown</mat-card-title>
              </mat-card-header>
              <mat-card-content class="pt-4">
                <div class="price-input-group">
                  <div class="price-row">
                    <span>Ex-Showroom Price</span>
                    <mat-form-field appearance="fill" class="compact-field">
                      <span matPrefix>₹&nbsp;</span>
                      <input matInput type="number" formControlName="exShowroom" required (input)="calculateTotal()">
                    </mat-form-field>
                  </div>
                  <div class="price-row">
                    <span>Insurance Premium</span>
                    <mat-form-field appearance="fill" class="compact-field">
                      <span matPrefix>₹&nbsp;</span>
                      <input matInput type="number" formControlName="insuranceAmt" (input)="calculateTotal()">
                    </mat-form-field>
                  </div>
                  <div class="price-row">
                    <span>Registration / RTO</span>
                    <mat-form-field appearance="fill" class="compact-field">
                      <span matPrefix>₹&nbsp;</span>
                      <input matInput type="number" formControlName="registrationAmt" (input)="calculateTotal()">
                    </mat-form-field>
                  </div>
                  <div class="price-row">
                    <span>Accessories</span>
                    <mat-form-field appearance="fill" class="compact-field">
                      <span matPrefix>₹&nbsp;</span>
                      <input matInput type="number" formControlName="accessoriesAmt" (input)="calculateTotal()">
                    </mat-form-field>
                  </div>
                  <div class="separator"></div>
                  <div class="price-row discount">
                    <span>Discount</span>
                    <mat-form-field appearance="fill" class="compact-field danger">
                      <span matPrefix>₹&nbsp;</span>
                      <input matInput type="number" formControlName="discount" (input)="calculateTotal()">
                    </mat-form-field>
                  </div>
                </div>

                <div class="total-on-road-box mt-4">
                  <div class="label">Total On-Road Value</div>
                  <div class="value">{{ totalValue | currency:'INR':'symbol':'1.0-0' }}</div>
                </div>

                <mat-form-field appearance="outline" class="w-full mt-4">
                  <mat-label>Booking Remarks</mat-label>
                  <textarea matInput formControlName="remarks" rows="3" placeholder="Optional notes..."></textarea>
                </mat-form-field>

                <div class="actions mt-4">
                  <button mat-flat-button color="primary" class="w-full submit-btn" 
                          [disabled]="form.invalid || saving || (customerMode === 'EXISTING' && !form.value.customerId)">
                    <mat-icon *ngIf="!saving">check_circle</mat-icon>
                    <span>{{saving ? 'Processing...' : 'Confirm Vehicle Booking'}}</span>
                  </button>
                  <button mat-button type="button" class="w-full mt-2" (click)="router.navigate(['/sales'])">Exit Without Saving</button>
                </div>
              </mat-card-content>
            </mat-card>
          </div>
        </div>
      </form>
    </div>
  `,
  styles: [`
    .booking-grid { display: grid; grid-template-columns: 1.2fr 0.8fr; gap: 24px; }
    .premium-card { border-radius: 12px; box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1); border: 1px solid #f1f5f9; }
    mat-card-title { font-size: 1.1rem; font-weight: 700; color: #334155; }
    .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
    .w-full { width: 100%; }
    .mb-4 { margin-bottom: 1rem; }
    .mt-4 { margin-top: 1rem; }
    .premium-toggle { width: 100%; display: flex; background: #f8fafc; padding: 4px; border-radius: 8px; border: 1px solid #e2e8f0; }
    .premium-toggle mat-button-toggle { flex: 1; border: none; border-radius: 6px; }
    .premium-toggle .mat-button-toggle-checked { background: #fff !important; box-shadow: 0 1px 3px 0 rgb(0 0 0 / 0.1); color: var(--hd-blue); font-weight: 600; }
    
    .vehicle-pill { display: flex; gap: 12px; background: #eff6ff; padding: 10px 16px; border-radius: 100px; border: 1px solid #dbeafe; margin-bottom: 16px; }
    .pill-info { font-size: 0.85rem; color: #1e40af; }

    .price-card { background: #fff; height: fit-content; sticky: top; top: 20px; }
    .price-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px; }
    .price-row span { color: #64748b; font-weight: 500; }
    .compact-field { width: 130px; }
    ::ng-deep .compact-field .mat-mdc-form-field-subscript-wrapper { display: none; }
    .separator { height: 1px; background: #e2e8f0; margin: 16px 0; }
    .discount span { color: #ef4444; }
    .danger input { color: #ef4444; }

    .total-on-road-box { background: var(--hd-blue); color: #fff; padding: 20px; border-radius: 12px; text-align: center; }
    .total-on-road-box .label { font-size: 0.9rem; opacity: 0.9; margin-bottom: 4px; }
    .total-on-road-box .value { font-size: 1.8rem; font-weight: 800; }
    
    .submit-btn { height: 50px; font-weight: 700; font-size: 1rem; border-radius: 8px; }

    @media (max-width: 900px) {
      .booking-grid { grid-template-columns: 1fr; }
    }
  `]
})
export class BookingFormComponent implements OnInit {
  form: FormGroup;
  customerSearchCtrl = new FormControl();
  filteredCustomers$: Observable<any[]>;
  searchingCustomers = false;
  
  saving = false;
  vehicles: any[] = [];
  execs: any[] = [];
  selectedVehicle: any = null;
  customerMode: 'NEW' | 'EXISTING' = 'NEW';
  totalValue = 0;

  constructor(
    private fb: FormBuilder,
    private api: ApiService,
    private snack: MatSnackBar,
    public router: Router
  ) {
    this.form = this.fb.group({
      customerId: [null],
      customerName: [''],
      customerPhone: ['', [Validators.pattern('^[0-9]{10}$')]],
      vehicleId: ['', Validators.required],
      salesExecId: ['', Validators.required],
      exShowroom: [0, [Validators.required, Validators.min(1000)]],
      discount: [0, Validators.min(0)],
      insuranceAmt: [0, Validators.min(0)],
      registrationAmt: [0, Validators.min(0)],
      accessoriesAmt: [0, Validators.min(0)],
      tcsAmt: [0, Validators.min(0)],
      expectedDelivery: ['', Validators.required],
      remarks: ['']
    });

    this.filteredCustomers$ = this.customerSearchCtrl.valueChanges.pipe(
      debounceTime(300),
      distinctUntilChanged(),
      switchMap(val => {
        if (typeof val !== 'string' || val.length < 2) return of([]);
        this.searchingCustomers = true;
        return this.api.getCustomers({ search: val, size: 20 }).pipe(
          map(res => {
            this.searchingCustomers = false;
            return res.content || [];
          }),
          catchError(() => {
            this.searchingCustomers = false;
            return of([]);
          })
        );
      })
    );
  }

  ngOnInit() {
    this.onModeChange();
    this.api.getVehicles({ page: 0, size: 500 }).subscribe((res: any) => {
      this.vehicles = (res.content || []).filter((v:any) => v.status === 'IN_STOCK');
    });
    this.api.getEmployees({ page: 0, size: 500 }).subscribe((res: any) => {
      this.execs = (res.content || []).filter((e: any) => 
        e.role?.name === 'SALES_EXECUTIVE' || e.role?.name === 'ADMIN' || e.role?.name === 'SALES_MANAGER'
      );
    });
  }

  displayCustomer(c: any): string {
    return c ? `${c.firstName} ${c.lastName} (${c.phone})` : '';
  }

  onCustomerSelect(c: any) {
    this.form.patchValue({ customerId: c.id });
  }

  onModeChange() {
    if (this.customerMode === 'NEW') {
      this.form.get('customerId')?.clearValidators();
      this.form.get('customerName')?.setValidators(Validators.required);
      this.form.get('customerPhone')?.setValidators([Validators.required, Validators.pattern('^[0-9]{10}$')]);
    } else {
      this.form.get('customerId')?.setValidators(Validators.required);
      this.form.get('customerName')?.clearValidators();
      this.form.get('customerPhone')?.clearValidators();
    }
    this.form.get('customerId')?.updateValueAndValidity();
    this.form.get('customerName')?.updateValueAndValidity();
    this.form.get('customerPhone')?.updateValueAndValidity();
  }

  onVehicleSelect(vid: number) {
    this.selectedVehicle = this.vehicles.find(v => v.id === vid);
    if (this.selectedVehicle) {
      const exShowroom = this.selectedVehicle.variant?.exShowroomPrice || 0;
      // Estimate RTO and Insurance based on Ex-Showroom if empty
      this.form.patchValue({
        exShowroom: exShowroom,
        registrationAmt: Math.round(exShowroom * 0.08), // 8% RTO estimate
        insuranceAmt: Math.round(exShowroom * 0.03),   // 3% Insurance estimate
        tcsAmt: exShowroom > 1000000 ? Math.round(exShowroom * 0.01) : 0
      });
      this.calculateTotal();
    }
  }

  calculateTotal() {
    const val = this.form.value;
    this.totalValue = (val.exShowroom || 0) + 
                       (val.registrationAmt || 0) + 
                       (val.insuranceAmt || 0) + 
                       (val.accessoriesAmt || 0) +
                       (val.tcsAmt || 0) - 
                       (val.discount || 0);
  }

  onSubmit() {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      this.snack.open('Please fix the errors in the form before submitting', 'Close', { duration: 4000 });
      return;
    }
    this.saving = true;

    const val = this.form.value;
    this.calculateTotal(); // final sync

    const payload = {
      ...val,
      totalOnRoad: this.totalValue,
      expectedDelivery: val.expectedDelivery ? new Date(val.expectedDelivery).toISOString() : null
    };

    this.api.createBooking(payload).subscribe({
      next: () => {
        this.snack.open('Vehicle Booking Successfully Generated!', 'Close', { duration: 3000 });
        this.router.navigate(['/sales']);
      },
      error: (err) => {
        console.error('Booking Error:', err);
        this.snack.open('Failed to create booking. Please check details.', 'Close', { duration: 4000 });
        this.saving = false;
      }
    });
  }
}
