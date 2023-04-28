package com.ssafy.daldong.friend.model.entity;

import java.io.Serializable;
import java.util.Objects;

public class FriendId implements Serializable {

    private long userId;
    private long friendId;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        FriendId that = (FriendId) o;
        return userId == that.userId &&
                friendId == that.friendId;
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId, friendId);
    }
}
