package com.ssafy.daldong.user.model.controller;


import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.daldong.user.model.dto.UserDetailDTO;
import com.ssafy.daldong.user.model.dto.UserJoinDTO;
import com.ssafy.daldong.user.model.dto.UserUpdateDTO;
import com.ssafy.daldong.user.model.service.UserService;
import com.ssafy.daldong.global.response.ResponseDefault;
import com.ssafy.daldong.user.model.dto.UserLoginDTO;
import com.ssafy.daldong.jwt.JwtTokenUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/user")
@Slf4j
public class UserController {
    private final JwtTokenUtil jwtTokenUtil;
    private final UserService userService;
    private ObjectMapper objectMapper = new ObjectMapper();
    @Value("${spring.security.oauth2.client.registration.google.client-id}")
    private String clientId;
    @Value("${spring.security.oauth2.client.registration.google.client-secret}")
    private String clientSecretKey;

    @PostMapping("/signin")
    public ResponseEntity<?> login(@RequestHeader(name="idToken") String idToken) throws Exception {//@RequestBody codeDto codeDto

        HttpHeaders headers = new HttpHeaders();
        ResponseDefault responseDefault = null;


        try{
            UserLoginDTO userLoginDTO = userService.login(idToken);
            if (userLoginDTO != null) {//가입된 유저다
                String accessToken = jwtTokenUtil.generateAccessToken(userLoginDTO.getUserUId(),userLoginDTO.getUserId());
                String refreshToken = jwtTokenUtil.generateRefreshToken(userLoginDTO.getUserUId(),userLoginDTO.getUserId());
                //jwt 생성
                headers.set("accessToken", accessToken);
                headers.set("refreshToken", refreshToken);
                userService.saveRefreshToken(userLoginDTO.getUserUId(),refreshToken);
                responseDefault = ResponseDefault.builder()
                        .success(true)
                        .messege("SUCCESS")
                        .data(userLoginDTO)
                        .build();
                return new ResponseEntity<>(responseDefault,headers,HttpStatus.OK);
            } else {
                String uid= userService.getUid(idToken);
                headers.set("uid", uid);
                responseDefault = ResponseDefault.builder()
                        .success(false)
                        .messege("FAIL")
                        .build();
                return new ResponseEntity<>(responseDefault,headers,HttpStatus.NOT_FOUND);
            }
        }catch (Exception e) {
            System.err.println(e.getMessage());
            responseDefault = ResponseDefault.builder()
                    .success(false)
                    .messege("ERROR")
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.BAD_REQUEST);
        }
    }
    @PostMapping("/signup")
    public ResponseEntity<?> signup( @RequestHeader(name = "uid") String uid,@RequestBody UserJoinDTO userJoinDTO) {
        ResponseDefault responseDefault = null;
        try {
            userService.join(uid,userJoinDTO);
            responseDefault = ResponseDefault.builder()
                    .success(true)
                    .messege("SUCCESS")
                    .data(null)
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.OK);
        } catch (Exception e) {
            log.error("회원 가입 실패");
            responseDefault = ResponseDefault.builder()
                    .success(false)
                    .messege(e.getMessage())
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.BAD_REQUEST);
        }
    }
    @GetMapping("/nameCheck")
    public ResponseEntity<?> nameCheck(@RequestBody String nickname){
        ResponseDefault responseDefault = null;
        try {
            if(userService.nameCheck(nickname)) {
                responseDefault = ResponseDefault.builder()
                        .success(true)
                        .messege("SUCCESS")
                        .data(null)
                        .build();
                return new ResponseEntity<>(responseDefault, HttpStatus.OK);
            }else{
                responseDefault = ResponseDefault.builder()
                        .success(false)
                        .messege("FAIL")
                        .build();
                return new ResponseEntity<>(responseDefault, HttpStatus.CONFLICT);
            }
        } catch (Exception e) {
            log.error("회원 가입 실패");
            responseDefault = ResponseDefault.builder()
                    .success(false)
                    .messege(e.getMessage())
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.BAD_REQUEST);
        }
    }
    @GetMapping("/mypage")
    public ResponseEntity<?> mypage(@RequestHeader(name="accessToken")String accessToken){
        long uid=jwtTokenUtil.getUserId(accessToken);
        ResponseDefault responseDefault = null;
        try {
            UserDetailDTO userDetailDTO=userService.mypage(uid);
            responseDefault = ResponseDefault.builder()
                    .success(true)
                    .messege("SUCCESS")
                    .data(userDetailDTO)
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.OK);
        } catch (Exception e) {
            log.error("사용자정보 조회 실패");
            responseDefault = ResponseDefault.builder()
                    .success(false)
                    .messege(e.getMessage())
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.BAD_REQUEST);
        }
    }
    @PutMapping("/mypage")
    public ResponseEntity<?> updateMypage(@RequestHeader(name="accessToken")String accessToken,@RequestBody UserUpdateDTO userUpdateDTO){
        long uid=jwtTokenUtil.getUserId(accessToken);
        userService.updateUser(uid,userUpdateDTO);
        return new ResponseEntity<>(HttpStatus.OK);
    }
    @PutMapping("/mypage/nickname")
    public ResponseEntity<?> updateNickname(@RequestHeader(name="accessToken")String accessToken,@RequestBody String nickname){
        long uid=jwtTokenUtil.getUserId(accessToken);
        ResponseDefault responseDefault = null;
        try {
            if(userService.updateNickname(uid,nickname)){
                responseDefault = ResponseDefault.builder()
                        .success(true)
                        .messege("SUCCESS")
                        .data("닉네임 변경 성공")
                        .build();
                return new ResponseEntity<>(responseDefault, HttpStatus.OK);
            }
            else{
                responseDefault = ResponseDefault.builder()
                        .success(false)
                        .messege("중복 닉네임")
                        .build();
                return new ResponseEntity<>(responseDefault, HttpStatus.CONFLICT);
            }


        } catch (Exception e) {
            responseDefault = ResponseDefault.builder()
                    .success(false)
                    .messege(e.getMessage())
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.BAD_REQUEST);
        }

    }
}
