package com.dealerconnect.repository;
import com.dealerconnect.entity.FinanceLoan;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
public interface FinanceLoanRepository extends JpaRepository<FinanceLoan, Long> {
    List<FinanceLoan> findByCustomerId(Long customerId);
}
