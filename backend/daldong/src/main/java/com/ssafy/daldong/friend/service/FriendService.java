package com.ssafy.daldong.friend.service;

import com.ssafy.daldong.friend.model.dto.FriendDto;
import com.ssafy.daldong.friend.model.dto.response.FriendSearchDTO;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface FriendService {

    void createFriend(long userId, long friendId);
    List<FriendDto> getFriendList(long userId);
    boolean isFriend(long userId, long friendId);
    void updateFriend(long userId, long friendId);
    boolean deleteFriend(long userId, long friendId) throws Exception;

    FriendSearchDTO searchFriend(long userId,String nickname);
}
