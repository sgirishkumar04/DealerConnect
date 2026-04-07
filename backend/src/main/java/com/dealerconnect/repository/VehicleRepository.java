package com.dealerconnect.repository;

import com.dealerconnect.entity.Vehicle;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.querydsl.QuerydslPredicateExecutor;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface VehicleRepository extends JpaRepository<Vehicle, Long>, QuerydslPredicateExecutor<Vehicle> {
    boolean existsByVin(String vin);
    Page<Vehicle> findByStatus(Vehicle.VehicleStatus status, Pageable pageable);

    @Query("SELECT v FROM Vehicle v JOIN v.variant vv JOIN vv.model m " +
           "WHERE v.status = 'IN_STOCK' AND (:modelId IS NULL OR m.id = :modelId)")
    Page<Vehicle> findAvailableByModel(@Param("modelId") Long modelId, Pageable pageable);

    @Query(value = "CALL GetInventoryStatusSummary(:year, :month, :dealerId)", nativeQuery = true)
    List<Object[]> getInventoryStatusSummary(@Param("year") Integer year, @Param("month") Integer month, @Param("dealerId") Long dealerId);

    @Query(value = "CALL GetStockByModelCount(:year, :month, :dealerId)", nativeQuery = true)
    List<Object[]> getStockByModelCount(@Param("year") Integer year, @Param("month") Integer month, @Param("dealerId") Long dealerId);
}
