package com.dealerconnect.util;



public class PasswordValidator {

    public static boolean isValid(String password) {
        if (password == null || password.length() < 8) return false;
        
        boolean hasUppercase = false;
        boolean hasSpecial = false;
        String specialChars = "!@#$%^&*()_+-=[]{};':\"\\|,.<>/?";
        
        for (char c : password.toCharArray()) {
            if (Character.isUpperCase(c)) hasUppercase = true;
            else if (specialChars.contains(String.valueOf(c))) hasSpecial = true;
        }
        
        return hasUppercase && hasSpecial;
    }

    public static String getRequirementsMessage() {
        return "Password must be at least 8 characters long, contain at least one uppercase letter (A-Z), and one special character (e.g., @, #, $, %).";
    }
}
