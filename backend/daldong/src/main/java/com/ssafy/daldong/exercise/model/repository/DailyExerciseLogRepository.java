package com.ssafy.daldong.exercise.model.repository;

import com.ssafy.daldong.exercise.model.entity.DailyExerciseLog;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DailyExerciseLogRepository extends JpaRepository<DailyExerciseLog, Long> {
}
