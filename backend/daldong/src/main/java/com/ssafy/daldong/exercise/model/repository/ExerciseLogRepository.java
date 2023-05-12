package com.ssafy.daldong.exercise.model.repository;

import com.ssafy.daldong.exercise.model.entity.ExerciseLog;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface ExerciseLogRepository extends JpaRepository<ExerciseLog, Long> {
    Optional<List<ExerciseLog>> findByUser_UserIdAndExerciseEndTimeBetween(long user_userId, LocalDateTime exerciseEndTime, LocalDateTime exerciseEndTime2);
}
