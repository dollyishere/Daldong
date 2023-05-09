package com.ssafy.daldong.main.model.repository;

import com.ssafy.daldong.main.model.entity.Asset;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface AssetRepository extends JpaRepository<Asset, Long> {
    Asset findByAssetId(Long aLong);
}
