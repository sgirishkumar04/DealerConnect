package com.hyundai.dms.config;

import com.hyundai.dms.entity.*;
import com.hyundai.dms.repository.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

/**
 * Inserts seed data on startup if the database is empty.
 * Also ensures the admin user always has the correct password.
 * Runs AFTER Hibernate creates/updates tables.
 */
@Component
@RequiredArgsConstructor
@Slf4j
public class DataInitializer implements CommandLineRunner {

    private final RoleRepository roleRepo;
    private final PermissionRepository permRepo;
    private final DepartmentRepository deptRepo;
    private final EmployeeRepository employeeRepo;
    private final SupplierRepository supplierRepo;
    private final SparePartRepository sparePartRepo;
    private final DealerRepository dealerRepo;
    private final CustomerRepository customerRepo;
    private final LeadRepository leadRepo;
    private final BookingRepository bookingRepo;
    private final ServiceAppointmentRepository serviceRepo;
    private final InventoryLocationRepository locationRepo;
    private final LeadSourceRepository leadSourceRepo;
    private final VehicleModelRepository modelRepo;
    private final PasswordEncoder passwordEncoder;

    private static final String DEFAULT_PASSWORD  = "Password@123";
    private static final String ADMIN_EMAIL        = "admin@hyundaidms.in";
    private static final String SUPER_ADMIN_EMAIL  = "superadmin@hyundaidms.in";
    private static final String SUPER_ADMIN_PWD    = "SuperAdmin@123";

    @Override
    public void run(String... args) {
        // Always ensure admin password is correct (fixes existing wrong-hash scenario)
        Optional<Employee> existingAdmin = employeeRepo.findByEmailAndIsActiveTrue(ADMIN_EMAIL);
        existingAdmin.ifPresent(emp -> {
            if (!passwordEncoder.matches(DEFAULT_PASSWORD, emp.getPasswordHash())) {
                log.warn("DataInitializer: admin password hash is wrong – resetting …");
                emp.setPasswordHash(passwordEncoder.encode(DEFAULT_PASSWORD));
                employeeRepo.save(emp);
                log.info("DataInitializer: admin password reset to '" + DEFAULT_PASSWORD + "' ✓");
            } else {
                log.info("DataInitializer: admin password hash OK.");
            }
        });

        if (employeeRepo.findByEmailAndIsActiveTrue(SUPER_ADMIN_EMAIL).isEmpty()) {
            seedSuperAdmin();
        }

        // Fix Migrated Databases: Automatically seed empty lookup tables for dropdowns!
        if (leadSourceRepo.count() == 0) {
            log.info("DataInitializer: Lookup tables empty – seeding Lead Sources, Models, etc. …");
            seedLookupTables();
        }

        // Link existing entities to the first dealer if they don't have one
        assignDefaultDealerToLegacyEntities();

        if (roleRepo.count() == 0) {
            log.info("DataInitializer: roles missing – inserting seed roles, departments and users …");
            seedRolesAndEmployees();
        } else {
            log.info("DataInitializer: roles present – skipping role seed.");
        }

        if (supplierRepo.count() == 0) {
            log.info("DataInitializer: suppliers missing – seeding suppliers and parts …");
            seedSuppliersAndParts();
        } else {
            log.info("DataInitializer: suppliers/parts present – skipping part seed.");
        }
    }

    private void seedSuperAdmin() {
        Role saRole = roleRepo.findByName("SUPER_ADMIN")
            .orElseGet(() -> roleRepo.save(Role.builder().name("SUPER_ADMIN").description("DMS Platform Administrator").build()));

        Department adminDept = deptRepo.findAll().stream()
            .filter(d -> d.getName().equalsIgnoreCase("Administration"))
            .findFirst()
            .orElseGet(() -> deptRepo.save(Department.builder().name("Administration").description("Admin & HR").build()));

        employeeRepo.save(Employee.builder()
            .employeeCode("SA001")
            .firstName("DMS").lastName("SuperAdmin")
            .email(SUPER_ADMIN_EMAIL).phone("9000000000")
            .passwordHash(passwordEncoder.encode(SUPER_ADMIN_PWD))
            .department(adminDept).role(saRole)
            .dealer(null)                      // SUPER_ADMIN has no specific dealer
            .isActive(true).build());
        log.info("DataInitializer: ✓ SUPER_ADMIN seeded. Login: {} / {}", SUPER_ADMIN_EMAIL, SUPER_ADMIN_PWD);
    }

    private void seedLookupTables() {
        // Lead Sources
        leadSourceRepo.save(LeadSource.builder().name("Walk-In").build());
        leadSourceRepo.save(LeadSource.builder().name("Website").build());
        leadSourceRepo.save(LeadSource.builder().name("Referral").build());
        leadSourceRepo.save(LeadSource.builder().name("Social Media").build());
        leadSourceRepo.save(LeadSource.builder().name("Call Center").build());

        // Standard Hyundai Models
        modelRepo.save(VehicleModel.builder().modelName("Creta").bodyType("SUV").build());
        modelRepo.save(VehicleModel.builder().modelName("Venue").bodyType("Compact SUV").build());
        modelRepo.save(VehicleModel.builder().modelName("Verna").bodyType("Sedan").build());
        modelRepo.save(VehicleModel.builder().modelName("i20").bodyType("Hatchback").build());
        modelRepo.save(VehicleModel.builder().modelName("Tucson").bodyType("Premium SUV").build());
        
        log.info("DataInitializer: ✓ Core Dropdown Lookups seeded.");
    }

    private void assignDefaultDealerToLegacyEntities() {
        dealerRepo.findById(1L).ifPresent(defaultDealer -> {
            // Employees
            List<Employee> emps = employeeRepo.findAll().stream()
                .filter(e -> e.getDealer() == null && !"SUPER_ADMIN".equals(e.getRole().getName()))
                .toList();
            if (!emps.isEmpty()) {
                emps.forEach(e -> e.setDealer(defaultDealer));
                employeeRepo.saveAll(emps);
                log.info("DataInitializer: Linked {} employees to {}", emps.size(), defaultDealer.getName());
            }

            // Customers
            List<Customer> customers = customerRepo.findAll().stream().filter(c -> c.getDealer() == null).toList();
            if (!customers.isEmpty()) { customers.forEach(c -> c.setDealer(defaultDealer)); customerRepo.saveAll(customers); }

            // Leads
            List<Lead> leads = leadRepo.findAll().stream().filter(l -> l.getDealer() == null).toList();
            if (!leads.isEmpty()) { leads.forEach(l -> l.setDealer(defaultDealer)); leadRepo.saveAll(leads); }

            // Bookings
            List<Booking> bookings = bookingRepo.findAll().stream().filter(b -> b.getDealer() == null).toList();
            if (!bookings.isEmpty()) { bookings.forEach(b -> b.setDealer(defaultDealer)); bookingRepo.saveAll(bookings); }

            // Service Appointments
            List<ServiceAppointment> svcs = serviceRepo.findAll().stream().filter(s -> s.getDealer() == null).toList();
            if (!svcs.isEmpty()) { svcs.forEach(s -> s.setDealer(defaultDealer)); serviceRepo.saveAll(svcs); }
            
            // Spare Parts
            List<SparePart> parts = sparePartRepo.findAll().stream().filter(p -> p.getDealer() == null).toList();
            if (!parts.isEmpty()) { parts.forEach(p -> p.setDealer(defaultDealer)); sparePartRepo.saveAll(parts); }

            // Inventory Locations
            List<InventoryLocation> locs = locationRepo.findAll().stream().filter(l -> l.getDealer() == null).toList();
            if (!locs.isEmpty()) { locs.forEach(l -> l.setDealer(defaultDealer)); locationRepo.saveAll(locs); }
        });
    }

    private void seedRolesAndEmployees() {
        String pwd = passwordEncoder.encode(DEFAULT_PASSWORD);

        // ── Permissions ────────────────────────────────────────────────────────
        Permission pSalesView   = permRepo.save(Permission.builder().name("SALES_VIEW").description("View Customers, Leads, Bookings").build());
        Permission pSalesCreate = permRepo.save(Permission.builder().name("SALES_CREATE").description("Create Leads, Bookings").build());
        Permission pSalesEdit   = permRepo.save(Permission.builder().name("SALES_EDIT").description("Edit Customers, Leads, Bookings").build());
        Permission pSalesDelete = permRepo.save(Permission.builder().name("SALES_DELETE").description("Delete Sales Records").build());

        Permission pInvView     = permRepo.save(Permission.builder().name("INVENTORY_VIEW").description("View Vehicles").build());
        Permission pInvCreate   = permRepo.save(Permission.builder().name("INVENTORY_CREATE").description("Add Vehicles").build());
        Permission pInvEdit     = permRepo.save(Permission.builder().name("INVENTORY_EDIT").description("Edit Vehicles").build());
        Permission pInvDelete   = permRepo.save(Permission.builder().name("INVENTORY_DELETE").description("Delete Vehicles").build());

        Permission pSvcView     = permRepo.save(Permission.builder().name("SERVICE_VIEW").description("View Service Records").build());
        Permission pSvcCreate   = permRepo.save(Permission.builder().name("SERVICE_CREATE").description("Create Appointments").build());
        Permission pSvcEdit     = permRepo.save(Permission.builder().name("SERVICE_EDIT").description("Edit Service Status").build());
        Permission pSvcDelete   = permRepo.save(Permission.builder().name("SERVICE_DELETE").description("Delete Service Records").build());

        Permission pPartsView   = permRepo.save(Permission.builder().name("PARTS_VIEW").description("View Parts").build());
        Permission pPartsCreate = permRepo.save(Permission.builder().name("PARTS_CREATE").description("Add Parts").build());
        Permission pPartsEdit   = permRepo.save(Permission.builder().name("PARTS_EDIT").description("Edit Parts").build());
        Permission pPartsDelete = permRepo.save(Permission.builder().name("PARTS_DELETE").description("Delete Parts").build());

        Permission pEmpView     = permRepo.save(Permission.builder().name("EMPLOYEES_VIEW").description("View Staff").build());
        Permission pEmpCreate   = permRepo.save(Permission.builder().name("EMPLOYEES_CREATE").description("Add Staff").build());
        Permission pEmpEdit     = permRepo.save(Permission.builder().name("EMPLOYEES_EDIT").description("Edit Staff").build());
        Permission pEmpDelete   = permRepo.save(Permission.builder().name("EMPLOYEES_DELETE").description("Delete Staff").build());

        Permission pRepView     = permRepo.save(Permission.builder().name("REPORTS_VIEW").description("View Reports").build());

        // ── Roles & Mappings ───────────────────────────────────────────────────
        Role admin      = roleRepo.save(Role.builder().name("ADMIN").description("Full system access")
            .permissions(java.util.Set.of(pSalesView, pSalesCreate, pSalesEdit, pSalesDelete,
                                          pInvView, pInvCreate, pInvEdit, pInvDelete,
                                          pSvcView, pSvcCreate, pSvcEdit, pSvcDelete,
                                          pPartsView, pPartsCreate, pPartsEdit, pPartsDelete,
                                          pEmpView, pEmpCreate, pEmpEdit, pEmpDelete, pRepView)).build());

        Role salesMgr   = roleRepo.save(Role.builder().name("SALES_MANAGER").description("Manage sales team and targets")
            .permissions(java.util.Set.of(pSalesView, pInvView, pEmpView, pRepView)).build());

        Role salesExec  = roleRepo.save(Role.builder().name("SALES_EXECUTIVE").description("Handle leads and bookings")
            .permissions(java.util.Set.of(pSalesView, pSalesCreate, pSalesEdit, pSalesDelete, pInvView, pRepView, pEmpView)).build());

        Role svcAdvisor = roleRepo.save(Role.builder().name("SERVICE_ADVISOR").description("Manage service appointments")
            .permissions(java.util.Set.of(pSvcView, pSvcCreate, pSvcEdit, pPartsView, pPartsCreate)).build());

        Role mechanic   = roleRepo.save(Role.builder().name("MECHANIC").description("Perform vehicle service")
            .permissions(java.util.Set.of(pSvcView, pSvcEdit, pPartsView)).build());

        Role invMgr     = roleRepo.save(Role.builder().name("INVENTORY_MANAGER").description("Manage vehicle & parts stock")
            .permissions(java.util.Set.of(pInvView, pInvCreate, pInvEdit, pInvDelete, pPartsView, pPartsCreate)).build());

        Role accounts   = roleRepo.save(Role.builder().name("ACCOUNTS").description("Handle invoices and payments")
            .permissions(java.util.Set.of(pSalesView, pSalesEdit, pSvcView, pPartsView, pRepView)).build());

        // ── Departments ────────────────────────────────────────────────────────
        Department administration = deptRepo.save(Department.builder().name("Administration").description("Admin & HR").build());
        Department sales          = deptRepo.save(Department.builder().name("Sales")         .description("Vehicle sales department").build());
        Department service        = deptRepo.save(Department.builder().name("Service")       .description("After-sales service center").build());
        Department parts          = deptRepo.save(Department.builder().name("Parts")         .description("Spare parts department").build());
        Department finance        = deptRepo.save(Department.builder().name("Finance")       .description("Accounts and finance").build());

        // ── Employees ─────────────────────────────────────────────────────────
        employeeRepo.save(Employee.builder()
            .employeeCode("EMP001").firstName("S").lastName("GIRISH KUMAR")
            .email(ADMIN_EMAIL).phone("9000000001")
            .passwordHash(pwd).department(administration).role(admin)
            .dateOfJoin(LocalDate.of(2020, 1, 1)).isActive(true).build());

        employeeRepo.save(Employee.builder()
            .employeeCode("EMP002").firstName("Karthik").lastName("Rajan")
            .email("sm@hyundaidms.in").phone("9000000002")
            .passwordHash(pwd).department(sales).role(salesMgr)
            .dateOfJoin(LocalDate.of(2020, 3, 15)).isActive(true).build());

        employeeRepo.save(Employee.builder()
            .employeeCode("EMP003").firstName("Deepika").lastName("Menon")
            .email("deepika@hyundaidms.in").phone("9000000003")
            .passwordHash(pwd).department(sales).role(salesExec)
            .dateOfJoin(LocalDate.of(2021, 6, 1)).isActive(true).build());

        employeeRepo.save(Employee.builder()
            .employeeCode("EMP004").firstName("Rahul").lastName("Verma")
            .email("rahul@hyundaidms.in").phone("9000000004")
            .passwordHash(pwd).department(sales).role(salesExec)
            .dateOfJoin(LocalDate.of(2021, 9, 10)).isActive(true).build());

        employeeRepo.save(Employee.builder()
            .employeeCode("EMP005").firstName("Preethi").lastName("Srinivasan")
            .email("preethi@hyundaidms.in").phone("9000000005")
            .passwordHash(pwd).department(service).role(svcAdvisor)
            .dateOfJoin(LocalDate.of(2020, 7, 20)).isActive(true).build());

        employeeRepo.save(Employee.builder()
            .employeeCode("EMP006").firstName("Murugan").lastName("Selvaraj")
            .email("murugan@hyundaidms.in").phone("9000000006")
            .passwordHash(pwd).department(service).role(mechanic)
            .dateOfJoin(LocalDate.of(2019, 11, 11)).isActive(true).build());

        employeeRepo.save(Employee.builder()
            .employeeCode("EMP007").firstName("Lakshmi").lastName("Narayanan")
            .email("lakshmi@hyundaidms.in").phone("9000000007")
            .passwordHash(pwd).department(parts).role(invMgr)
            .dateOfJoin(LocalDate.of(2022, 1, 3)).isActive(true).build());

        employeeRepo.save(Employee.builder()
            .employeeCode("EMP008").firstName("Vijay").lastName("Anand")
            .email("vijay@hyundaidms.in").phone("9000000008")
            .passwordHash(pwd).department(finance).role(accounts)
            .dateOfJoin(LocalDate.of(2020, 5, 18)).isActive(true).build());

        log.info("DataInitializer: ✓ Seed roles and employees inserted.");
    }

    private void seedSuppliersAndParts() {
        log.info("DataInitializer: inserting seed suppliers and parts …");
        // ── Suppliers ────────────────────────────────────────────────────────
        Supplier hyundai = supplierRepo.save(Supplier.builder().name("Genuine Hyundai Spares").contactName("Anil Kumar").phone("9845012345").email("sales@hyundaispares.com").address("Chennai, TN").build());
        Supplier metro   = supplierRepo.save(Supplier.builder().name("Metro Auto Parts").contactName("Suresh Raina").phone("9845012346").email("info@metroautos.com").address("Bangalore, KA").build());
        Supplier bosch   = supplierRepo.save(Supplier.builder().name("Bosch Automotive India").contactName("Meera Nair").phone("9845012347").email("support@bosch-ind.com").address("Pune, MH").build());
        Supplier castrol = supplierRepo.save(Supplier.builder().name("Castrol Lubricants").contactName("Rajesh Gupta").phone("9845012348").email("orders@castrol.in").address("Mumbai, MH").build());

        // ── Spare Parts ──────────────────────────────────────────────────────
        sparePartRepo.save(SparePart.builder().partNumber("P-BRK-PAD-02").name("Brake Pads (Front)").category("Brakes").unit("Set").unitPrice(new java.math.BigDecimal("1850.00")).supplier(hyundai).isActive(true).build());
        sparePartRepo.save(SparePart.builder().partNumber("P-OIL-FLT-01").name("Oil Filter").category("Engine").unit("Piece").unitPrice(new java.math.BigDecimal("450.00")).supplier(hyundai).isActive(true).build());
        sparePartRepo.save(SparePart.builder().partNumber("P-CLNT-03").name("Coolant (5L)").category("Consumables").unit("Can").unitPrice(new java.math.BigDecimal("850.00")).supplier(metro).isActive(true).build());
        sparePartRepo.save(SparePart.builder().partNumber("P-SPK-PLG-04").name("Spark Plug (Iridium)").category("Engine").unit("Piece").unitPrice(new java.math.BigDecimal("580.00")).supplier(bosch).isActive(true).build());
        sparePartRepo.save(SparePart.builder().partNumber("P-WPR-05").name("Wiper Blades (Pair)").category("Accessories").unit("Set").unitPrice(new java.math.BigDecimal("950.00")).supplier(metro).isActive(true).build());
        sparePartRepo.save(SparePart.builder().partNumber("P-BAT-60AH").name("Battery (60AH)").category("Electrical").unit("Piece").unitPrice(new java.math.BigDecimal("6500.00")).supplier(bosch).isActive(true).build());
        sparePartRepo.save(SparePart.builder().partNumber("P-ENG-OIL-5W30").name("Engine Oil (5W30) - 4L").category("Consumables").unit("Can").unitPrice(new java.math.BigDecimal("2100.00")).supplier(castrol).isActive(true).build());
        sparePartRepo.save(SparePart.builder().partNumber("P-HED-LMP-LH").name("Headlight Assembly (Left)").category("Body").unit("Piece").unitPrice(new java.math.BigDecimal("8500.00")).supplier(hyundai).isActive(true).build());
        log.info("DataInitializer: ✓ Seed suppliers and parts inserted.");
    }
}
