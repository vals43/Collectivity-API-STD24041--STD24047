package com.collectivity.agricultural.entity.dto;

import com.collectivity.agricultural.entity.enums.Gender;
import com.collectivity.agricultural.entity.enums.CollectivityOccupation;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.Date;
import java.util.List;


@AllArgsConstructor
@NoArgsConstructor
@Builder
@Data
public class CreateMember {

    private String firstName;
    private String lastName;
    private LocalDate birthDate;
    private Gender gender;
    private String address;
    private String profession;
    private String phoneNumber;
    private String email;

    private CollectivityOccupation occupation;

    private Integer collectivityIdentifier;
    private List<Integer> referees;

    private boolean registrationFeePaid;
    private boolean membershipDuesPaid;
}