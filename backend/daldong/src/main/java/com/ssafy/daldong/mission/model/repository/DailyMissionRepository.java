package com.ssafy.daldong.mission.model.repository;

import com.ssafy.daldong.mission.model.entity.DailyMission;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface DailyMissionRepository extends JpaRepository<DailyMission, Long> {
    @Override
    Optional<DailyMission> findById(Long id);
}
