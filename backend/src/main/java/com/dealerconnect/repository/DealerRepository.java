package com.dealerconnect.repository;

import com.dealerconnect.entity.Dealer;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface DealerRepository extends JpaRepository<Dealer, Long> {
    boolean existsByDealerCode(String dealerCode);
    boolean existsByGstNumber(String gstNumber);
    Optional<Dealer> findByDealerCode(String dealerCode);
}
