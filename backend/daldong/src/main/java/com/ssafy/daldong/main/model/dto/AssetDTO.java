package com.ssafy.daldong.main.model.dto;

import com.ssafy.daldong.main.model.entity.Asset;
import lombok.*;
import org.springframework.data.domain.Page;

import javax.persistence.Column;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import java.util.List;
import java.util.stream.Collectors;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Setter
public class AssetDTO {

    private long assetId;

    private boolean isPet;

    private String assetName;
    private String assetKRName;
    private String assetCustomName;
    private int assetStatus;

    private int assetUnlockLevel;

    private int assetPrice;

    private int exp;


    public List<AssetDTO> toDtoList(List<Asset> assets){
        List<AssetDTO> assetList =assets.stream().map(m -> AssetDTO.fromEntity(m)).collect(Collectors.toList());
        return assetList;


    }

    public static AssetDTO fromEntity(Asset asset){
        return AssetDTO.builder()
                .assetId(asset.getAssetId())
                .isPet(asset.isPet())
                .assetName(asset.getAssetName())
                .assetCustomName(asset.getAssetKRName())
                .assetKRName(asset.getAssetKRName())
                .assetUnlockLevel(asset.getAssetUnlockLevel())
                .assetPrice(asset.getAssetPrice())
                .exp(0)
                .build();
    }



}
