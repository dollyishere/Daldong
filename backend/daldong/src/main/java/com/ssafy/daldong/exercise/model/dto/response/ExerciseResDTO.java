package com.ssafy.daldong.exercise.model.dto.response;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Map;

@Getter
@Setter
@Builder
public class ExerciseResDTO {
    private long statisticsId;

    private long userId;

    private LocalTime dailyExTime;

    private int dailyKcal;

    private int dailyCount;

    private int dailyFriend;
    private int dailyPoint;
    private Map<LocalDate, Integer> chart;
}
