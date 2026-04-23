package com.collectivity.agricultural.model;

import lombok.*;
import java.math.BigDecimal;

@Getter @Setter @Builder
@NoArgsConstructor @AllArgsConstructor
public class FinancialAccount {
    private String id;
    private String label; // ex: "Caisse principale", "Compte BNI"
    private String type;  // CASH, MOBILE_MONEY, BANK
    private BigDecimal balance; // Le solde calculé
}