package com.ssafy.daldong.main.model.dto;

import com.ssafy.daldong.main.model.entity.Asset;
import com.ssafy.daldong.main.model.entity.UserAsset;
import com.ssafy.daldong.main.model.entity.UserAssetId;
import com.ssafy.daldong.main.model.repository.UserAssetRepository;
import com.ssafy.daldong.user.model.entity.User;
import lombok.*;

import javax.persistence.Embeddable;
import java.io.Serializable;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Embeddable
@Setter
public class UserAssetDTO implements Serializable {
    private long userId;
    private long assetId;
    private int petExp;
    private String petName;
    private String assetName;
    private boolean isPet;


    public static UserAsset toEntity(long userId,long assetId,String petName,int exp){
        return UserAsset.builder()
                .userAssetId(new UserAssetId(userId,assetId))
                .petExp(exp)
                .petName(petName)
                .build();
    }
    public static UserAssetDTO fromEntity(UserAsset userAsset){
        return UserAssetDTO.builder()
                .userId(userAsset.getUserAssetId().getUserId())
                .assetId(userAsset.getUserAssetId().getAssetId())
                .petExp(userAsset.getPetExp())
                .petName(userAsset.getPetName())
                .build();
    }
    public List<UserAssetDTO> toDtoList(List<UserAsset> assets){
        List<UserAssetDTO> userAssetList = (List<UserAssetDTO>) assets.stream().map(m -> UserAssetDTO.fromEntity(m));

        return userAssetList;


    }
    public static UserAsset newUser(long userId,long assetId,boolean isPet,String petName){
        return UserAsset.builder()
                .userAssetId(new UserAssetId().from(userId,assetId))
                .petExp(0)
                .petName(petName)
                .assetType(isPet)
                .build();
    }

}
