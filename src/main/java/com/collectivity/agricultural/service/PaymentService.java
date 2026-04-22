package com.collectivity.agricultural.service;

import com.collectivity.agricultural.model.Transaction;
import com.collectivity.agricultural.model.enums.TransactionType;
import com.collectivity.agricultural.exception.NotFoundException;
import com.collectivity.agricultural.repository.CollectivityRepository;
import com.collectivity.agricultural.repository.TransactionRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

@Service
@AllArgsConstructor
public class PaymentService {
    private final TransactionRepository transactionRepository;
    private final CollectivityRepository collectivityRepository;

    /**
     * Traitement d'un paiement (Fonctionnalité C)
     */
    public void processPayment(Integer collectivityId, Transaction payment) {
        // 1. Vérification de l'existence de la collectivité
        if (collectivityRepository.findById(collectivityId) == null) {
            throw new NotFoundException("Collectivité introuvable ID: " + collectivityId);
        }

        // 2. Validation du montant (Énoncé C : garder trace du montant positif)
        if (payment.getAmount() == null || payment.getAmount().compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Le montant doit être strictement supérieur à zéro");
        }

        // 3. Validation du mode de paiement (Énoncé C)
        if (payment.getPaymentMode() == null) {
            throw new IllegalArgumentException("Le mode de paiement est obligatoire (CASH, BANK_TRANSFER, MOBILE_MONEY)");
        }

        // 4. Forcer les données de contexte
        payment.setCollectivityId(collectivityId);
        payment.setTransactionType(TransactionType.IN); // C'est un encaissement

        // 5. Enregistrement via le Repository
        transactionRepository.saveTransaction(payment);
    }

    /**
     * Récupération de l'historique (Fonctionnalité D : Transparence financière)
     */
    public List<Transaction> getTransactionsByCollectivity(Integer collectivityId) {
        return transactionRepository.findAllByCollectivityId(collectivityId);
    }
}