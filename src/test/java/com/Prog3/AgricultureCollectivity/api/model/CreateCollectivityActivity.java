package com.Prog3.AgricultureCollectivity.api.model;

import java.time.LocalDate;
import java.util.List;

public class CreateCollectivityActivity {
    public String label;
    public String activityType;
    public List<MemberOccupation> memberOccupationConcerned;
    public LocalDate executiveDate;
    public MonthlyRecurrenceRule recurrenceRule;
}
