package com.ssafy.daldong.response;


import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class ResponseDefault {
    private boolean success;
    private String messege;
    private Object data;
}
//사용할 땐 밑에처럼 주시면 됩니당
//  responseDefault = ResponseDefault.builder()
//                        .success(true)
//                        .messege("SUCCESS")
//                        .data(user.getProfileImg())
//                        .build();
//                return new ResponseEntity<>(responseDefault, HttpStatus.OK);
//            } catch (IOException e) {
//                responseDefault = ResponseDefault.builder()
//                        .success(false)
//                        .messege("FAIL")
//                        .data(null)
//                        .build();
//                return new ResponseEntity<>(responseDefault, HttpStatus.NOT_FOUND);
//            }
