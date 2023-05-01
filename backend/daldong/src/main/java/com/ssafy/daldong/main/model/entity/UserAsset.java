package com.ssafy.daldong.main.model.entity;

import com.ssafy.daldong.user.model.entity.User;
import lombok.*;

import javax.persistence.*;

@Entity
@Table(name = "userAsset")
@IdClass(UserAssetId.class)
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserAsset {

    @Id
    @ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Id
    @ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    @JoinColumn(name = "asset_id", nullable = false)
    private Asset asset;

    @Column(name = "asset_type", nullable = false)
    private boolean assetType;

    @Column(name = "pet_exp", nullable = false)
    private int petExp;

    @Column(name = "pet_name")
    private String petName;

}