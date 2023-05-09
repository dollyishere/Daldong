package com.ssafy.daldong.main.model.dto;

import com.ssafy.daldong.main.model.entity.Asset;
import com.ssafy.daldong.main.model.entity.UserAsset;
import com.ssafy.daldong.main.model.repository.UserAssetRepository;
import com.ssafy.daldong.user.model.entity.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.Embeddable;
import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Embeddable
public class UserAssetDTO implements Serializable {
    private long userId;
    private long assetId;
    private int petExp;
    private String petName;


    public static UserAsset toEntity(UserAsset userAsset){
        return UserAsset.builder()
                .userAssetId(userAsset.getUserAssetId())
                .petExp(userAsset.getPetExp())
                .petName(userAsset.getPetName())
                .build();
    }



}
