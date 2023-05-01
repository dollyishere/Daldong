package com.ssafy.daldong.mission.model.entity;

import java.io.Serializable;
import java.util.Objects;

public class UserMissionId implements Serializable {

    private long user;
    private long mission;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        UserMissionId that = (UserMissionId) o;
        return user == that.user &&
                mission == that.mission;
    }

    @Override
    public int hashCode() {
        return Objects.hash(user, mission);
    }

}
