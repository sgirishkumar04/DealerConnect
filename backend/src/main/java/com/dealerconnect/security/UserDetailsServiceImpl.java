package com.dealerconnect.security;

import com.dealerconnect.entity.Employee;
import com.dealerconnect.repository.EmployeeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.*;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.ArrayList;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserDetailsServiceImpl implements UserDetailsService {

    private final EmployeeRepository employeeRepository;

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        Employee emp = employeeRepository.findByEmailAndIsActiveTrue(email)
            .orElseThrow(() -> new UsernameNotFoundException("User not found: " + email));

        List<SimpleGrantedAuthority> authorities = new ArrayList<>();
        
        emp.getRoles().forEach(role -> {
            // Add the role itself
            authorities.add(new SimpleGrantedAuthority("ROLE_" + role.getName()));
            
            // Add all granular database permissions
            if(role.getPermissions() != null) {
                authorities.addAll(role.getPermissions().stream()
                    .map(p -> new SimpleGrantedAuthority(p.getName()))
                    .collect(Collectors.toList()));
            }
        });

        // Unique authorities check
        List<SimpleGrantedAuthority> uniqueAuthorities = authorities.stream()
            .distinct()
            .collect(Collectors.toList());

        return new UserPrincipal(emp, uniqueAuthorities);
    }
}
