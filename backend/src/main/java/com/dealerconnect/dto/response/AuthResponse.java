package com.dealerconnect.dto.response;

import lombok.*;
import java.util.List;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class AuthResponse {
    private String token;
    private String email;
    private String role;
    private String fullName;
    private Long employeeId;
    private Long dealerId;
    private Boolean isSuperAdmin;
    private List<String> permissions;
}
