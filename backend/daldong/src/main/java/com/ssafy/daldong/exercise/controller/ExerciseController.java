package com.ssafy.daldong.exercise.controller;

import com.ssafy.daldong.exercise.model.dto.response.ExerciseResDTO;
import com.ssafy.daldong.exercise.model.service.ExerciseService;
import com.ssafy.daldong.global.response.ResponseDefault;
import com.ssafy.daldong.jwt.JwtTokenUtil;
import io.swagger.v3.oas.annotations.Operation;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.List;
import java.util.Map;


@RestController
@RequestMapping("/exercise")
@RequiredArgsConstructor
public class ExerciseController {

    private static final Logger logger = LogManager.getLogger(ExerciseController.class);
    private final ExerciseService exerciseService;
    private final JwtTokenUtil jwtTokenUtil;

    /**
     * 운동 메인 페이지 조회
     * @param accessToken
     * @return ResponseEntity
     */
    @Operation(summary = "운동 메인 페이지 조회")
    @GetMapping("/")
    public ResponseEntity<?> getExercise(@RequestHeader(name = "accessToken") String accessToken) {
        long userId = jwtTokenUtil.getUserId(accessToken);
        logger.info("ExerciseController.getExercise({})",userId);

        ResponseDefault responseDefault;
        try{
            ExerciseResDTO exerciseResDTO =  exerciseService.getExercise(userId);
            responseDefault = ResponseDefault.builder()
                    .success(true)
                    .messege("SUCCESS")
                    .data(exerciseResDTO)
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
     * 해당 월 운동 조회
     * @param accessToken
     * @param month
     * @return
     */
    @Operation(summary = "해당 월 운동 조회")
    @GetMapping("/monthly/{year-month}")
    public ResponseEntity<?> getExerciseMonthly(@RequestHeader(name = "accessToken") String accessToken,
                                                    @PathVariable(name = "year-month") String month) {
        long userId = jwtTokenUtil.getUserId(accessToken);
        logger.info("ExerciseController.getExerciseMonthly({}, {})",month, userId);


        ResponseDefault responseDefault;
        try{
            List<Map<String, Object>> exerciseMonthlyResDTOList = exerciseService.getExerciseMonthly(userId, month);
            responseDefault = ResponseDefault.builder()
                    .success(true)
                    .messege("SUCCESS")
                    .data(exerciseMonthlyResDTOList)
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
}

