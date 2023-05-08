package com.ssafy.daldong.jwt;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.util.Date;

@Slf4j
@Component
public class JwtTokenUtil {

    @Value("${jwt.secret}")
    private String SECRET_KEY;
    private static final long ACCESS_TOKEN_EXPIRE_MINUTES = 1000L * 60 * 60*3; // 시간 단위
    private static final long REFRESH_TOKEN_EXPIRE_MINUTES = 1000L * 60 * 60 * 24 * 7; // 주단위
    /**
     * 토큰 추출 메서드
     * 서명했을때 secretkey 로 서명하고 토큰을 만들때 username,발급날짜,만료기간을 넣었단 payload를 가져온다.
     * @param token
     * @return
     */
    public Claims extratAllClaims(String token){
        return Jwts.parserBuilder()
                .setSigningKey(getSigningKey(SECRET_KEY))
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    public String getUsername(String token){
        return extratAllClaims(token).get("username", String.class);
    }

    private Key getSigningKey(String secretKey){
        byte[] keyBytes = secretKey.getBytes(StandardCharsets.UTF_8);
        return Keys.hmacShaKeyFor(keyBytes);
    }

    public Boolean isTokenExpired(String token){
        Date expiration = extratAllClaims(token).getExpiration();
        return expiration.before(new Date());
    }

    public String generateAccessToken(long userId){
        return doGenerateToken("access token",ACCESS_TOKEN_EXPIRE_MINUTES,userId);
    }

    public String generateRefreshToken(long userId){
        return doGenerateToken("refresh token",REFRESH_TOKEN_EXPIRE_MINUTES,userId);
    }


    /**
     * 토큰 생성 매서드
     * JWT 구성 ( header.payload.signature )
     * username,발급날짜,만료기간을 payload 에 넣고 application.yml 에 설정한 secretkey 로 서명 후 HS256알고리즘으로 암호화한다.
     * @param token
     * @param expireTime
     * @return
     */

    private String doGenerateToken(String token,long expireTime,long userId) {
        Claims claims = Jwts.claims();
        claims.put("token", token);
        claims.put("userId",userId);
        return Jwts.builder()
                .setClaims(claims)
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + expireTime))
                .signWith(getSigningKey(SECRET_KEY), SignatureAlgorithm.HS256)
                .compact();
    }
    public boolean validateToken(String token) {
        try {
            Jwts.parserBuilder().setSigningKey(SECRET_KEY).build().parseClaimsJws(token);
            return true;
        } catch (io.jsonwebtoken.security.SecurityException | MalformedJwtException e) {
            log.info("잘못된 JWT 서명입니다.");
        } catch (ExpiredJwtException e) {
            log.info("만료된 JWT 토큰입니다.");
        } catch (UnsupportedJwtException e) {
            log.info("지원되지 않는 JWT 토큰입니다.");
        } catch (IllegalArgumentException e) {
            log.info("JWT 토큰이 잘못되었습니다.");
        }
        return false;
    }

    public long getRemainMilliSeconds(String token){
        Date expiration = extratAllClaims(token).getExpiration();
        Date now = new Date();
        return expiration.getTime() - now.getTime();
    }


    public long getTokenExpirationTime(String refreshToken) {
        return 1000L * 60 * 60 * 24 * 7;
    }

    public  Long getUserId(String token) {
        Claims jws = Jwts.parser()
                .setSigningKey(SECRET_KEY.getBytes())
                .parseClaimsJws(token).getBody();

        String userId = jws.get("userId").toString();
        return Long.parseLong(userId);
    }
}

