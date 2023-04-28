package com.ssafy.daldong.mission.model.entity;

import com.ssafy.daldong.user.model.entity.User;
import lombok.*;

import javax.persistence.*;
import java.io.Serializable;

@Entity
@Table(name = "stastics")
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class Stastics implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "stastics_id", nullable = false)
    private long stasticsId;

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
