package com.ssafy.daldong.auth.service;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;
import com.ssafy.daldong.auth.model.dto.response.AuthResDto;
import com.ssafy.daldong.main.model.repository.AssetRepository;
import com.ssafy.daldong.user.model.entity.User;
import com.ssafy.daldong.user.model.repository.UserAuthRepository;
import com.ssafy.daldong.user.model.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService{

    private final UserAuthRepository userAuthRepository;
    private final UserRepository userRepository;
    private final FirebaseAuth firebaseAuth;
    private final AssetRepository assetRepository;

    public AuthResDto authenticateUser(String idToken) {
        try {
            FirebaseToken decodedToken = firebaseAuth.verifyIdToken(idToken);
            String uId = decodedToken.getUid();
            boolean userExists = true;
            if (!userAuthRepository.existsByUserUid(uId)){
                System.out.println("new user");
                userExists = false;
                try {
                    userRepository.save(User.builder()
                            .userUid(uId)
                            .mainPet(assetRepository.findDefaultPet())
                            .mainBack(assetRepository.findDefaultBg())
                            .build());
                } catch (DataIntegrityViolationException e){
                    e.getStackTrace();
                    throw new DataIntegrityViolationException("Failed to save user");
                }
            }
            return AuthResDto.builder()
                        .uId(uId)
                        .userExists(userExists)
                        .build();
            // You can add additional checks here to validate the user before returning the uid
        } catch (FirebaseAuthException e) {
            throw new RuntimeException("Failed to authenticate user", e);
        }

    }

    @Override
    public User getUserByUid(String uid) {
        return userAuthRepository.findByUserUid(uid);
    }

}
