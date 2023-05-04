package com.ssafy.daldong.friend.model.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString
public class FriendRequestDto {
        @Schema(description = "친구 요청 보낸 사람", example = "1", required = true)
        private long senderId;
        @Schema(description = "친구 요청 받는 사람", example = "4", required = true)
        private long receiverId;
}
