package com.ssafy.daldong.user.model.entity;

import lombok.*;

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

    @OneToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "user_id", referencedColumnName = "user_id", nullable = false, unique = true)
    private User user;

    @Column(name = "daily_ex_time", nullable = false)
    private int dailyExTime;

    @Column(name = "daily_kcal", nullable = false)
    private int dailyKcal;

    @Column(name = "daily_count")
    private int dailyCount;

    @Column(name = "daily_friend")
    private int dailyFriend;
}
