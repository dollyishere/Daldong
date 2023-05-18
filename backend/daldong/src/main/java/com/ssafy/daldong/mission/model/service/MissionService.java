package com.ssafy.daldong.mission.model.service;

import com.ssafy.daldong.mission.model.dto.MissionResDTO;

import java.util.List;

public interface MissionService {
    public List<MissionResDTO> getUserMissions(Long userId);

    public boolean getReward(Long userId, Long missionId) throws Exception;

    public void setMission(long userId);
}
