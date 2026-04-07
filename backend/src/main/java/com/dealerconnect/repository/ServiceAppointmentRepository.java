package com.dealerconnect.repository;

import com.dealerconnect.entity.ServiceAppointment;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ServiceAppointmentRepository extends JpaRepository<ServiceAppointment, Long> {
    boolean existsByAppointmentNoAndDealerId(String appointmentNo, Long dealerId);
    Page<ServiceAppointment> findByCustomerIdAndDealerId(Long customerId, Long dealerId, Pageable pageable);
    @Query("SELECT s FROM ServiceAppointment s WHERE (:dealerId IS NULL OR s.dealer.id = :dealerId) AND " +
           "s.status = :status")
    Page<ServiceAppointment> findByStatusAndDealerId(@Param("status") ServiceAppointment.AppointmentStatus status, @Param("dealerId") Long dealerId, Pageable pageable);

    @Query(value = "CALL GetWorkloadSummary(:year, :month, :dealerId)", nativeQuery = true)
    List<Object[]> getWorkloadSummary(@Param("year") Integer year, @Param("month") Integer month, @Param("dealerId") Long dealerId);

    Page<ServiceAppointment> findByDealerId(Long dealerId, Pageable pageable);
}
