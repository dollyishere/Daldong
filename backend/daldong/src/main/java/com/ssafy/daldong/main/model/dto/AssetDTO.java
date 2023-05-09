package com.ssafy.daldong.main.model.dto;

import com.ssafy.daldong.main.model.entity.Asset;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AssetDTO {

    private long assetId;

    private boolean assetType;

    private String assetName;

    private int assetUnlockLevel;

    private int assetPrice;

    public static AssetDTO fromEntity(Asset asset){
        return AssetDTO.builder()
                .assetId(asset.getAssetId())
                .assetType(asset.isAssetType())
                .assetName(asset.getAssetName())
                .assetUnlockLevel(asset.getAssetUnlockLevel())
                .assetPrice(builder().assetPrice)
                .build();
    }



}
