package com.ssafy.daldong.exercise.controller;

import com.ssafy.daldong.exercise.model.dto.response.ExerciseResDTO;
import com.ssafy.daldong.exercise.model.service.ExerciseService;
import com.ssafy.daldong.response.ResponseDefault;
import io.swagger.v3.oas.annotations.Operation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.util.List;
import java.util.Map;


@RestController
@RequestMapping("/api/exercise")
public class ExerciseController {

    private static final Logger logger = LogManager.getLogger(ExerciseController.class);
    private final ExerciseService exerciseService;

    @Autowired
    public ExerciseController(ExerciseService exerciseService) {
        this.exerciseService = exerciseService;
    }

    /**
     * 운동 메인 페이지 조회
     * @param userId 유저ID
     * @return ResponseEntity
     */
    @Operation(summary = "운동 메인 페이지 조회")
    @GetMapping("/{userid}")
    public ResponseEntity<?> getExercise(@PathVariable(name = "userid") Long userId) {
        logger.info("ExerciseController.getExercise({})",userId);
        ExerciseResDTO exerciseResDTO =  exerciseService.getExercise(userId);

        ResponseDefault responseDefault;
        try{
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
     * @param userid
     * @param month
     * @return
     */
    @Operation(summary = "해당 월 운동 조회")
    @GetMapping("/monthly/{userid}/{month}")
    public ResponseEntity<?> getExerciseMonthly(@PathVariable(name = "userid") Long userid,
                                                    @PathVariable(name = "month") String month) {
        logger.info("ExerciseController.getExerciseMonthly({}, {})",month, userid);

        List<Map<String, Object>> exerciseMonthlyResDTOList = exerciseService.getExerciseMonthly(userid, month);

        ResponseDefault responseDefault;
        try{
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

