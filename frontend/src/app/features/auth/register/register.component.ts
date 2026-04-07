import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { MatSnackBar } from '@angular/material/snack-bar';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../../../environments/environment';

@Component({
  selector: 'app-register',
  styles: [`
    .register-page {
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      background: linear-gradient(135deg, #001733 0%, #002c5f 50%, #003d7a 100%);
      padding: 24px;
      position: relative;
      overflow: hidden;
    }
    .register-page::before {
      content: '';
      position: absolute;
      width: 500px; height: 500px; border-radius: 50%;
      background: radial-gradient(circle, rgba(0,170,210,.15) 0%, transparent 70%);
      top: -150px; right: -150px;
    }
    .register-page::after {
      content: '';
      position: absolute;
      width: 400px; height: 400px; border-radius: 50%;
      background: radial-gradient(circle, rgba(0,170,210,.08) 0%, transparent 70%);
      bottom: -100px; left: -100px;
    }
    .register-box {
      width: 100%; max-width: 580px;
      background: #fff; border-radius: 16px;
      padding: 40px; box-shadow: 0 24px 64px rgba(0,0,0,.35);
      position: relative; z-index: 1;
    }
    .brand-header { text-align: center; margin-bottom: 28px; }
    .brand-logo {
      width: 56px; height: 56px; border-radius: 14px;
      background: #002c5f; display: flex; align-items: center;
      justify-content: center; font-size: 1.5rem; font-weight: 900;
      color: #00aad2; margin: 0 auto 12px;
    }
    .brand-header h1 { font-size: 1.25rem; font-weight: 700; color: #002c5f; }
    .brand-header p { font-size: .8rem; color: #64748b; margin-top: 4px; }
    .section-label {
      font-size: .7rem; font-weight: 700; text-transform: uppercase;
      letter-spacing: .08em; color: #002c5f;
      margin: 20px 0 12px; padding-bottom: 6px;
      border-bottom: 1px solid #e2e8f0; display: flex; align-items: center; gap: 8px;
    }
    .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 0 16px; }
    .login-link { text-align: center; margin-top: 16px; font-size: .8rem; color: #64748b; }
    .login-link a { color: #002c5f; font-weight: 600; cursor: pointer; text-decoration: none; }
    .success-box {
      text-align: center; padding: 32px; background: #dcfce7;
      border-radius: 12px; margin-top: 12px;
    }
    .success-box mat-icon { font-size: 48px; width: 48px; height: 48px; color: #15803d; }
    .success-box h2 { color: #15803d; margin: 12px 0 8px; }
    .success-box p { color: #166534; font-size: .85rem; }
  `],
  template: `
    <div class="register-page">
      <div class="register-box">
        <!-- Brand -->
        <div class="brand-header">
          <div class="brand-logo">H</div>
          <h1>Apply for Dealer Access</h1>
          <p>Register your dealership to join the DealerConnect network</p>
        </div>

        <!-- Success State -->
        <div class="success-box" *ngIf="submitted">
          <mat-icon>check_circle</mat-icon>
          <h2>Application Submitted!</h2>
          <p>Your dealership application is under review by the DMS team.<br>
             You will be able to log in once your application is approved.</p>
          <button mat-raised-button style="background:#002c5f;color:#fff;margin-top:16px" (click)="goToLogin()">
            Go to Login
          </button>
        </div>

        <!-- Registration Form -->
        <form [formGroup]="form" (ngSubmit)="onSubmit()" *ngIf="!submitted">

          <div class="section-label"><mat-icon style="font-size:15px;width:15px;height:15px">store</mat-icon> Dealership Information</div>
          <mat-form-field appearance="outline" class="w-100">
            <mat-label>Dealership Name</mat-label>
            <input matInput formControlName="dealerName" placeholder="e.g. DealerConnect Bangalore North">
            <mat-error *ngIf="f['dealerName'].hasError('required')">Required</mat-error>
          </mat-form-field>

          <div class="form-row">
            <mat-form-field appearance="outline">
              <mat-label>City</mat-label>
              <input matInput formControlName="city">
              <mat-error *ngIf="f['city'].hasError('required')">Required</mat-error>
            </mat-form-field>
            <mat-form-field appearance="outline">
              <mat-label>State</mat-label>
              <input matInput formControlName="state">
              <mat-error *ngIf="f['state'].hasError('required')">Required</mat-error>
            </mat-form-field>
          </div>

          <div class="form-row">
            <mat-form-field appearance="outline">
              <mat-label>GST Number (Optional)</mat-label>
              <input matInput formControlName="gstNumber">
            </mat-form-field>
            <mat-form-field appearance="outline">
              <mat-label>Contact Phone</mat-label>
              <input matInput formControlName="contactPhone">
              <mat-error *ngIf="f['contactPhone'].hasError('required')">Required</mat-error>
              <mat-error *ngIf="f['contactPhone'].hasError('pattern')">Valid 10-digit number required</mat-error>
            </mat-form-field>
          </div>

          <mat-form-field appearance="outline" class="w-100">
            <mat-label>Address</mat-label>
            <textarea matInput formControlName="address" rows="2"></textarea>
          </mat-form-field>

          <div class="section-label"><mat-icon style="font-size:15px;width:15px;height:15px">person</mat-icon> Admin Account Details</div>
          <mat-form-field appearance="outline" class="w-100">
            <mat-label>Admin Full Name</mat-label>
            <input matInput formControlName="adminFullName">
            <mat-error *ngIf="f['adminFullName'].hasError('required')">Required</mat-error>
          </mat-form-field>

          <div class="form-row">
            <mat-form-field appearance="outline">
              <mat-label>Admin Email</mat-label>
              <input matInput formControlName="adminEmail" type="email">
              <mat-error *ngIf="f['adminEmail'].hasError('required')">Required</mat-error>
              <mat-error *ngIf="f['adminEmail'].hasError('email')">Invalid email</mat-error>
            </mat-form-field>
            <mat-form-field appearance="outline">
              <mat-label>Password</mat-label>
              <input matInput formControlName="adminPasswordHash" [type]="showPwd ? 'text' : 'password'">
              <button mat-icon-button matSuffix type="button" (click)="showPwd = !showPwd">
                <mat-icon style="color:#94a3b8">{{showPwd ? 'visibility_off' : 'visibility'}}</mat-icon>
              </button>
              <mat-error *ngIf="f['adminPasswordHash'].hasError('required')">Required</mat-error>
              <mat-error *ngIf="f['adminPasswordHash'].hasError('minlength')">Min 8 characters</mat-error>
            </mat-form-field>
          </div>

          <!-- Error message -->
          <div *ngIf="errorMsg" style="background:#fee2e2;color:#b91c1c;padding:10px 14px;border-radius:8px;font-size:.8rem;margin-bottom:12px;display:flex;align-items:center;gap:8px">
            <mat-icon style="font-size:16px;width:16px;height:16px">error_outline</mat-icon>
            {{errorMsg}}
          </div>

          <button mat-raised-button style="width:100%;height:46px;background:#002c5f;color:#fff;font-weight:600;font-size:.9rem;border-radius:8px;margin-top:8px" type="submit" [disabled]="loading">
            <mat-spinner *ngIf="loading" diameter="18" style="display:inline-block;vertical-align:middle;margin-right:8px"></mat-spinner>
            <span>{{loading ? 'Submitting…' : 'Submit Application'}}</span>
          </button>

          <div class="login-link">
            Already have an account? <a (click)="goToLogin()">Sign In</a>
          </div>
        </form>
      </div>
    </div>
  `
})
export class RegisterComponent {
  form = this.fb.group({
    dealerName:       ['', Validators.required],
    city:             ['', Validators.required],
    state:            ['', Validators.required],
    address:          [''],
    gstNumber:        [''],
    contactPhone:     ['', [Validators.required, Validators.pattern('^[0-9]{10}$')]],
    contactName:      [''],
    adminFullName:    ['', Validators.required],
    adminEmail:       ['', [Validators.required, Validators.email]],
    adminPasswordHash:['', [Validators.required, Validators.minLength(8)]]
  });

  loading   = false;
  showPwd   = false;
  submitted = false;
  errorMsg  = '';

  get f() { return this.form.controls; }

  constructor(private fb: FormBuilder, private http: HttpClient, private router: Router) {}

  onSubmit() {
    if (this.form.invalid) { this.form.markAllAsTouched(); return; }
    this.loading  = true;
    this.errorMsg = '';
    // Set contactName from adminFullName if not provided
    if (!this.form.value.contactName) {
      this.form.patchValue({ contactName: this.form.value.adminFullName });
    }
    this.http.post(`${environment.apiUrl}/dealers/register`, this.form.value).subscribe({
      next: () => { this.loading = false; this.submitted = true; },
      error: (err) => {
        this.loading = false;
        this.errorMsg = err.error?.message || 'Submission failed. Please try again.';
      }
    });
  }

  goToLogin() { this.router.navigate(['/login']); }
}
