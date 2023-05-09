package com.ssafy.daldong.friend.model.repository;

import com.ssafy.daldong.friend.model.entity.FriendRequest;
import com.ssafy.daldong.user.model.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FriendRequestRepository extends JpaRepository<FriendRequest, User> {

    List<FriendRequest> findBySender_UserId(long senderId);
    List<FriendRequest> findByReceiver_UserId(long receiverId);
    Optional<FriendRequest> findBySender_UserIdAndReceiver_UserId(long senderId, long receiverId);
    boolean existsBySender_UserIdAndReceiver_UserId(long senderId, long receiverId);

}
