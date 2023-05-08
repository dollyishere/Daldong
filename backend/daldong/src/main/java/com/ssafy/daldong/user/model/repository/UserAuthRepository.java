package com.ssafy.daldong.user.model.repository;

import com.ssafy.daldong.user.model.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserAuthRepository  extends JpaRepository<User, Long> {

    User findByUserUid(String uid);
    boolean existsByUserUid(String uid);

}
