package com.ssafy.daldong.mission.model.entity;

import com.ssafy.daldong.user.model.entity.User;
import lombok.*;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "userMission")
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserMission {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_mission_id", nullable = false)
    private long userMissionId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "mission_id", nullable = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    private DailyMission mission;

    @Column(name = "is_receive", nullable = false)
    private boolean isReceive;

    @Column(name = "is_done", nullable = false)
    private boolean isDone;

    @Column(name = "mission_date", nullable = false)
    private LocalDate missionDate;

    public void receive() {
        isReceive = true;
    }

    public void done() {
        this.isDone = true;
    }
}
