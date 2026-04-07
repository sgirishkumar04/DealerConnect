package com.dealerconnect.repository;

import com.dealerconnect.entity.Customer;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface CustomerRepository extends JpaRepository<Customer, Long> {
    Optional<Customer> findByPhoneAndDealerId(String phone, Long dealerId);
    boolean existsByCustomerCodeAndDealerId(String customerCode, Long dealerId);

    @Query("SELECT c FROM Customer c WHERE (:dealerId IS NULL OR c.dealer.id = :dealerId) AND " +
           "(:search IS NULL OR LOWER(c.firstName) LIKE %:search% OR LOWER(c.lastName) LIKE %:search% " +
           "OR c.phone LIKE %:search% OR c.customerCode LIKE %:search%)")
    Page<Customer> search(@Param("search") String search, @Param("dealerId") Long dealerId, Pageable pageable);

    Page<Customer> findByDealerId(Long dealerId, Pageable pageable);

    long countByDealerId(Long dealerId);
}
