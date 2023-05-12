package com.ssafy.daldong.mission.model.service;

import com.ssafy.daldong.mission.model.dto.MissionResDTO;
import com.ssafy.daldong.mission.model.entity.DailyMission;
import com.ssafy.daldong.mission.model.entity.UserMission;
import com.ssafy.daldong.mission.model.repository.DailyMissionRepository;
import com.ssafy.daldong.mission.model.repository.UserMissionRepository;
import com.ssafy.daldong.user.model.entity.User;
import com.ssafy.daldong.user.model.repository.StatisticsRepository;
import com.ssafy.daldong.user.model.repository.UserRepository;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class MissionServiceImpl implements MissionService{
    private static final Logger logger = LogManager.getLogger(MissionServiceImpl.class);
    private final UserMissionRepository userMissionRepository;
    private final StatisticsRepository statisticsRepository;
    private final UserRepository userRepository;
    private final DailyMissionRepository dailyMissionRepository;

    @Autowired
    public MissionServiceImpl(UserMissionRepository userMissionRepository, StatisticsRepository statisticsRepository,
                              UserRepository userRepository,
                              DailyMissionRepository dailyMissionRepository) {
        this.userMissionRepository = userMissionRepository;
        this.statisticsRepository = statisticsRepository;
        this.userRepository = userRepository;
        this.dailyMissionRepository = dailyMissionRepository;
    }

    @Override
    public List<MissionResDTO> getUserMissions(Long userId) {
        logger.info("MissionServiceImpl.getUserMission({}, {})",userId, LocalDate.now());
        List<UserMission> userMissionList = userMissionRepository.findUserMissionsByUser_UserIdAndMissionDate(userId, LocalDate.now());
        logger.info("userMissionList : {}",userMissionList);

        List<MissionResDTO> missionResDTOS = userMissionList.stream()
                .map(MissionResDTO::of)
                .collect(Collectors.toList());

        for (MissionResDTO missionResDTO : missionResDTOS) {
            switch (missionResDTO.getMission().getQualificationName()) {
                case "KCAL":
                    missionResDTO.setQualificationCnt(statisticsRepository.findByUser_UserId(userId).getDailyKcal());
                    break;
                case "EX_TIME":
                    missionResDTO.setQualificationCnt(statisticsRepository.findByUser_UserId(userId).getDailyExTime());
                    break;
                case "COUNT":
                    missionResDTO.setQualificationCnt(statisticsRepository.findByUser_UserId(userId).getDailyCount());
                    break;
                case "FRIEND":
                    missionResDTO.setQualificationCnt(statisticsRepository.findByUser_UserId(userId).getDailyFriend());
                    break;
            }
        }

        return missionResDTOS;
    }

    @Transactional
    @Override
    public boolean getReward(Long userId, Long missionId) throws Exception {
        logger.info("MissionServiceImpl.getUserMissions({},{})", userId, missionId);
        //미션조회
        UserMission userMission = userMissionRepository.findUserMissionByUserMissionIdAndUser_UserId(missionId, userId);

        //수령조회
        if (userMission.isReceive())
            throw new Exception();

        // 달성조건 확인
        if (!userMission.isDone())
            throw new Exception();

        // 재화 수령
        userMission.receive();
        User user = userRepository.findById(userId).orElseThrow();
        user.payPoint(userMission.getMission().getRewardPoint());
        userMissionRepository.save(userMission);
        userRepository.save(user);
        return true;
    }

    @Scheduled(cron = "0 0 0 * * ?")
    public void initMission(){
        logger.info("{}| 미션 초기화 시작", LocalDateTime.now());
        List<User> users = userRepository.findAll();
        List<DailyMission> dailyMissions = dailyMissionRepository.findAll();

        List<UserMission> userMissionList = new ArrayList<>();
        for (User user : users) {
            for (DailyMission mission : dailyMissions) {
                UserMission userMission = UserMission.builder()
                        .user(user)
                        .mission(mission)
                        .isReceive(false)
                        .isDone(false)
                        .missionDate(LocalDate.now())
                        .build();
                userMissionList.add(userMission);
            }
        }

        userMissionRepository.saveAll(userMissionList);
        logger.info("{}| 미션 초기화 종료", LocalDateTime.now());
    }
}

