import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../../environments/environment';
import {
  Employee, Vehicle, Customer, Lead, ServiceAppointment, SparePart, FinanceLoan,
  VehicleModel, VehicleVariant, Color, EngineType, InventoryLocation,
  LeadSource, Supplier, Bank, Role, Department, Booking, Page
} from '../models/models';

@Injectable({ providedIn: 'root' })
export class ApiService {
  private base = environment.apiUrl;
  constructor(private http: HttpClient) {}

  // ── Generic helpers ───────────────────────────────────────────
  get<T>(path: string): Observable<T> { return this.http.get<T>(`${this.base}${path}`); }
  post<T>(path: string, body: any): Observable<T> { return this.http.post<T>(`${this.base}${path}`, body); }
  put<T>(path: string, body: any): Observable<T>  { return this.http.put<T>(`${this.base}${path}`, body); }
  del<T>(path: string): Observable<T>             { return this.http.delete<T>(`${this.base}${path}`); }


  login(email: string, password: string) { return this.http.post<any>(`${this.base}/auth/login`, { email, password }); }

  // ── Lookup & Admin ───────────────────────────────────────
  getRoles(): Observable<Role[]>                      { return this.http.get<Role[]>(`${this.base}/lookup/roles?t=${Date.now()}`); }
  getPermissions(): Observable<any[]>                 { return this.http.get<any[]>(`${this.base}/roles/permissions`); }
  updateRolePermissions(roleId: number, permissionIds: number[]): Observable<Role> {
    return this.http.put<Role>(`${this.base}/roles/${roleId}/permissions`, permissionIds);
  }
  getDepartments(): Observable<Department[]>          { return this.http.get<Department[]>(`${this.base}/lookup/departments?t=${Date.now()}`); }
  getModels(): Observable<VehicleModel[]>             { return this.http.get<VehicleModel[]>(`${this.base}/lookup/vehicle-models?t=${Date.now()}`); }
  getVariants(modelId?: number): Observable<VehicleVariant[]> {
    const url = modelId ? `${this.base}/lookup/vehicle-variants/${modelId}?t=${Date.now()}` : `${this.base}/lookup/vehicle-variants?t=${Date.now()}`;
    return this.http.get<VehicleVariant[]>(url);
  }
  getColors(): Observable<Color[]>                    { return this.http.get<Color[]>(`${this.base}/lookup/colors?t=${Date.now()}`); }
  getEngineTypes(): Observable<EngineType[]>          { return this.http.get<EngineType[]>(`${this.base}/lookup/engine-types?t=${Date.now()}`); }
  getLocations(): Observable<InventoryLocation[]>     { return this.http.get<InventoryLocation[]>(`${this.base}/lookup/locations?t=${Date.now()}`); }
  getLeadSources(): Observable<LeadSource[]>          { return this.http.get<LeadSource[]>(`${this.base}/lookup/lead-sources?t=${Date.now()}`); }
  getSuppliers(): Observable<Supplier[]>              { return this.http.get<Supplier[]>(`${this.base}/lookup/suppliers?t=${Date.now()}`); }
  getBanks(): Observable<Bank[]>                      { return this.http.get<Bank[]>(`${this.base}/lookup/banks?t=${Date.now()}`); }
  getDealers(): Observable<any[]>                     { return this.http.get<any[]>(`${this.base}/dealers?t=${Date.now()}`); }

  // ── Employees ─────────────────────────────────────────────────
  getEmployees(params: any): Observable<Page<Employee>> {
    return this.http.get<Page<Employee>>(`${this.base}/employees`, { params });
  }
  getEmployee(id: number): Observable<Employee>       { return this.http.get<Employee>(`${this.base}/employees/${id}`); }
  createEmployee(data: any): Observable<Employee>     { return this.http.post<Employee>(`${this.base}/employees`, data); }
  updateEmployee(id: number, data: any): Observable<Employee> { return this.http.put<Employee>(`${this.base}/employees/${id}`, data); }
  deleteEmployee(id: number): Observable<void>        { return this.http.delete<void>(`${this.base}/employees/${id}`); }
  unlockEmployee(id: number): Observable<void>        { return this.http.post<void>(`${this.base}/employees/${id}/unlock`, {}); }
  getMe(): Observable<Employee>                       { return this.http.get<Employee>(`${this.base}/employees/me`); }

  // ── Vehicles ──────────────────────────────────────────────────
  getVehicles(params: any): Observable<Page<Vehicle>> { return this.http.get<Page<Vehicle>>(`${this.base}/vehicles`, { params }); }
  getVehicle(id: number): Observable<Vehicle>         { return this.http.get<Vehicle>(`${this.base}/vehicles/${id}`); }
  getVehicleDetails(id: number): Observable<any>     { return this.http.get<any>(`${this.base}/vehicles/${id}/details`); }
  createVehicle(data: any): Observable<Vehicle>       { return this.http.post<Vehicle>(`${this.base}/vehicles`, data); }
  updateVehicle(id: number, data: any): Observable<Vehicle> { return this.http.put<Vehicle>(`${this.base}/vehicles/${id}`, data); }
  deleteVehicle(id: number): Observable<void>         { return this.http.delete<void>(`${this.base}/vehicles/${id}`); }
  getInventorySummary(): Observable<any[]>            { return this.http.get<any[]>(`${this.base}/vehicles/inventory-summary`); }

  // ── Customers ─────────────────────────────────────────────────
  getCustomers(params: any): Observable<Page<Customer>> { return this.http.get<Page<Customer>>(`${this.base}/customers`, { params }); }
  getCustomer(id: number): Observable<Customer>         { return this.http.get<Customer>(`${this.base}/customers/${id}`); }
  createCustomer(data: any): Observable<Customer>       { return this.http.post<Customer>(`${this.base}/customers`, data); }
  updateCustomer(id: number, data: any): Observable<Customer> { return this.http.put<Customer>(`${this.base}/customers/${id}`, data); }
  deleteCustomer(id: number): Observable<void>          { return this.http.delete<void>(`${this.base}/customers/${id}`); }
  getNextCustomerCode(): Observable<{code: string}>     { return this.http.get<{code: string}>(`${this.base}/customers/next-code`); }

  // ── Leads ─────────────────────────────────────────────────────
  getLeads(params: any): Observable<Page<Lead>>         { return this.http.get<Page<Lead>>(`${this.base}/leads`, { params }); }
  getLead(id: number): Observable<Lead>                 { return this.http.get<Lead>(`${this.base}/leads/${id}`); }
  createLead(data: any): Observable<Lead>               { return this.http.post<Lead>(`${this.base}/leads`, data); }
  updateLead(id: number, data: any): Observable<Lead>   { return this.http.put<Lead>(`${this.base}/leads/${id}`, data); }
  deleteLead(id: number): Observable<void>              { return this.http.delete<void>(`${this.base}/leads/${id}`); }
  getLeadFunnel(): Observable<any[]>                    { return this.http.get<any[]>(`${this.base}/leads/funnel-summary`); }
  getNextLeadNumber(): Observable<string>               { return this.http.get(`${this.base}/leads/next-number`, { responseType: 'text' }); }

  // ── Bookings (Sales) ──────────────────────────────────────────
  getBookings(params: any): Observable<Page<Booking>>   { return this.http.get<Page<Booking>>(`${this.base}/bookings`, { params }); }
  getBooking(id: number): Observable<Booking>           { return this.http.get<Booking>(`${this.base}/bookings/${id}`); }
  createBooking(data: any): Observable<Booking>         { return this.http.post<Booking>(`${this.base}/bookings`, data); }
  updateBooking(id: number, data: any): Observable<Booking> { return this.http.put<Booking>(`${this.base}/bookings/${id}`, data); }
  deleteBooking(id: number): Observable<void>           { return this.http.delete<void>(`${this.base}/bookings/${id}`); }

  // ── Service ───────────────────────────────────────────────────
  getAppointments(params: any): Observable<Page<ServiceAppointment>> {
    return this.http.get<Page<ServiceAppointment>>(`${this.base}/service/appointments`, { params });
  }
  getAppointment(id: number): Observable<ServiceAppointment> {
    return this.http.get<ServiceAppointment>(`${this.base}/service/appointments/${id}`);
  }
  createAppointment(data: any): Observable<ServiceAppointment> {
    return this.http.post<ServiceAppointment>(`${this.base}/service/appointments`, data);
  }
  updateAppointment(id: number, data: any): Observable<ServiceAppointment> {
    return this.http.put<ServiceAppointment>(`${this.base}/service/appointments/${id}`, data);
  }

  // ── Spare Parts ───────────────────────────────────────────────
  getSpareParts(params: any): Observable<Page<SparePart>> {
    return this.http.get<Page<SparePart>>(`${this.base}/parts`, { params });
  }
  getPartCategories(): Observable<string[]> {
    return this.http.get<string[]>(`${this.base}/parts/categories`);
  }
  getPart(id: number): Observable<SparePart> {
    return this.http.get<SparePart>(`${this.base}/parts/${id}`);
  }
  createSparePart(data: any): Observable<SparePart> {
    return this.http.post<SparePart>(`${this.base}/parts`, data);
  }
  updateSparePart(id: number, data: any): Observable<SparePart> {
    return this.http.put<SparePart>(`${this.base}/parts/${id}`, data);
  }
  deleteSparePart(id: number): Observable<void> {
    return this.http.delete<void>(`${this.base}/parts/${id}`);
  }

  // ── Reports ──────────────────────────────────────────────────
  getMonthlyBookings(year?: number, dealerId?: number): Observable<any[]> {
    return this.http.get<any[]>(`${this.base}/reports/monthly-bookings`, { params: this.buildParams(year, undefined, dealerId) });
  }
  getTopSellingModels(year?: number, month?: number, dealerId?: number): Observable<any[]> {
    return this.http.get<any[]>(`${this.base}/reports/top-selling-models`, { params: this.buildParams(year, month, dealerId) });
  }
  getSalesPipeline(year?: number, month?: number, dealerId?: number): Observable<any[]> {
    return this.http.get<any[]>(`${this.base}/reports/sales-pipeline`, { params: this.buildParams(year, month, dealerId) });
  }
  getInventoryStatus(year?: number, month?: number, dealerId?: number): Observable<any[]> {
    return this.http.get<any[]>(`${this.base}/reports/inventory-status`, { params: this.buildParams(year, month, dealerId) });
  }
  getServiceWorkload(year?: number, month?: number, dealerId?: number): Observable<any[]> {
    return this.http.get<any[]>(`${this.base}/reports/service-workload`, { params: this.buildParams(year, month, dealerId) });
  }

  getStockByModel(year?: number, month?: number, dealerId?: number): Observable<any[]> {
    return this.http.get<any[]>(`${this.base}/reports/stock-by-model`, { params: this.buildParams(year, month, dealerId) });
  }

  getBookingsByModel(year?: number, month?: number, dealerId?: number): Observable<any[]> {
    return this.http.get<any[]>(`${this.base}/reports/bookings-by-model`, { params: this.buildParams(year, month, dealerId) });
  }

  private buildParams(year?: number, month?: number, dealerId?: number): any {
    const params: any = {};
    if (year) params.year = year;
    if (month) params.month = month;
    if (dealerId) params.dealerId = dealerId;
    return params;
  }
}
