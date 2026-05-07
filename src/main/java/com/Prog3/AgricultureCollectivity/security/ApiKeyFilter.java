package com.Prog3.AgricultureCollectivity.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

/**
 * Filter that validates API key for all incoming requests.
 * The API key must be provided in the x-api-key header.
 */
@Component
public class ApiKeyFilter extends OncePerRequestFilter {

    @Value("${api.security.key:agri-secure-key}")
    private String validApiKey;

    private static final String API_KEY_HEADER = "x-api-key";
    private static final String ERROR_MESSAGE = "Bad credentials";

    @Override
    public void doFilterInternal(HttpServletRequest request,
                                 HttpServletResponse response,
                                 FilterChain chain)
            throws IOException, ServletException {

        String apiKey = request.getHeader(API_KEY_HEADER);

        // Check if API key header is present and valid
        if (!isValidApiKey(apiKey)) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\": \"" + ERROR_MESSAGE + "\"}");
            return;
        }

        // API key is valid, continue with the request
        chain.doFilter(request, response);
    }

    /**
     * Validates if the provided API key matches the expected key.
     *
     * @param apiKey the API key to validate
     * @return true if valid, false otherwise
     */
    private boolean isValidApiKey(String apiKey) {
        return apiKey != null && apiKey.equals(validApiKey);
    }
}