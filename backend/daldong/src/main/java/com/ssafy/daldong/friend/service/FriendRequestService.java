package com.ssafy.daldong.friend.service;

import com.ssafy.daldong.friend.model.dto.FriendDto;
import com.ssafy.daldong.friend.model.dto.request.FriendRequestHandleDto;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface FriendRequestService {
    boolean createFriendRequest(long senderId, long receiverId);
    List<FriendDto> getReceivedFriendRequestList(long userId);
    List<FriendDto> getSendFriendRequestList(long userId);
    void handleFriendRequest(long senderId, FriendRequestHandleDto friendRequestHandleDto);
}
