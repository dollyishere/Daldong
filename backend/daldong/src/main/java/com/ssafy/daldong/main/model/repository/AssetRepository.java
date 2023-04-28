package com.ssafy.daldong.main.model.repository;

import com.ssafy.daldong.main.model.entity.Asset;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AssetRepository extends JpaRepository<Asset, Long> {
}
