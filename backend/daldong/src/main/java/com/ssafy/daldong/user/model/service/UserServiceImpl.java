package com.ssafy.daldong.user.model.service;


import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;
import com.ssafy.daldong.main.model.dto.UserAssetDTO;
import com.ssafy.daldong.main.model.entity.Asset;
import com.ssafy.daldong.main.model.repository.AssetRepository;
import com.ssafy.daldong.main.model.repository.UserAssetRepository;
import com.ssafy.daldong.user.model.dto.UserDetailDTO;
import com.ssafy.daldong.user.model.dto.UserJoinDTO;
import com.ssafy.daldong.user.model.dto.UserLoginDTO;
import com.ssafy.daldong.user.model.dto.UserUpdateDTO;
import com.ssafy.daldong.user.model.entity.Statistics;
import com.ssafy.daldong.user.model.entity.User;
import com.ssafy.daldong.user.model.repository.StatisticsRepository;
import com.ssafy.daldong.user.model.repository.UserRepository;
import com.ssafy.daldong.jwt.JwtTokenUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.time.LocalDateTime;
import java.util.List;


@Service
@Slf4j
@RequiredArgsConstructor
@Transactional
public class UserServiceImpl implements UserService{
    private final StatisticsRepository statisticsRepository;
    private final UserRepository userRepository;
    private final AssetRepository assetRepository;

    private final FirebaseAuth firebaseAuth;
    private final UserAssetRepository userAssetRepository;
    private final RedisService redisService;
    private final JwtTokenUtil jwtTokenUtil;

    public UserLoginDTO login (String idToken) throws FirebaseAuthException {

        FirebaseToken decodedToken = firebaseAuth.verifyIdToken(idToken);
        String uId = decodedToken.getUid();
        User user =userRepository.findByUserUid(uId).orElse(null);
        if(user!=null){
            UserLoginDTO userLoginDTO = new UserLoginDTO().fromEntity(user);
            return userLoginDTO;
        }else return null;


    }


    @Override
    @Transactional
    public void join(String uid,UserJoinDTO userJoinDTO) {
        userJoinDTO.setMainBackId(1L);//참새
        userJoinDTO.setMainPetId(3L);//아직 몇번인지 모름 임의 세팅
        userJoinDTO.setUserUId(uid);
        Asset assetBack= assetRepository.findByAssetId(userJoinDTO.getMainBackId());
        Asset assetPet= assetRepository.findByAssetId(userJoinDTO.getMainBackId());
        User user=userJoinDTO.toEntity(User.from(userJoinDTO,assetBack,assetPet));
        userRepository.save(user);
        user=userRepository.findByUserUid(userJoinDTO.getUserUId()).orElse(null);
        userAssetRepository.save(new UserAssetDTO().newUser(user.getUserId(),assetPet.getAssetId(),"참새"));
        userAssetRepository.save(new UserAssetDTO().newUser(user.getUserId(),assetBack.getAssetId(),"초원"));
    }

    @Override
    public Boolean nameCheck(String nickname) {
        User user = userRepository.findByNickname(nickname).orElse(null);
        if(user!=null)return false;
        else return true;
    }
    public UserDetailDTO mypage(long uid) {

        return new UserDetailDTO().fromEntity(userRepository.findByUserId(uid));

    }

    @Override
    public String getUid(String idToken) throws FirebaseAuthException {
        FirebaseToken decodedToken = firebaseAuth.verifyIdToken(idToken);
        return  decodedToken.getUid();
    }

    @Override
    public void updateUser(long uid, UserUpdateDTO userUpdateDTO) {
        User user = userRepository.findByUserId(uid);
        user.setUpdate(userUpdateDTO);
        userRepository.save(user);
    }

    @Override
    public Boolean updateNickname(long uid, String nickname) {
        User user = userRepository.findByNickname(nickname).orElse(null);
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

    @Override
    public void logout(long uid){
       User user =userRepository.findByUserId(uid);
       String userId=user.getUserUid();
      redisService.deleteValues(userId);
    }

    @Scheduled(cron = "0 0 0 * * ?")
    public void initStatistics(){
        log.info("{} | Statistics 초기화 시작", LocalDateTime.now());
        List<Statistics> statistics = statisticsRepository.findAll();
        statistics.forEach(Statistics::initTable);
        statisticsRepository.saveAll(statistics);
        log.info("{} | Statistics 초기화 종료", LocalDateTime.now());
    }

}
