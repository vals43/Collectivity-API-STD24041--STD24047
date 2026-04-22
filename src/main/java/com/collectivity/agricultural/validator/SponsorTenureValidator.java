package com.collectivity.agricultural.validator;


import com.collectivity.agricultural.entity.Member;
import com.collectivity.agricultural.exception.SponsorTenureException;
import org.springframework.stereotype.Component;

@Component
public class SponsorTenureValidator {
    public void validate(Member sponsor){
        if(!sponsor.isAValidSponsor()){
            throw new SponsorTenureException(sponsor.getId() + "'s tenure in Federation is below 90 days");
        }
    }
}
