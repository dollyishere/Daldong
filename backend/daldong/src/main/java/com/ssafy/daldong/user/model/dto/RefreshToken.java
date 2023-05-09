package com.ssafy.daldong.user.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import org.springframework.data.redis.core.RedisHash;
import org.springframework.data.redis.core.TimeToLive;

import javax.persistence.Id;

/**
 * @RedisHash(value)
 * > value로 Redis의 Set자료구조를 통해 해당 객체가 저장
 * @TimeToLive
 * > 설정한 시간 만큰 데이터를 저장, 시간이 자나면 자동으로 해당데이터가 사라지는 휘발 역할
 */
@Getter
@RedisHash("refreshToken")
@AllArgsConstructor
@Builder
public class RefreshToken {


    private String refreshToken;

    @TimeToLive
    private Long expiration;

    public static RefreshToken createRefreshToken( String refreshToken, Long remainingMilliSeconds){
        return RefreshToken.builder()
                .refreshToken(refreshToken)
                .expiration(remainingMilliSeconds / 1000)
                .build();
    }
}
