package com.ssafy.daldong.asset.model.entity;

import java.io.Serializable;
import java.util.Objects;

public class UserAssetId implements Serializable {

    private long userId;
    private long assetId;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        UserAssetId that = (UserAssetId) o;
        return userId == that.userId &&
                assetId == that.assetId;
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId, assetId);
    }
}
