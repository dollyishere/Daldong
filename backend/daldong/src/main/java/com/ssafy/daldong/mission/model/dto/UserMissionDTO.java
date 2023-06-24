package com.ssafy.daldong.mission.model.dto;

import com.ssafy.daldong.mission.model.entity.DailyMission;
import com.ssafy.daldong.mission.model.entity.UserMission;
import com.ssafy.daldong.user.model.entity.User;
import lombok.*;

import java.time.LocalDate;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserMissionDTO {
    private long userMissionId;


    private long user;


    private long mission;


    private boolean isReceive;


    private boolean isDone;


    private LocalDate missionDate;

    public static UserMission toEntity(User user,DailyMission dailyMission){
        return UserMission.builder()
                .user(user)
                .mission(dailyMission)
                .isReceive(false)
                .isDone(false)
                .missionDate(LocalDate.now())
                .build();
    }

}
