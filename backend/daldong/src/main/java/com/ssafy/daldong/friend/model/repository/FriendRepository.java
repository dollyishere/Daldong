package com.ssafy.daldong.friend.model.repository;

import com.ssafy.daldong.friend.model.entity.Friend;
import com.ssafy.daldong.user.model.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.lang.reflect.Field;
import java.util.List;
import java.util.Optional;

@Repository
public interface FriendRepository extends JpaRepository<Friend, User> {

    List<Friend> findAllByUser_UserId(long userId);
    Optional<Friend> findByUser_UserIdAndFriend_UserId(long userId, long friendId);
    boolean existsByUser_UserIdAndFriend_UserId(long userId, long friendId);



}
