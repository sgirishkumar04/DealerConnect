package com.dealerconnect.security;

import com.dealerconnect.entity.Employee;
import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;

import java.time.LocalDate;
import java.util.Collection;

@Getter
public class UserPrincipal extends User {
    private final Long id;
    private final Long dealerId;
    private final boolean isSuperAdmin;
    private final String employeeCode;

    public UserPrincipal(Employee employee, Collection<? extends GrantedAuthority> authorities) {
        super(employee.getEmail(), employee.getPasswordHash(), 
              employee.getIsActive() != null && employee.getIsActive(), 
              employee.getExpiryDate() == null || employee.getExpiryDate().isAfter(LocalDate.now()), 
              true, 
              employee.getIsLocked() == null || !employee.getIsLocked(), 
              authorities);
        this.id = employee.getId();
        this.dealerId = (employee.getDealer() != null) ? employee.getDealer().getId() : null;
        this.isSuperAdmin = employee.getRoles() != null && 
                           employee.getRoles().stream().anyMatch(r -> "SUPER_ADMIN".equals(r.getName()));
        this.employeeCode = employee.getEmployeeCode();
    }
}
