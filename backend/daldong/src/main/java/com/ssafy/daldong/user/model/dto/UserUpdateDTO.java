package com.ssafy.daldong.user.model.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserUpdateDTO {
    private float height;
    private float weight;
    private boolean gender;
    private int age;
    private int ability;
}
