package com.ssafy.daldong;

import com.ssafy.daldong.exercise.model.entity.DailyExerciseLog;
import com.ssafy.daldong.exercise.model.entity.ExerciseLog;
import com.ssafy.daldong.exercise.model.repository.DailyExerciseLogRepository;
import com.ssafy.daldong.exercise.model.repository.ExerciseLogRepository;
import com.ssafy.daldong.friend.model.entity.Friend;
import com.ssafy.daldong.friend.model.entity.FriendRequest;
import com.ssafy.daldong.friend.model.repository.FriendRepository;
import com.ssafy.daldong.friend.model.repository.FriendRquestRepository;
import com.ssafy.daldong.main.model.entity.Asset;
import com.ssafy.daldong.main.model.entity.UserAsset;
import com.ssafy.daldong.main.model.repository.AssetRepository;
import com.ssafy.daldong.main.model.repository.UserAssetRepository;
import com.ssafy.daldong.user.model.entity.Statistics;
import com.ssafy.daldong.user.model.entity.User;
import com.ssafy.daldong.user.model.repository.StatisticsRepository;
import com.ssafy.daldong.user.model.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Component
@RequiredArgsConstructor
public class DumpData implements CommandLineRunner {

    private final UserRepository userRepository;
    private final StatisticsRepository statisticsRepository;
    private final AssetRepository assetRepository;
    private final UserAssetRepository userAssetRepository;
    private final FriendRepository friendRepository;
    private final FriendRquestRepository friendRquestRepository;
    private final ExerciseLogRepository exerciseLogRepository;
    private final DailyExerciseLogRepository dailyExerciseLogRepository;
    @Override
    public void run(String... args) throws Exception {
        log.info("Asset");
        createAsset();
        log.info("User");
        createUser();
        log.info("createStatistics");
        createStatistics();
        log.info("createUserAsset");
        createUserAsset();
        log.info("createFriend");
        createFriend();
        log.info("createFriendRequest");
        createFriendRequest();
        log.info("createExerciseLog");
        createExerciseLog();
    }

    private void createAsset(){
            List<Asset> assetList = new ArrayList<>();
            Asset sparrow = Asset.builder()
                    .assetType(true)
                .assetName("sparrow")
                .assetUnlockLevel(1)
                .assetPrice(100)
                .build();
        Asset dog = Asset.builder()
                .assetType(true)
                .assetName("dog")
                .assetUnlockLevel(1)
                .assetPrice(100)
                .build();
        Asset bg1 = Asset.builder()
                .assetType(false)
                .assetName("bg1")
                .assetUnlockLevel(1)
                .assetPrice(100)
                .build();
        Asset bg2 = Asset.builder()
                .assetType(false)
                .assetName("bg2")
                .assetUnlockLevel(1)
                .assetPrice(100)
                .build();
        assetList.add(sparrow);
        assetList.add(dog);
        assetList.add(bg1);
        assetList.add(bg2);
        assetRepository.saveAll(assetList);

    }

    private void createUser(){
        Asset mainPet = assetRepository.findById((long) 1).get();
        Asset mainBack = assetRepository.findById((long) 3).get();
        User user1 = User.builder()
                .userUid("user1uid")
                .nickname("user1")
                .height((float)180)
                .weight((float)70)
                .gender(true)
                .age(20)
                .ability(1)
                .userLevel(0)
                .userExp(0)
                .requiredExp(10)
                .userPoint(10)
                .mainPet(mainPet)
                .mainBack(mainBack)
                .mainPetName("짹짹이")
                .build();
        userRepository.save(user1);

        mainPet = assetRepository.findById((long) 2).get();
        mainBack = assetRepository.findById((long) 4).get();
        User user2 = User.builder()
                .userUid("user2uid")
                .nickname("user2")
                .height((float)180)
                .weight((float)70)
                .gender(false)
                .age(25)
                .ability(1)
                .userLevel(0)
                .userExp(0)
                .requiredExp(10)
                .userPoint(10)
                .mainPet(mainPet)
                .mainBack(mainBack)
                .mainPetName("멍멍이")
                .build();
        userRepository.save(user2);
        mainPet = assetRepository.findById((long) 1).get();
        User user3 = User.builder()
                .userUid("user2uid")
                .nickname("user3")
                .height((float)150)
                .weight((float)40)
                .gender(false)
                .age(23)
                .ability(1)
                .userLevel(0)
                .userExp(0)
                .requiredExp(10)
                .userPoint(10)
                .mainPet(mainPet)
                .mainBack(mainBack)
                .mainPetName("짹이")
                .build();
        userRepository.save(user3);

    }

    private void createStatistics(){
        User user = userRepository.findById((long) 1).get();
        statisticsRepository.save(Statistics.builder()
                .user(user)
                .dailyExTime(0)
                .dailyKcal(0)
                .dailyCount(0)
                .dailyFriend(0)
                .build());
    }

    private void createUserAsset(){
        User user = userRepository.findById((long) 1).get();

        List<Asset> assetList = assetRepository.findAll();
        List<UserAsset> userAssetList = new ArrayList<>();
        for (Asset asset: assetList) {
            userAssetList.add(UserAsset.builder()
                    .user(user)
                    .asset(asset)
                    .assetType(asset.isAssetType())
                    .petExp(0)
                    .petName(asset.getAssetName())
                    .build());
        }
        userAssetRepository.saveAll(userAssetList);


    }

    private void createFriend(){
        User user1 = userRepository.findById((long) 1).get();
        User user2 = userRepository.findById((long) 2).get();
        friendRepository.save(Friend.builder()
                .user(user1)
                .friend(user2)
                .isSting(false)
                .build());
        friendRepository.save(Friend.builder()
                .user(user2)
                .friend(user1)
                .isSting(false)
                .build());

    }

    private void createFriendRequest(){
        User user1 = userRepository.findById((long) 1).get();
        User user3 = userRepository.findById((long) 3).get();
        friendRquestRepository.save(FriendRequest.builder()
                .sender(user1)
                .receiver(user3)
                .build());


    }

    private void createExerciseLog(){
        User user = userRepository.findById((long) 1).get();
        exerciseLogRepository.save(ExerciseLog.builder()
                .user(user)
                .exerciseStartTime(LocalDateTime.parse("2023-05-01T11:00:00"))
                .exerciseEndTime(LocalDateTime.parse("2023-05-01T11:30:00"))
                .exerciseTime(LocalTime.parse("00:30:00"))
                .exerciseKcal(100)
                .averageHeart(120)
                .maxHeart(150)
                .exercisePoint(100)
                .exerciseUserExp(100)
                .exercisePetExp(100)
                .exerciseMemo("실내운동")
                .build());
        exerciseLogRepository.save(ExerciseLog.builder()
                .user(user)
                .exerciseStartTime(LocalDateTime.parse("2023-05-01T14:00:00"))
                .exerciseEndTime(LocalDateTime.parse("2023-05-01T14:50:00"))
                .exerciseTime(LocalTime.parse("00:50:00"))
                .exerciseKcal(100)
                .averageHeart(120)
                .maxHeart(150)
                .exercisePoint(100)
                .exerciseUserExp(100)
                .exercisePetExp(100)
                .exerciseMemo("야외운동")
                .build());
        dailyExerciseLogRepository.save(DailyExerciseLog.builder()
                .user(user)
                .exDate(LocalDate.parse("2023-05-01"))
                .exTime(LocalTime.parse("01:20:00"))
                .kcal(200)
                .count(2)
                .point(200)
                .build());

    }


}
