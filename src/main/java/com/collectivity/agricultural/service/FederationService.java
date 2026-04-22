package com.collectivity.agricultural.service;


import com.collectivity.agricultural.model.Federation;
import com.collectivity.agricultural.exception.NotFoundException;
import com.collectivity.agricultural.repository.FederationRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@AllArgsConstructor
public class FederationService {
    private final FederationRepository federationRepository;

    public Federation getFederation() {
        return federationRepository.findFederation()
                .orElseThrow(() -> new NotFoundException("Federation not found"));
    }
}