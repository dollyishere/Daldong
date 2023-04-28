package com.ssafy.daldong.friend.model.entity;

import java.io.Serializable;
import java.util.Objects;

public class FriendRequestId implements Serializable {

    private long senderId;
    private long receiverId;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        FriendRequestId that = (FriendRequestId) o;
        return senderId == that.senderId &&
                receiverId == that.receiverId;
    }

    @Override
    public int hashCode() {
        return Objects.hash(senderId, receiverId);
    }
}
