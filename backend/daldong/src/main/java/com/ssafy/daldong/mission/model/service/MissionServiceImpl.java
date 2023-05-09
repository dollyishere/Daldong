package com.ssafy.daldong.mission.model.service;

import com.ssafy.daldong.mission.model.dto.MissionResDTO;
import com.ssafy.daldong.mission.model.entity.UserMission;
import com.ssafy.daldong.mission.model.repository.UserMissionRepository;
import com.ssafy.daldong.user.model.entity.User;
import com.ssafy.daldong.user.model.repository.StatisticsRepository;
import com.ssafy.daldong.user.model.repository.UserRepository;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class MissionServiceImpl implements MissionService{
    private static final Logger logger = LogManager.getLogger(MissionServiceImpl.class);
    private final UserMissionRepository userMissionRepository;
    private final StatisticsRepository statisticsRepository;
    private final UserRepository userRepository;

    @Autowired
    public MissionServiceImpl(UserMissionRepository userMissionRepository, StatisticsRepository statisticsRepository,
                              UserRepository userRepository) {
        this.userMissionRepository = userMissionRepository;
        this.statisticsRepository = statisticsRepository;
        this.userRepository = userRepository;
    }

    @Override
    public List<MissionResDTO> getUserMissions(Long userId) {
        logger.info("MissionServiceImpl.getUserMission({})",userId);
        List<UserMission> userMissionList = userMissionRepository.findUserMissionsByUser_UserId(userId);
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
        UserMission userMission = userMissionRepository.findUserMissionByUser_UserIdAndMission_MissionId(userId, missionId);

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
}

