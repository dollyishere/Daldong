package com.ssafy.daldong.user.model.dto;

import com.ssafy.daldong.main.model.dto.AssetDTO;
import com.ssafy.daldong.main.model.dto.UserAssetDTO;
import com.ssafy.daldong.user.model.entity.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserLoginDTO {
    private Long userId;
    private String userUId;
    private String nickname;
    private float height;
    private float weight;
    private boolean gender;
    private int age;
    private int ability;
    private int userLevel;
    private int userExp;
    private int requiredExp;
    private int userPoint;
    private String mainBackName;
    private String mainPetName;
    private String mainPetCustomName;

    public UserLoginDTO fromEntity(User user){
        return UserLoginDTO.builder()
                .userId(user.getUserId())
                .userUId(user.getUserUid())
                .nickname(user.getNickname())
                .height(user.getHeight())
                .weight(user.getWeight())
                .gender(user.getGender())
                .age(user.getAge())
                .ability(user.getAbility())
                .userLevel(user.getUserLevel())
                .userExp(user.getUserExp())
                .requiredExp(user.getRequiredExp())
                .userPoint(user.getUserPoint())
                .mainBackName(AssetDTO.fromEntity(user.getMainBack()).getAssetName())
                .mainPetName(AssetDTO.fromEntity(user.getMainPet()).getAssetName())
                .mainPetName(user.getMainPetName())
                .build();
    }



}
