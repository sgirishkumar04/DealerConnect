package com.dealerconnect.dto.request;

import jakarta.validation.constraints.*;
import lombok.*;
import java.time.LocalDate;

@Data @NoArgsConstructor @AllArgsConstructor
public class EmployeeRequest {
    @Size(max = 20)            private String employeeCode;
    @NotBlank @Size(max = 80)  private String firstName;
    @NotBlank @Size(max = 80)  private String lastName;
    @NotBlank @Email           private String email;
    @Size(max = 20)            private String phone;
    private String password;
    @NotNull                   private Long departmentId;
    @NotNull                   private Long roleId;
    private Long managerId;
    private LocalDate dateOfJoin;
}
