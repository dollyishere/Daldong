package com.ssafy.daldong.main.model.entity;

import lombok.*;

import javax.persistence.*;

@Entity
@Table(name = "asset")
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Asset {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "asset_id", nullable = false)
    private long assetId;

    @Column(name = "is_pet", nullable = false)
    private boolean isPet;

    @Column(name = "asset_name", nullable = false)
    private String assetName;
    @Column(name = "asset_KRname",nullable = false)
    private  String assetKRName;

    @Column(name = "asset_unlock_level", nullable = false)
    private int assetUnlockLevel;

    @Column(name = "asset_price", nullable = false)
    private int assetPrice;

}