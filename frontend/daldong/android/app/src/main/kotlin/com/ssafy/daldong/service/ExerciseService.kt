package com.ssafy.daldong.service

import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

class ExerciseService {

    companion object {
        val TAG: String? = this::class.qualifiedName
        const val baseUrl: String = "https://k8a104.p.ssafy.io/"

        var retrofit: Retrofit = Retrofit.Builder()
            .baseUrl(baseUrl)
            .addConverterFactory(GsonConverterFactory.create())
            .build();

        var service = retrofit.create(RetrofitService::class.java);
    }
}