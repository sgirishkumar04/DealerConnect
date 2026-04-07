package com.dealerconnect.repository;
import com.dealerconnect.entity.InventoryLocation;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
public interface InventoryLocationRepository extends JpaRepository<InventoryLocation, Long> {
    List<InventoryLocation> findByDealerId(Long dealerId);
}
