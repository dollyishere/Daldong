package com.ssafy.daldong.mission.model.dto;

import com.ssafy.daldong.mission.model.entity.UserMission;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class MissionResDTO {
    private DailyMissionDTO mission;
    private int QualificationCnt;
    private boolean isReceive;
    private boolean isDone;

    public static MissionResDTO of (UserMission userMission){
        return MissionResDTO.builder()
                .mission(DailyMissionDTO.of(userMission.getMission()))
                .isReceive(userMission.isReceive())
                .isDone(userMission.isDone())
                .build();
    }
}
