package com.ssafy.daldong.main.model.service;

import com.ssafy.daldong.main.model.dto.AssetDTO;
import com.ssafy.daldong.main.model.dto.MainpageDTO;
import com.ssafy.daldong.main.model.dto.UserAssetDTO;
import com.ssafy.daldong.main.model.entity.Asset;
import com.ssafy.daldong.main.model.entity.UserAsset;
import com.ssafy.daldong.main.model.repository.AssetRepository;
import com.ssafy.daldong.main.model.repository.UserAssetRepository;
import com.ssafy.daldong.user.model.entity.User;
import com.ssafy.daldong.user.model.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.annotation.Isolation;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class MainpageServiceImpl implements MainpageService{

    private final UserRepository userRepository;
    private final AssetRepository assetRepository;
    private final UserAssetRepository userAssetRepository;

    @Override
    public MainpageDTO mainpage(long uid) {
        MainpageDTO mainpageDTO= new MainpageDTO().fromEntity(userRepository.findByUserId(uid).orElseThrow());
        return mainpageDTO;
    }

    @Override
    public List<AssetDTO> inven(long uid) {
        //findAll asset을 AssetDTO리스트로 불러오고.
        //하나하나 비교하면서 status 체크->유저레벨체크 -> 구매여부 체크(UserAsset)
        //최종 List 출력

        //1
        int userLevel=userRepository.findByUserId(uid).orElseThrow().getUserLevel();
        //#1 전체 에셋 리스트 호출
        List<AssetDTO> assets= new AssetDTO().toDtoList(assetRepository.findAll());
        for(AssetDTO assetDTO:assets) {

            UserAsset userAsset=userAssetRepository.findByUserIdAndAssetId(uid,assetDTO.getAssetId()).orElse(null);

            if(userAsset!=null){//구매한 에셋이다 ->변경사항 : 상태, 이름, 경험치
                assetDTO.setAssetStatus(2);
                assetDTO.setAssetCustomName(userAsset.getPetName());
                assetDTO.setExp(userAsset.getPetExp());
            }
            else if(userLevel>=assetDTO.getAssetUnlockLevel()){
                assetDTO.setAssetStatus(1);
            }
            else{
                assetDTO.setAssetStatus(0);
            }
        }
            //????? 에셋의 id와 List index가 일치할까? -> Test 필요
        //#2 현재 유저가 보유한 에셋 리스트 호출
        //#3 유저가 보유한 에셋으로 전체리스트에 업데이트
        return assets;
    }

    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE)
    public int buyAsset(long uid, long assetId) {
        User user=userRepository.findByUserId(uid).orElseThrow();
        int userLevel=user.getUserLevel();
        int userPoint=user.getUserPoint();

        Asset asset=assetRepository.findByAssetId(assetId);
        int assetUnlockLevel=asset.getAssetUnlockLevel();
        int assetPrice=asset.getAssetPrice();
        if(userLevel>=assetUnlockLevel&&userPoint>=assetPrice){
            user.setRemainedPoint(userPoint-assetPrice);//유저 포인트 차감
            userRepository.save(user);
            UserAsset userAsset=new UserAssetDTO().toEntity(uid,assetId, asset.getAssetKRName(),0);
            userAssetRepository.save(userAsset);
            return 1;//1. 에셋구매
        }
        else if(userLevel>=assetUnlockLevel&&userPoint<assetPrice){
            return 2;//2. 포인트 부족 에러
        }
        else if (userLevel<assetUnlockLevel) {
            return 3;//3. 레벨 부족 에러
        }
        return 4;//비정상적인 접근 에러
    }

    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE)
    public Boolean setMainAsset(long uid, long assetId) {
        UserAsset userAsset=userAssetRepository.findByUserIdAndAssetId(uid,assetId).orElse(null);
        if(userAsset==null){
            //보유하지않은 에셋을 메인으로 설정요청 -> 비정상적인 접근
            return false;
        }
        else{
            User user =userRepository.findByUserId(uid).orElseThrow();
            Asset asset=assetRepository.findByAssetId(assetId);
            if(asset.isPet()){//선택한 에셋이 펫이다
                user.setMainPet(asset);
                user.setMainPetName(asset.getAssetKRName());
                userRepository.save(user);
            }
            else{//선택한 에셋이 배경이다
                user.setMainBack(asset);
                userRepository.save(user);
            }
           return true;
        }
    }

    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE)
    public Boolean setPetName(long uid, long assetId, String setAssetName) {
        User user=userRepository.findByUserId(uid).orElseThrow();
        Asset asset=assetRepository.findByAssetId(assetId);
        UserAsset userAsset=userAssetRepository.findByUserIdAndAssetId(uid,assetId).orElse(null);
        if(userAsset==null){//유저가 보유하지않은 에셋
            return false;
        }
        if(!asset.isPet()){//배경 아이디를 가져오면 에러
            return false;
        }
        if(user.getMainPet().getAssetId()==userAsset.getUserAssetId().getAssetId()) {//해당 펫이 메인펫이면 메인도 수정 필요
            userAsset.setPetName(setAssetName);
            userAssetRepository.save(userAsset);
            user.setMainPetName(setAssetName);
            userRepository.save(user);
            return true;
        }
        else{
            userAsset.setPetName(setAssetName);
            userAssetRepository.save(userAsset);
            return true;
        }
    }

}
