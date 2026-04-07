package com.dealerconnect;

import com.dealerconnect.entity.ServiceAppointment;
import com.dealerconnect.repository.ServiceAppointmentRepository;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import org.springframework.context.annotation.Profile;
import java.util.List;

@Component
@Profile("debug")
public class DebugDataRunner implements CommandLineRunner {
    private final ServiceAppointmentRepository repo;

    public DebugDataRunner(ServiceAppointmentRepository repo) { this.repo = repo; }

    @Override
    public void run(String... args) {
        System.out.println("DEBUG: Fetching Service Appointments...");
        List<ServiceAppointment> all = repo.findAll();
        System.out.println("DEBUG: Found " + all.size() + " appointments.");
        if (!all.isEmpty()) {
            ServiceAppointment first = all.get(0);
            System.out.println("DEBUG: First Appt No: " + first.getAppointmentNo());
            System.out.println("DEBUG: First Customer: " + (first.getCustomer() != null ? first.getCustomer().getFirstName() : "NULL"));
        }
    }
}
