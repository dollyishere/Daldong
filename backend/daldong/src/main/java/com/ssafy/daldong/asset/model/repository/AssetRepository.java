package com.ssafy.daldong.asset.model.repository;

import com.ssafy.daldong.asset.model.entity.Asset;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AssetRepository extends JpaRepository<Asset, Long> {
}
