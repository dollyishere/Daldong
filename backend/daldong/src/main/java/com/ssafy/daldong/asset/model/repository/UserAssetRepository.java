package com.ssafy.daldong.asset.model.repository;

import com.ssafy.daldong.asset.model.entity.UserAsset;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserAssetRepository extends JpaRepository<UserAsset, Long> {
}
