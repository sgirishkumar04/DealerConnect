package com.dealerconnect.repository;

import com.dealerconnect.entity.Lead;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface LeadRepository extends JpaRepository<Lead, Long> {
    boolean existsByLeadNumber(String leadNumber);
    
    @Query("SELECT MAX(l.leadNumber) FROM Lead l WHERE (:dealerId IS NULL OR l.dealer.id = :dealerId)")
    String findMaxLeadNumber(@Param("dealerId") Long dealerId);

    long countByDealerId(Long dealerId);

    @EntityGraph(attributePaths = {"customer", "assignedTo", "preferredModel", "preferredVariant", "preferredColor", "source"})
    @Query("SELECT l FROM Lead l WHERE (:dealerId IS NULL OR l.dealer.id = :dealerId) AND l.status = :status")
    Page<Lead> findByStatusAndDealerId(@Param("status") Lead.LeadStatus status, @Param("dealerId") Long dealerId, Pageable pageable);

    @EntityGraph(attributePaths = {"customer", "assignedTo", "preferredModel", "preferredVariant", "preferredColor", "source"})
    @Query("SELECT l FROM Lead l WHERE (:dealerId IS NULL OR l.dealer.id = :dealerId) AND l.assignedTo.id = :employeeId")
    Page<Lead> findByAssignedToIdAndDealerId(@Param("employeeId") Long employeeId, @Param("dealerId") Long dealerId, Pageable pageable);

    @EntityGraph(attributePaths = {"customer", "assignedTo", "preferredModel", "preferredVariant", "preferredColor", "source"})
    Page<Lead> findByDealerId(Long dealerId, Pageable pageable);

    @Query(value = "CALL GetLeadFunnelCounts(:year, :month, :dealerId)", nativeQuery = true)
    List<Object[]> getLeadFunnelCounts(@Param("year") Integer year, @Param("month") Integer month, @Param("dealerId") Long dealerId);

    @EntityGraph(attributePaths = {"customer", "assignedTo", "preferredModel", "preferredVariant", "preferredColor", "source"})
    @Query("SELECT l FROM Lead l WHERE (:dealerId IS NULL OR l.dealer.id = :dealerId) AND (" +
           "(:search IS NULL OR LOWER(l.leadNumber) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(l.customer.firstName) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(l.customer.lastName) LIKE LOWER(CONCAT('%', :search, '%'))))")
    Page<Lead> search(@Param("search") String search, @Param("dealerId") Long dealerId, Pageable pageable);
}
