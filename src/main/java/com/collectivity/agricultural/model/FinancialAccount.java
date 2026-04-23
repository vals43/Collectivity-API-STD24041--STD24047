package com.collectivity.agricultural.model;

import com.collectivity.agricultural.model.enums.PaymentMode;
import lombok.*;
import java.math.BigDecimal;

@Getter @Setter @Builder
@NoArgsConstructor @AllArgsConstructor
public class FinancialAccount {
    private String id;
    private String label; // ex: "Caisse principale", "Compte BNI"
    private PaymentMode type;  // CASH, MOBILE_MONEY, BANK
    private BigDecimal balance; // Le solde calculé
}