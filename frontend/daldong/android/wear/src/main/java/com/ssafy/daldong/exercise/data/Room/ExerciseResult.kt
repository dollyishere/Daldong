package com.ssafy.daldong.exercise.data.Room

import androidx.lifecycle.LiveData
import androidx.room.Entity
import androidx.room.PrimaryKey
import androidx.room.TypeConverter
import androidx.room.TypeConverters
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken

@Entity(tableName = "exercise_result")
@TypeConverters(Converters::class)
data class ExerciseResult(
    @PrimaryKey
    val userId: String,
    val caloriesHistory: MutableList<Double>,
    val heartRateHistory: MutableList<Double>,
    var elapsedTime: String,
    val startTime: String,
    var endTime: String,
    var calories: String,
    var heartRate: Int = 0,
    var distance: String,
)

object Converters {
    @TypeConverter
    @JvmStatic
    fun fromDoubleList(list: List<Double>): String {
        return Gson().toJson(list)
    }

    @TypeConverter
    @JvmStatic
    fun toDoubleList(json: String): List<Double> {
        return Gson().fromJson(json, object : TypeToken<List<Double>>() {}.type)
    }
}