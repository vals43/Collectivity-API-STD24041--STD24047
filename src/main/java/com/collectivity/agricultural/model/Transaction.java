package com.collectivity.agricultural.model;

import com.collectivity.agricultural.model.enums.PaymentMode;
import com.collectivity.agricultural.model.enums.TransactionType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.util.Date;


@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Transaction {
    private String id;
    private Integer memberId;
    private Integer collectivityId;
    private Integer cotisationPlanId;
    private Integer accountId;
    private BigDecimal amount;
    private PaymentMode paymentMode;
    private String description;
    private TransactionType transactionType;
    private Date transactionDate;
}