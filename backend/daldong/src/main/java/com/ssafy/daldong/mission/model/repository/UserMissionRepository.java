package com.ssafy.daldong.mission.model.repository;

import com.ssafy.daldong.mission.model.entity.UserMission;
import com.ssafy.daldong.user.model.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserMissionRepository extends JpaRepository<UserMission, User> {
}
