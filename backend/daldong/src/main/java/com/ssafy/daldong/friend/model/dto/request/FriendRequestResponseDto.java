package com.ssafy.daldong.friend.model.dto.request;

import io.swagger.annotations.ApiModelProperty;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString
public class FriendRequestResponseDto {

    @Schema(description = "친구 요청 보낸 사람", example = "1", required = true)
    private long senderId;
    @Schema(description = "친구 요청 받는 사람", example = "3", required = true)
    private long receiverId;
    @Schema(description = "수락 여부", example = "true", required = true)
    private boolean accept;
}
