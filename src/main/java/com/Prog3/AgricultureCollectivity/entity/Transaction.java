package com.Prog3.AgricultureCollectivity.entity;

import com.Prog3.AgricultureCollectivity.entity.enums.PaymentMode;
import com.Prog3.AgricultureCollectivity.entity.enums.TransactionType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Transaction {
    private String id;
    private Collectivity collectivity;
    private Member member;
    private CotisationPlan cotisationPlan;
    private TransactionType transactionType;
    private Double amount;
    private LocalDate transactionDate;
    private PaymentMode paymentMode;
    private String description;
    private Account account;
}