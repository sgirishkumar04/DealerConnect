package com.dealerconnect.repository;
import com.dealerconnect.entity.VehicleVariant;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
public interface VehicleVariantRepository extends JpaRepository<VehicleVariant, Long> {
    List<VehicleVariant> findByModelId(Long modelId);
}
