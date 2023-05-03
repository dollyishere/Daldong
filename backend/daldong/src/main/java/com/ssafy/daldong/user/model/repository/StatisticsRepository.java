package com.ssafy.daldong.user.model.repository;

import com.ssafy.daldong.user.model.entity.Statistics;
import org.springframework.data.jpa.repository.JpaRepository;

public interface StatisticsRepository extends JpaRepository<Statistics, Long> {
    Statistics findByUser_UserId(Long userId);
}
