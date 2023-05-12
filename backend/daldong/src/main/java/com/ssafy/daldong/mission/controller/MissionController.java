package com.ssafy.daldong.mission.controller;

import com.ssafy.daldong.jwt.JwtTokenUtil;
import com.ssafy.daldong.mission.model.dto.MissionResDTO;
import com.ssafy.daldong.mission.model.service.MissionService;
import com.ssafy.daldong.global.response.ResponseDefault;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/mission")
@RequiredArgsConstructor
public class MissionController {

    private static final Logger logger = LogManager.getLogger(MissionController.class);
    private final MissionService missionService;
    private final JwtTokenUtil jwtTokenUtil;


    /**
     * 미션 메인 페이지 조회
     * @param accessToken
     * @return ResponseEntity
     */
    @Operation(summary = "미션 메인 페이지 조회")
    @GetMapping()
    public ResponseEntity<?> getUserMission(@RequestHeader(name = "accessToken") String accessToken) {
        long userId = jwtTokenUtil.getUserId(accessToken);
        logger.info("MissionController.getMission({})",userId);

        ResponseDefault responseDefault;
        try{
            List<MissionResDTO> missionResDTOS =  missionService.getUserMissions(userId);
            responseDefault = ResponseDefault.builder()
                    .success(true)
                    .messege("SUCCESS")
                    .data(missionResDTOS)
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.OK);
        } catch (Exception e) {
            responseDefault = ResponseDefault.builder()
                    .success(false)
                    .messege("FAIL")
                    .data(null)
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.NOT_FOUND);
        }
    }

    /**
     * 미션 리워드 얻기
     * @param accessToken 액세스토큰
     * @param MissionId
     * @return
     */
    @Operation(summary = "미션 리워드 얻기")
    @PostMapping("/{userid}/{missionid}")
    public ResponseEntity<?> getExerciseMonthly(@RequestHeader(name = "accessToken") String accessToken,
                                                @PathVariable(name = "missionid") Long MissionId) {
        long userId = jwtTokenUtil.getUserId(accessToken);
        logger.info("ExerciseController.getExerciseMonthly({}, {})",userId, MissionId);

        ResponseDefault responseDefault;
        try{
            missionService.getReward(userId, MissionId);
            responseDefault = ResponseDefault.builder()
                    .success(true)
                    .messege("SUCCESS")
                    .data(null)
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.OK);
        }catch (Exception e){
            responseDefault = ResponseDefault.builder()
                    .success(false)
                    .messege("FAIL")
                    .data(null)
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.NOT_FOUND);
        }
    }
}

