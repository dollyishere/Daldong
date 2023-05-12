package com.ssafy.daldong.jwt;
import com.ssafy.daldong.jwt.custom.CustomUserDetailsService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;

@Slf4j
@RequiredArgsConstructor
@Component
    public class JwtFilter extends OncePerRequestFilter {

        private final JwtTokenUtil jwtTokenUtil;
        private final CustomUserDetailsService customUserDetailsService;
        // 실제 필터링 로직은 doFilterInternal 에 들어감
        // JWT 토큰의 인증 정보를 현재 쓰레드의 SecurityContext 에 저장하는 역할 수행
        @Override
        protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws IOException, ServletException {

            // 1. Request Header 에서 토큰을 꺼냄
            String accessToken =  request.getHeader("accesstoken");

            // 2. validateToken 으로 토큰 유효성 검사
            // 정상 토큰이면 해당 토큰으로 Authentication 을 가져와서 SecurityContext 에 저장
            if (StringUtils.hasText(accessToken)) {
                if( jwtTokenUtil.validateToken(accessToken)) {
                    UserDetails userDetails = customUserDetailsService.loadUserByUsername(jwtTokenUtil.getUsername(accessToken));
                    equalsUsernameFromTokenAndUserDetails(userDetails.getUsername(), jwtTokenUtil.getUsername(accessToken));
                    processSecurity(request, userDetails);
                    filterChain.doFilter(request, response);
                }
                else{
                    log.info("유효하지 않은 토큰입니다.");
                    filterChain.doFilter(request, response);
                }
            }
            else{
                log.info("토큰 없음");
                filterChain.doFilter(request, response);
            }


        }
    private void equalsUsernameFromTokenAndUserDetails(String userDetailsUsername, String tokenUsername){
        if(!userDetailsUsername.equals(tokenUsername)){
            throw new IllegalArgumentException("username이 토큰과 맞지 않습니다");
        }
    }
    private void processSecurity(HttpServletRequest request, UserDetails userDetails){
        UsernamePasswordAuthenticationToken usernamePasswordAuthenticationToken =
                new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
        usernamePasswordAuthenticationToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
        SecurityContextHolder.getContext().setAuthentication(usernamePasswordAuthenticationToken);
    }



}


