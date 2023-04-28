package com.ssafy.daldong.asset.model.repository;

import com.ssafy.daldong.asset.model.entity.Motion;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MotionRepository extends JpaRepository<Motion, Long> {
}
