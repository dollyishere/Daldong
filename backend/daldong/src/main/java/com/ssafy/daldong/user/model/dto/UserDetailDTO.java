package com.ssafy.daldong.user.model.dto;

import com.ssafy.daldong.main.model.dto.AssetDTO;
import com.ssafy.daldong.user.model.entity.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserDetailDTO {
    private String nickname;
    private float height;
    private float weight;
    private boolean gender;
    private int age;
    private int ability;
    private int userLevel;
    private int userExp;
    private int userPoint;
    private String mainPetName;

    public UserDetailDTO fromEntity(User user){
        return UserDetailDTO.builder()
                .nickname(user.getNickname())
                .height(user.getHeight())
                .weight(user.getWeight())
                .gender(user.getGender())
                .age(user.getAge())
                .ability(user.getAbility())
                .userLevel(user.getUserLevel())
                .userExp(user.getUserExp())
                .userPoint(user.getUserPoint())
                .mainPetName(user.getMainPetName())
                .build();
    }

}
