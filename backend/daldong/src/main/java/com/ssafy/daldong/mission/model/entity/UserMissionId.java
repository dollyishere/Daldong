package com.ssafy.daldong.mission.model.entity;

import java.io.Serializable;
import java.util.Objects;

public class UserMissionId implements Serializable {

    private long userId;
    private long missionId;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        UserMissionId that = (UserMissionId) o;
        return userId == that.userId &&
                missionId == that.missionId;
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId, missionId);
    }

}
