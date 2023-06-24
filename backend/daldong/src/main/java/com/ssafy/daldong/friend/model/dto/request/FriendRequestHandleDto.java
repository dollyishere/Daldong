package com.ssafy.daldong.friend.model.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString
public class FriendRequestHandleDto {
        @Schema(description = "친구 요청 받는 사람", example = "3", required = true)
        private long receiverId;
        @Schema(description = "수락 여부", example = "true", required = true)
        private boolean accept;
}
