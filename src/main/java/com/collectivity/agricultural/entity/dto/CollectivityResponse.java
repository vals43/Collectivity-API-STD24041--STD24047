package com.collectivity.agricultural.entity.dto;

import com.collectivity.agricultural.entity.Member;
import com.collectivity.agricultural.entity.Structure;
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