package com.dealerconnect.security;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.util.StringUtils;

/**
 * Extracts dealer context (dealerId, isSuperAdmin) from the current SecurityContext.
 */
@Component
@RequiredArgsConstructor
public class DealerContext {

    private final JwtTokenProvider tokenProvider;

    public static Long getCurrentDealerId() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.getPrincipal() instanceof UserPrincipal principal) {
            return principal.getDealerId();
        }
        return null;
    }

    public static boolean isCurrentSuperAdmin() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.getPrincipal() instanceof UserPrincipal principal) {
            return principal.isSuperAdmin();
        }
        return false;
    }

    private String resolveToken(HttpServletRequest request) {
        String bearer = request.getHeader("Authorization");
        if (StringUtils.hasText(bearer) && bearer.startsWith("Bearer ")) {
            return bearer.substring(7);
        }
        return null;
    }

    public Long getDealerId(HttpServletRequest request) {
        String token = resolveToken(request);
        if (token == null) return null;
        return tokenProvider.getDealerIdFromToken(token);
    }

    public boolean isSuperAdmin(HttpServletRequest request) {
        String token = resolveToken(request);
        if (token == null) return false;
        return tokenProvider.isSuperAdminToken(token);
    }
}
