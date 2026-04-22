package com.collectivity.agricultural.service;

import com.collectivity.agricultural.exception.NotFoundException;
import com.collectivity.agricultural.model.Transaction;
import com.collectivity.agricultural.model.enums.TransactionType;
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
     * Traitement d'une liste de paiements (Conforme OpenAPI v0.0.3)
     */
    public void processPayments(Integer collectivityId, List<Transaction> payments) {
        // 1. Vérification globale de la collectivité
        if (collectivityRepository.findById(collectivityId) == null) {
            throw new NotFoundException("Collectivité introuvable ID: " + collectivityId);
        }

        // 2. Traitement et validation de chaque paiement
        for (Transaction payment : payments) {
            validateAndPrepareTransaction(collectivityId, payment);
            transactionRepository.saveTransaction(payment);
        }
    }

    /**
     * Récupération de l'historique par période (Fonctionnalité D)
     */
    public List<Transaction> getTransactionsByPeriod(Integer id, String from, String to) {
        return transactionRepository.findTransactionsByPeriod(id, from, to);
    }

    /**
     * Méthode utilitaire de validation (Énoncé C)
     */
    private void validateAndPrepareTransaction(Integer collectivityId, Transaction payment) {
        // Validation du montant
        if (payment.getAmount() == null || payment.getAmount().compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Le montant doit être strictement supérieur à zéro");
        }

        // Validation du mode de paiement
        if (payment.getPaymentMode() == null) {
            throw new IllegalArgumentException("Le mode de paiement est obligatoire (CASH, BANK_TRANSFER, MOBILE_BANKING)");
        }

        // Forcer les données de contexte pour la sécurité
        payment.setCollectivityId(collectivityId);
        payment.setTransactionType(TransactionType.IN); // Toujours 'IN' pour un encaissement
    }

    /**
     * Gardée pour compatibilité si besoin, mais appelle désormais la logique commune
     */
    public void processPayment(Integer collectivityId, Transaction payment) {
        if (collectivityRepository.findById(collectivityId) == null) {
            throw new NotFoundException("Collectivité introuvable");
        }
        validateAndPrepareTransaction(collectivityId, payment);
        transactionRepository.saveTransaction(payment);
    }
}