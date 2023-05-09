package com.ssafy.daldong.mission.model.repository;

import com.ssafy.daldong.mission.model.entity.DailyMission;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DailyMissionRepository extends JpaRepository<DailyMission, Long> {
}
