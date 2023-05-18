package com.ssafy.daldong.main.controller;


import com.ssafy.daldong.global.response.ResponseDefault;
import com.ssafy.daldong.jwt.JwtTokenUtil;
import com.ssafy.daldong.main.model.dto.AssetDTO;
import com.ssafy.daldong.main.model.dto.AssetIdDTO;
import com.ssafy.daldong.main.model.dto.AssetNameDTO;
import com.ssafy.daldong.main.model.dto.MainpageDTO;
import com.ssafy.daldong.main.model.service.MainpageService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/main")
public class MainController {
    private final MainpageService mainService;
    private final JwtTokenUtil jwtTokenUtil;
    @GetMapping("")
    public ResponseEntity<?> mainpage(@RequestHeader(name="accessToken")String accessToken) throws Exception {
        long uid=jwtTokenUtil.getUserId(accessToken);
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
    public ResponseEntity<?> inven(@RequestHeader(name="accessToken")String accessToken){


        long uid=jwtTokenUtil.getUserId(accessToken);
        ResponseDefault responseDefault = null;
        //전체 에셋 + 해당 유저가 보유한 에셋 같이 반환
        try {
            List<AssetDTO> assets=mainService.inven(uid);

            responseDefault = ResponseDefault.builder()
                    .success(true)
                    .messege("SUCCESS")
                    .data(assets)
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.OK);

        }catch (Exception e) {
            responseDefault = ResponseDefault.builder()
                    .success(false)
                    .messege(e.getMessage())
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.BAD_REQUEST);
        }

    }
    @PostMapping("/inven/buy")
    public ResponseEntity<?> buyAsset(@RequestHeader(name = "accessToken") String accessToken,@RequestBody AssetIdDTO assetIdDTO){//{"assetId" : "assetId"}
        //구매하고자 하는 에셋의 구매가능 레벨 & 포인트 충분여부 판단 필요
        long uid=jwtTokenUtil.getUserId(accessToken);
        //구매 상태에 따라 isBuy에 숫자 저장
        //1. 유저 레벨 OK&& 포인트 Ok ->구매성공
        //2. 유저레벨 OK / 포인트 부족 -> 구매실패(포인트부족)
        //3. 유저레벨 X ->구매실패(레벨 부족)
        ResponseDefault responseDefault = null;
        try{
            int isbuy=mainService.buyAsset(uid,assetIdDTO.getAssetId());

            switch(isbuy){
                case 1:
                    responseDefault = ResponseDefault.builder()
                            .success(true)
                            .messege("구매 성공")
                            .build();
                    return new ResponseEntity<>(responseDefault, HttpStatus.OK);
                case 2:
                    responseDefault = ResponseDefault.builder()
                            .success(false)
                            .messege("포인트가 부족합니다. 운동을 통해 포인트를 모아보세요!")
                            .build();
                    return new ResponseEntity<>(responseDefault, HttpStatus.NOT_FOUND);
                case 3:
                    responseDefault = ResponseDefault.builder()
                            .success(false)
                            .messege("구매가능한 레벨이 아닙니다.")
                            .build();
                    return new ResponseEntity<>(responseDefault, HttpStatus.NOT_FOUND);
                case 4:
                    responseDefault = ResponseDefault.builder()
                            .success(false)
                            .messege("비정상적인 접근입니다.")
                            .build();
                    return new ResponseEntity<>(responseDefault, HttpStatus.NOT_FOUND);

            }
            responseDefault = ResponseDefault.builder()
                    .success(false)
                    .messege("비정상적인 접근입니다.")
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.BAD_REQUEST);
        }catch (Exception e){
            responseDefault = ResponseDefault.builder()
                    .success(false)
                    .messege(e.getMessage())
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.BAD_REQUEST);
        }


    }
    @PutMapping("/inven/set")
    public ResponseEntity<?> setMainAsset(@RequestHeader(name = "accessToken") String accessToken,@RequestBody AssetIdDTO assetIdDTO){
       // 해당 에셋을 메인으로 세팅
        //user가 보유중인 에셋이 맞는지 확인 필요 ->비정상적인 접근 방지
        long uid=jwtTokenUtil.getUserId(accessToken);
        ResponseDefault responseDefault = null;
        try{
            Boolean isSetAsset=mainService.setMainAsset(uid,assetIdDTO.getAssetId());

            if (isSetAsset) {//유저가 보유한 에셋이 맞다

                responseDefault = ResponseDefault.builder()
                        .success(true)
                        .messege("SUCCESS")
                        .data("메인 에셋이 변경되었습니다.")
                        .build();
                return new ResponseEntity<>(responseDefault, HttpStatus.OK);
            } else {
                responseDefault = ResponseDefault.builder()
                        .success(false)
                        .messege("FAIL")
                        .data("보유하지 않은 에셋입니다.")
                        .build();
                return new ResponseEntity<>(responseDefault,HttpStatus.NOT_FOUND);
            }
        }catch (Exception e){
            responseDefault = ResponseDefault.builder()
                    .success(false)
                    .messege("FAIL")
                    .data("비정상적인 접근입니다.")
                    .build();
            return new ResponseEntity<>(responseDefault,HttpStatus.BAD_REQUEST);
        }

    }
    @PutMapping("/inven/setPetName")
    public ResponseEntity<?> setPetName(@RequestHeader(name = "accessToken") String accessToken,@RequestBody AssetNameDTO assetNameDTO) {

        long assetId = assetNameDTO.getAssetId();
        String setAssetName = assetNameDTO.getSetAssetName();
        long uid = jwtTokenUtil.getUserId(accessToken);
        ResponseDefault responseDefault = null;
        try {
            Boolean isSetAssetName = mainService.setPetName(uid, assetId, setAssetName);

            if (isSetAssetName) {//가입된 유저다

                responseDefault = ResponseDefault.builder()
                        .success(true)
                        .messege("SUCCESS")
                        .data("펫 이름이 변경되었습니다.")
                        .build();
                return new ResponseEntity<>(responseDefault, HttpStatus.OK);
            } else {
                responseDefault = ResponseDefault.builder()
                        .success(false)
                        .messege("FAIL")
                        .data("비정상적인 접근입니다.")
                        .build();
                return new ResponseEntity<>(responseDefault, HttpStatus.NOT_FOUND);
            }
        } catch (Exception e) {
            responseDefault = ResponseDefault.builder()
                    .success(false)
                    .messege("FAIL")
                    .data("비정상적인 접근입니다.")
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.BAD_REQUEST);
        }
    }
}
