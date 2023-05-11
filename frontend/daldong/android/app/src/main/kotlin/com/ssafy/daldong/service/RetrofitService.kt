package com.ssafy.daldong.service

import com.google.gson.JsonObject
import retrofit2.Call
import retrofit2.http.GET
import retrofit2.http.Path

interface RetrofitService {
    @GET("test")
    fun test(): Call<JsonObject>

    @GET("query/{msg}")
    fun test(@Path("msg") msg: String): Call<JsonObject>

//    @POST("web3/license")
//    fun setDoctor(@Body doctor: RequestDoctorDTO): Call<JsonObject>
}