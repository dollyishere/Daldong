package com.ssafy.daldong.main.model.repository;

import com.ssafy.daldong.main.model.dto.UserAssetDTO;
import com.ssafy.daldong.main.model.entity.UserAsset;
import com.ssafy.daldong.main.model.entity.UserAssetId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface UserAssetRepository extends JpaRepository<UserAsset, UserAssetId> {

    @Query("select us from UserAsset us where us.userAssetId.userId =:userId and us.userAssetId.assetId =:assetId")
    Optional<UserAsset> findByUserIdAndAssetId(long userId, long assetId);
}
