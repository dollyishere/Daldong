package com.ssafy.daldong.exercise.model.repository;

import com.ssafy.daldong.exercise.model.entity.ExerciseLog;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDateTime;
import java.util.List;

public interface ExerciseLogRepository extends JpaRepository<ExerciseLog, Long> {
    List<ExerciseLog> findByUser_UserIdAndExerciseEndTimeBetween(long user_userId, LocalDateTime exerciseEndTime, LocalDateTime exerciseEndTime2);
}
