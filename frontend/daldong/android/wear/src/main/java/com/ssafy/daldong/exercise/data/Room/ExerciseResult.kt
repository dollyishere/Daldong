package com.ssafy.daldong.exercise.data.Room

import android.text.SpannedString
import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "exercise_result")
data class ExerciseResult(
    @PrimaryKey(autoGenerate = true)
    val id: Long = 0,
    val startTime: String,
    val endTime: String,
    val distance: SpannedString,
    val heartRate: Int,
    val calories: SpannedString,
    val timestamp: String
)