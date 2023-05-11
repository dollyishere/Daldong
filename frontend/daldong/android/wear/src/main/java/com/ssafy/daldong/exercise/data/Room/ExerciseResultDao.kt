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

//@Dao
//interface UserDao {
//    @Query("SELECT * FROM user")
//    fun getAll(): List<User>
//
//    @Query("SELECT * FROM user WHERE uid IN (:userIds)")
//    fun loadAllByIds(userIds: IntArray): List<User>
//
//    @Query("SELECT * FROM user WHERE first_name LIKE :first AND " +
//            "last_name LIKE :last LIMIT 1")
//    fun findByName(first: String, last: String): User
//
//    @Insert
//    fun insertAll(vararg users: User)
//
//    @Delete
//    fun delete(user: User)
//}