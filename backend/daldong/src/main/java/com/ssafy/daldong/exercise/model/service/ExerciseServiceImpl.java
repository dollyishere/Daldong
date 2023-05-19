package com.ssafy.daldong.exercise.model.service;

import com.google.cloud.firestore.Firestore;
import com.google.firebase.cloud.FirestoreClient;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import com.ssafy.daldong.exercise.model.dto.response.ExerciseLogResDTO;
import com.ssafy.daldong.exercise.model.dto.response.ExerciseMonthlyResDTO;
import com.ssafy.daldong.exercise.model.dto.response.ExerciseResDTO;
import com.ssafy.daldong.exercise.model.entity.DailyExerciseLog;
import com.ssafy.daldong.exercise.model.entity.ExerciseLog;
import com.ssafy.daldong.exercise.model.repository.DailyExerciseLogRepository;
import com.ssafy.daldong.exercise.model.repository.ExerciseLogRepository;
import com.ssafy.daldong.main.model.entity.UserAsset;
import com.ssafy.daldong.main.model.repository.UserAssetRepository;
import com.ssafy.daldong.user.model.entity.Statistics;
import com.ssafy.daldong.user.model.entity.User;
import com.ssafy.daldong.user.model.repository.LevelRepository;
import com.ssafy.daldong.user.model.repository.StatisticsRepository;
import com.ssafy.daldong.user.model.repository.UserRepository;
import io.swagger.models.auth.In;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class ExerciseServiceImpl implements ExerciseService{

    private static final Logger logger = LogManager.getLogger(ExerciseServiceImpl.class);
    private final StatisticsRepository stasticsRepository;
    private final ExerciseLogRepository exerciseLogRepository;
    private final UserRepository userRepository;
    private final LevelRepository levelRepository;
    private final UserAssetRepository userAssetRepository;
    private final DailyExerciseLogRepository dailyExerciseLogRepository;

    @Autowired
    public ExerciseServiceImpl(StatisticsRepository stasticsRepository,
                               ExerciseLogRepository exerciseLogRepository,
                               UserRepository userRepository,
                               LevelRepository levelRepository,
                               UserAssetRepository userAssetRepository,
                               DailyExerciseLogRepository dailyExerciseLogRepository) {
        this.stasticsRepository = stasticsRepository;
        this.exerciseLogRepository = exerciseLogRepository;
        this.userRepository = userRepository;
        this.levelRepository = levelRepository;
        this.userAssetRepository = userAssetRepository;
        this.dailyExerciseLogRepository = dailyExerciseLogRepository;
    }

    @Override
    public ExerciseResDTO getExercise(Long userId) {
        logger.info("ExerciseServiceImpl.getExercise({})",userId);
        Statistics statistics = stasticsRepository.findByUser_UserId(userId).orElseThrow();

        Map<LocalDate, Integer> chart = new TreeMap<>();
        for (int i = 0; i < 7; i++) {
            LocalDate date = LocalDate.now().minusDays(1+i);
            List<DailyExerciseLog> dailyExerciseLogs = dailyExerciseLogRepository.findAllByUser_UserIdAndExDate(userId, date);
            if (dailyExerciseLogs.isEmpty()) {
                chart.put(date, 0);
                continue;
            }

            int totalKcal = 0;
            for (DailyExerciseLog dailyExerciseLog : dailyExerciseLogs) {
                totalKcal += dailyExerciseLog.getKcal();
            }
            chart.put(date, totalKcal);
        }

        logger.info("statistics : {}",statistics);
        return ExerciseResDTO.builder()
                .statisticsId(statistics.getStatisticsId())
                .userId(statistics.getUser().getUserId())
                .dailyExTime(statistics.getDailyExTime())
                .dailyKcal(statistics.getDailyKcal())
                .dailyCount(statistics.getDailyCount())
                .dailyFriend(statistics.getDailyFriend())
                .dailyPoint(statistics.getDailyPoint())
                .chart(chart)
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

    @Transactional
    @Override
    public void endExercise(ExerciseLogResDTO exerciseLogResDTO) {
        logger.info("ExerciseServiceImpl.endExercise()");
        User user = userRepository.findByUserUid(exerciseLogResDTO.getUid()).orElseThrow();

        logger.info("exerciseLog");
        ExerciseLog exerciseLog = ExerciseLog.builder()
                .user(user)
                .exerciseStartTime(exerciseLogResDTO.getStartTime())
                .exerciseEndTime(exerciseLogResDTO.getEndTime())
                .exerciseTime(calcExerciseTime(exerciseLogResDTO.getStartTime(), exerciseLogResDTO.getEndTime()))
                .exerciseKcal(exerciseLogResDTO.getCalories())
                .averageHeart(exerciseLogResDTO.getHeartRate())
                .exercisePetExp(5)
                .exerciseUserExp(exerciseLogResDTO.getCalories()/30)
                .maxHeart((int) getMaxHeart(exerciseLogResDTO.getHeartRateHistory()))
                .exercisePoint(0)
                .build();

        logger.info("statistics");
        Statistics statistics = stasticsRepository.findByUser_UserId(user.getUserId()).orElseThrow();
        statistics.sum(calcExerciseTime(exerciseLogResDTO.getStartTime(), exerciseLogResDTO.getEndTime()),
                exerciseLogResDTO.getCalories(), 1);

        logger.info("리워드 제공");
        int exp = exerciseLogResDTO.getCalories()/30;
        if (user.getRequiredExp() <= exp) {
            int nextRequiredExp = levelRepository.findById((long) user.getUserLevel()).orElseThrow().getRequiredExp();
            user.levelUp(nextRequiredExp);
        }
        UserAsset userAsset = userAssetRepository.findByUserIdAndAssetId(user.getUserId(), user.getMainPet().getAssetId()).orElseThrow();
        userAsset.sumExp(5);

        userAssetRepository.save(userAsset);
        exerciseLogRepository.save(exerciseLog);
        stasticsRepository.save(statistics);
        userRepository.save(user);

        logger.info("firebase 저장");
        Firestore db = FirestoreClient.getFirestore();
        db.collection("uid").document(user.getUserUid())
                .collection("log").document(String.valueOf(exerciseLog.getExerciseId())).create(exerciseLogResDTO);
//        ApiFuture<QuerySnapshot> query = db.collection("test").get();
//        QuerySnapshot querySnapshot = query.get();
//        List<QueryDocumentSnapshot> documents = querySnapshot.getDocuments();
//        for (QueryDocumentSnapshot document : documents) {
//            System.out.println("User: " + document.getLong("userid"));
//        }
    }

    @Override
    @Transactional
    public String sendExerciseEndAlarm(ExerciseLogResDTO exerciseLogResDTO) {
        User user = userRepository.findByUserUid(exerciseLogResDTO.getUid()).orElseThrow();
        String nickname = user.getNickname();
        String fcmToken = user.getFCM();
        try{
            Message message = Message.builder()
                    .putData("type", "exercise")
                    .setNotification(Notification.builder()
                            .setTitle("운동이 기록되었습니다!")
                            .setBody("운동 페이지의 캘린더에서 확인 가능합니다.")
                            .build())
                    .setToken(fcmToken)
                    .build();

            // Send a message to the device corresponding to the provided
            // registration token.
            String response = FirebaseMessaging.getInstance().send(message);
            // Response is a message ID string.
            logger.info("Successfully sent message: {}", response);
            return response;

        } catch (FirebaseMessagingException e){
            logger.error("Firebase Error, {}", e.toString());
            throw new RuntimeException(e);
        }

    }

    private LocalTime calcExerciseTime(LocalDateTime start, LocalDateTime end) {
        Duration duration = Duration.between(start, end); // 두 일시 간의 지속 시간 계산
        long hoursDiff = duration.toHours(); // 시간 단위의 차이 계산
        long minutesDiff = duration.toMinutesPart(); // 분 단위의 차이 계산
        long secondsDiff = duration.toSecondsPart(); // 초 단위의 차이 계산
        return LocalTime.of((int) hoursDiff, (int) minutesDiff, (int) secondsDiff);
    }

    private double getMaxHeart(List<Double> heartRateHistory){
        if (heartRateHistory.isEmpty()) {
            throw new IllegalArgumentException("heartRateHistory is empty");
        }

        return heartRateHistory.stream()
                .mapToDouble(Double::doubleValue)
                .max()
                .orElseThrow(); // 최대값이 없을 경우 예외를 던집니다.
    }
}
