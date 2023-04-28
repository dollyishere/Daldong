package com.ssafy.daldong.exercise.model.entity;

import com.ssafy.daldong.user.model.entity.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Entity
@Table(name = "exerciseLog")
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class ExerciseLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "exercize_id")
    private Long exerciseId;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "exercise_starttime", nullable = false)
    private LocalDateTime exerciseStartTime;

    @Column(name = "exercise_endtime", nullable = false)
    private LocalDateTime exerciseEndTime;

    @Column(name = "exercise_time", nullable = false)
    private LocalTime exerciseTime;

    @Column(name = "exercise_kcal", nullable = false)
    private int exerciseKcal;

    @Column(name = "average_heart", nullable = false)
    private int averageHeart;

    @Column(name = "max_heart", nullable = false)
    private int maxHeart;

    @Column(name = "exercise_point", nullable = false)
    private int exercisePoint;

    @Column(name = "ecercise_user_exp", nullable = false)
    private int exerciseUserExp;

    @Column(name = "exercise_pet_exp", nullable = false)
    private int exercisePetExp;

    @Column(name = "exercise_memo")
    private String exerciseMemo;

}