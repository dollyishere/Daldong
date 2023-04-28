package com.ssafy.daldong.mission.model.entity;

import com.ssafy.daldong.asset.model.entity.Asset;
import com.ssafy.daldong.user.model.entity.User;
import lombok.*;

import javax.persistence.*;

@Entity
@Table(name = "userMission")
@IdClass(UserMissionId.class)
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class UserMission {

    @Id
    @ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Id
    @ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "mission_id", nullable = false)
    private DailyMission dailyMission;

    @Column(name = "is_receive", nullable = false)
    private boolean isReceive;

    @Column(name = "is_done", nullable = false)
    private boolean isDone;

}
