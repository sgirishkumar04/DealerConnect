import { Component, Input, Output, EventEmitter, OnInit } from '@angular/core';
import { Router, NavigationEnd } from '@angular/router';
import { AuthService } from '../../../core/services/auth.service';
import { filter } from 'rxjs/operators';

@Component({
  selector: 'app-header',
  template: `
    <div class="header-bar">
      <!-- Mobile Logo (shown only on mobile when sidebar is hidden) -->
      <div class="mobile-logo" *ngIf="isMobile">
        <div class="logo-icon-sm">H</div>
      </div>

      <!-- Sidebar toggle / Hamburger -->
      <button class="toggle-btn" (click)="toggleSidebar.emit()">
        <mat-icon>{{isMobile ? 'menu' : (sidebarCollapsed ? 'menu_open' : 'menu')}}</mat-icon>
      </button>

      <!-- Breadcrumb / Page title -->
      <div class="breadcrumb" [class.hidden-mobile]="isMobile && pageTitle.length > 15">
        <span *ngIf="!isMobile">DealerConnect</span>
        <mat-icon *ngIf="!isMobile">chevron_right</mat-icon>
        
        <!-- Dashboard Link (clickable only if not on Dashboard) -->
        <a *ngIf="router.url !== '/dashboard'" routerLink="/dashboard" class="breadcrumb-link">Dashboard</a>
        <span *ngIf="router.url === '/dashboard'" class="breadcrumb-page">Dashboard</span>
        
        <!-- History-based Breadcrumbs -->
        <ng-container *ngFor="let item of breadcrumbHistory; let last = last">
          <mat-icon>chevron_right</mat-icon>
          <a *ngIf="!last" [routerLink]="item.url" class="breadcrumb-link">{{item.label}}</a>
          <span *ngIf="last" class="breadcrumb-page">{{item.label}}</span>
        </ng-container>
      </div>

      <!-- Spacer -->
      <div class="flex-1"></div>

      <!-- Date/time (Hidden on mobile to save space) -->
      <span class="text-sm text-secondary nowrap d-flex align-center date-display" *ngIf="!isMobile" style="gap:6px">
        <mat-icon style="font-size:16px;width:16px;height:16px;color:var(--text-muted)">today</mat-icon>
        {{today}}
      </span>

      <!-- Actions -->
      <div class="header-actions">
        <!-- Notification hidden on small mobile if needed, but keeping for now -->
        <button mat-icon-button matTooltip="Notifications" *ngIf="!isMobile">
          <mat-icon style="color:var(--text-secondary)">notifications_none</mat-icon>
        </button>

        <!-- User menu - Compact on mobile -->
        <div [matMenuTriggerFor]="userMenu" class="user-menu-btn">
          <div class="user-avatar-sm">
            {{initials}}
          </div>
          <div class="user-info-header" *ngIf="!isMobile">
            <div class="user-name-top">{{auth.currentUser?.fullName}}</div>
            <div class="user-role-top">{{roleName}}</div>
          </div>
          <mat-icon class="expand-icon">expand_more</mat-icon>
        </div>

        <mat-menu #userMenu="matMenu" xPosition="before">
          <div mat-menu-item disabled style="opacity:.7;font-size:.75rem;line-height:1.3;padding:8px 16px">
            <div>{{auth.currentUser?.email}}</div>
          </div>
          <mat-divider></mat-divider>
          <button mat-menu-item (click)="logout()">
            <mat-icon>logout</mat-icon>
            <span>Sign Out</span>
          </button>
        </mat-menu>
      </div>
    </div>
  `
})
export class HeaderComponent implements OnInit {
  @Input()  sidebarCollapsed = false;
  @Input()  isMobile = false;
  @Output() toggleSidebar    = new EventEmitter<void>();

  pageTitle = 'Dashboard';
  today = '';
  breadcrumbHistory: { label: string, url: string }[] = [];
  private readonly MAX_HISTORY = 6;

  constructor(public auth: AuthService, public router: Router) {}

  ngOnInit() {
    this.today = new Date().toLocaleDateString('en-IN', { weekday: 'short', day: 'numeric', month: 'short', year: 'numeric' });

    this.router.events.pipe(filter(e => e instanceof NavigationEnd)).subscribe((e: any) => {
      this.updateBreadcrumbs(e.urlAfterRedirects);
    });
    this.updateBreadcrumbs(this.router.url);
  }

  private updateBreadcrumbs(url: string) {
    const cleanUrl = url.split('?')[0];
    this.pageTitle = this.routeToTitle(cleanUrl);
    
    if (cleanUrl === '/dashboard') {
      this.breadcrumbHistory = [];
      return;
    }

    // If page is already in history, trim everything after it
    const index = this.breadcrumbHistory.findIndex(h => h.url === cleanUrl);
    if (index !== -1) {
      this.breadcrumbHistory = this.breadcrumbHistory.slice(0, index + 1);
    } else {
      // Limit depth for UI cleanliness
      if (this.breadcrumbHistory.length >= this.MAX_HISTORY) {
        this.breadcrumbHistory.shift();
      }
      this.breadcrumbHistory.push({ label: this.pageTitle, url: cleanUrl });
    }
  }

  private routeToTitle(url: string): string {
    // 1. Clean URL from query params if any
    const cleanUrl = url.split('?')[0];

    const map: Record<string, string> = {
      '/dashboard':        'Dashboard',
      '/inventory':        'Vehicle Inventory',
      '/inventory/new':    'Add New Vehicle',
      '/customers':        'Customers',
      '/customers/new':    'Add New Customer',
      '/leads':            'Leads & Enquiries',
      '/leads/new':        'New Lead Enquiry',
      '/sales':            'Sales',
      '/service':          'Service Center',
      '/service/add':      'Schedule Service',
      '/parts':            'Spare Parts',
      '/finance':          'Finance & Insurance',
      '/employees':        'Employees',
      '/employees/add':    'Add New Employee',
      '/employees/roles':  'Role Permissions',
      '/reports':          'Reports',
      '/super-admin':      'Dealer Management'
    };
    
    // 2. Try exact match
    if (map[cleanUrl]) return map[cleanUrl];

    // 3. Try base segment match (for edit pages, etc.)
    const seg = '/' + cleanUrl.split('/')[1];
    return map[seg] ?? 'DealerConnect';
  }

  logout() { this.auth.logout(); }

  get initials(): string {
    const name = this.auth.currentUser?.fullName ?? '';
    return name.split(' ').map(n => n[0]).join('').toUpperCase().slice(0, 2);
  }

  get roleName(): string {
    return (this.auth.role ?? '').replace('ROLE_', '').replace(/_/g, ' ');
  }
}
