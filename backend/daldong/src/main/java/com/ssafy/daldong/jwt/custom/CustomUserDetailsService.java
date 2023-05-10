package com.ssafy.daldong.jwt.custom;

import com.ssafy.daldong.user.model.entity.User;
import com.ssafy.daldong.user.model.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;


@Service
@RequiredArgsConstructor
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;

    /**
     * Cacheable의 동작 방식은 캐시에서 메서드의 파라미터로 캐시를 먼저 조회
     *
     * Redis에 데이터가 있을 경우는 Redis에 저장된 데이터를 그대로 반환해주고, 없을 경우는 DB에 직접 조회
     *
     * Cacheable을 통해 저장된 데이터는 어노테이션에 설정된 value::key 의 형태로 Redis의 Key로 저장
     *
     * @param userUId the username identifying the user whose data is required.
     * @return
     * @throws UsernameNotFoundException
     */
    @Override
    public UserDetails loadUserByUsername(String userUId) throws UsernameNotFoundException {
        User user = userRepository.findByUserUid(userUId);
        return CustomUserDetails.of(user);
    }
}
