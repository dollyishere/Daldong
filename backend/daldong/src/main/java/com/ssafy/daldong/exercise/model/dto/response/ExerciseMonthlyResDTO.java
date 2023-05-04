package com.ssafy.daldong.exercise.model.dto.response;

import com.ssafy.daldong.exercise.model.entity.ExerciseLog;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;
import java.time.LocalTime;

@Getter
@Setter
@Builder
public class ExerciseMonthlyResDTO {
    private LocalDateTime exerciseStartTime;
    private LocalDateTime exerciseEndTime;
    private LocalTime exerciseTime;
    private int exerciseKcal;
    private int exercisePoint;
    private int averageHeart;
    private int exercisePetExp;
    private int exerciseUserExp;
    private int maxHeart;

    public static ExerciseMonthlyResDTO of(ExerciseLog exerciseLog){
        return ExerciseMonthlyResDTO.builder()
                .exerciseStartTime(exerciseLog.getExerciseStartTime())
                .exerciseEndTime(exerciseLog.getExerciseEndTime())
                .exerciseTime(exerciseLog.getExerciseTime())
                .exerciseKcal(exerciseLog.getExerciseKcal())
                .exercisePoint(exerciseLog.getExercisePoint())
                .averageHeart(exerciseLog.getAverageHeart())
                .exercisePetExp(exerciseLog.getExercisePetExp())
                .exerciseUserExp(exerciseLog.getExerciseUserExp())
                .maxHeart(exerciseLog.getMaxHeart())
                .build();
    }
}
