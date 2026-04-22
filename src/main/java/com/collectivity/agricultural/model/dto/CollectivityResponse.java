package com.collectivity.agricultural.model.dto;

import com.collectivity.agricultural.model.Member;
import com.collectivity.agricultural.model.Structure;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CollectivityResponse {
    private String id;
    private String location;
    private Structure structure;
    private List<Member> members;
}