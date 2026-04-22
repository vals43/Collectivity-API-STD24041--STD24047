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


    @PostMapping("/{id}/payments")
    public ResponseEntity<?> addPayment(
            @PathVariable("id") Integer collectivityId,
            @RequestBody Transaction payment) {
        try {
            payment.setCollectivityId(collectivityId);

            paymentService.processPayment(collectivityId, payment);
            return ResponseEntity.status(HttpStatus.CREATED).body("Paiement enregistré avec succès");
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Erreur serveur : " + e.getMessage());
        }
    }


    @GetMapping("/{id}/transactions")
    public ResponseEntity<List<Transaction>> getTransactions(@PathVariable("id") Integer collectivityId) {
        List<Transaction> transactions = paymentService.getTransactionsByCollectivity(collectivityId);
        return ResponseEntity.ok(transactions);
    }
}