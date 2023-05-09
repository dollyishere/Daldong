package com.ssafy.daldong.main.model.service;

import com.ssafy.daldong.main.model.dto.MainpageDTO;
import com.ssafy.daldong.user.model.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;

@Service
@RequiredArgsConstructor
@Transactional
public class MainpageServiceImpl implements MainpageService{

    private final UserRepository userRepository;


    @Override
    public MainpageDTO mainpage(String uid) {
        MainpageDTO mainpageDTO= new MainpageDTO().fromEntity(userRepository.findByUserUid(uid));
        return mainpageDTO;
    }
}
