package com.ssafy.daldong.friend.model.repository;

import com.ssafy.daldong.friend.model.entity.FriendRequest;
import com.ssafy.daldong.user.model.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FriendRquestRepository extends JpaRepository<FriendRequest, User> {
}
