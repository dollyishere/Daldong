package com.ssafy.daldong.main.model.entity;

import com.ssafy.daldong.user.model.dto.UserJoinDTO;
import com.ssafy.daldong.user.model.entity.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.io.Serializable;
import java.util.Objects;

@Embeddable
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserAssetId implements Serializable {
    @Column(name = "user_id", nullable = false)
    private long userId;
    @Column(name = "asset_id", nullable = false)
    private long assetId;

    public static UserAssetId from(long userId,long assetId) {
        return UserAssetId.builder()
                .userId(userId)
                .assetId(assetId)
                .build();
    }
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
