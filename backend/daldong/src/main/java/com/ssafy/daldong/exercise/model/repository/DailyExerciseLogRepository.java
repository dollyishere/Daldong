package com.ssafy.daldong.exercise.model.repository;

import com.ssafy.daldong.exercise.model.entity.DailyExerciseLog;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface DailyExerciseLogRepository extends JpaRepository<DailyExerciseLog, Long> {
    public List<DailyExerciseLog> findAllByUser_UserIdAndExDate(long userid, LocalDate date);
}
