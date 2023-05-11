package com.ssafy.daldong.exercise.data.Room

import androidx.room.*
import java.util.concurrent.Flow

@Dao
interface ExerciseResultDao {
    @Query("SELECT * FROM exercise_result")
    fun getAll(): List<ExerciseResult>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(exerciseResult: ExerciseResult)

    @Delete
    suspend fun delete(exerciseResult: ExerciseResult)
}