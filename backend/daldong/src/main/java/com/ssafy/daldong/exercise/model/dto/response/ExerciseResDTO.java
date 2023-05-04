package com.ssafy.daldong.exercise.model.dto.response;

import com.ssafy.daldong.user.model.entity.User;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class ExerciseResDTO {
    private long statisticsId;

    private long userId;

    private int dailyExTime;

    private int dailyKcal;

    private int dailyCount;

    private int dailyFriend;
}
