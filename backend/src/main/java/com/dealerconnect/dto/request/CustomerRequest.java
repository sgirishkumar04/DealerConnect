package com.dealerconnect.dto.request;

import jakarta.validation.constraints.*;
import lombok.*;
import java.time.LocalDate;

@Data @NoArgsConstructor @AllArgsConstructor
public class CustomerRequest {
    @NotBlank @Size(max = 20)  private String customerCode;
    @NotBlank @Size(max = 80)  private String firstName;
    @NotBlank @Size(max = 80)  private String lastName;
    @Email  @Size(max = 150)   private String email;
    @NotBlank @Size(max = 20)  private String phone;
    @Size(max = 20)            private String alternatePhone;
    private LocalDate dateOfBirth;
    private String gender;
    @Size(max = 10)            private String panNumber;
    private String customerType;
    @Size(max = 150)           private String companyName;
    @Size(max = 20)            private String gstNumber;
    private java.util.List<AddressRequest> addresses = new java.util.ArrayList<>();

    @Data @NoArgsConstructor @AllArgsConstructor
    public static class AddressRequest {
        @NotBlank private String type;
        @NotBlank private String line1;
        private String line2;
        @NotBlank private String city;
        @NotBlank private String state;
        @NotBlank private String pincode;
        private Boolean isPrimary;
    }
}
