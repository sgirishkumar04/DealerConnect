import { Component, Input, Output, EventEmitter, OnInit } from '@angular/core';
import { AuthService } from '../../../core/services/auth.service';

interface NavItem {
  label: string;
  icon: string;
  route: string;
  roles?: string[];
  permission?: string;
  section?: string;
  exact?: boolean;
}

@Component({
  selector: 'app-sidebar',
  template: `
    <div class="sidebar-container" [class.collapsed]="collapsed">
      <!-- Mobile Close Button (shown only when drawer is open on mobile) -->
      <button class="mobile-close-btn" (click)="closeDrawer.emit()">
        <mat-icon>close</mat-icon>
      </button>

      <!-- Logo -->
      <div class="sidebar-logo">
        <div class="logo-icon">H</div>
        <div class="logo-text" *ngIf="!collapsed">
          <span class="logo-brand">DealerConnect</span>
          <span class="logo-sub">Dealer Management</span>
        </div>
      </div>

      <!-- Nav Items -->
      <nav class="nav-section">
        <ng-container *ngFor="let item of visibleNavItems()">
          <div *ngIf="item.section && !collapsed" class="nav-label">{{item.section}}</div>
          <a class="nav-item"
             [routerLink]="item.route"
             routerLinkActive="active"
             [routerLinkActiveOptions]="{exact: !!item.exact}"
             [matTooltip]="collapsed ? item.label : ''"
             matTooltipPosition="right"
             (click)="onNavItemClick()">
            <mat-icon>{{item.icon}}</mat-icon>
            <span class="nav-text" *ngIf="!collapsed">{{item.label}}</span>
          </a>
        </ng-container>
      </nav>

      <!-- User footer -->
      <div class="sidebar-footer">
        <div class="user-info"
             [matTooltip]="collapsed ? (auth.currentUser?.fullName ?? '') : ''"
             matTooltipPosition="right">
          <div class="user-avatar">{{initials}}</div>
          <div class="user-details" *ngIf="!collapsed">
            <div class="user-name">{{auth.currentUser?.fullName}}</div>
            <div class="user-role">{{roleName}}</div>
          </div>
        </div>
      </div>
    </div>
  `
})
export class SidebarComponent implements OnInit {
  @Input() collapsed = false;
  @Output() closeDrawer = new EventEmitter<void>();

  // Roles use short names (no ROLE_ prefix) — matched against auth.role which also has no prefix
  navItems: NavItem[] = [
    { section: 'Core',             label: 'Dashboard',         icon: 'dashboard',       route: '/dashboard', exact: true },
    
    // Super Admin Section
    { section: 'Platform Admin',   label: 'Dealer Management', icon: 'admin_panel_settings', route: '/super-admin', roles: ['SUPER_ADMIN'], exact: true },
    {                              label: 'Network Overview',  icon: 'insights',        route: '/super-admin/reports', roles: ['SUPER_ADMIN'] },
    {                              label: 'Audit Logs',        icon: 'history_edu',     route: '/super-admin/audit-logs', roles: ['SUPER_ADMIN'] },

    { section: 'Sales Operations', label: 'Vehicle Inventory', icon: 'directions_car',  route: '/inventory',  roles: ['ADMIN','SALES_MANAGER','SALES_EXECUTIVE','INVENTORY_MANAGER'], permission: 'INVENTORY_VIEW' },
    {                              label: 'Customers',         icon: 'people',          route: '/customers',  roles: ['ADMIN','SALES_MANAGER','SALES_EXECUTIVE'],                     permission: 'SALES_VIEW' },
    {                              label: 'Leads / Enquiries', icon: 'trending_up',     route: '/leads',      roles: ['ADMIN','SALES_MANAGER','SALES_EXECUTIVE'],                     permission: 'SALES_VIEW' },
    {                              label: 'Sales',             icon: 'shopping_cart',   route: '/sales',      roles: ['ADMIN','SALES_MANAGER','SALES_EXECUTIVE','ACCOUNTS'],          permission: 'SALES_VIEW' },
    { section: 'Service',          label: 'Service Center',    icon: 'build_circle',    route: '/service',    roles: ['ADMIN','SERVICE_ADVISOR','MECHANIC'],                          permission: 'SERVICE_VIEW' },
    {                              label: 'Spare Parts',       icon: 'settings',        route: '/parts',      roles: ['ADMIN','SERVICE_ADVISOR','MECHANIC','INVENTORY_MANAGER'],      permission: 'PARTS_VIEW' },
    { section: 'Admin',            label: 'Employees',         icon: 'badge',           route: '/employees',  roles: ['ADMIN','SALES_MANAGER'],                                       permission: 'EMPLOYEES_VIEW', exact: true },
    {                              label: 'Role Permissions',  icon: 'security',        route: '/employees/roles', roles: ['ADMIN'] },
    {                              label: 'Reports',           icon: 'bar_chart',       route: '/reports',    roles: ['ADMIN','SALES_MANAGER','SALES_EXECUTIVE','ACCOUNTS','SUPER_ADMIN'], permission: 'REPORTS_VIEW' },
  ];

  constructor(public auth: AuthService) {}
  ngOnInit() {}

  onNavItemClick() {
    this.closeDrawer.emit();
  }

  visibleNavItems(): NavItem[] {
    const role = (this.auth.role ?? '').replace('ROLE_', '');
    const shownSections = new Set<string>();
    return this.navItems
      .filter(item => {
        if (item.route === '/dashboard') return !this.auth.isSuperAdmin;
        if (this.auth.isSuperAdmin) {
          return item.roles?.includes('SUPER_ADMIN') ?? false;
        }
        if (item.roles?.includes('SUPER_ADMIN') && item.roles.length === 1) return false;
        if (item.permission && this.auth.hasPermission(item.permission)) return true;
        return item.roles?.includes(role) ?? false;
      })
      .map(item => {
        if (item.section) {
          if (shownSections.has(item.section)) {
            return { ...item, section: undefined };
          }
          shownSections.add(item.section);
        }
        return item;
      });
  }

  get initials(): string {
    const name = this.auth.currentUser?.fullName ?? '';
    return name.split(' ').map(n => n[0]).join('').toUpperCase().slice(0, 2);
  }

  get roleName(): string {
    return (this.auth.role ?? '').replace('ROLE_', '').replace(/_/g, ' ');
  }
}
