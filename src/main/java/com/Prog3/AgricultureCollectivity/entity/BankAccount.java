package com.Prog3.AgricultureCollectivity.entity;

import com.Prog3.AgricultureCollectivity.entity.enums.Bank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class BankAccount {
    private String id;
    private Account account;
    private String holderName;
    private Bank bankName;
    private String bankCode;
    private String branchCode;
    private String accountNumber;
    private String ribKey;
}