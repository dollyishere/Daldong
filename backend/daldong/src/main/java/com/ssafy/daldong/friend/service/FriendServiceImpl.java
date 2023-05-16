package com.ssafy.daldong.friend.service;

import com.ssafy.daldong.friend.model.dto.FriendDto;
import com.ssafy.daldong.friend.model.dto.response.FriendSearchDTO;
import com.ssafy.daldong.friend.model.entity.Friend;
import com.ssafy.daldong.friend.model.repository.FriendRepository;
import com.ssafy.daldong.friend.model.repository.FriendRequestRepository;
import com.ssafy.daldong.user.model.entity.User;
import com.ssafy.daldong.user.model.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class FriendServiceImpl implements FriendService{

    private final FriendRepository friendRepository;
    private final UserRepository userRepository;
    private final FriendRequestRepository friendRequestRepository;

    @Override
    public void createFriend(long userId, long friendId) {
        friendRepository.save(Friend.builder().user(userRepository.getReferenceById(userId)).friend(userRepository.getReferenceById(friendId)).build());
        friendRepository.save(Friend.builder().user(userRepository.getReferenceById(friendId)).friend(userRepository.getReferenceById(userId)).build());
    }

    @Override
    @Transactional(readOnly = true)
    public List<FriendDto> getFriendList(long userId) {
        List<Friend> friends = friendRepository.findAllByUser_UserId(userId);
        List<FriendDto> friendsDto = new ArrayList<>();
        for (Friend friend : friends) {
            User friendUser = friend.getFriend();
            FriendDto friendDto = FriendDto.builder()
                    .friendId(friendUser.getUserId())
                    .friendNickname(friendUser.getNickname())
                    .friendUserLevel(friendUser.getUserLevel())
                    .mainPetAssetName(friendUser.getMainPet().getAssetName())
                    .isSting(friend.isSting())
                    .build();
            friendsDto.add(friendDto);
        }
        log.info("[getFriendList] : 친구 목록 가져오기 완료, userId : {}", userId);
        return friendsDto;
    }

    @Override
    public boolean isFriend(long userId, long friendId) {
        return friendRepository.existsByUser_UserIdAndFriend_UserId(userId, friendId);
    }

//    @Override
//    public FriendDto getFriend(long userId, long friendId) {
//
//        return null;
//    }

    @Override
    @Transactional
    public void updateFriend(long userId, long friendId) {

        Optional<Friend> optionalFriendship = friendRepository.findByUser_UserIdAndFriend_UserId(userId, friendId);
        if (optionalFriendship.isEmpty()){
            return;
        }
        Friend friendship = optionalFriendship.get();
        if (friendship.isSting()){
            return;
        }
        friendship.updateFriend();
        log.info("[stingFriend] : 친구 찌르기 성공, userId : {}, friendId : {}", userId, friendId);

    }

    @Override
    @Transactional
    public boolean deleteFriend(long userId, long friendId) {
        if(userId == friendId){
            throw new IllegalStateException("same user");
        }
        Optional<Friend> optionalFriendship1 = friendRepository.findByUser_UserIdAndFriend_UserId(userId, friendId);
        Optional<Friend> optionalFriendship2 = friendRepository.findByUser_UserIdAndFriend_UserId(friendId, userId);
        log.info("getit {} {}", optionalFriendship1.toString(), optionalFriendship2.toString());
        if (optionalFriendship1.isEmpty() || optionalFriendship2.isEmpty()){
            return false;
        }
        Friend friendship1 = optionalFriendship1.get();
        Friend friendship2 = optionalFriendship2.get();
        friendRepository.delete(friendship1);
        friendRepository.delete(friendship2);
        return true;
    }

    @Override
    public FriendSearchDTO searchFriend(long userId,String nickname) {
        User user=userRepository.findByNickname(nickname).orElse(null);
        if(user==null||user.getUserId()==userId){//해당하는 유저가 없다
            return null;
        }
        long friendId=user.getUserId();
        FriendSearchDTO friendSearchDTO= new FriendSearchDTO().fromEntity(user);
        boolean isFriend = friendRepository.existsByUser_UserIdAndFriend_UserId(userId,friendId);
        boolean isRequest = friendRequestRepository.existsBySender_UserIdAndReceiver_UserId(userId,friendId );
        boolean isReceive =friendRequestRepository.existsBySender_UserIdAndReceiver_UserId(friendId,userId );
        if(isFriend){
            friendSearchDTO.setIsFriend(3);
        } else if (isReceive) {
            friendSearchDTO.setIsFriend(2);
        }else if (isRequest) {
            friendSearchDTO.setIsFriend(1);
        }
        else {
            friendSearchDTO.setIsFriend(0);
        }
        return friendSearchDTO;
    }

    @Scheduled(cron = "0 0 0 * * ?")
    public void initSting(){
        log.info("{} | 찌르기 초기화 시작", LocalDateTime.now());
        List<Friend> friends = friendRepository.findAll();
        friends.forEach(Friend::initSting);
        friendRepository.saveAll(friends);
        log.info("{} | 찌르기 초기화 종료", LocalDateTime.now());
    }
}
