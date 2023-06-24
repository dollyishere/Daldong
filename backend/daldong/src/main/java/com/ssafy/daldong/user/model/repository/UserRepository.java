package com.ssafy.daldong.user.model.repository;

import com.ssafy.daldong.user.model.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository

public interface UserRepository extends JpaRepository<User, Long> {
    Optional <User> findByUserId(Long userId);
    Optional <User> findByUserUid(String userUid);
    Optional <User> findByNickname(String nickname);

}
