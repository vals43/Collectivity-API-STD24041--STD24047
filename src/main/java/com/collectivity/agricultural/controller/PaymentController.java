package com.collectivity.agricultural.controller;

import com.collectivity.agricultural.model.Transaction;
import com.collectivity.agricultural.service.PaymentService;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@AllArgsConstructor
@RequestMapping("/collectivities")
public class PaymentController {

    private final PaymentService paymentService;

    /**
     * POST /collectivities/{id}/payments
     * Doit accepter une LISTE de paiements selon l'OpenAPI v0.0.3
     */
    @PostMapping("/{id}/payments")
    public ResponseEntity<?> addPayments(
            @PathVariable("id") Integer collectivityId,
            @RequestBody List<Transaction> payments) { // Changé en List
        try {
            // On délègue le traitement de la liste au service
            paymentService.processPayments(collectivityId, payments);
            return ResponseEntity.status(HttpStatus.CREATED).body("Paiements enregistrés avec succès");
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Erreur serveur : " + e.getMessage());
        }
    }

    /**
     * GET /collectivities/{id}/transactions
     * Les paramètres 'from' et 'to' sont OBLIGATOIRES dans l'OpenAPI v0.0.3
     */
    @GetMapping("/{id}/transactions")
    public ResponseEntity<?> getTransactions(
            @PathVariable("id") Integer collectivityId,
            @RequestParam("from") String from, // Paramètre obligatoire
            @RequestParam("to") String to) {   // Paramètre obligatoire
        try {
            List<Transaction> transactions = paymentService.getTransactionsByPeriod(collectivityId, from, to);
            return ResponseEntity.ok(transactions);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Paramètres de date invalides ou manquants");
        }
    }
}