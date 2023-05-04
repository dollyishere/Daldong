package com.ssafy.daldong.friend.controller;

import com.ssafy.daldong.friend.model.dto.FriendDto;
import com.ssafy.daldong.friend.model.dto.request.FriendRequestDto;
import com.ssafy.daldong.friend.model.dto.request.FriendRequestResponseDto;
import com.ssafy.daldong.friend.service.FriendRequestService;
import com.ssafy.daldong.friend.service.FriendService;
import com.ssafy.daldong.global.response.ResponseDefault;
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

    @Operation(summary = "user의 친구 목록 가져오기")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "OK"),
            @ApiResponse(responseCode = "404", description = "NOT FOUND"),
    })
    @GetMapping("/{userId}")
    public ResponseEntity<?> friendList(@Parameter(description="userId", example = "1") @PathVariable long userId) {
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
    @PutMapping("/sting/{userId}/{friendId}")
    public ResponseEntity<?> friendSting(@Parameter(description="userId", example = "1") @PathVariable long userId,
                                         @Parameter(description="friendId", example = "2") @PathVariable long friendId){
        try {
            friendService.updateFriend(userId, friendId);
            ResponseDefault responseDefault = ResponseDefault.builder()
                    .success(true)
                    .messege("친구 찌르기 성공")
                    .data(null)
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
    @DeleteMapping("/{userId}/{friendId}")
    public ResponseEntity<?> friendRemove(@Parameter(description="userId", example = "1") @PathVariable long userId,
                                          @Parameter(description="friendId", example = "2") @PathVariable long friendId){
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
    @PostMapping("/request")
    public ResponseEntity<?> friendRequest(@RequestBody FriendRequestDto friendRequestDto) {
        try {
            friendRequestService.createFriendRequest(friendRequestDto);
            ResponseDefault responseDefault = ResponseDefault.builder()
                    .success(true)
                    .messege("친구 요청 성공")
                    .data(null)
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
    public ResponseEntity<?> friendRequestResult(@RequestBody FriendRequestResponseDto responseDto) {
        try {
            friendRequestService.handleFriendRequest(responseDto);
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
    @GetMapping("request/received/{userId}")
    public ResponseEntity<?> getReceivedFriendRequest(@Parameter(description="userId", example = "3") @PathVariable long userId){
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
    @GetMapping("request/send/{userId}")
    public ResponseEntity<?> getSendFriendRequest(@Parameter(description="userId", example = "1") @PathVariable long userId){
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


}
