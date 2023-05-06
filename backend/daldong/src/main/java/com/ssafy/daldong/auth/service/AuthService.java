package com.ssafy.daldong.auth.service;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;
import com.ssafy.daldong.user.model.entity.User;
import org.springframework.stereotype.Service;

@Service
public interface AuthService {


    public String authenticateUser(String idToken);

    public User getUserByUid(String uid);
}
