package com.ssafy.daldong.user.model.entity;

import lombok.*;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalTime;

@Entity
@Table(name = "statistics")
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Statistics implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "statistics_id", nullable = false)
    private long statisticsId;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", referencedColumnName = "user_id", nullable = false, unique = true)
    @OnDelete(action = OnDeleteAction.CASCADE)
    private User user;

    @Column(name = "daily_ex_time", nullable = false)
    private LocalTime dailyExTime;

    @Column(name = "daily_kcal", nullable = false)
    private int dailyKcal;

    @Column(name = "daily_count")
    private int dailyCount;

    @Column(name = "daily_friend")
    private int dailyFriend;
    @Column(name = "daily_point")
    private int dailyPoint;
    public void initTable() {
        this.dailyExTime = LocalTime.MIN;
        this.dailyKcal = 0;
        this.dailyCount = 0;
        this.dailyFriend = 0;
        this.dailyPoint = 0;
    }
    public void sum(LocalTime time, int kcal, int count) {
        this.dailyExTime.plusHours(time.getHour())
                .plusMinutes(time.getMinute())
                .plusSeconds(time.getSecond());
        this.dailyKcal += kcal;
        this.dailyCount += count;
    }

    public void stingFriend(){
        this.dailyFriend += 1;
    }
}
