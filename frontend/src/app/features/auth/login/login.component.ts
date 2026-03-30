import { Component } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { MatSnackBar } from '@angular/material/snack-bar';
import { AuthService } from '../../../core/services/auth.service';
import { roleHome } from '../../../core/guards/auth.guard';

@Component({
  selector: 'app-login',
  template: `
    <div class="login-page">
      <div class="login-box">

        <!-- Brand -->
        <div class="login-brand">
          <div class="brand-logo">H</div>
          <h1>Hyundai DMS</h1>
          <p>Dealer Management System — Sign in to continue</p>
        </div>

        <!-- Form -->
        <form [formGroup]="form" (ngSubmit)="onSubmit()">
          <mat-form-field appearance="outline" class="w-100">
            <mat-label>Email Address</mat-label>
            <input matInput formControlName="email" type="email" autocomplete="email"
                   placeholder="you&#64;hyundaidms.in">
            <mat-icon matSuffix style="color:var(--text-muted)">mail_outline</mat-icon>
            <mat-error *ngIf="form.get('email')?.hasError('required')">Email is required</mat-error>
            <mat-error *ngIf="form.get('email')?.hasError('email')">Enter a valid email</mat-error>
          </mat-form-field>

          <mat-form-field appearance="outline" class="w-100 mt-1">
            <mat-label>Password</mat-label>
            <input matInput formControlName="password" [type]="showPwd ? 'text' : 'password'"
                   autocomplete="current-password">
            <button mat-icon-button matSuffix type="button" (click)="showPwd = !showPwd">
              <mat-icon style="color:var(--text-muted)">{{showPwd ? 'visibility_off' : 'visibility'}}</mat-icon>
            </button>
            <mat-error *ngIf="form.get('password')?.hasError('required')">Password is required</mat-error>
          </mat-form-field>

          <!-- Error alert -->
          <div *ngIf="errorMsg" style="background:#fee2e2;color:#b91c1c;padding:10px 14px;border-radius:8px;font-size:.8rem;margin-bottom:12px;display:flex;align-items:center;gap:8px">
            <mat-icon style="font-size:16px;width:16px;height:16px">error_outline</mat-icon>
            {{errorMsg}}
          </div>

          <button mat-raised-button class="login-btn" type="submit" [disabled]="loading">
            <mat-spinner *ngIf="loading" diameter="18" style="display:inline-block;vertical-align:middle;margin-right:8px"></mat-spinner>
            <span>{{loading ? 'Signing in…' : 'Sign In'}}</span>
          </button>
        </form>



        <!-- Footer -->
        <div style="margin-top:24px; text-align:center; display:flex; flex-direction:column; gap:12px;">
          <div style="font-size:.85rem; color:var(--text-secondary)">
            New dealership? <a routerLink="/login/register" style="color:var(--hd-blue); font-weight:600; text-decoration:none">Register Here</a>
          </div>
          <div style="font-size:.7rem; color:var(--text-muted)">
            © 2026 Hyundai Motor India · Dealer Management System
          </div>
        </div>
      </div>
    </div>
  `
})
export class LoginComponent {
  form = this.fb.group({
    email:    ['', [Validators.required, Validators.email]],
    password: ['', Validators.required]
  });
  loading  = false;
  showPwd  = false;
  errorMsg = '';

  constructor(
    private fb: FormBuilder,
    private auth: AuthService,
    private router: Router,
    private snack: MatSnackBar
  ) {}

  onSubmit() {
    if (this.form.invalid) return;
    this.loading  = true;
    this.errorMsg = '';
    const { email, password } = this.form.value;
    this.auth.login(email!, password!).subscribe({
      next: (res) => {
          this.loading = false;
          const role = (res.role ?? '').replace('ROLE_', '');
          this.router.navigate([roleHome(role)]);
        },
      error: (err) => {
        this.loading  = false;
        this.errorMsg = err.error?.message || 'Invalid email or password. Please check your credentials.';
      }
    });
  }
}
