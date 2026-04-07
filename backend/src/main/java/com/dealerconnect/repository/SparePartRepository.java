package com.dealerconnect.repository;

import com.dealerconnect.entity.SparePart;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface SparePartRepository extends JpaRepository<SparePart, Long> {
    boolean existsByPartNumberAndDealerId(String partNumber, Long dealerId);
    Page<SparePart> findByCategoryAndDealerId(String category, Long dealerId, Pageable pageable);

    @Query("SELECT sp FROM SparePart sp WHERE (:dealerId IS NULL OR sp.dealer.id = :dealerId) AND sp.isActive = true AND " +
           "(:search IS NULL OR LOWER(sp.name) LIKE LOWER(CONCAT('%', :search, '%')) " +
           "OR LOWER(sp.partNumber) LIKE LOWER(CONCAT('%', :search, '%')) " +
           "OR LOWER(sp.category) LIKE LOWER(CONCAT('%', :search, '%')))")
    Page<SparePart> search(@Param("search") String search, @Param("dealerId") Long dealerId, Pageable pageable);

    @Query("SELECT DISTINCT sp.category FROM SparePart sp WHERE (:dealerId IS NULL OR sp.dealer.id = :dealerId) AND sp.isActive = true ORDER BY sp.category")
    List<String> findAllCategoriesByDealerId(@Param("dealerId") Long dealerId);

    Page<SparePart> findByDealerId(Long dealerId, Pageable pageable);
}
