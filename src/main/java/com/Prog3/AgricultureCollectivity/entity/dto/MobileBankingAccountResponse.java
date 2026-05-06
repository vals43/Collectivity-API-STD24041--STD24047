package com.Prog3.AgricultureCollectivity.entity.dto;

import com.Prog3.AgricultureCollectivity.entity.enums.MobileBankingService;
import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

@Data
@EqualsAndHashCode(callSuper = true)
@NoArgsConstructor
public class MobileBankingAccountResponse extends FinancialAccountResponse {
    private String type = "MOBILE_BANKING";
    private String holderName;
    private MobileBankingService mobileBankingService;
    private Integer mobileNumber;

    @Builder
    public MobileBankingAccountResponse(String id, Double amount, String holderName,
                                        MobileBankingService mobileBankingService, Integer mobileNumber) {
        super(id, amount);
        this.holderName = holderName;
        this.mobileBankingService = mobileBankingService;
        this.mobileNumber = mobileNumber;
    }
}