package com.ssafy.daldong.exercise.model.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@Builder
public class ExerciseLogResDTO {
    private long userId;
    private List<Double> caloriesHistory;
    private List<Double> heartRateHistory;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private int calories;
    private int heartRate;
    private double distance;
}