package com.ssafy.daldong.user.model.dto;

import com.ssafy.daldong.main.model.dto.AssetDTO;
import com.ssafy.daldong.user.model.entity.Statistics;
import com.ssafy.daldong.user.model.entity.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserStatisticsDTO {

    private User user;

    private LocalTime dailyExTime;

    private int dailyKcal;

    private int dailyCount;

    private int dailyFriend;

    private int dailyPoint;
    public Statistics fromEntity(User user){
        return Statistics.builder()
                .user(user)
                .dailyExTime(LocalTime.of(0,0,0))
                .dailyKcal(0)
                .dailyCount(0)
                .dailyFriend(0)
                .dailyPoint(0)
                .build();
    }

}

