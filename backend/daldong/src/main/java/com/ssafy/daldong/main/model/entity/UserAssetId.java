package com.ssafy.daldong.main.model.entity;

import java.io.Serializable;
import java.util.Objects;

public class UserAssetId implements Serializable {

    private long user;
    private long asset;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        UserAssetId that = (UserAssetId) o;
        return user == that.user &&
                asset == that.asset;
    }

    @Override
    public int hashCode() {
        return Objects.hash(user, asset);
    }
}
