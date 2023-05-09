package com.ssafy.daldong.user.model.service;


import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;
import com.ssafy.daldong.main.model.entity.Asset;
import com.ssafy.daldong.main.model.repository.AssetRepository;
import com.ssafy.daldong.main.model.repository.UserAssetRepository;
import com.ssafy.daldong.user.model.dto.UserDetailDTO;
import com.ssafy.daldong.user.model.dto.UserJoinDTO;
import com.ssafy.daldong.user.model.dto.UserLoginDTO;
import com.ssafy.daldong.user.model.dto.UserUpdateDTO;
import com.ssafy.daldong.user.model.entity.User;
import com.ssafy.daldong.user.model.repository.UserRepository;
import com.ssafy.daldong.jwt.JwtTokenUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;


@Service
@Slf4j
@RequiredArgsConstructor
@Transactional
public class UserServiceImpl implements UserService{
    private final UserRepository userRepository;
    private final AssetRepository assetRepository;

    private final FirebaseAuth firebaseAuth;
    private final UserAssetRepository userAssetRepository;
    private final RedisService redisService;
    private final JwtTokenUtil jwtTokenUtil;

        public UserLoginDTO login (String idToken) throws FirebaseAuthException {

            FirebaseToken decodedToken = firebaseAuth.verifyIdToken(idToken);
            String uId = decodedToken.getUid();

            log.info(uId);
            UserLoginDTO userLoginDTO = new UserLoginDTO().fromEntity(userRepository.findByUserUid(uId));
            return userLoginDTO;
        }


    @Override
    public void join(UserJoinDTO userJoinDTO) {
            userJoinDTO.setMainBackId(1L);
            userJoinDTO.setMainPetId(1L);//아직 몇번인지 모름 임의 세팅
            Asset assetBack= assetRepository.findByAssetId(userJoinDTO.getMainBackId());
            Asset assetPet= assetRepository.findByAssetId(userJoinDTO.getMainBackId());
            //UserAsset 추가부분 미완성 - 노션 댓글 참고
            //userAssetRepository.save(new UserAssetDTO().toEntity(userAssetRepository.findByUserIdAndAssetId(assetBack.getAssetId(),assetPet.getAssetId())));
        User user=userJoinDTO.toEntity(User.from(userJoinDTO,assetBack,assetPet));

            userRepository.save(user);
    }

    @Override
    public Boolean nameCheck(String nickname) {
        User user = userRepository.findByNickname(nickname);
        if(user!=null)return true;
        else return false;
    }
    public UserDetailDTO mypage(long uid) {

        return new UserDetailDTO().fromEntity(userRepository.findByUserId(uid));

    }

    @Override
    public void updateUser(long uid, UserUpdateDTO userUpdateDTO) {
        User user = userRepository.findByUserId(uid);
        user.setUpdate(userUpdateDTO);
        userRepository.save(user);
    }

    @Override
    public Boolean updateNickname(long uid, String nickname) {
        User user = userRepository.findByNickname(nickname);
        if(user!=null){
            return false;
        }
        else{
            user = userRepository.findByUserId(uid);
            user.setNickname(nickname);
            userRepository.save(user);
            return true;
        }

    }


    @Override
    @Transactional
    public void saveRefreshToken(String principal, String refreshToken) {
        redisService.setValuesWithTimeout(principal, // key
                refreshToken, // value
                jwtTokenUtil.getTokenExpirationTime(refreshToken)); // timeout(milliseconds)
    }




}
