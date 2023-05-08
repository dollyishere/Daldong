package com.ssafy.daldong.auth.controller;

import com.google.firebase.auth.FirebaseAuthException;
import com.ssafy.daldong.auth.model.dto.response.AuthResDto;
import com.ssafy.daldong.auth.service.AuthService;
import com.ssafy.daldong.global.response.ResponseDefault;
import com.ssafy.daldong.user.model.entity.User;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.NoSuchElementException;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @Operation(summary = "idToken 인증")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "OK"),
            @ApiResponse(responseCode = "404", description = "NOT FOUND"),
    })
    @PostMapping("/")
    public ResponseEntity<?> authenticateUser(@RequestHeader("Authorization") String idToken) {
        try {
            AuthResDto authResDto = authService.authenticateUser(idToken);
            ResponseDefault responseDefault = ResponseDefault.builder()
                    .success(true)
                    .messege("Authentication success")
                    .data(authResDto)
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.OK);
        } catch (DataIntegrityViolationException e) {
            ResponseDefault responseDefault = ResponseDefault.builder()
                    .success(false)
                    .messege("Error during saving user")
                    .data(null)
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.BAD_REQUEST);
        } catch (RuntimeException e) {
            ResponseDefault responseDefault = ResponseDefault.builder()
                    .success(false)
                    .messege("Invalid ID token")
                    .data(null)
                    .build();
            return new ResponseEntity<>(responseDefault, HttpStatus.UNAUTHORIZED);
        }
    }


    @GetMapping("/user/{uid}")
    public ResponseEntity<String> getUser(@PathVariable String uid) {
        User user = authService.getUserByUid(uid);
        if (user == null) {
            // Handle case where user is not found in database
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("User not found");
        } else {
            // Handle successful user retrieval
            return ResponseEntity.ok("Welcome " + user.getUserId());
        }
    }



}
