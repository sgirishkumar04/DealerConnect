import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { MatSnackBar } from '@angular/material/snack-bar';
import { ApiService } from '../../../core/services/api.service';

@Component({
  selector: 'app-customer-form',
  template: `
    <div class="page-header">
      <h1>{{isEdit ? 'Edit' : 'New'}} Customer</h1>
    </div>
    <mat-card style="max-width:900px">
      <mat-card-content style="padding:24px">
        <form [formGroup]="form" (ngSubmit)="onSubmit()">
          
          <div class="form-section">
            <div class="section-title">Personal Information</div>
            <div class="form-row">
              <mat-form-field appearance="outline"><mat-label>Customer Code</mat-label>
                <input matInput formControlName="customerCode"></mat-form-field>
              <mat-form-field appearance="outline"><mat-label>First Name</mat-label>
                <input matInput formControlName="firstName"></mat-form-field>
              <mat-form-field appearance="outline"><mat-label>Last Name</mat-label>
                <input matInput formControlName="lastName"></mat-form-field>
            </div>
            
            <div class="form-row">
              <mat-form-field appearance="outline"><mat-label>Phone</mat-label>
                <input matInput formControlName="phone">
                <mat-error *ngIf="form.get('phone')?.hasError('pattern')">Valid 10-digit number required</mat-error>
              </mat-form-field>
              <mat-form-field appearance="outline"><mat-label>Alternate Phone</mat-label>
                <input matInput formControlName="alternatePhone">
                <mat-error *ngIf="form.get('alternatePhone')?.hasError('pattern')">Valid 10-digit number required</mat-error>
              </mat-form-field>
              <mat-form-field appearance="outline"><mat-label>Email</mat-label>
                <input matInput formControlName="email" type="email"></mat-form-field>
            </div>

            <div class="form-row">
              <mat-form-field appearance="outline"><mat-label>Gender</mat-label>
                <mat-select formControlName="gender">
                  <mat-option value="MALE">Male</mat-option>
                  <mat-option value="FEMALE">Female</mat-option>
                  <mat-option value="OTHER">Other</mat-option>
                </mat-select></mat-form-field>
              <mat-form-field appearance="outline"><mat-label>Customer Type</mat-label>
                <mat-select formControlName="customerType">
                  <mat-option value="INDIVIDUAL">Individual</mat-option>
                  <mat-option value="CORPORATE">Corporate</mat-option>
                </mat-select></mat-form-field>
              <mat-form-field appearance="outline"><mat-label>PAN Number</mat-label>
                <input matInput formControlName="panNumber" maxlength="10"></mat-form-field>
            </div>
          </div>

          <div class="form-section" *ngIf="form.get('customerType')?.value === 'CORPORATE'">
            <div class="section-title">Corporate Information</div>
            <div class="form-row">
              <mat-form-field appearance="outline"><mat-label>Company Name</mat-label>
                <input matInput formControlName="companyName"></mat-form-field>
              <mat-form-field appearance="outline"><mat-label>GST Number</mat-label>
                <input matInput formControlName="gstNumber"></mat-form-field>
            </div>
          </div>

          <div class="form-section">
            <div class="section-title">Address Information</div>
            <div class="form-row">
              <mat-form-field appearance="outline" style="flex:2">
                <mat-label>Address Line 1</mat-label>
                <input matInput formControlName="line1"></mat-form-field>
              <mat-form-field appearance="outline">
                <mat-label>City</mat-label>
                <input matInput formControlName="city"></mat-form-field>
            </div>
            <div class="form-row">
              <mat-form-field appearance="outline">
                <mat-label>State</mat-label>
                <input matInput formControlName="state"></mat-form-field>
              <mat-form-field appearance="outline">
                <mat-label>Pincode</mat-label>
                <input matInput formControlName="pincode">
                <mat-error *ngIf="form.get('pincode')?.hasError('pattern')">Valid 6-digit PIN required</mat-error>
              </mat-form-field>
            </div>
          </div>

          <div class="form-actions">
            <button mat-stroked-button type="button" routerLink="/customers">Cancel</button>
            <button mat-raised-button style="background:var(--hd-blue);color:#fff" type="submit">Save Customer</button>
          </div>
        </form>
      </mat-card-content>
    </mat-card>
  `
})
export class CustomerFormComponent implements OnInit {
  form = this.fb.group({
    customerCode: ['', Validators.required], firstName: ['', Validators.required],
    lastName: ['', Validators.required], phone: ['', [Validators.required, Validators.pattern('^[0-9]{10}$')]],
    alternatePhone: ['', Validators.pattern('^$|^[0-9]{10}$')], email: ['', Validators.email], gender: [''],
    customerType: ['INDIVIDUAL'], panNumber: [''], companyName: [''], gstNumber: [''],
    // Address fields
    line1: [''], city: [''], state: [''], pincode: ['', Validators.pattern('^$|^[1-9][0-9]{5}$')]
  });
  isEdit = false; customerId: number | null = null;

  constructor(private fb: FormBuilder, private api: ApiService,
              private router: Router, private route: ActivatedRoute,
              private snack: MatSnackBar) {}

  ngOnInit() {
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.isEdit = true; this.customerId = +id;
      this.api.getCustomer(+id).subscribe((c: any) => {
        this.form.patchValue(c);
        if (c.addresses && c.addresses.length > 0) {
          const primary = c.addresses.find((a: any) => a.isPrimary) || c.addresses[0];
          this.form.patchValue({
            line1: primary.line1,
            city: primary.city,
            state: primary.state,
            pincode: primary.pincode
          });
        }
      });
    } else {
      this.api.getNextCustomerCode().subscribe(res => {
        this.form.patchValue({ customerCode: res.code });
      });
    }
  }

  onSubmit() {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      this.snack.open('Please fix the errors in the form', 'Close', { duration: 3000 });
      return;
    }
    /*
   ### Final Multi-Tenant State
- **Hyundai Chennai Admin**: Sees 85 leads, 39 in-stock vehicles, and historical revenue.
- **Prachi Kumari (Hyundai Delhi)**: Correctly isolated with 0 leads/revenue.
- **Super Admin View**: Correctly shows Girish as the contact for Chennai and Prachi for Delhi. No duplicates.
- **Dealer Approval**: Fixed GST collisions (empty strings are now NULL) and robust employee code generation (`DLRxx-ADM`).
- **Customer Code**: Auto-filled in the "New Customer" form based on the dealer (e.g., `CST-DLR05-0001`).

## How to Test
1. **Login as Abhinav K**: (The new dealer)
2. **New Customer**: Go to "Customers" -> "New Customer". Verify the "Customer Code" is already filled.
3. **Dashboard Recovery**: Login as Girish and verify all 0s are gone.
*/
    const val: any = this.form.value;
    
    // Format addresses array for backend
    const payload = {
      ...val,
      addresses: [{
        type: 'HOME',
        line1: val.line1,
        city: val.city,
        state: val.state,
        pincode: val.pincode,
        isPrimary: true
      }]
    };

    const obs = this.isEdit
      ? this.api.updateCustomer(this.customerId!, payload)
      : this.api.createCustomer(payload);
    obs.subscribe(() => { this.snack.open('Saved!', 'OK', {duration:3000}); this.router.navigate(['/customers']); });
  }
}
