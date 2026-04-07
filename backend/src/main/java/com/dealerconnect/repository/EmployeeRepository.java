package com.dealerconnect.repository;

import com.dealerconnect.entity.Employee;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.EntityGraph;

import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface EmployeeRepository extends JpaRepository<Employee, Long> {
    Optional<Employee> findByEmailAndIsActiveTrue(String email);
    Optional<Employee> findByEmail(String email);
    Optional<Employee> findByEmployeeCode(String employeeCode);
    boolean existsByEmployeeCodeAndDealerId(String employeeCode, Long dealerId);

    @EntityGraph(attributePaths = {"role", "department"})
    @Query("SELECT e FROM Employee e WHERE (:dealerId IS NULL OR e.dealer.id = :dealerId) AND " +
           "(:search IS NULL OR LOWER(e.firstName) LIKE %:search% OR LOWER(e.lastName) LIKE %:search% OR e.employeeCode LIKE %:search%)")
    Page<Employee> searchAll(@Param("search") String search, @Param("dealerId") Long dealerId, Pageable pageable);

    Page<Employee> findByDealerId(Long dealerId, Pageable pageable);
    
    @Query("SELECT MAX(e.employeeCode) FROM Employee e WHERE e.dealer.id = :dealerId")
    String findMaxEmployeeCode(@Param("dealerId") Long dealerId);
    
    Long countByDealerId(Long dealerId);
}
