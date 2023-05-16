package com.ssafy.daldong.exercise.service

import com.google.gson.JsonObject
import com.ssafy.daldong.exercise.data.Room.ExerciseResult
import retrofit2.Call
import retrofit2.Response
import retrofit2.http.Body
import retrofit2.http.POST

interface RetrofitInterface {
    @POST("exercise")
    suspend fun saveExerciseResult(
        @Body exerciseResult: ExerciseResult
    ): Call<JsonObject>
}