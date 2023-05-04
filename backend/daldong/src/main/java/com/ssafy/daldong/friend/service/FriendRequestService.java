package com.ssafy.daldong.friend.service;

import com.ssafy.daldong.friend.model.dto.FriendDto;
import com.ssafy.daldong.friend.model.dto.request.FriendRequestDto;
import com.ssafy.daldong.friend.model.dto.request.FriendRequestResponseDto;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface FriendRequestService {
    boolean createFriendRequest(FriendRequestDto friendRequestDto);
    List<FriendDto> getReceivedFriendRequestList(long userId);
    List<FriendDto> getSendFriendRequestList(long userId);
    void handleFriendRequest(FriendRequestResponseDto responseDto);
}
