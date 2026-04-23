package com.collectivity.agricultural.controller;

import com.collectivity.agricultural.model.Collectivity;
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

    @PostMapping
    public ResponseEntity<?> createCollectivities(@RequestBody(required = false) List<CreateCollectivity> createCollectivities){
        try{
            if(createCollectivities == null){
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Mandatory body not provided");
            }
            List<CollectivityResponse> collectivities = service.createCollectivities(createCollectivities);
            return ResponseEntity.status(HttpStatus.CREATED).body(collectivities);
        }catch (BadRequestException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (NotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("An unexpected error occurred: " + e.getMessage());
        }
    }


    @PatchMapping("/{id}/identity")
    public ResponseEntity<?> updateIdentity(
            @PathVariable Integer id,
            @RequestBody IdentityRequest request) {
        try {
            // Appel de la logique métier adaptée à l'immuabilité et l'unicité
            Collectivity updated = service.assignIdentity(id, request.getNumber(), request.getName());
            return ResponseEntity.ok(updated);

        } catch (IllegalStateException e) {
            // 403 Forbidden : Identité déjà fixée (Immuabilité)
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());

        } catch (IllegalArgumentException e) {
            // 400 Bad Request : Nom déjà utilisé ou données manquantes
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());

        } catch (NotFoundException e) {
            // 404 Not Found : Collectivité inexistante
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Erreur lors de l'attribution : " + e.getMessage());
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