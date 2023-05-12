package com.ssafy.daldong.friend.model.entity;

import java.io.Serializable;
import java.util.Objects;

public class FriendRequestId implements Serializable {

    private long sender;
    private long receiver;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        FriendRequestId that = (FriendRequestId) o;
        return sender == that.sender &&
                receiver == that.receiver;
    }

    @Override
    public int hashCode() {
        return Objects.hash(sender, receiver);
    }
}
