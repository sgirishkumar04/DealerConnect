package com.dealerconnect.repository;

import com.dealerconnect.entity.Booking;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface BookingRepository extends JpaRepository<Booking, Long> {
    boolean existsByBookingNumber(String bookingNumber);
    @Query("SELECT b FROM Booking b WHERE (:dealerId IS NULL OR b.dealer.id = :dealerId) AND b.customer.id = :customerId")
    Page<Booking> findByCustomerIdAndDealerId(@Param("customerId") Long customerId, @Param("dealerId") Long dealerId, Pageable pageable);

    @Query("SELECT b FROM Booking b WHERE (:dealerId IS NULL OR b.dealer.id = :dealerId) AND b.salesExec.id = :execId")
    Page<Booking> findBySalesExecIdAndDealerId(@Param("execId") Long execId, @Param("dealerId") Long dealerId, Pageable pageable);
    List<Booking> findByVehicleIdAndDealerId(Long vehicleId, Long dealerId);
    List<Booking> findByVehicleId(Long vehicleId);
    Optional<Booking> findByLeadIdAndDealerId(Long leadId, Long dealerId);

    @Query(value = "CALL GetTopSellingModels(:year, :month, :dealerId)", nativeQuery = true)
    List<Object[]> getTopSellingModels(@Param("year") Integer year, @Param("month") Integer month, @Param("dealerId") Long dealerId);

    @Query(value = "CALL GetMonthlyBookings(:year, :dealerId)", nativeQuery = true)
    List<Object[]> getMonthlyBookings(@Param("year") Integer year, @Param("dealerId") Long dealerId);

    @Query(value = "CALL GetBookingsByModelCount(:year, :month, :dealerId)", nativeQuery = true)
    List<Object[]> getBookingsByModelCount(@Param("year") Integer year, @Param("month") Integer month, @Param("dealerId") Long dealerId);

    @Query("SELECT b FROM Booking b WHERE (:dealerId IS NULL OR b.dealer.id = :dealerId) AND (" +
           "LOWER(b.bookingNumber) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(b.customer.firstName) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(b.customer.lastName) LIKE LOWER(CONCAT('%', :search, '%')))")
    Page<Booking> search(@Param("search") String search, @Param("dealerId") Long dealerId, Pageable pageable);

    Page<Booking> findByDealerId(Long dealerId, Pageable pageable);
}
