package com.ssafy.daldong.mission.model.dto;

import com.ssafy.daldong.mission.model.entity.DailyMission;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.sql.Timestamp;

@Getter
@Setter
@Builder
public class DailyMissionDTO {
    private long missionId;
    private String missionName;
    private String missionContent;
    private String qualificationName;
    private int qualificationNum;
    private int rewardPoint;

    public static DailyMissionDTO of(DailyMission mission) {
        return DailyMissionDTO.builder()
                .missionId(mission.getMissionId())
                .missionName(mission.getMissionName())
                .missionContent(mission.getMissionContent())
                .qualificationName(mission.getQualificationName())
                .qualificationNum(mission.getQualificationNum())
                .rewardPoint(mission.getRewardPoint())
                .build();
    }
}
