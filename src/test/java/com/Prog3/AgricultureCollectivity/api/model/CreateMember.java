package com.Prog3.AgricultureCollectivity.api.model;

import java.util.List;

public class CreateMember extends MemberInformation {

    public String collectivityIdentifier;
    public List<String> referees;
    public Boolean registrationFeePaid;
    public Boolean membershipDuesPaid;
}