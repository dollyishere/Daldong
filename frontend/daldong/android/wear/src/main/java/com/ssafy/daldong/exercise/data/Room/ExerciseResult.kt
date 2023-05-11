package com.ssafy.daldong.exercise.data.Room

import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "exercise_result")
data class ExerciseResult(
    @PrimaryKey(autoGenerate = true)
    val id: Long = 0,
    val time: Int,
    val distance: Int,
    val heartRate: Int,
    val calories: Int,
    val timestamp: Long
)