package com.ssafy.daldong.exercise.data.Room

import android.content.Context

class ExerciseResultRepository(context: Context) {
    private val exerciseResultDao: ExerciseResultDao

    init {
        val db = ExerciseResultDatabase.getDatabase(context)
        exerciseResultDao = db.exerciseResultDao()
    }

    fun getAll(): List<ExerciseResult> {
        return exerciseResultDao.getAll()
    }

    suspend fun insert(exerciseResult: ExerciseResult) {
        exerciseResultDao.insert(exerciseResult)
    }

    suspend fun delete(exerciseResult: ExerciseResult) {
        exerciseResultDao.delete(exerciseResult)
    }
}
