package com.ssafy.daldong.main.model.controller;


import com.ssafy.daldong.global.response.ResponseDefault;
import com.ssafy.daldong.main.model.dto.MainpageDTO;
import com.ssafy.daldong.main.model.service.MainpageService;
import com.ssafy.daldong.user.model.dto.UserLoginDTO;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/main")
public class MainController {
    private final MainpageService mainService;
    @GetMapping("")
    public ResponseEntity<?> mainpage(@RequestHeader(name = "userid") String uid) throws Exception {

        HttpHeaders headers = new HttpHeaders();

        ResponseDefault responseDefault = null;
        try{
            MainpageDTO mainpageDTO=null;
            mainpageDTO = mainService.mainpage(uid);
            if (mainpageDTO != null) {//가입된 유저다

                responseDefault = ResponseDefault.builder()
                        .success(true)
                        .messege("SUCCESS")
                        .data(mainpageDTO)
                        .build();
                return new ResponseEntity<>(responseDefault,headers, HttpStatus.OK);
            } else {
                responseDefault = ResponseDefault.builder()
                        .success(false)
                        .messege("FAIL")
                        .build();
                return new ResponseEntity<>(responseDefault,HttpStatus.NOT_FOUND);
            }
        }catch (Exception e) {
            responseDefault = ResponseDefault.builder()
                    .success(false)
                    .messege("FAIL")
                    .data(e.getMessage())
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping("/inven")
    public ResponseEntity<?> inven(@RequestHeader(name = "userid") String uid){
        //전체 에셋 + 해당 유저가 보유한 에셋 같이 반환

        return new ResponseEntity<>(HttpStatus.OK);
    }
    @PostMapping("/inven/buy")
    public ResponseEntity<?> buyAsset(@RequestHeader(name = "userid") String uid){
        //구매하고자 하는 에셋의 구매가능 레벨 & 포인트 충분여부 판단 필요
        return new ResponseEntity<>(HttpStatus.OK);
    }
    @PutMapping("/inven/set")
    public ResponseEntity<?> setMainAsset(@RequestHeader(name = "userid") String uid){
        //구매하고자 하는 에셋의 구매가능 레벨 & 포인트 충분여부 판단 필요
        return new ResponseEntity<>(HttpStatus.OK);
    }
    @GetMapping("/pet")
    public ResponseEntity<?> petDetail(@RequestHeader(name = "petid") String petId){
        return new ResponseEntity<>(HttpStatus.OK);
    }
}
