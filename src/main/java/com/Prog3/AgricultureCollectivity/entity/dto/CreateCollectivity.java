package com.Prog3.AgricultureCollectivity.entity.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CreateCollectivity {
    private String location;
    private String speciality;
    private List<String> members;
    private boolean federationApproval;
    private CreateCollectivityStructure structure;
}