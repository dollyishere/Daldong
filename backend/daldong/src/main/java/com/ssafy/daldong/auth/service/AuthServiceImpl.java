package com.ssafy.daldong.auth.service;

import com.google.firebase.FirebaseException;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;
import com.ssafy.daldong.user.model.entity.User;
import com.ssafy.daldong.user.model.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService{

    private final UserRepository userRepository;
    private final FirebaseAuth firebaseAuth;

    public String authenticateUser(String idToken) {
        try {
            FirebaseToken decodedToken = firebaseAuth.verifyIdToken(idToken);
            String uid = decodedToken.getUid();
            // You can add additional checks here to validate the user before returning the uid
            return uid;
        } catch (FirebaseAuthException e) {
            throw new RuntimeException("Failed to authenticate user", e);
        }
    }

    @Override
    public User getUserByUid(String uid) {
        return userRepository.findByUserUid(uid);
    }

}
