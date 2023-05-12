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
public class UserJoinDTO {
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
    private Long mainBackId;
    private Long mainPetId;
    private String mainPetName;


    public User toEntity(User user){
        return User.builder()
                .userUid(user.getUserUid())
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
                .mainBack(user.getMainBack())
                .mainPet(user.getMainPet())
                .mainPetName(user.getMainPetName())
                .build();
    }
}
