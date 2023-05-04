package com.ssafy.daldong.user.model.entity;

import jdk.jfr.Enabled;
import lombok.*;

import javax.persistence.*;

@Entity
@Table(name = "level")
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@ToString
public class Level {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "level", nullable = false)
    private long level;

    @Column(name = "required_exp", nullable = false)
    private int requiredExp;
}
