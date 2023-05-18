package com.ssafy.daldong.friend.controller;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import com.ssafy.daldong.friend.model.dto.FriendDto;
import com.ssafy.daldong.friend.model.dto.request.FriendRequestHandleDto;
import com.ssafy.daldong.friend.model.dto.response.FriendSearchDTO;
import com.ssafy.daldong.friend.service.FriendRequestService;
import com.ssafy.daldong.friend.service.FriendService;
import com.ssafy.daldong.global.response.ResponseDefault;
import com.ssafy.daldong.jwt.JwtTokenUtil;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.NoSuchElementException;

@RestController
@RequestMapping("/friend")
@RequiredArgsConstructor
public class FriendController {
    private final FriendService friendService;
    private final FriendRequestService friendRequestService;
    private final JwtTokenUtil jwtTokenUtil;

    @PostMapping("/test")
    public ResponseEntity<?> testApi(){
        String fcmToken = "ckRGSeaSRhiL_2kLRWEAOH:APA91bFAFeQqwtLwTqsXwpt0Um0i22QP4v5wmhnxQWOIJXjayJSMzg0BlZFyLwPaEfmrSG4HKfIscnjYbL1kfRIXjxVsiNfODHQZcTsFf6Mwz2Sui7BZXChteHYdIntIHSpILH5nIBSb";
        Message message = Message.builder()
                .putData("type", "test")
                .setNotification(Notification.builder()
                        .setTitle("Test alarm")
                        .setBody("WOW")
                        .build())
                .setToken(fcmToken)
                .build();

        // Send a message to the device corresponding to the provided
        // registration token.
        try{
            String response = FirebaseMessaging.getInstance().send(message);
            System.out.println("Successfully sent message: " + response);


            ResponseDefault responseDefault = ResponseDefault.builder()
                    .success(true)
                    .messege("테스트 성공")
                    .data(response)
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.OK);

        } catch (FirebaseMessagingException e) {
            throw new RuntimeException(e);
        }
    }

    @Operation(summary = "user의 친구 목록 가져오기")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "OK"),
            @ApiResponse(responseCode = "404", description = "NOT FOUND"),
    })
    @GetMapping("/")
    public ResponseEntity<?> friendList(@RequestHeader(name = "accessToken") String accessToken) {
        long userId = jwtTokenUtil.getUserId(accessToken);
        try {
            ResponseDefault responseDefault = ResponseDefault.builder()
                    .success(true)
                    .messege("친구 목록 가져오기 성공")
                    .data(friendService.getFriendList(userId))
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.OK);
        } catch (NoSuchElementException e) {
            ResponseDefault responseDefault = ResponseDefault.builder()
                    .success(false)
                    .messege("해당 유저를 찾을 수 없습니다")
                    .data(null)
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.NOT_FOUND);
        }
    }


    @Operation(summary = "user가 friend 찌르기")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "OK"),
            @ApiResponse(responseCode = "404", description = "NOT FOUND"),
    })
    @PutMapping("/sting/{friendId}")
    public ResponseEntity<?> friendSting(@RequestHeader(name = "accessToken") String accessToken,
                                         @Parameter(description="friendId", example = "2") @PathVariable long friendId){
        long userId = jwtTokenUtil.getUserId(accessToken);

        try {
            friendService.updateFriend(userId, friendId);
            String response = friendService.sendAlarmToFriend(userId, friendId);
            ResponseDefault responseDefault = ResponseDefault.builder()
                    .success(true)
                    .messege("친구 찌르기 성공")
                    .data(response)
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.OK);
        } catch (Exception e) {
            ResponseDefault responseDefault = ResponseDefault.builder()
                    .success(false)
                    .messege("친구가 아닙니다")
                    .data(friendService.getFriendList(userId))
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.NOT_FOUND);
        }

    }

    @Operation(summary = "user가 friend 삭제하기")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "OK"),
            @ApiResponse(responseCode = "404", description = "NOT FOUND"),
    })
    @DeleteMapping("/{friendId}")
    public ResponseEntity<?> friendRemove(@RequestHeader(name = "accessToken") String accessToken,
                                          @Parameter(description="friendId", example = "2") @PathVariable long friendId){
        long userId = jwtTokenUtil.getUserId(accessToken);
        try {
            friendService.deleteFriend(userId, friendId);
            ResponseDefault responseDefault = ResponseDefault.builder()
                    .success(true)
                    .messege("친구 삭제 성공")
                    .data(null)
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.OK);
        } catch (IllegalStateException e) {
            ResponseDefault responseDefault = ResponseDefault.builder()
                    .success(false)
                    .messege("친구가 아닙니다")
                    .data(null)
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.NOT_FOUND);
        } catch (Exception e){
            ResponseDefault responseDefault = ResponseDefault.builder()
                    .success(false)
                    .messege("삭제에 실패했습니다")
                    .data(null)
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.NOT_FOUND);
        }

    }

    @Operation(summary = "sender가 receiver에게 친구요청 보내기")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "OK"),
            @ApiResponse(responseCode = "404", description = "NOT FOUND"),
    })
    @PostMapping("/request/{friendId}")
    public ResponseEntity<?> friendRequest(@RequestHeader(name = "accessToken") String accessToken,
                                           @Parameter(description="friendId", example = "2") @PathVariable long friendId) {
        long userId = jwtTokenUtil.getUserId(accessToken);
        try {
            friendRequestService.createFriendRequest(userId, friendId);
            String response = friendRequestService.sendRequestAlarm(userId, friendId);
            ResponseDefault responseDefault = ResponseDefault.builder()
                    .success(true)
                    .messege("친구 요청 성공")
                    .data(response)
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.CREATED);
        } catch (Exception e){
            ResponseDefault responseDefault = ResponseDefault.builder()
                    .success(false)
                    .messege("친구 요청 실패")
                    .data(null)
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.NOT_FOUND);
        }
    }

    @Operation(summary = "sender가 receiver에게 보낸 친구요청 처리")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "OK"),
            @ApiResponse(responseCode = "404", description = "NOT FOUND"),
    })
    @PostMapping("/request/result")
    public ResponseEntity<?> friendRequestResult(@RequestHeader(name = "accessToken") String accessToken,
                                                 @RequestBody FriendRequestHandleDto friendRequestHandleDto) {
        long userId = jwtTokenUtil.getUserId(accessToken);
        try {
            friendRequestService.handleFriendRequest(userId, friendRequestHandleDto);
            ResponseDefault responseDefault = ResponseDefault.builder()
                    .success(true)
                    .messege("친구 요청 처리 완료")
                    .data(null)
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.CREATED);
        } catch (Exception e){
            ResponseDefault responseDefault = ResponseDefault.builder()
                    .success(false)
                    .messege("친구 요청 처리 실패")
                    .data(null)
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.NOT_FOUND);
        }

    }

    @Operation(summary = "user가 받은 친구요청")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "OK"),
            @ApiResponse(responseCode = "404", description = "NOT FOUND"),
    })
    @GetMapping("/request/received")
    public ResponseEntity<?> getReceivedFriendRequest(@RequestHeader(name = "accessToken") String accessToken){
        long userId = jwtTokenUtil.getUserId(accessToken);
        try {
            List<FriendDto> friendDtoList = friendRequestService.getReceivedFriendRequestList(userId);
            ResponseDefault responseDefault = ResponseDefault.builder()
                    .success(true)
                    .messege("받은 요청 가져오기 완료")
                    .data(friendDtoList)
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.OK);
        } catch (Exception e){
            ResponseDefault responseDefault = ResponseDefault.builder()
                    .success(false)
                    .messege("실패")
                    .data(null)
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.NOT_FOUND);
        }
    }

    @Operation(summary = "user가 보낸 친구요청")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "OK"),
            @ApiResponse(responseCode = "404", description = "NOT FOUND"),
    })
    @GetMapping("/request/send")
    public ResponseEntity<?> getSendFriendRequest(@RequestHeader(name = "accessToken") String accessToken){
        long userId = jwtTokenUtil.getUserId(accessToken);
        try {
            List<FriendDto> friendDtoList = friendRequestService.getSendFriendRequestList(userId);
            ResponseDefault responseDefault = ResponseDefault.builder()
                    .success(true)
                    .messege("보낸 요청 가져오기 완료")
                    .data(friendDtoList)
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.OK);
        } catch (Exception e){
            ResponseDefault responseDefault = ResponseDefault.builder()
                    .success(false)
                    .messege("실패")
                    .data(null)
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.NOT_FOUND);
        }
    }
    @Operation(summary = "user가 friend 검색하기")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "OK"),
            @ApiResponse(responseCode = "404", description = "NOT FOUND"),
    })
    @GetMapping("/search/{friendNickname}")
    public ResponseEntity<?> friendSearch(@RequestHeader(name = "accessToken") String accessToken,@PathVariable(name="friendNickname") String friendNickname){
        long userId = jwtTokenUtil.getUserId(accessToken);
        try {
            FriendSearchDTO friendSearchDTO=friendService.searchFriend(userId,friendNickname);
            if(friendSearchDTO!=null) {
                ResponseDefault responseDefault = ResponseDefault.builder()
                        .success(true)
                        .messege("유저 검색 성공")
                        .data(friendSearchDTO)
                        .build();
                return new ResponseEntity<>(responseDefault, HttpStatus.OK);
            }else{
                ResponseDefault responseDefault = ResponseDefault.builder()
                        .success(false)
                        .messege("유저 조회 실패 : 없는 유저")
                        .data(null)
                        .build();
                return new ResponseEntity<>(responseDefault, HttpStatus.NOT_FOUND);
            }
        }  catch (Exception e){
            ResponseDefault responseDefault = ResponseDefault.builder()
                    .success(false)
                    .messege("비정상적인 접근")
                    .data(null)
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.BAD_REQUEST);
        }

    }

}
