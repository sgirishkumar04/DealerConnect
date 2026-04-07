import { Component, OnInit, HostListener } from '@angular/core';
import { AuthService } from './core/services/auth.service';
import { Router, NavigationEnd } from '@angular/router';
import { filter } from 'rxjs/operators';
import { BreakpointObserver, Breakpoints } from '@angular/cdk/layout';

@Component({
  selector: 'app-root',
  template: `
    <ng-container *ngIf="auth.isLoggedIn && !isLoginRoute(); else loginView">
      <div class="app-shell" [class.is-mobile]="isMobile">
        <!-- Collapsible Sidebar / Mobile Drawer -->
        <app-sidebar [collapsed]="sidebarCollapsed" 
                     [class.mobile-open]="mobileDrawerOpen"
                     (closeDrawer)="mobileDrawerOpen = false">
        </app-sidebar>

        <!-- Overlay for mobile drawer -->
        <div class="drawer-overlay" *ngIf="isMobile && mobileDrawerOpen" (click)="mobileDrawerOpen = false"></div>

        <!-- Main Column: Header + Page Content -->
        <div class="main-container">
          <app-header [sidebarCollapsed]="sidebarCollapsed"
                       [isMobile]="isMobile"
                       (toggleSidebar)="handleSidebarToggle()">
          </app-header>

          <main class="page-area">
            <router-outlet></router-outlet>
          </main>
        </div>
      </div>
    </ng-container>

    <ng-template #loginView>
      <router-outlet></router-outlet>
    </ng-template>
  `
})
export class AppComponent implements OnInit {
  sidebarCollapsed = false;
  isMobile = false;
  mobileDrawerOpen = false;

  constructor(
    public auth: AuthService, 
    private router: Router,
    private breakpointObserver: BreakpointObserver
  ) {}

  @HostListener('window:keydown', ['$event'])
  handleKeyboardEvent(event: KeyboardEvent) {
    if (!this.auth.isLoggedIn || this.isLoginRoute()) return;

    // Don't trigger if user is typing in an input/textarea
    const activeElement = document.activeElement?.tagName.toLowerCase();
    if (activeElement === 'input' || activeElement === 'textarea') {
      if (event.key === 'Escape') {
        (document.activeElement as HTMLElement).blur();
      }
      return;
    }

    // Keyboard Shortcuts
    if (event.key === '/') {
      event.preventDefault();
      // Try to find the search input in the current page
      const searchInput = document.querySelector('input[placeholder*="Search"]') as HTMLInputElement;
      if (searchInput) {
        searchInput.focus();
      }
    } else if (event.key === 'n' || event.key === 'N') {
      const url = this.router.url;
      if (url.includes('/leads')) this.router.navigate(['/leads/new']);
      else if (url.includes('/inventory')) this.router.navigate(['/inventory/new']);
      else if (url.includes('/customers')) this.router.navigate(['/customers/new']);
      else if (url.includes('/service')) this.router.navigate(['/service/new']);
      else if (url.includes('/parts')) this.router.navigate(['/parts/new']);
    } else if (event.key === 'h' || event.key === 'H') {
      this.router.navigate(['/dashboard']);
    }
  }

  ngOnInit() {
    this.auth.refreshProfile();

    // Responsive breakpoints
    this.breakpointObserver.observe([
      Breakpoints.Handset,
      Breakpoints.TabletPortrait
    ]).subscribe(result => {
      this.isMobile = result.matches;
      if (this.isMobile) {
        this.sidebarCollapsed = false; // Sidebar width handles itself in CSS is-mobile
        this.mobileDrawerOpen = false;
      }
    });

    // Close mobile drawer on navigation
    this.router.events.pipe(
      filter(event => event instanceof NavigationEnd)
    ).subscribe(() => {
      if (this.isMobile) {
        this.mobileDrawerOpen = false;
      }
    });
  }

  handleSidebarToggle() {
    if (this.isMobile) {
      this.mobileDrawerOpen = !this.mobileDrawerOpen;
    } else {
      this.sidebarCollapsed = !this.sidebarCollapsed;
    }
  }

  isLoginRoute(): boolean {
    return this.router.url.includes('/login');
  }
}
