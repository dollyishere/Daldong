package com.ssafy.daldong.main.model.repository;

import com.ssafy.daldong.main.model.entity.Motion;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MotionRepository extends JpaRepository<Motion, Long> {
}
