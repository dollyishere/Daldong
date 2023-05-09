package com.ssafy.daldong.main.model.entity;

import com.ssafy.daldong.user.model.entity.User;
import lombok.*;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import javax.persistence.*;

@Entity
@Table(name = "userAsset")
//@IdClass(UserAssetId.class)
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserAsset {


//    @Id
//    @ManyToOne(fetch = FetchType.LAZY)
//    @JoinColumn(name = "user_id", nullable = false)
//    @OnDelete(action = OnDeleteAction.CASCADE)
//    private User user;
//
//    @Id
//    @ManyToOne(fetch = FetchType.LAZY)
//    @JoinColumn(name = "asset_id", nullable = false)
//    @OnDelete(action = OnDeleteAction.CASCADE)
//    private Asset asset;

    @EmbeddedId
    private UserAssetId userAssetId;

    @Column(name = "asset_type", nullable = false)
    private boolean assetType;

    @Column(name = "pet_exp", nullable = false)
    private int petExp;

    //유저가 설정할 펫의 이름 첫 구매하면 Asset-assetKRName이 default로 입력됨
    @Column(name="pet_name_custom")
    private String petCustomName;

    @Column(name = "pet_name")
    private String petName;

}