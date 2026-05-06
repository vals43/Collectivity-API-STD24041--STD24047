package com.Prog3.AgricultureCollectivity.entity.dto;

import com.Prog3.AgricultureCollectivity.entity.enums.Bank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BankAccountDetail {
    private String id;
    private String type = "BANK";
    private Double amount;
    private String holderName;
    private Bank bankName;
    private Integer bankCode;
    private Integer bankBranchCode;
    private Integer bankAccountNumber;
    private Integer bankAccountKey;
}