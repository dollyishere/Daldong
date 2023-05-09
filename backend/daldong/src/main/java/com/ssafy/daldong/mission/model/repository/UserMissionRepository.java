package com.ssafy.daldong.mission.model.repository;

import com.ssafy.daldong.mission.model.entity.UserMission;
import com.ssafy.daldong.user.model.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface UserMissionRepository extends JpaRepository<UserMission, User> {
    List<UserMission> findUserMissionsByUser_UserId(long userId);
    UserMission findUserMissionByUser_UserIdAndMission_MissionId(long userId, long missionId);
}
