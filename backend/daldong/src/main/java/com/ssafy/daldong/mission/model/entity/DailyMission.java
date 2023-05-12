package com.ssafy.daldong.mission.model.entity;

import lombok.*;
import java.sql.Timestamp;

import javax.persistence.*;

@Entity
@Table(name = "dailyMission")
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class DailyMission {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "mission_id", nullable = false)
    private long missionId;

    @Column(name = "mission_name", nullable = false)
    private String missionName;

    @Column(name = "mission_content", nullable = false)
    private String missionContent;

    @Column(name = "qualification_name", nullable = false)
    private String qualificationName;

    @Column(name = "qualification_num", nullable = false)
    private int qualificationNum;

    @Column(name = "reward_point", nullable = false)
    private int rewardPoint;
}
