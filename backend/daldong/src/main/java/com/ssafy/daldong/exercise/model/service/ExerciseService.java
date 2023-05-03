package com.ssafy.daldong.exercise.model.service;

import com.ssafy.daldong.exercise.model.dto.response.ExerciseResDTO;

import java.util.List;
import java.util.Map;

public interface ExerciseService {
    public ExerciseResDTO getExercise(Long userId);
    public List<Map<String, Object>> getExerciseMonthly(Long userId, String month);
}
