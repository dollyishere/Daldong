package com.ssafy.daldong.exercise.model.service;

import com.ssafy.daldong.exercise.model.dto.response.ExerciseMonthlyResDTO;
import com.ssafy.daldong.exercise.model.dto.response.ExerciseResDTO;
import com.ssafy.daldong.exercise.model.entity.ExerciseLog;
import com.ssafy.daldong.exercise.model.repository.ExerciseLogRepository;
import com.ssafy.daldong.user.model.entity.Statistics;
import com.ssafy.daldong.user.model.repository.StatisticsRepository;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class ExerciseServiceImpl implements ExerciseService{

    private static final Logger logger = LogManager.getLogger(ExerciseServiceImpl.class);
    private final StatisticsRepository stasticsRepository;
    private final ExerciseLogRepository exerciseLogRepository;

    @Autowired
    public ExerciseServiceImpl(StatisticsRepository stasticsRepository,
                               ExerciseLogRepository exerciseLogRepository) {
        this.stasticsRepository = stasticsRepository;
        this.exerciseLogRepository = exerciseLogRepository;
    }

    @Override
    public ExerciseResDTO getExercise(Long userId) {
        logger.info("ExerciseServiceImpl.getExercise({})",userId);
        Statistics statistics = stasticsRepository.findByUser_UserId(userId).orElseThrow();

        logger.info("statistics : {}",statistics);
        return ExerciseResDTO.builder()
                .statisticsId(statistics.getStatisticsId())
                .userId(statistics.getUser().getUserId())
                .dailyExTime(statistics.getDailyExTime())
                .dailyKcal(statistics.getDailyKcal())
                .dailyCount(statistics.getDailyCount())
                .dailyFriend(statistics.getDailyFriend())
                .dailyPoint(statistics.getDailyPoint())
                .build();
    }

    @Override
    public List<Map<String, Object>> getExerciseMonthly(Long userId, String date) {
        logger.info("ExerciseServiceImpl.getExerciseMonthly({}, {})", userId, date);
        int year = Integer.parseInt(date.substring(0, 4));
        int month = Integer.parseInt(date.substring(4));
        LocalDateTime startDate = LocalDateTime.of(year, month, 1, 0, 0);
        LocalDateTime endDate = startDate.plusMonths(1);

        List<ExerciseLog> exerciseLogList = exerciseLogRepository.findByUser_UserIdAndExerciseEndTimeBetween(userId, startDate, endDate)
                .orElseThrow();

        Map<LocalDate, List<ExerciseLog>> dailyExerciseLogs = new LinkedHashMap<>();
        for (ExerciseLog exerciseLog : exerciseLogList) {
            LocalDate day = exerciseLog.getExerciseEndTime().toLocalDate();
            dailyExerciseLogs.computeIfAbsent(day, k -> new ArrayList<>()).add(exerciseLog);
        }

        List<Map<String, Object>> result = new ArrayList<>();
        for (LocalDate day : dailyExerciseLogs.keySet()) {
            Map<String, Object> dayExerciseMap = new HashMap<>();
            dayExerciseMap.put("date", day.toString());
            dayExerciseMap.put("exercise", dailyExerciseLogs.get(day).stream()
                    .map(ExerciseMonthlyResDTO::of)
                    .collect(Collectors.toList()));
            result.add(dayExerciseMap);
        }
        return result;
    }
}
