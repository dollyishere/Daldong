package com.ssafy.daldong.friend.model.dto.response;

import com.ssafy.daldong.main.model.dto.AssetDTO;
import com.ssafy.daldong.user.model.entity.User;
import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString
public class FriendSearchDTO {
    private long userId;
    private String nickname;
    private int userLevel;
    private String mainPetName;
    private int isFriend;
    public FriendSearchDTO fromEntity(User user){
        return FriendSearchDTO.builder()
                .userId(user.getUserId())
                .nickname(user.getNickname())
                .userLevel(user.getUserLevel())
                .mainPetName(user.getMainPet().getAssetName())
                .build();
    }

}
