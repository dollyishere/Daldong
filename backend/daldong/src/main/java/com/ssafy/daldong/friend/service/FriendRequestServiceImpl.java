package com.ssafy.daldong.friend.service;

import com.ssafy.daldong.friend.model.dto.FriendDto;
import com.ssafy.daldong.friend.model.dto.request.FriendRequestHandleDto;
import com.ssafy.daldong.friend.model.entity.Friend;
import com.ssafy.daldong.friend.model.entity.FriendRequest;
import com.ssafy.daldong.friend.model.repository.FriendRepository;
import com.ssafy.daldong.friend.model.repository.FriendRequestRepository;
import com.ssafy.daldong.user.model.entity.User;
import com.ssafy.daldong.user.model.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
public class FriendRequestServiceImpl implements FriendRequestService {
    private final UserRepository userRepository;

    private final FriendRepository friendRepository;
    private final FriendRequestRepository friendRequestRepository;
    @Override
    @Transactional
    public boolean createFriendRequest(long senderId, long receiverId) {
        //TODO: 예외처리
        if (friendRepository.existsByUser_UserIdAndFriend_UserId(senderId, receiverId)) return false;
        if (friendRequestRepository.existsBySender_UserIdAndReceiver_UserId(senderId, receiverId)) return false;
        FriendRequest friendRequest = FriendRequest.builder()
                .sender(userRepository.getReferenceById(senderId))
                .receiver(userRepository.getReferenceById(receiverId))
                .build();
        friendRequestRepository.save(friendRequest);
        log.info("[requestFriend] : 친구 신청 성공, senderId : {}, receiverId : {}", senderId, receiverId);
        return true;
    }

    @Override
    @Transactional(readOnly = true)
    public List<FriendDto> getReceivedFriendRequestList(long userId) {
        List<FriendRequest> friendRequests = friendRequestRepository.findByReceiver_UserId(userId);
        List<FriendDto> receivedList = new ArrayList<>();
        for (FriendRequest request : friendRequests) {
            User friend = request.getSender();
            FriendDto friendDto = FriendDto.builder()
                    .friendId(friend.getUserId())
                    .friendNickname(friend.getNickname())
                    .friendUserLevel(friend.getUserLevel())
                    .mainPetAssetName(friend.getMainPet().getAssetName())
                    .isSting(false)
                    .build();
            receivedList.add(friendDto);

        }
        return receivedList;
    }

    @Override
    @Transactional(readOnly = true)
    public List<FriendDto> getSendFriendRequestList(long userId) {
        List<FriendRequest> friendRequests = friendRequestRepository.findBySender_UserId(userId);
        List<FriendDto> sendList = new ArrayList<>();
        for (FriendRequest request : friendRequests) {
            User friend = request.getReceiver();
            FriendDto friendDto = FriendDto.builder()
                    .friendId(friend.getUserId())
                    .friendNickname(friend.getNickname())
                    .friendUserLevel(friend.getUserLevel())
                    .mainPetAssetName(friend.getMainPet().getAssetName())
                    .isSting(false)
                    .build();
            sendList.add(friendDto);

        }
        return sendList;
    }


    @Override
    @Transactional
    public void handleFriendRequest(long receiverId, FriendRequestHandleDto friendRequestHandleDto) {
        System.out.println(friendRequestHandleDto.isAccept());
        long senderId = friendRequestHandleDto.getReceiverId();
        // 요청 삭제
        FriendRequest friendRequest = friendRequestRepository.findBySender_UserIdAndReceiver_UserId(senderId, receiverId).orElseThrow();
        friendRequestRepository.delete(friendRequest);
        // 수락/거절 처리
        if (friendRequestHandleDto.isAccept()){
            Friend senderFriend = Friend.builder()
                    .user(userRepository.getReferenceById(senderId))
                    .friend(userRepository.getReferenceById(receiverId))
                    .build();
            Friend receiverFriend = Friend.builder()
                    .user(userRepository.getReferenceById(receiverId))
                    .friend(userRepository.getReferenceById(senderId))
                    .build();
            friendRepository.save(senderFriend);
            friendRepository.save(receiverFriend);
        }
        log.info("[handleFriendRequest] : 친구 신청 처리 성공, senderId : {}, receiverId : {}", senderId, receiverId);

    }

}
