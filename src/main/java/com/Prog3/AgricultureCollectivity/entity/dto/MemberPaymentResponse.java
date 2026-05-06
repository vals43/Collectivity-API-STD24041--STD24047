package com.Prog3.AgricultureCollectivity.entity.dto;

import com.Prog3.AgricultureCollectivity.entity.enums.PaymentMode;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MemberPaymentResponse {
    private String id;
    private Integer amount;
    private PaymentMode paymentMode;
    private FinancialAccountResponse accountCredited;
    private LocalDate creationDate;
}