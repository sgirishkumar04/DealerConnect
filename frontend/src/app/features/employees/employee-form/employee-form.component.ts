import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators, FormGroup } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { MatSnackBar } from '@angular/material/snack-bar';
import { ApiService } from '../../../core/services/api.service';
import { Role, Department } from '../../../core/models/models';

@Component({
  selector: 'app-employee-form',
  template: `
    <div class="page-container" style="max-width:900px; margin:0 auto; padding: 20px;">
      <div class="page-header mb-4" style="display:flex; align-items:center; gap:16px">
        <button mat-icon-button (click)="router.navigate(['/employees'])" style="background: #f1f5f9">
          <mat-icon>arrow_back</mat-icon>
        </button>
        <div>
          <h1 style="margin:0; font-size: 1.75rem; font-weight: 800; color: #1e293b">{{isEdit ? 'Update' : 'Register New'}} Employee</h1>
          <p style="margin:0; color: #64748b">{{isEdit ? 'Modify staff details and role' : 'Onboard a new staff member to the dealership'}}</p>
        </div>
      </div>

      <form [formGroup]="form" (ngSubmit)="onSubmit()">
        <div class="grid">
          <!-- Main Details -->
          <mat-card class="premium-card mb-4">
            <mat-card-header>
              <mat-card-title>Personal Information</mat-card-title>
            </mat-card-header>
            <mat-card-content class="pt-4">
              <div class="form-row">
                <mat-form-field appearance="outline">
                  <mat-label>First Name</mat-label>
                  <input matInput formControlName="firstName" required>
                  <mat-icon matSuffix>person</mat-icon>
                </mat-form-field>
                <mat-form-field appearance="outline">
                  <mat-label>Last Name</mat-label>
                  <input matInput formControlName="lastName" required>
                </mat-form-field>
              </div>

              <div class="form-row">
                <mat-form-field appearance="outline">
                  <mat-label>Contact email</mat-label>
                  <input matInput formControlName="email" type="email" required>
                  <mat-icon matSuffix>alternate_email</mat-icon>
                </mat-form-field>
                <mat-form-field appearance="outline">
                  <mat-label>Phone Number</mat-label>
                  <input matInput formControlName="phone">
                  <mat-icon matSuffix>phone</mat-icon>
                  <mat-error *ngIf="form.get('phone')?.hasError('pattern')">Valid 10-digit number required</mat-error>
                </mat-form-field>
              </div>
            </mat-card-content>
          </mat-card>

          <!-- Employment Details -->
          <mat-card class="premium-card mb-4">
            <mat-card-header>
              <mat-card-title>Job & Department</mat-card-title>
            </mat-card-header>
            <mat-card-content class="pt-4">
              <div class="form-row">
                <mat-form-field appearance="outline">
                  <mat-label>Department</mat-label>
                  <mat-select formControlName="departmentId" required>
                    <mat-option *ngFor="let d of departments" [value]="d.id">{{d.name}}</mat-option>
                  </mat-select>
                  <mat-icon matSuffix>business</mat-icon>
                </mat-form-field>
                <mat-form-field appearance="outline">
                  <mat-label>Role / Designation</mat-label>
                  <mat-select formControlName="roleId" required>
                    <mat-option *ngFor="let r of roles" [value]="r.id">{{r.name}}</mat-option>
                  </mat-select>
                  <mat-icon matSuffix>badge</mat-icon>
                </mat-form-field>
              </div>

              <div class="form-row">
                <mat-form-field appearance="outline">
                  <mat-label>Date of Joining</mat-label>
                  <input matInput type="date" formControlName="dateOfJoin" required>
                </mat-form-field>
                <div class="info-pill" *ngIf="!isEdit">
                  <mat-icon style="font-size:16px; width:16px; height:16px">info</mat-icon>
                  <span>Employee code will be auto-generated on save.</span>
                </div>
                <mat-form-field appearance="outline" *ngIf="isEdit">
                  <mat-label>Employee Code</mat-label>
                  <input matInput formControlName="employeeCode" readonly style="color:#64748b">
                </mat-form-field>
              </div>
            </mat-card-content>
          </mat-card>

          <!-- Security (New Only) -->
          <mat-card class="premium-card mb-4" *ngIf="!isEdit">
            <mat-card-header>
              <mat-card-title>Security & Login</mat-card-title>
            </mat-card-header>
            <mat-card-content class="pt-4">
              <mat-form-field appearance="outline" class="w-full">
                <mat-label>Temporary Password</mat-label>
                <input matInput formControlName="password" type="password" [required]="!isEdit">
                <mat-icon matSuffix>lock</mat-icon>
                <mat-hint>At least 8 chars, 1 uppercase, 1 special character.</mat-hint>
                <mat-error *ngIf="form.get('password')?.hasError('pattern')">
                  Password does not meet complexity requirements.
                </mat-error>
              </mat-form-field>
            </mat-card-content>
          </mat-card>

          <div class="form-actions mt-4">
            <button mat-button type="button" (click)="router.navigate(['/employees'])" class="cancel-btn">Cancel</button>
            <button mat-flat-button color="primary" type="submit" [disabled]="form.invalid || saving" class="submit-btn ml-3">
              <mat-icon *ngIf="!saving">check_circle</mat-icon>
              <span>{{saving ? 'Processing...' : (isEdit ? 'Update Profile' : 'Confirm Registration')}}</span>
            </button>
          </div>
        </div>
      </form>
    </div>
  `,
  styles: [`
    .premium-card { border-radius: 12px; border: 1px solid #f1f5f9; box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1); }
    mat-card-title { font-size: 1.1rem; font-weight: 700; color: #334155; }
    .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
    .w-full { width: 100%; }
    .mb-4 { margin-bottom: 1.5rem; }
    .mt-4 { margin-top: 1.5rem; }
    .ml-3 { margin-left: 12px; }
    
    .info-pill { display: flex; align-items: center; gap: 8px; background: #f8fafc; padding: 12px 16px; border-radius: 8px; border: 1px solid #e2e8f0; color: #64748b; font-size: 0.85rem; height: fit-content; align-self: center; }
    
    .form-actions { display: flex; justify-content: flex-end; padding-bottom: 40px; }
    .submit-btn { height: 48px; min-width: 180px; font-weight: 700; border-radius: 8px; }
    .cancel-btn { height: 48px; font-weight: 600; color: #64748b; }

    @media (max-width: 600px) {
      .form-row { grid-template-columns: 1fr; gap: 0; }
    }
  `]
})
export class EmployeeFormComponent implements OnInit {
  form: FormGroup;
  roles: Role[] = [];
  departments: Department[] = [];
  isEdit = false;
  empId: number | null = null;
  saving = false;

  constructor(
    private fb: FormBuilder,
    private api: ApiService,
    public router: Router,
    private route: ActivatedRoute,
    private snack: MatSnackBar
  ) {
    this.form = this.fb.group({
      employeeCode: [''],
      firstName: ['', Validators.required],
      lastName: ['', Validators.required],
      email: ['', [Validators.required, Validators.email]],
      phone: ['', [Validators.pattern('^[0-9]{10}$')]],
      departmentId: ['', Validators.required],
      roleId: ['', Validators.required],
      password: [''],
      dateOfJoin: [new Date().toISOString().split('T')[0], Validators.required]
    });
  }

  ngOnInit() {
    this.api.getRoles().subscribe(r => this.roles = r);
    this.api.getDepartments().subscribe(d => this.departments = d);
    
    const passwordRegex = /^(?=.*[A-Z])(?=.*[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]).{8,}$/;
    const id = this.route.snapshot.paramMap.get('id');
    if (id) {
      this.isEdit = true;
      this.empId = +id;
      this.form.get('password')?.setValidators([Validators.minLength(8), Validators.pattern(passwordRegex)]);
      this.api.getEmployee(this.empId).subscribe(e => {
        this.form.patchValue({
          employeeCode: e.employeeCode,
          firstName: e.firstName,
          lastName: e.lastName,
          email: e.email,
          phone: e.phone,
          departmentId: e.department?.id,
          roleId: e.role?.id,
          dateOfJoin: e.dateOfJoin
        });
      });
    } else {
      this.form.get('password')?.setValidators([Validators.required, Validators.minLength(8), Validators.pattern(passwordRegex)]);
    }
  }

  onSubmit() {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      this.snack.open('Please fix the errors in the form', 'Close', { duration: 3000 });
      return;
    }
    this.saving = true;

    const obs = this.isEdit
      ? this.api.updateEmployee(this.empId!, this.form.value)
      : this.api.createEmployee(this.form.value);

    obs.subscribe({
      next: () => {
        this.snack.open(`Employee successfully ${this.isEdit ? 'updated' : 'registered'}!`, 'Close', { duration: 3000 });
        this.router.navigate(['/employees']);
      },
      error: (err) => {
        console.error('Employee Save Error:', err);
        this.snack.open('Failed to save employee. Please check details.', 'Close', { duration: 4000 });
        this.saving = false;
      }
    });
  }
}
