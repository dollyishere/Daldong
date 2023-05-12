package com.ssafy.daldong.user.model.repository;

import com.ssafy.daldong.user.model.entity.Statistics;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface StatisticsRepository extends JpaRepository<Statistics, Long> {
    Optional<Statistics> findByUser_UserId(Long userId);
}
