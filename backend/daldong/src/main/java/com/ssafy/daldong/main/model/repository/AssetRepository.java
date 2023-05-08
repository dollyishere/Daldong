package com.ssafy.daldong.main.model.repository;

import com.ssafy.daldong.main.model.entity.Asset;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AssetRepository extends JpaRepository<Asset, Long> {
    String defaultPetName = "sparrow";
    String defaultBgName = "bg1";
    Asset findByAssetName(String name);
    default Asset findDefaultPet() {
        return findByAssetName(defaultPetName);
    }

    default Asset findDefaultBg(){
        return findByAssetName(defaultBgName);
    }
}
