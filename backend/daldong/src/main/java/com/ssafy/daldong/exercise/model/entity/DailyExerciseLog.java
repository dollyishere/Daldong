package com.ssafy.daldong.exercise.model.entity;

import com.ssafy.daldong.user.model.entity.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import javax.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Table(name = "dailyExerciseLog")
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class DailyExerciseLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "dailyExercise_id")
    private Long dailyExerciseId;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    private User user;

    @Column(name = "ex_date", nullable = false)
    private LocalDate exDate;

    @Column(name = "ex_time", nullable = false)
    private LocalTime exTime;

    @Column(name = "kcal", nullable = false)
    private int kcal;

    @Column(name = "count", nullable = false)
    private int count;

    @Column(name = "point", nullable = false)
    private int point;
}

