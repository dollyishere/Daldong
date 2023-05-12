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

import android.text.SpannedString
import android.util.Log
import androidx.compose.foundation.background
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.res.stringResource
import androidx.health.services.client.data.DataPoint
import androidx.health.services.client.data.DataType
import androidx.health.services.client.data.ExerciseState
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.navigation.NavHostController
import androidx.wear.compose.material.Button
import androidx.wear.compose.material.Icon
import androidx.wear.compose.material.MaterialTheme
import androidx.wear.compose.material.Scaffold
import androidx.wear.compose.material.Text
import com.ssafy.daldong.exercise.Screens
import com.ssafy.daldong.exercise.service.ExerciseStateChange
import com.ssafy.daldong.R
import com.ssafy.daldong.exercise.data.ServiceState
import com.ssafy.daldong.exercise.presentation.component.*
import com.ssafy.daldong.exercise.theme.ExerciseTheme
import java.time.Duration
import kotlin.time.toKotlinDuration
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.*
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.unit.dp
import androidx.compose.runtime.*
import androidx.compose.ui.graphics.Color
import androidx.core.text.buildSpannedString
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter
import java.util.*

/**
 * Shows while an exercise is in progress
 */
data class ExerciseScreenState(
    val caloriesHistory: MutableList<Double>, // 운동 중에 쌓인 칼로리 기록
    val heartRateHistory: MutableList<Double>, // 운동 중에 쌓인 심박수 기록
    var elapsedTime: String, // 운동 경과 시간
    val startTime : LocalDateTime,
    var endTime : LocalDateTime,
    var calories: SpannedString,
    var heartRate: Int = 0,
    var distance: SpannedString,
)

@Composable
fun ExerciseScreen(
    onPauseClick: () -> Unit = {},
    onEndClick: () -> Unit = {},
    onResumeClick: () -> Unit = {},
    onStartClick: () -> Unit = {},
    serviceState: ServiceState,
    navController: NavHostController,
) {
    val chronoTickJob = remember { mutableStateOf<Job?>(null) }
    val formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSSSSS")

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

            val exerciseScreenState = remember { ExerciseScreenState(
                caloriesHistory = mutableListOf(),
                heartRateHistory = mutableListOf(),
                elapsedTime = "",
                startTime = LocalDateTime.now(),
                endTime = LocalDateTime.now(),
                calories = buildSpannedString { append("0.0") },
                heartRate = 0,
                distance = buildSpannedString { append("0.0") },
            ) }

            val caloriesHistory = exerciseScreenState.caloriesHistory
            val heartRateHistory = exerciseScreenState.heartRateHistory
//            val startTime = exerciseScreenState.startTime
//            var calories = exerciseScreenState.calories
//            val heartRate = exerciseScreenState.heartRate
//            var distance = exerciseScreenState.distance

            // The ticker coroutine updates activeDuration, but the ticker fires more often than
            // once a second, so we use derivedStateOf to update the elapsedTime state only when
            // the string representing the time on the screen changes. Recomposition then only
            // happens when elapsedTime changes, so once a second.

            val elapsedTime = derivedStateOf {
                formatElapsedTime(activeDuration.toKotlinDuration(), true).toString()
            }

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
                        Row( // 시계
                            horizontalArrangement = Arrangement.Center,
                            modifier = Modifier.fillMaxWidth().padding(5.dp),
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
                                    Log.d("운동 스크린", "운동 끝")

                                    //In a production fitness app, you might upload workout metrics to your app
                                    // either via network connection or to your mobile app via the Data Layer API.
                                    
                                    exerciseScreenState.endTime = LocalDateTime.now()
                                    exerciseScreenState.heartRate = tempAverageHeartRate.value.toInt()
                                    exerciseScreenState.distance = formatDistanceKm(tempDistance.value)
                                    exerciseScreenState.calories = formatCalories(tempCalories.value)
                                    exerciseScreenState.elapsedTime = formatElapsedTime(activeDuration.toKotlinDuration(), true).toString()

//                                    printResult(exerciseScreenState)
                                    println("총 결과 출력 : ${exerciseScreenState.toString()}")

                                    navController.navigate(
                                        Screens.SummaryScreen.route + "/" +
                                                "${tempAverageHeartRate.value.toInt()} bpm/" +
                                                "${formatDistanceKm(tempDistance.value)} km/" +
                                                "${formatCalories(tempCalories.value)} kcal/" +
                                                formatElapsedTime(activeDuration.toKotlinDuration(), true).toString()
                                    ) { popUpTo(Screens.ExerciseScreen.route) { inclusive = true } }

//                                Button(onClick = { onStartClick() }) {
//                                    Icon(
//                                        imageVector = startOrEnd,
//                                        contentDescription = stringResource(id = R.string.startOrEnd)
//                                    )
//                                }

                                } else { // 운동 시작 중일 때
                                    Button(
                                        onClick = { onEndClick() },
//                                    Modifier.size(40.dp)
                                    ) {
                                        Icon(
                                            imageVector = startOrEnd,
                                            contentDescription = stringResource(id = R.string.startOrEnd)
                                        )
                                    }
                                }
                            }
                            Column(
                                verticalArrangement = Arrangement.Center,
//                                modifier = Modifier.fillMaxHeight().padding(10.dp)
                                modifier = Modifier.height(90.dp).padding(10.dp)
                            ){
                                Image(
                                    painter = painterResource(id = R.drawable.sparrow),
                                    contentDescription = ""
                                )
                            }
                            Column(
                                verticalArrangement = Arrangement.Center,
                                modifier = Modifier.height(90.dp)
//                                modifier = Modifier.padding(5.dp)
                            ){
                                //운동 정지
                                if (exerciseStateChange.exerciseState.isPaused) {
                                    Button(
                                        onClick = { onResumeClick() },
//                                    Modifier.size(40.dp)
                                    ) {
                                        Icon(
                                            imageVector = pauseOrResume,
                                            contentDescription = stringResource(id = R.string.pauseOrResume)
                                        )
//                                    Image(
//                                        painter = painterResource(id = pauseOrResume),
//                                        contentDescription = stringResource(id = R.string.pauseOrResume),
////                                        modifier = Modifier.size(24.dp)
//                                    )
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
                            modifier = Modifier.fillMaxWidth().padding(5.dp),
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
    exerciseResult: ExerciseScreenState
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