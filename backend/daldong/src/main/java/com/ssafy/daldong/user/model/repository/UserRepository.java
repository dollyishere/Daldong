package com.ssafy.daldong.user.model.repository;

import com.ssafy.daldong.user.model.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, Long> {
    User findByUserId(Long userId);
    User findByUserUid(String uid);

}
