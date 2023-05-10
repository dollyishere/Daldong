package com.ssafy.daldong.main.model.service;

import com.ssafy.daldong.main.model.dto.AssetDTO;
import com.ssafy.daldong.main.model.dto.MainpageDTO;

import java.util.List;

public interface MainpageService {
    MainpageDTO mainpage(long uid);

    List<AssetDTO> inven(long uid);

    int buyAsset(long uid, long assetId);

    Boolean setMainAsset(long uid, long assetId);

    Boolean setPetName(long uid, long assetId, String setAssetName);
}
