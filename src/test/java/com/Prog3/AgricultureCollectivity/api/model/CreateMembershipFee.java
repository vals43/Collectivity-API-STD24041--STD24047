package com.Prog3.AgricultureCollectivity.api.model;

import java.math.BigDecimal;
import java.time.LocalDate;

public class CreateMembershipFee {

    public LocalDate eligibleFrom;
    public Frequency frequency;
    public BigDecimal amount;
    public String label;
}