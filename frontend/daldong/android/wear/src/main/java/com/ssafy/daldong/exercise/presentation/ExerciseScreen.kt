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

import android.content.Context
import android.util.Log
import androidx.compose.foundation.background
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.derivedStateOf
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
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
import androidx.compose.ui.graphics.Color
import androidx.health.services.client.HealthServices
import com.ssafy.daldong.exercise.data.Room.ExerciseResult
import com.ssafy.daldong.exercise.data.Room.ExerciseResultRepository
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

/**
 * Shows while an exercise is in progress
 */
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
            var startImage by remember { mutableStateOf(R.drawable.exercise_start) }
            var endImage by remember { mutableStateOf(R.drawable.exercise_end) }
            var pauseImage by remember { mutableStateOf(R.drawable.exercise_pause) }
            var startTime = LocalDateTime.now().format(formatter);

            /** Collect [DataPoint]s from the aggregate and exercise metric flows. Because
             * collectAsStateWithLifecycle() is asynchronous, store the last known value from each flow,
             * and update the value on screen only when the flow re-connects. **/
            val tempHeartRate = remember { mutableStateOf(0.0) }
            if (exerciseMetrics?.getData(DataType.HEART_RATE_BPM)
                    ?.isNotEmpty() == true
            ) tempHeartRate.value =
                exerciseMetrics?.getData(DataType.HEART_RATE_BPM)
                    ?.last()?.value!!
            else tempHeartRate.value = tempHeartRate.value

            /**Store previous calorie and distance values to avoid rendering null values from
             * [getExerciseServiceState] flow**/
            val distance =
                exerciseMetrics?.getData(DataType.DISTANCE_TOTAL)?.total
            val tempDistance = remember { mutableStateOf(0.0) }

            val calories =
                exerciseMetrics?.getData(DataType.CALORIES_TOTAL)?.total
            val tempCalories = remember { mutableStateOf(0.0) }

            val averageHeartRate =
                exerciseMetrics?.getData(DataType.HEART_RATE_BPM_STATS)?.average
            val tempAverageHeartRate = remember { mutableStateOf(0.0) }

            /** Update the Pause and End buttons according to [ExerciseState].**/
            val pauseOrResume = when (exerciseStateChange.exerciseState.isPaused) {
//                true -> R.drawable.exercise_start
//                false -> R.drawable.exercise_pause

                true -> Icons.Default.PlayArrow
                false -> Icons.Default.Pause
            }
            val startOrEnd =
                when (exerciseStateChange.exerciseState.isEnded || exerciseStateChange.exerciseState.isEnding) {
//                    true -> R.drawable.exercise_start
//                    false -> R.drawable.exercise_end
                    true -> Icons.Default.PlayArrow
                    false -> Icons.Default.Stop
                }

            // The ticker coroutine updates activeDuration, but the ticker fires more often than
            // once a second, so we use derivedStateOf to update the elapsedTime state only when
            // the string representing the time on the screen changes. Recomposition then only
            // happens when elapsedTime changes, so once a second.

            val elapsedTime = derivedStateOf {
                formatElapsedTime(
                    activeDuration.toKotlinDuration(), true
                ).toString()
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

            LaunchedEffect(exerciseStateChange) {
                if (exerciseStateChange is ExerciseStateChange.ActiveStateChange
                ) {
                    val activeStateChange =
                        exerciseStateChange as ExerciseStateChange.ActiveStateChange
                    val timeOffset =
                        (System.currentTimeMillis() -
                            activeStateChange.durationCheckPoint.time.toEpochMilli())
                    baseActiveDuration.value =
                        activeStateChange.durationCheckPoint.activeDuration.plusMillis(timeOffset)
                    chronoTickJob.value = startTick(chronoTickJob.value, scope) { tickerTime ->
                        activeDuration = baseActiveDuration.value.plusMillis(tickerTime)
                    }
                } else {
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
                                CaloriesText(
                                    calories
                                )
                                tempCalories.value = calories
                            } else {
                                CaloriesText(
                                    tempCalories.value
                                )
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



                                    val endTime = LocalDateTime.now().format(formatter)
                                    // Room에 저장
                                    val exerciseResult = ExerciseResult(
                                        startTime = startTime,
                                        endTime = endTime,
                                        distance = formatDistanceKm(tempDistance.value),
                                        heartRate = tempAverageHeartRate.value.toInt(),
                                        calories = formatCalories(tempCalories.value),
                                        timestamp = formatElapsedTime(activeDuration.toKotlinDuration(), true).toString(),
                                    )

                                    val exerciseResultDao = ExerciseResultDatabase.getDatabase(context).exerciseResultDao()

                                    val exerciseResultRepository = ExerciseResultRepository(context)

                                    navController.navigate(
                                        Screens.SummaryScreen.route + "/${tempAverageHeartRate.value.toInt()} bpm/${
                                            formatDistanceKm(
                                                tempDistance.value
                                            )
                                        }/${formatCalories(tempCalories.value)}/" + formatElapsedTime(
                                            activeDuration.toKotlinDuration(), true
                                        ).toString()
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
//                                    Row(verticalAlignment = Alignment.CenterVertically) {
//                                        Icon(
//                                            imageVector = startOrEnd,
//                                            contentDescription = stringResource(id = R.string.startOrEnd),
//                                            modifier = Modifier.padding(end = 4.dp)
//                                        )
//                                        Text(
//                                            text = "운동종료",
//                                            style = MaterialTheme.typography.button
//                                        )
//                                    }
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

//                            Icon(
//                                imageVector = Icons.Default.WatchLater,
//                                contentDescription = stringResource(id = R.string.duration)
//                            )
//                            Text(elapsedTime.value)
//                            Icon(
//                                imageVector = Icons.Default._360,
//                                contentDescription = stringResource(id = R.string.laps)
//                            )
//                            Text(text = laps.toString())
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

        else -> {}
    }
}

// A coroutine is used to update a ticker whilst the exercise is active. This is necessary because
// WHS might not give us ExerciseUpdates every second on some devices. So the transition to the
// Active state is used to start the ticker, but once started, delivery of ExerciseUpdates shouldn't
// be relied on to make each tick, instead using the coroutine.
private fun startTick(
    chronoTickJob: Job?, scope: CoroutineScope, block: (tickTime: Long) -> Unit
): Job? {
    if (chronoTickJob == null || !chronoTickJob.isActive) {
        return scope.launch {
            val tickStart = System.currentTimeMillis()
            while (isActive) {
                val tickSpan = System.currentTimeMillis() - tickStart
                block(tickSpan)
                delay(CHRONO_TICK_MS)
            }
        }
    }
    return null
}

const val CHRONO_TICK_MS = 200L