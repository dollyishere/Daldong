package com.ssafy.daldong.auth.model.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@ToString
public class AuthResDto {
    private String uId;
    private boolean userExists;
}
