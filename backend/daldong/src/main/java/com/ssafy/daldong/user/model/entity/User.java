package com.ssafy.daldong.user.model.entity;

import com.ssafy.daldong.main.model.dto.AssetDTO;
import com.ssafy.daldong.main.model.entity.Asset;
import com.ssafy.daldong.main.model.repository.AssetRepository;
import com.ssafy.daldong.user.model.dto.UserJoinDTO;
import com.ssafy.daldong.user.model.dto.UserUpdateDTO;
import lombok.*;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import javax.persistence.*;

@Entity
@Table(name = "users")
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_id", nullable = false)
    private long userId;

    @Column(name = "user_uid", nullable = false)
    private String userUid;

    @Column(name = "nickname", nullable = false)
    private String nickname;

    @Column(name = "height")
    private Float height;

    @Column(name = "weight")
    private Float weight;

    @Column(name = "gender")
    private Boolean gender;

    @Column(name = "age")
    private Integer age;

    @Column(name = "ability")
    private Integer ability;

    @Column(name = "user_level", nullable = false)
    private int userLevel;

    @Column(name = "user_exp", nullable = false)
    private int userExp;

    @Column(name = "required_exp", nullable = false)
    private int requiredExp;

    @Column(name = "user_point", nullable = false)
    private int userPoint;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "main_back_id", nullable = false)
    private Asset mainBack;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "main_pet_id", nullable = false)
    private Asset mainPet;

    @Column(name = "main_pet_name", nullable = false)
    private String mainPetName;

    public void payPoint(int rewardPoint) {
        userPoint += rewardPoint;
    }
    public void setUpdate(UserUpdateDTO userUpdateDTO){
        this.height=userUpdateDTO.getHeight();
        this.weight= userUpdateDTO.getWeight();
        this.gender=userUpdateDTO.isGender();
        this.age= userUpdateDTO.getAge();
        this.ability=userUpdateDTO.getAbility();
    }
    public void setNickname(String nickname){
        this.nickname=nickname;
    }
    public void setRemainedPoint(int Point){
        this.userPoint=Point;
    }

    public void setMainBack(Asset assetBack){
        this.mainBack=assetBack;
    }
    public void setMainPet(Asset assetPet){
        this.mainPet=assetPet;
    }
    public void setMainPetName(String assetPetName){
        this.mainPetName=assetPetName;
    }
    public static User from(UserJoinDTO userJoinDTO,Asset assetBack,Asset assetPet) {
        return User.builder()
                .userUid(userJoinDTO.getUserUId())
                .nickname(userJoinDTO.getNickname())
                .height(userJoinDTO.getHeight())
                .weight(userJoinDTO.getWeight())
                .gender(userJoinDTO.isGender())
                .age(userJoinDTO.getAge())
                .ability(userJoinDTO.getAbility())
                .userLevel(1)
                .userExp(0)
                .requiredExp(100)//아직 미정
                .userPoint(100)//0 시작 OR 기본 포인트 100 주고 시작
                .mainBack(assetBack)
                .mainPet(assetPet)
                .mainPetName("참새")
                .build();
    }
}
