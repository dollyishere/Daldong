package com.ssafy.daldong.main.model.entity;

import lombok.*;

import javax.persistence.*;

@Entity
@Table(name = "motion")
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class Motion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "motion_id", nullable = false)
    private long motionId;

    @Column(name = "motion_name", nullable = false)
    private String motionName;

    @Column(name = "motion_unlock_exp", nullable = false)
    private int motionUnlockExp;

    @Column(name = "motion_kr_name", nullable = false)
    private String motionKrName;

    @Column(name = "motion_asset_id", nullable = false)
    private int motionAssetId;
}
