package com.ssafy.daldong.friend.model.dto;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.PropertyNamingStrategy;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import com.ssafy.daldong.main.model.entity.Asset;
import lombok.*;

@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString
public class FriendDto {

    private long friendId;
    private String friendNickname;
    private int friendUserLevel;
    private String mainPetAssetName;
    private boolean isSting;

}
