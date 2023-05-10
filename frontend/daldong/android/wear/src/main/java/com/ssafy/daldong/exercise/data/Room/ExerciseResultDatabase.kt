package com.ssafy.daldong.exercise.data.Room

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase

@Database(entities = [ExerciseResult::class], version = 1)
abstract class ExerciseResultDatabase : RoomDatabase() {
    abstract fun exerciseResultDao(): ExerciseResultDao
    companion object {
        @Volatile
        private var INSTANCE: ExerciseResultDatabase? = null

        fun getDatabase(context: Context): ExerciseResultDatabase {
            return INSTANCE ?: synchronized(this) {
                val instance = Room.databaseBuilder(
                    context.applicationContext,
                    ExerciseResultDatabase::class.java,
                    "exercise_result_database"
                ).build()
                INSTANCE = instance
                instance
            }
        }
    }
}

@Database(entities = [User::class], version = 1)
abstract class AppDatabase : RoomDatabase() {
    abstract fun userDao(): UserDao

}