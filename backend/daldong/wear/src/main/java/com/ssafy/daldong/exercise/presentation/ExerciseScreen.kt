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

import UserInfoViewModel
import android.os.Build
import android.util.Log
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.runtime.*
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import androidx.health.services.client.data.DataPoint
import androidx.health.services.client.data.DataType
import androidx.health.services.client.data.ExerciseState
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.navigation.NavHostController
import androidx.wear.compose.material.*
import coil.ImageLoader
import coil.compose.rememberAsyncImagePainter
import coil.decode.GifDecoder
import coil.decode.ImageDecoderDecoder
import com.ssafy.daldong.R
import com.ssafy.daldong.exercise.Screens
import com.ssafy.daldong.exercise.data.Room.ExerciseResult
import com.ssafy.daldong.exercise.data.ServiceState
import com.ssafy.daldong.exercise.presentation.component.*
import com.ssafy.daldong.exercise.service.ExerciseStateChange
import com.ssafy.daldong.exercise.service.RetrofitExerciseService
import com.ssafy.daldong.exercise.theme.ExerciseTheme
import kotlinx.coroutines.*
import java.time.Duration
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import java.util.*
import kotlin.time.toKotlinDuration
import java.time.ZoneId
import java.time.ZonedDateTime
import java.util.Locale
import java.text.SimpleDateFormat
import java.util.Date


/**
 * Shows while an exercise is in progress
 */

@Composable
fun ExerciseScreen(
    onPauseClick: () -> Unit = {},
    onEndClick: () -> Unit = {},
//    onEndClick: (exerciseResult: ExerciseResult) -> Unit = {},
    onResumeClick: () -> Unit = {},
    onStartClick: () -> Unit = {},
    serviceState: ServiceState,
    navController: NavHostController,
) {
    val chronoTickJob = remember { mutableStateOf<Job?>(null) }

    val zoneId = ZoneId.of("Asia/Seoul")
    val inputFormatter = DateTimeFormatter.ISO_ZONED_DATE_TIME
    val outputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS")

    /** Only collect metrics while we are connected to the Foreground Service. **/
    when (serviceState) {
        is ServiceState.Connected -> {
            val scope = rememberCoroutineScope()
            val getExerciseServiceState by serviceState.exerciseServiceState.collectAsStateWithLifecycle()
            val exerciseMetrics by mutableStateOf(getExerciseServiceState.exerciseMetrics)
            val laps by mutableStateOf(getExerciseServiceState.exerciseLaps)
            val baseActiveDuration = remember { mutableStateOf(Duration.ZERO) }
            var activeDuration by remember { mutableStateOf(Duration.ZERO) }
            val exerciseStateChange by mutableStateOf(getExerciseServiceState.exerciseStateChange)

            /** Collect [DataPoint]s from the aggregate and exercise metric flows. Because
             * collectAsStateWithLifecycle() is asynchronous, store the last known value from each flow,
             * and update the value on screen only when the flow re-connects. **/

            val tempHeartRate = remember { mutableStateOf(0.0) }

            if (exerciseMetrics?.getData(DataType.HEART_RATE_BPM)?.isNotEmpty() == true)
                tempHeartRate.value = exerciseMetrics?.getData(DataType.HEART_RATE_BPM)?.last()?.value!!
            else tempHeartRate.value = tempHeartRate.value

            /**Store previous calorie and distance values to avoid rendering null values from
             * [getExerciseServiceState] flow**/
            val distance = exerciseMetrics?.getData(DataType.DISTANCE_TOTAL)?.total
            val tempDistance = remember { mutableStateOf(0.0) }

            val calories = exerciseMetrics?.getData(DataType.CALORIES_TOTAL)?.total
            val tempCalories = remember { mutableStateOf(0.0) }

            val averageHeartRate = exerciseMetrics?.getData(DataType.HEART_RATE_BPM_STATS)?.average
            val tempAverageHeartRate = remember { mutableStateOf(0.0) }

            /** Update the Pause and End buttons according to [ExerciseState].**/
            val pauseOrResume = when (exerciseStateChange.exerciseState.isPaused) {
                true -> Icons.Default.PlayArrow
                false -> Icons.Default.Pause
            }
            val startOrEnd =
                when (exerciseStateChange.exerciseState.isEnded || exerciseStateChange.exerciseState.isEnding) {
                    true -> Icons.Default.PlayArrow
                    false -> Icons.Default.Stop
                }

            val startTime = LocalDateTime.now().atZone(ZoneId.systemDefault()).toString()
            val zonedStartTime = ZonedDateTime.parse(startTime, inputFormatter)
            val localDateStartTime = zonedStartTime.toLocalDateTime()
            val formattedStartDateTime = localDateStartTime.format(outputFormatter)

            val exerciseResult = remember {
                ExerciseResult(
                    uid = "LgjoMubicOZEUdRowUmhaXtWP5o2",
                    caloriesHistory = mutableListOf(),
                    heartRateHistory = mutableListOf(),
                    elapsedTime = "",
                    startTime = formattedStartDateTime,
                    endTime = formattedStartDateTime,
                    calories = "0.0",
                    heartRate = 0,
                    distance = "0.0",
                )
            }

            val caloriesHistory = exerciseResult.caloriesHistory
            val heartRateHistory = exerciseResult.heartRateHistory

            // The ticker coroutine updates activeDuration, but the ticker fires more often than
            // once a second, so we use derivedStateOf to update the elapsedTime state only when
            // the string representing the time on the screen changes. Recomposition then only
            // happens when elapsedTime changes, so once a second.

            val elapsedTime = derivedStateOf {
                formatElapsedTime(activeDuration.toKotlinDuration(), true).toString()
            }

            val imageLoader = ImageLoader.Builder(LocalContext.current)
                .components {
                    if (Build.VERSION.SDK_INT >= 28) {
                        add(ImageDecoderDecoder.Factory())
                    } else {
                        add(GifDecoder.Factory())
                    }
                }
                .build()


            // Instead of watching the ExerciseState state, or active duration, I've defined a
            // ExerciseStateChange object in the service (and exposed it in the view), which is only
            // updated in the service when it transitions from one State to another.
            // This means that when the exercise state changes to ACTIVE, on that first transition
            // then again, the ticker is started, or if the state is no longer ACTIVE, the ticker is
            // stopped.
            // Also, the ExerciseStateChange object, when active, has an ActiveDurationCheckpoint
            // which allows the base ActiveDuration to be set. This is again set in the service and
            // avoids exposing ActiveDuration as state to compose, which could cause recomposition,
            // and you want the ActiveDurationCheckpoint to be associated with exactly when the
            // state changed to active.

            /*
            ExerciseStateChange 객체는 서비스에서 정의되며, 운동 상태가 변경될 때만 업데이트 됨.
            ExerciseStateChange 객체는 운동 상태가 ACTIVE로 변경되면 타이머를 시작,
            운동 상태가 ACTIVE가 아니면 타이머를 중지.

            또한, ExerciseStateChange 객체는 운동 상태가 ACTIVE일 때 ActiveDurationCheckpoint를 가지며,
            이를 통해 기본 ActiveDuration을 설정할 수 있습니다.
            ActiveDurationCheckpoint는 서비스에서 설정되며, ActiveDuration을 Compose에 노출하지 않습니다.

            이렇게 하면 Compose가 재구성되지 않으며, ActiveDurationCheckpoint가 운동 상태가
            ACTIVE로 변경된 정확한 시점에 연결되게 됩니다.

            좀 더 자세히 설명하자면, ExerciseStateChange 객체는 다음과 같은 속성을 가지고 있습니다.
            exerciseState: 운동 상태
            activeDuration: 운동 중 경과된 시간
            activeDurationCheckpoint: 운동 상태가 ACTIVE로 변경된 시점

            ExerciseStateChange 객체는 서비스에서 onExerciseStateChanged() 메서드를 통해 업데이트됩니다.
            이 메서드는 운동 상태가 변경될 때마다 호출됩니다.

            ExerciseStateChange 객체는 Compose에서 exerciseStateChange 값으로 노출됩니다.
            exerciseStateChange 값은 ExerciseStateChange 객체의 exerciseState 속성입니다.
            exerciseStateChange 값을 사용하여 운동 상태를 확인하고,
            운동 중 경과된 시간과 운동 상태가 ACTIVE로 변경된 시점을 확인할 수 있습니다
            */

            LaunchedEffect(exerciseStateChange) {
                if (exerciseStateChange is ExerciseStateChange.ActiveStateChange
                ) {
                    val activeStateChange = exerciseStateChange as ExerciseStateChange.ActiveStateChange

                    val timeOffset = (System.currentTimeMillis() - activeStateChange.durationCheckPoint.time.toEpochMilli())
                    baseActiveDuration.value = activeStateChange.durationCheckPoint.activeDuration.plusMillis(timeOffset)
                    chronoTickJob.value = startTick(
                        chronoTickJob = chronoTickJob.value,
                        scope = scope,
                        block = { tickerTime ->
                            activeDuration = baseActiveDuration.value.plusMillis(tickerTime)
                        },
                        tempAverageHeartRate = tempAverageHeartRate,
                        averageHeartRate = averageHeartRate,
                        tempCalories = tempCalories,
                        calories = calories,
                        heartRateHistory = heartRateHistory,
                        caloriesHistory = caloriesHistory
                    )
                } else {
                    println("운동 종료와 경과 시간 : ${activeDuration}")
                    chronoTickJob.value?.cancel()
                }
            }

            ExerciseTheme {
                Scaffold(
//                    timeText = { TimeText( timeSource = TimeTextDefaults.timeSource(
//                            TimeTextDefaults.timeFormat())) }
                ) {
                    Column(
                        modifier = Modifier
                            .fillMaxSize()
                            .background(MaterialTheme.colors.background),
                        verticalArrangement = Arrangement.Center
                    ) {
                        Row(
                            // 시계
                            horizontalArrangement = Arrangement.Center,
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(5.dp),
                        ) {
                            Icon(
                                imageVector = Icons.Default.WatchLater,
                                contentDescription = stringResource(id = R.string.duration),
//                            modifier = Modifier.size(24.dp)
                            )
                            Text(
                                text = elapsedTime.value,
                                color = Color(0xFFC4E8C2),
                                modifier = Modifier.padding(start = 4.dp)
                            )
                        }

                        Row( // 칼로리
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.Center
                        ) {
                            Image(
                                painter = painterResource(id = R.drawable.calorie),
                                contentDescription = stringResource(id = R.string.calories)
                            )

                            if (calories != null) {
                                CaloriesText(calories)
                                tempCalories.value = calories
                            } else {
                                CaloriesText(tempCalories.value)
                            }
                        }

                        Row(
                            horizontalArrangement = Arrangement.Center,
                            modifier = Modifier.fillMaxWidth(),
                        ){
                            Column(
                                verticalArrangement = Arrangement.Center,
                                modifier = Modifier.height(90.dp)
//                                modifier = Modifier.padding(5.dp)
                            ) {
                                // 운동 종료
                                if (exerciseStateChange.exerciseState.isEnding || exerciseStateChange.exerciseState.isEnded) {
                                    //In a production fitness app, you might upload workout metrics to your app
                                    // either via network connection or to your mobile app via the Data Layer API.

                                    //to execute the suspend function withContext within the LaunchedEffect block.
                                    // By using coroutineScope,
                                    // you ensure that the suspend function is executed within a valid coroutine context.
                                    // val coroutineScope = rememberCoroutineScope()

                                    val endTime = LocalDateTime.now().atZone(ZoneId.systemDefault()).toString()
                                    val zonedEndTime = ZonedDateTime.parse(endTime, inputFormatter)
                                    val localDateEndTime = zonedEndTime.toLocalDateTime()
                                    val formattedEndDateTime = localDateEndTime.format(outputFormatter)

                                    exerciseResult.endTime = formattedEndDateTime
                                    exerciseResult.heartRate = tempAverageHeartRate.value.toInt()
                                    exerciseResult.distance = formatDistanceKm(tempDistance.value).toString()
                                    exerciseResult.calories = formatCalories(tempCalories.value).toString()
                                    exerciseResult.elapsedTime = formatElapsedTime(activeDuration.toKotlinDuration(), true).toString()

                                    println("총 결과 출력 : ${exerciseResult.toString()}")

                                    navController.navigate(
                                        Screens.SummaryScreen.route + "/" +
                                                "${tempAverageHeartRate.value.toInt()} bpm/" +
                                                "${formatDistanceKm(tempDistance.value)} km/" +
                                                "${formatCalories(tempCalories.value)} kcal/" +
                                                formatElapsedTime(activeDuration.toKotlinDuration(), true).toString()
                                    ) { popUpTo(Screens.ExerciseScreen.route) { inclusive = true } }

//                                    LaunchedEffect(Unit) {
//                                        // Retrofit을 사용한 비동기 호출을 위한 코루틴입니다.
////
//                                        try {
//                                            val response = withContext(Dispatchers.IO) {
//                                                RetrofitExerciseService().saveExerciseResult(exerciseResult)
//                                            }
//                                            // 결과 처리
//                                            if (response.isSuccessful) {
//                                                // 성공적인 응답인 경우 (응답 코드가 200인 경우)
//                                                val responseData = response.body()
//                                                // responseData를 처리하는 코드 작성
//                                                Log.d("운동 결과 화면", "운동 결과 전송 성공 ${responseData}")
//                                            }else {
//                                                // 서버로부터 에러 응답이 온 경우 (응답 코드가 400 등인 경우)
//                                                val errorCode = response.code()
//                                                val errorBody = response.errorBody()?.string()
//                                                Log.d("운동 결과 화면", "HTTP 요청 실패 - 코드: $errorCode, 에러 메시지: $errorBody")
//                                                // 에러 처리 로직을 추가하여 사용자에게 알림 또는 적절한 조치를 취할 수 있습니다.
//                                            }
//
//                                        }catch (e: retrofit2.HttpException) {
//                                            // HTTP 요청 실패 처리
//                                            val errorCode = e.code()
//                                            val errorBody = e.response()?.errorBody()?.string()
//                                            Log.d("운동 결과 화면", "HTTP 요청 실패 - 코드: $errorCode, 에러 메시지: $errorBody")
//
//                                        }catch (e: Exception) {
//                                            // 에러 처리
//                                            Log.d("운동 결과 화면", "운동 결과 전송 에러 : ${e.toString()}")
//                                        }
//
//                                        navController.navigate(
//                                            Screens.SummaryScreen.route + "/" +
//                                                    "${tempAverageHeartRate.value.toInt()} bpm/" +
//                                                    "${formatDistanceKm(tempDistance.value)} km/" +
//                                                    "${formatCalories(tempCalories.value)} kcal/" +
//                                                    formatElapsedTime(activeDuration.toKotlinDuration(), true).toString()
//                                        ) { popUpTo(Screens.ExerciseScreen.route) { inclusive = true } }
//                                    }

//                                Button(onClick = { onStartClick() }) {
//                                    Icon(
//                                        imageVector = startOrEnd,
//                                        contentDescription = stringResource(id = R.string.startOrEnd)
//                                    )
//                                }

                                } else {
                                    // 운동 시작 중일 때
                                    if (!(exerciseStateChange.exerciseState.isEnded || exerciseStateChange.exerciseState.isEnding)){
                                        Button(
//                                        onClick = { onEndClick(exerciseResult) },
                                            onClick = { onEndClick() },
//                                    Modifier.size(40.dp)
                                        ) {
                                            Icon(
                                                imageVector = startOrEnd,
                                                contentDescription = stringResource(id = R.string.startOrEnd)
                                            )
                                        }
                                    }else{

                                    }
                                }
                            }
                            Column(
                                verticalArrangement = Arrangement.Center,
//                                modifier = Modifier.fillMaxHeight().padding(10.dp)
                                modifier = Modifier
                                    .height(90.dp)
                                    .padding(10.dp)
                            ){
                                
//                                 운동 중 GIF
                                if (exerciseStateChange.exerciseState.isPaused) {
                                    Image(
                                        painter = rememberAsyncImagePainter(R.drawable.sparrow_sit, imageLoader),
                                        contentDescription = "",
                                    )
                                } else {
                                    Image(
                                        painter = rememberAsyncImagePainter(R.drawable.sparrow_run, imageLoader),
                                        contentDescription = "",
                                    )
                                }
                            }
                            Column(
                                verticalArrangement = Arrangement.Center,
                                modifier = Modifier.height(90.dp)
//                                modifier = Modifier.padding(5.dp)
                            ){
                                //운동 정지 관련
                                // 운동 중일 떄
                                if((!(exerciseStateChange.exerciseState.isEnded || exerciseStateChange.exerciseState.isEnding))){
                                    if (exerciseStateChange.exerciseState.isPaused) {
                                        Button(
                                            onClick = { onResumeClick() },
//                                    Modifier.size(40.dp)
                                        ) {
                                            Icon(
                                                imageVector = pauseOrResume,
                                                contentDescription = stringResource(id = R.string.pauseOrResume)
                                            )
                                        }
                                    } else {
                                        Button(
                                            onClick = { onPauseClick() },
//                                        Modifier.size(40.dp)
                                        ) {
                                            Icon(
                                                imageVector = pauseOrResume,
                                                contentDescription = stringResource(id = R.string.pauseOrResume)
                                            )
                                        }
                                    }
                                }else{
                                    
                                }
                            }
                        }
                        Row(
                            horizontalArrangement = Arrangement.Center,
                            modifier = Modifier.fillMaxWidth()
                        ) {
//                            Icon(
//                                imageVector = Icons.Default.Watch,
//                                contentDescription = stringResource(id = R.string.duration)
//                            )
//                            Text(elapsedTime.value)
                        }

                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.Center
                        ) {
                            Image(
                                painter = painterResource(id = R.drawable.heart),
                                contentDescription = stringResource(id = R.string.heart_rate)
                            )

                            HRText(
                                hr = tempHeartRate.value
                            )
                            if (averageHeartRate != null) {
                                tempAverageHeartRate.value = averageHeartRate
                            }
                        }

                        Row( // 이동 거리
                            modifier = Modifier
                                .fillMaxWidth()
                                .padding(5.dp),
                            horizontalArrangement = Arrangement.Center
                        ) {
                            Icon(
                                imageVector = Icons.Default.DirectionsRun,
                                contentDescription = stringResource(id = R.string.distance)
                            )
                            if (distance != null) {
                                DistanceText(
                                    distance
                                )
                                tempDistance.value = distance
                            } else {
                                DistanceText(
                                    tempDistance.value
                                )
                            }
                        }
                    }
                }
            }
        }

        else -> {
            println("여기는 뭘까")
        }
    }
}

// A coroutine is used to update a ticker whilst the exercise is active. This is necessary because
// WHS might not give us ExerciseUpdates every second on some devices. So the transition to the
// Active state is used to start the ticker, but once started, delivery of ExerciseUpdates shouldn't
// be relied on to make each tick, instead using the coroutine.
private fun startTick(
    chronoTickJob: Job?,
    scope: CoroutineScope,
    block: (tickTime: Long) -> Unit,
    tempAverageHeartRate: MutableState<Double>,
    averageHeartRate: Double?,
    tempCalories: MutableState<Double>,
    calories: Double?,
    caloriesHistory: MutableList<Double>, // 운동 중에 쌓인 칼로리 기록 리스트
    heartRateHistory: MutableList<Double> // 운동 중에 쌓인 심박수 기록 리스트
): Job? {
    if (chronoTickJob == null || !chronoTickJob.isActive) {
        return scope.launch {
            val tickStart = System.currentTimeMillis()
            while (isActive) {
                val tickSpan = System.currentTimeMillis() - tickStart

                if (calories != null) {
                    tempCalories.value = calories
                    caloriesHistory.add(tempCalories.value)
                }else{
                    caloriesHistory.add(tempCalories.value)
                }
//                println("칼로리 : ${tempCalories.value}, 큐 사이즈: ${caloriesHistory.size}")

                if (averageHeartRate != null) {
                    tempAverageHeartRate.value = averageHeartRate
                    heartRateHistory.add(tempAverageHeartRate.value)
                }else{
                    heartRateHistory.add(tempAverageHeartRate.value)
                }
//                println("심박수 : ${tempAverageHeartRate.value} 심박수 큐 사이즈: ${heartRateHistory.size}")

                block(tickSpan)
                delay(CHRONO_TICK_MS)
            }
        }
    }
    return null
}

const val CHRONO_TICK_MS = 1000L

//출력
private fun printResult(
    exerciseResult: ExerciseResult
) {
    println("칼로리 결과 출력 ${exerciseResult.caloriesHistory}")

    var iterator = exerciseResult.caloriesHistory.iterator()
    while (iterator.hasNext()) {
        val element = iterator.next()
        print("${element}, ")
    }

    println()

    println("심박수 결과 출력 ${exerciseResult.heartRateHistory}")
    iterator = exerciseResult.heartRateHistory.iterator()
    while (iterator.hasNext()) {
        val element = iterator.next()
        print("${element}, ")
    }

    println()

    println("총 결과 출력")
    exerciseResult.toString()
}