package com.ssafy.daldong.friend.model.entity;

import java.io.Serializable;
import java.util.Objects;

public class FriendId implements Serializable {

    private long user;
    private long friend;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        FriendId that = (FriendId) o;
        return user == that.user &&
                friend == that.friend;
    }

    @Override
    public int hashCode() {
        return Objects.hash(user, friend);
    }
}
