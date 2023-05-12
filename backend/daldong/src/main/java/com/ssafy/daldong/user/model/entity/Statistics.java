package com.ssafy.daldong.user.model.entity;

import lombok.*;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import javax.persistence.*;
import java.io.Serializable;

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
    private int dailyExTime;

    @Column(name = "daily_kcal", nullable = false)
    private int dailyKcal;

    @Column(name = "daily_count")
    private int dailyCount;

    @Column(name = "daily_friend")
    private int dailyFriend;

    public void initTable() {
        this.dailyExTime = 0;
        this.dailyKcal = 0;
        this.dailyCount = 0;
        this.dailyFriend = 0;
    }
}
