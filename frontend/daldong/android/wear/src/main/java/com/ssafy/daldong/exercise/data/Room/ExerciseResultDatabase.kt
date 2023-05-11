package com.ssafy.daldong.exercise.data.Room

import android.content.Context
import android.text.SpannedString
import androidx.room.*


@Database(entities = [ExerciseResult::class], version = 1)
@TypeConverters(SpannedStringConverter::class)
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

class SpannedStringConverter {
    @TypeConverter
    fun fromSpannedString(value: SpannedString?): String? {
        return value?.toString()
    }

    @TypeConverter
    fun toSpannedString(value: String?): SpannedString? {
        return value?.let { SpannedString(it) }
    }
}