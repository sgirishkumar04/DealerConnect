package com.hyundai.dms.service.impl;

import com.hyundai.dms.security.DealerContext;
import com.hyundai.dms.entity.Dealer;
import com.hyundai.dms.repository.DealerRepository;

import com.hyundai.dms.dto.request.CustomerRequest;
import com.hyundai.dms.entity.Customer;
import com.hyundai.dms.entity.CustomerAddress;
import com.hyundai.dms.exception.ResourceNotFoundException;
import com.hyundai.dms.repository.CustomerRepository;
import com.hyundai.dms.service.AuditService;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class CustomerService {

    private final CustomerRepository customerRepo;
    private final DealerRepository dealerRepo;
    private final AuditService auditService;
    private final ObjectMapper objectMapper;

    private <T extends Enum<T>> T safeValueOf(Class<T> enumType, String value) {
        if (value == null || value.trim().isEmpty()) return null;
        try {
            return Enum.valueOf(enumType, value.toUpperCase());
        } catch (Exception e) {
            return null;
        }
    }

    public Page<Customer> getAll(String search, Pageable pageable) {
        Long dealerId = DealerContext.getCurrentDealerId();
        return customerRepo.search(search, dealerId, pageable);
    }

    public Customer getById(Long id) {
        Long dealerId = DealerContext.getCurrentDealerId();
        return customerRepo.findById(id)
            .filter(c -> c.getDealer().getId().equals(dealerId))
            .orElseThrow(() -> new ResourceNotFoundException("Customer not found: " + id));
    }

    @Transactional
    public Customer create(CustomerRequest req) {
        Long dealerId = DealerContext.getCurrentDealerId();
        Dealer dealer = dealerRepo.findById(dealerId)
            .orElseThrow(() -> new ResourceNotFoundException("Dealer not found"));

        if (customerRepo.existsByCustomerCodeAndDealerId(req.getCustomerCode(), dealerId))
            throw new IllegalArgumentException("Customer code already exists for this dealer");
            
        Customer c = Customer.builder()
            .customerCode(req.getCustomerCode())
            .firstName(req.getFirstName())
            .lastName(req.getLastName())
            .email(req.getEmail())
            .phone(req.getPhone())
            .alternatePhone(req.getAlternatePhone())
            .dateOfBirth(req.getDateOfBirth())
            .gender(safeValueOf(Customer.Gender.class, req.getGender()))
            .panNumber(req.getPanNumber())
            .customerType(safeValueOf(Customer.CustomerType.class, req.getCustomerType()))
            .companyName(req.getCompanyName())
            .gstNumber(req.getGstNumber())
            .dealer(dealer)
            .build();
            
        if (req.getAddresses() != null) {
            List<CustomerAddress> addresses = req.getAddresses().stream()
                .map(a -> CustomerAddress.builder()
                    .customer(c)
                    .type(safeValueOf(CustomerAddress.AddressType.class, a.getType()))
                    .line1(a.getLine1())
                    .line2(a.getLine2())
                    .city(a.getCity())
                    .state(a.getState())
                    .pincode(a.getPincode())
                    .isPrimary(a.getIsPrimary())
                    .build())
                .collect(Collectors.toList());
            c.setAddresses(addresses);
        }

        Customer saved = customerRepo.save(c);
        auditService.log("Customer", saved.getId(), "CREATE", null, saved);
        return saved;
    }

    @Transactional
    public Customer update(Long id, CustomerRequest req) {
        Customer c = getById(id);
        String oldJson = null;
        try {
            oldJson = objectMapper.writeValueAsString(c);
        } catch (Exception e) {}

        c.setFirstName(req.getFirstName());
        c.setLastName(req.getLastName());
        c.setEmail(req.getEmail());
        c.setPhone(req.getPhone());
        c.setAlternatePhone(req.getAlternatePhone());
        c.setDateOfBirth(req.getDateOfBirth());
        c.setGender(safeValueOf(Customer.Gender.class, req.getGender()));
        c.setPanNumber(req.getPanNumber());
        c.setCustomerType(safeValueOf(Customer.CustomerType.class, req.getCustomerType()));
        c.setCompanyName(req.getCompanyName());
        c.setGstNumber(req.getGstNumber());
        
        if (req.getAddresses() != null) {
            c.getAddresses().clear();
            List<CustomerAddress> newAddresses = req.getAddresses().stream()
                .map(a -> CustomerAddress.builder()
                    .customer(c)
                    .type(safeValueOf(CustomerAddress.AddressType.class, a.getType()))
                    .line1(a.getLine1())
                    .line2(a.getLine2())
                    .city(a.getCity())
                    .state(a.getState())
                    .pincode(a.getPincode())
                    .isPrimary(a.getIsPrimary())
                    .build())
                .collect(Collectors.toList());
            c.getAddresses().addAll(newAddresses);
        }
        
        Customer saved = customerRepo.save(c);
        auditService.log("Customer", saved.getId(), "UPDATE", oldJson, saved);
        return saved;
    }

    @Transactional
    public void delete(Long id) {
        Customer c = getById(id);
        String oldJson = null;
        try {
            oldJson = objectMapper.writeValueAsString(c);
        } catch (Exception e) {}

        customerRepo.delete(c);
        auditService.log("Customer", id, "DELETE", oldJson, null);
    }

    public String generateNextCode() {
        Long dealerId = DealerContext.getCurrentDealerId();
        long count = customerRepo.countByDealerId(dealerId);
        String code;
        do {
            count++;
            code = String.format("CST-DLR%02d-%04d", dealerId, count);
        } while (customerRepo.existsByCustomerCodeAndDealerId(code, dealerId));
        return code;
    }
}
