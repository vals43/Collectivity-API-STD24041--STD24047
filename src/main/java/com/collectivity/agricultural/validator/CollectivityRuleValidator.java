package com.collectivity.agricultural.validator;

import com.collectivity.agricultural.model.Member;
import com.collectivity.agricultural.model.dto.CreateMember;
import com.collectivity.agricultural.exception.InsufficientSponsorCount;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
public class CollectivityRuleValidator {

    public void validate(CreateMember dto, List<Member> sponsors) {

        int inTargetCollectivity = 0;
        int inOtherCollectivities = 0;

        for (Member sponsor : sponsors) {

            if (!dto.getReferees().contains(sponsor.getId())) {
                continue;
            }

            List<String> collectivityIds =
                    sponsor.getIdsOfActualBelongingCollectivities();

            if (collectivityIds.contains(dto.getCollectivityIdentifier())) {
                inTargetCollectivity++;
            } else {
                inOtherCollectivities++;
            }
        }

        if (inTargetCollectivity < inOtherCollectivities) {
            throw new InsufficientSponsorCount(
                    dto.getFirstName() +
                            " does not satisfy collectivity sponsor rule"
            );
        }
    }
}