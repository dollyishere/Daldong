package com.ssafy.daldong.exercise.service

import android.util.Log
import com.google.gson.JsonObject
import com.ssafy.daldong.exercise.data.Room.ExerciseResult
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Call
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import javax.inject.Inject


class RetrofitExerciseService  @Inject constructor() {

    companion object {
        val TAG = "Retrofit 운동 서비스"
//        const val baseUrl: String = "https://k8a104.p.ssafy.io/test/api/"
      const val baseUrl: String = "http://70.12.247.124:8080/"
        val token = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyVWlkIjoidXNlcjF1aWQiLCJ1c2VySWQiOjEsImlhdCI6MTY4Mzc2OTQ5MCwiZXhwIjoxNzE1MzA1NDkwfQ.vCuovmTOlf4KCROcemtPJUuOvUKsXp1LSKVrjaIMlaY"
        var logging = HttpLoggingInterceptor()
    }

    suspend fun saveExerciseResult(exerciseResult: ExerciseResult): Call<JsonObject> {
        Log.d(TAG, "레트로 핏 시작")
        logging.setLevel(HttpLoggingInterceptor.Level.BASIC)

        val client = OkHttpClient.Builder().addInterceptor { chain ->
            val newRequest = chain.request().newBuilder()
                .addHeader("accessToken", token)
                .build()
            chain.proceed(newRequest)
        }.build()
        Log.d(TAG, "클라이언트 : ${client.toString()}")

        val clientBuilder: OkHttpClient.Builder = OkHttpClient.Builder()
        val loggingInterceptor = HttpLoggingInterceptor()
        loggingInterceptor.setLevel(HttpLoggingInterceptor.Level.BODY)
        clientBuilder.addInterceptor(loggingInterceptor)

        val retrofit = Retrofit.Builder()
            .client(client)
            .baseUrl(baseUrl)
            .addConverterFactory(GsonConverterFactory.create())
            .client(clientBuilder.build()) //  로그를 추가적으로 획득 하기 위해
            .build()
        Log.d(TAG, "레트로핏 : ${retrofit.toString()}")

        val service = retrofit.create(RetrofitInterface::class.java)
        Log.d(TAG, "서비스 : ${service.toString()}")

        return service.saveExerciseResult(exerciseResult)
    }
}