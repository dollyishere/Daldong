package com.ssafy.daldong.main.model.dto;

import com.ssafy.daldong.user.model.entity.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MainpageDTO {
    private String nickname;
    private int userLevel;
    private int userExp;
    private int requiredExp;
    private int userPoint;
    private String mainBackName;
    private String mainPetName;
    private String mainPetCustomName;

    public MainpageDTO fromEntity(User user) {
        return MainpageDTO.builder()
                .nickname(user.getNickname())
                .userLevel(user.getUserLevel())
                .userExp(user.getUserExp())
                .requiredExp(user.getRequiredExp())
                .userPoint(user.getUserPoint())
                .mainBackName(AssetDTO.fromEntity(user.getMainBack()).getAssetName())
                .mainPetName(AssetDTO.fromEntity(user.getMainPet()).getAssetName())
                .mainPetCustomName(user.getMainPetName())
                .build();
    }
}