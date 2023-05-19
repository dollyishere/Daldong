/*
 * Copyright 2022 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.ssafy.daldong.exercise.presentation

import android.Manifest
import android.util.Log
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.remember
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.ssafy.daldong.exercise.data.HealthServicesRepository
import com.ssafy.daldong.exercise.data.Room.ExerciseResult
import com.ssafy.daldong.exercise.data.ServiceState
import com.ssafy.daldong.exercise.service.RetrofitExerciseService
import com.ssafy.daldong.exercise.service.RetrofitInterface
import dagger.hilt.android.lifecycle.HiltViewModel
import kotlinx.coroutines.Dispatchers
import javax.inject.Inject
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import okhttp3.OkHttpClient
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.create

/** Data class for the initial values we need to check before a user starts an exercise **/
data class ExerciseUiState(
    val hasExerciseCapabilities: Boolean = true,
    val isTrackingAnotherExercise: Boolean = false,
)

@HiltViewModel
class ExerciseViewModel @Inject constructor(
    private val healthServicesRepository: HealthServicesRepository,
    private val retrofitExerciseService: RetrofitExerciseService
) : ViewModel() {

    companion object {
        val TAG = "운동 뷰 모델"
        const val baseUrl: String = "https://k8a104.p.ssafy.io/test/api/"
        val token = "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyVWlkIjoidXNlcjF1aWQiLCJ1c2VySWQiOjEsImlhdCI6MTY4Mzc2OTQ5MCwiZXhwIjoxNzE1MzA1NDkwfQ.vCuovmTOlf4KCROcemtPJUuOvUKsXp1LSKVrjaIMlaY"
    }

    val permissions = arrayOf(
        Manifest.permission.BODY_SENSORS,
        Manifest.permission.ACCESS_FINE_LOCATION,
        Manifest.permission.ACTIVITY_RECOGNITION
    )

    val uiState: StateFlow<ExerciseUiState> = flow {
        emit(
            ExerciseUiState(
                hasExerciseCapabilities = healthServicesRepository.hasExerciseCapability(),
                isTrackingAnotherExercise = healthServicesRepository.isTrackingExerciseInAnotherApp(),
            )
        )
    }.stateIn(
        viewModelScope,
        SharingStarted.WhileSubscribed(3_000),
        ExerciseUiState()
    )

    private var _exerciseServiceState: MutableState<ServiceState> = healthServicesRepository.serviceState
    val exerciseServiceState = _exerciseServiceState

    init {
        viewModelScope.launch {
            healthServicesRepository.createService()
        }
        Log.d("ExerciseViewModel 처음", permissions.joinToString())
    }

    suspend fun isExerciseInProgress(): Boolean {
        return healthServicesRepository.isExerciseInProgress()
    }

    suspend fun prepareExercise() = viewModelScope.launch { healthServicesRepository.prepareExercise() }
    suspend fun startExercise() = viewModelScope.launch { healthServicesRepository.startExercise() }
    suspend fun pauseExercise() = viewModelScope.launch { healthServicesRepository.pauseExercise() }
    suspend fun endExercise() = viewModelScope.launch {

//    fun endExercise(exerciseResult : ExerciseResult) = viewModelScope.launch {
        healthServicesRepository.endExercise()
        Log.d(TAG, "운동 종료")

//        try {
//            val response = withContext(Dispatchers.IO) {
//                RetrofitExerciseService().saveExerciseResult(exerciseResult)
//            }
//            // Handle the response
//            Log.d("운동 결과 화면", "운동 결과 전송 성공 ${response.toString()}")
//        } catch (e: Exception) {
//            // Handle the error
//            Log.d("운동 결과 화면", "운동 결과 전송 에러 : ${e.toString()}")
//        }

    }
    fun resumeExercise() = viewModelScope.launch { healthServicesRepository.resumeExercise() }

    override fun toString(): String {
        return "ExerciseViewModel(uiState=$uiState, exerciseServiceState=$exerciseServiceState)"
    }

}