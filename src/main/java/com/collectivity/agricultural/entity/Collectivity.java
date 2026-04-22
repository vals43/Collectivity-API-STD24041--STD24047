package com.collectivity.agricultural.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Collectivity {
    private Integer id;
    private String number;
    private String name;
    private String speciality;
    private java.util.Date creationDatetime;
    private boolean federationApproval;
    private java.util.Date authorizationDate;
    private String location;
    private Structure structure;
    private List<Member> members;
}