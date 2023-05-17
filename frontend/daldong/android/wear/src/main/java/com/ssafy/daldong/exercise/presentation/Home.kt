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
import android.content.ContentValues.TAG
import android.util.Log
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.PlayArrow
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.health.services.client.data.LocationAvailability
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.wear.compose.material.Button
import androidx.wear.compose.material.ButtonDefaults
import androidx.wear.compose.material.Icon
import androidx.wear.compose.material.MaterialTheme
import androidx.wear.compose.material.Scaffold
import androidx.wear.compose.material.Text
import androidx.wear.compose.material.TimeText
import androidx.wear.compose.material.TimeTextDefaults
import com.ssafy.daldong.R
import kotlinx.coroutines.launch
import com.ssafy.daldong.exercise.theme.ExerciseTheme
import com.ssafy.daldong.exercise.data.ServiceState
import androidx.compose.runtime.Composable
import android.os.Build.VERSION.SDK_INT
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import coil.ImageLoader
import coil.compose.rememberAsyncImagePainter
import coil.decode.GifDecoder
import coil.decode.ImageDecoderDecoder

/**
 * Screen that appears while the device is preparing the exercise.
 */
@Composable
fun Home(
    onStartClick: () -> Unit = {},
    prepareExercise: () -> Unit,
    onStart: () -> Unit = {},
    serviceState: ServiceState,
    permissions: Array<String>,
    userInfoViewModel : UserInfoViewModel,
//    isTrackingAnotherExercise: Boolean,
) {
//    if (isTrackingAnotherExercise) {
//        ExerciseInProgressAlert(true)
//    }

    // 작업 완료 여부를 나타내는 상태 변수들
    var isPrepareExerciseFinished by remember { mutableStateOf(false) }
    var isStartExerciseFinished by remember { mutableStateOf(false) }

    /** Request permissions prior to launching exercise.**/
    val permissionLauncher = rememberLauncherForActivityResult(
        ActivityResultContracts.RequestMultiplePermissions()
    ) { result ->
        if (result.all { it.value }) {
            Log.d(TAG, "All required permissions granted")
            prepareExercise() //이동
            isPrepareExerciseFinished = true
        }
    }

    when (serviceState) {
        is ServiceState.Connected -> {
            LaunchedEffect(Unit) {
                launch {
                    permissionLauncher.launch(permissions)
//                    prepareExercise() // 기존 코드
                }
            }
//            Log.d("위치 서비스 상태", serviceState.exerciseServiceState. toString())
            val location by serviceState.locationAvailabilityState.collectAsStateWithLifecycle()

            ExerciseTheme {
                Scaffold(timeText =
                { TimeText(timeSource = TimeTextDefaults.timeSource(TimeTextDefaults.timeFormat())) }) {
                    Column(
                        modifier = Modifier
                            .fillMaxSize()
                            .background(MaterialTheme.colors.background),
                        verticalArrangement = Arrangement.Center

                    ) {
                        Row(
                            horizontalArrangement = Arrangement.Center,
//                            verticalAlignment = Alignment.Top,
//                            modifier = Modifier.height(25.dp).padding(0.dp)
                            modifier = Modifier.fillMaxWidth().padding(20.dp),
                        ) {
                            Text(
                                textAlign = TextAlign.Center,
//                                text = stringResource(id = R.string.app_name),
                                text = "짹짹이",
                                modifier = Modifier.fillMaxWidth(),
                                color = Color(0xFFC4E8C2),
                            )
                        }

                        Row( // 동물
                            horizontalArrangement = Arrangement.Center,
                            modifier = Modifier.fillMaxWidth(),
                        ) {
//
//                            val drawableName = userInfoViewModel.petNamePng.value ?: ""
//                            val drawableResId = getDrawableResourceId(drawableName)
//                            Image(
//                                painter = painterResource(id = drawableResId),
//                                contentDescription = ""
//                            )
                            //기존
                            Image(
                                painter = painterResource(id = R.drawable.sparrow_png),
                                contentDescription = ""
                            )
                        }

//                        Row( // 로딩
//                            horizontalArrangement = Arrangement.Center,
//                            modifier = Modifier.height(40.dp)
//                        ) {
//                            Log.d("지역", location.toString())
//                            when (location) {
//                                LocationAvailability.ACQUIRING, LocationAvailability.UNKNOWN -> ProgressBar()
//                                LocationAvailability.ACQUIRED_TETHERED, LocationAvailability.ACQUIRED_UNTETHERED -> AcquiredCheck()
//                                else -> NotAcquired()
//                            }
//                        }

//                        Row( // GPS 상태
//                            horizontalArrangement = Arrangement.Center,
//                            verticalAlignment = Alignment.Top
//                        ) {
//                            Text(
//                                textAlign = TextAlign.Center,
//                                text = updatePrepareLocationStatus(locationAvailability = location),
//                                modifier = Modifier.fillMaxWidth()
//                            )
//                        }

                        Row( //운동 시작 버튼
                            horizontalArrangement = Arrangement.Center,
                            verticalAlignment = Alignment.CenterVertically,
                            modifier = Modifier.padding(6.dp),
                        ) {
                            Column(
                                modifier = Modifier.fillMaxWidth(),
                                verticalArrangement = Arrangement.Center,
                                horizontalAlignment = Alignment.CenterHorizontally,
                            ) {
                                Button(
                                    onClick = {
                                        onStart()
                                        onStartClick();
                                    },
                                    modifier = Modifier.size(ButtonDefaults.SmallButtonSize)
                                ) {
                                    Icon(
                                        imageVector = Icons.Default.PlayArrow,
                                        contentDescription = stringResource(id = R.string.start)
                                    )
                                }
                            }

                        }
                    }
                }
            }
        }
        else -> {}
    }
}
//
//@Composable
//private fun getDrawableResourceId(drawableName: String?): Int {
//    val resources = LocalContext.current.resources
//    return resources.getIdentifier(drawableName, "drawable", resources.getResourcePackageName(R.drawable.default_image))
//}

/**Return [LocationAvailability] value code as a string**/

@Composable
private fun updatePrepareLocationStatus(locationAvailability: LocationAvailability): String {

    val gpsText = when (locationAvailability) {
        LocationAvailability.ACQUIRED_TETHERED, LocationAvailability.ACQUIRED_UNTETHERED -> R.string.GPS_acquired
        LocationAvailability.NO_GNSS -> R.string.GPS_disabled // TODO Consider redirecting user to change device settings in this case
        LocationAvailability.ACQUIRING -> R.string.GPS_acquiring
        LocationAvailability.UNKNOWN -> R.string.GPS_initializing
        else -> R.string.GPS_unavailable
    }

    return stringResource(id = gpsText)
}
