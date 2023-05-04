package com.ssafy.daldong.friend.model.repository;

import com.ssafy.daldong.friend.model.entity.Friend;
import com.ssafy.daldong.user.model.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FriendRepository extends JpaRepository<Friend, User> {
}
