package com.collectivity.agricultural.controller;

import com.collectivity.agricultural.model.Collectivity;
import com.collectivity.agricultural.model.FinancialAccount;
import com.collectivity.agricultural.model.dto.CollectivityResponse;
import com.collectivity.agricultural.model.dto.CreateCollectivity;
import com.collectivity.agricultural.exception.NotFoundException;
import com.collectivity.agricultural.service.CollectivityService;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.apache.coyote.BadRequestException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@AllArgsConstructor
@RequestMapping("/collectivities")
public class   CollectivityController {
    private final CollectivityService service;

    // --- AJOUTS DU JEUDI 22 AVRIL (Deadline 12h) ---

    @GetMapping("/{id}")
    public ResponseEntity<Collectivity> getCollectivityById(@PathVariable Integer id) {
        // Le service appelle repository.findById qui charge déjà les members (indispensable !)
        Collectivity collectivity = service.getById(id);
        return ResponseEntity.ok(collectivity);
    }

    @GetMapping("/{id}/financialAccounts")
    public ResponseEntity<List<FinancialAccount>> getFinancialAccounts(
            @PathVariable Integer id,
            @RequestParam(name = "at") String atDate) {
        List<FinancialAccount> accounts = service.getFinancialAccountsWithBalance(id, atDate);
        return ResponseEntity.ok(accounts);
    }

    // --- FONCTIONNALITÉS PRÉCÉDENTES ---

    @PostMapping
    public ResponseEntity<?> createCollectivities(@RequestBody(required = false) List<CreateCollectivity> createCollectivities){
        try {
            if(createCollectivities == null){
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Mandatory body not provided");
            }
            List<CollectivityResponse> collectivities = service.createCollectivities(createCollectivities);
            return ResponseEntity.status(HttpStatus.CREATED).body(collectivities);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
        }
    }

    // CORRIGÉ : Utilisation de PUT et /informations selon le sujet J
    @PutMapping("/{id}/informations")
    public ResponseEntity<?> updateIdentity(
            @PathVariable Integer id,
            @RequestBody IdentityRequest request) {
        try {
            Collectivity updated = service.assignIdentity(id, request.getNumber(), request.getName());
            return ResponseEntity.ok(updated);
        } catch (IllegalStateException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
        } catch (NotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        }
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class IdentityRequest {
        private String number;
        private String name;
    }
}