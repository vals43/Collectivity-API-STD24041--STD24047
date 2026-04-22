package com.collectivity.agricultural.entity.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CreateStructure {
    private Integer presidentId;
    private Integer vicePresidentId;
    private Integer treasurerId;
    private Integer secretaryId;
}