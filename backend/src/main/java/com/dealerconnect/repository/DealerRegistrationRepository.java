package com.dealerconnect.repository;

import com.dealerconnect.entity.Dealer;
import com.dealerconnect.entity.DealerRegistration;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface DealerRegistrationRepository extends JpaRepository<DealerRegistration, Long> {
    List<DealerRegistration> findByStatus(Dealer.DealerStatus status);
    boolean existsByAdminEmail(String adminEmail);
}
