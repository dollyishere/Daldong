package com.ssafy.daldong.main.model.repository;

import com.ssafy.daldong.main.model.entity.UserAsset;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserAssetRepository extends JpaRepository<UserAsset, Long> {
}
