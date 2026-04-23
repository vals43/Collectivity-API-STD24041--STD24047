
package com.collectivity.agricultural.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Federation {
    private String id;
    private double cotisationPercentage;
    private Structure structure;
}
