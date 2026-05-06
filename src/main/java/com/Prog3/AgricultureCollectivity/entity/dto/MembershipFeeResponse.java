package com.Prog3.AgricultureCollectivity.entity.dto;

import com.Prog3.AgricultureCollectivity.entity.enums.ActivityStatus;
import com.Prog3.AgricultureCollectivity.entity.enums.Frequency;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MembershipFeeResponse {
    private String id;
    private LocalDate eligibleFrom;
    private Frequency frequency;
    private Double amount;
    private String label;
    private ActivityStatus status;
}