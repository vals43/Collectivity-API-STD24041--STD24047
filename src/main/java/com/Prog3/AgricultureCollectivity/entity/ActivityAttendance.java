package com.Prog3.AgricultureCollectivity.entity;

import com.Prog3.AgricultureCollectivity.entity.enums.AttendanceStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ActivityAttendance {
    private String id;
    private String activityId;
    private Member member;
    private AttendanceStatus attendanceStatus;
}