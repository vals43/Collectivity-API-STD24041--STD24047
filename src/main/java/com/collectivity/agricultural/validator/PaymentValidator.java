package com.collectivity.agricultural.validator;

import com.collectivity.agricultural.entity.dto.CreateMember;
import com.collectivity.agricultural.exception.PaymentException;
import org.springframework.stereotype.Component;

import java.util.List;


@Component
public class PaymentValidator {
    public void validate(CreateMember member) {
        if (!member.isMembershipDuesPaid() || !member.isRegistrationFeePaid()) {
            throw new PaymentException(
                    member.getFirstName() + " : payment not completed"
            );
        }
    }
    public void validate(List<CreateMember> members) {
        for (CreateMember member : members) {
            validate(member);
        }
    }
}
