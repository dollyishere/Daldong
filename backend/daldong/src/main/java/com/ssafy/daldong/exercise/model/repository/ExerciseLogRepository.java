package com.ssafy.daldong.exercise.model.repository;

import com.ssafy.daldong.exercise.model.entity.ExerciseLog;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ExerciseLogRepository extends JpaRepository<ExerciseLog, Long> {
}
