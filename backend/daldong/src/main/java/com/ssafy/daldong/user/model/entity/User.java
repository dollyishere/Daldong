package com.ssafy.daldong.user.model.entity;

import com.ssafy.daldong.main.model.entity.Asset;
import lombok.*;

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

    @ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.DETACH)
    @JoinColumn(name = "main_back_id", nullable = false)
    private Asset mainBack;

    @ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.DETACH)
    @JoinColumn(name = "main_pet_id", nullable = false)
    private Asset mainPet;

    @Column(name = "main_pet_name", nullable = false)
    private String mainPetName;

    public void payPoint(int rewardPoint) {
        userPoint += rewardPoint;
    }
}
