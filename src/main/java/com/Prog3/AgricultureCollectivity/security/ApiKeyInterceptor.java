package com.Prog3.AgricultureCollectivity.security;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class ApiKeyInterceptor implements HandlerInterceptor {

    @Value("${api.key:agri-secure-key}")
    private String validApiKey;

    private static final String API_KEY_HEADER = "x-api-key";

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response,
                             Object handler) throws Exception {

        // Vérifier si la méthode a l'annotation @SkipApiKeyCheck
        if (handler instanceof HandlerMethod) {
            HandlerMethod handlerMethod = (HandlerMethod) handler;
            SkipApiKeyCheck skipCheck = handlerMethod.getMethodAnnotation(SkipApiKeyCheck.class);
            if (skipCheck != null || handlerMethod.getBeanType().isAnnotationPresent(SkipApiKeyCheck.class)) {
                return true; // Pas de vérification pour cette méthode
            }
        }

        // Récupérer la clé API de l'en-tête
        String apiKey = request.getHeader(API_KEY_HEADER);

        // Vérifier la présence et la validité de la clé
        if (apiKey == null || !validApiKey.equals(apiKey)) {
            response.setStatus(HttpStatus.UNAUTHORIZED.value());
            response.setContentType("application/json");
            response.getWriter().write("{\"message\": \"Bad credentials\"}");
            return false;
        }

        return true; // Clé valide, continuer le traitement
    }
}