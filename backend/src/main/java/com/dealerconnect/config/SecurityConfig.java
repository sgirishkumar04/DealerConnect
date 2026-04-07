package com.dealerconnect.config;

import com.dealerconnect.security.*;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.*;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.*;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.*;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.*;

import java.util.List;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final UserDetailsServiceImpl userDetailsService;
    private final JwtTokenProvider tokenProvider;
    private final RateLimitingFilter rateLimitingFilter;

    @Bean
    public JwtAuthFilter jwtAuthFilter() {
        return new JwtAuthFilter(tokenProvider, userDetailsService);
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .cors(cors -> cors.configurationSource(corsConfigurationSource()))
            .csrf(csrf -> csrf.disable())
            .sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/auth/**").permitAll()
                .requestMatchers("/dealers/register").permitAll()
                .requestMatchers("/monitor/**", "/monitor", "/actuator/**").permitAll()
                .requestMatchers("/v3/api-docs/**", "/swagger-ui/**", "/swagger-ui.html").permitAll()
                .requestMatchers(HttpMethod.GET, "/lookup/**").authenticated()

                // SUPER_ADMIN-only routes
                .requestMatchers("/dealers/**").hasRole("SUPER_ADMIN")
                .requestMatchers("/super-admin/**").hasRole("SUPER_ADMIN")

                // GET (View-Only)
                .requestMatchers(HttpMethod.GET, "/employees/**").hasAuthority("EMPLOYEES_VIEW")
                .requestMatchers(HttpMethod.GET, "/vehicles/**").hasAuthority("INVENTORY_VIEW")
                .requestMatchers(HttpMethod.GET, "/customers/**").hasAuthority("SALES_VIEW")
                .requestMatchers(HttpMethod.GET, "/leads/**").hasAuthority("SALES_VIEW")
                .requestMatchers(HttpMethod.GET, "/bookings/**").hasAuthority("SALES_VIEW")
                .requestMatchers(HttpMethod.GET, "/service/**").hasAuthority("SERVICE_VIEW")
                .requestMatchers(HttpMethod.GET, "/parts/**").hasAuthority("PARTS_VIEW")
                .requestMatchers(HttpMethod.GET, "/reports/**").hasAnyAuthority("REPORTS_VIEW", "ROLE_SUPER_ADMIN")
                
                // POST (Create)
                .requestMatchers(HttpMethod.POST, "/employees/**").hasAuthority("EMPLOYEES_CREATE")
                .requestMatchers(HttpMethod.POST, "/vehicles/**").hasAuthority("INVENTORY_CREATE")
                .requestMatchers(HttpMethod.POST, "/customers/**").hasAuthority("SALES_CREATE")
                .requestMatchers(HttpMethod.POST, "/leads/**").hasAuthority("SALES_CREATE")
                .requestMatchers(HttpMethod.POST, "/bookings/**").hasAuthority("SALES_CREATE")
                .requestMatchers(HttpMethod.POST, "/service/**").hasAuthority("SERVICE_CREATE")
                .requestMatchers(HttpMethod.POST, "/parts/**").hasAuthority("PARTS_CREATE")

                // PUT (Edit)
                .requestMatchers(HttpMethod.PUT, "/employees/**").hasAuthority("EMPLOYEES_EDIT")
                .requestMatchers(HttpMethod.PUT, "/vehicles/**").hasAuthority("INVENTORY_EDIT")
                .requestMatchers(HttpMethod.PUT, "/customers/**").hasAuthority("SALES_EDIT")
                .requestMatchers(HttpMethod.PUT, "/leads/**").hasAuthority("SALES_EDIT")
                .requestMatchers(HttpMethod.PUT, "/bookings/**").hasAuthority("SALES_EDIT")
                .requestMatchers(HttpMethod.PUT, "/service/**").hasAuthority("SERVICE_EDIT")
                .requestMatchers(HttpMethod.PUT, "/parts/**").hasAuthority("PARTS_EDIT")

                // DELETE 
                .requestMatchers(HttpMethod.DELETE, "/employees/**").hasAuthority("EMPLOYEES_DELETE")
                .requestMatchers(HttpMethod.DELETE, "/vehicles/**").hasAuthority("INVENTORY_DELETE")
                .requestMatchers(HttpMethod.DELETE, "/customers/**").hasAuthority("SALES_DELETE")
                .requestMatchers(HttpMethod.DELETE, "/leads/**").hasAuthority("SALES_DELETE")
                .requestMatchers(HttpMethod.DELETE, "/bookings/**").hasAuthority("SALES_DELETE")
                .requestMatchers(HttpMethod.DELETE, "/service/**").hasAuthority("SERVICE_DELETE")
                .requestMatchers(HttpMethod.DELETE, "/parts/**").hasAuthority("PARTS_DELETE")

                // Other endpoints (Finance)
                .requestMatchers("/finance/**").hasAnyRole("ADMIN", "ACCOUNTS", "SALES_MANAGER")
                .anyRequest().authenticated()
            )
            .addFilterBefore(jwtAuthFilter(), UsernamePasswordAuthenticationFilter.class)
            .addFilterBefore(rateLimitingFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration cfg = new CorsConfiguration();
        cfg.setAllowedOrigins(List.of("http://localhost:4200"));
        cfg.setAllowedMethods(List.of("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"));
        cfg.setAllowedHeaders(List.of("*"));
        cfg.setAllowCredentials(true);
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", cfg);
        return source;
    }
}
