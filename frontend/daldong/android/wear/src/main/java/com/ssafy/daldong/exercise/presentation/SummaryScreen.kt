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
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.focusable
import androidx.compose.foundation.gestures.scrollBy
import androidx.compose.foundation.layout.*
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.DirectionsRun
import androidx.compose.material.icons.filled.WatchLater
import androidx.compose.runtime.*
import androidx.compose.runtime.livedata.observeAsState
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.FocusRequester
import androidx.compose.ui.focus.focusRequester
import androidx.compose.ui.input.rotary.onRotaryScrollEvent
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.tooling.preview.Devices
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.wear.compose.material.*
import coil.ImageLoader
import coil.compose.rememberAsyncImagePainter
import coil.decode.GifDecoder
import coil.decode.ImageDecoderDecoder
import com.ssafy.daldong.R
import com.ssafy.daldong.exercise.presentation.component.SummaryFormat
import com.ssafy.daldong.exercise.theme.ExerciseTheme
import kotlinx.coroutines.launch

/**End-of-workout summary screen**/

@Composable
fun SummaryScreen(
    averageHeartRate: String,
    totalDistance: String,
    totalCalories: String,
    elapsedTime: String,
    onRestartClick: () -> Unit,
    userInfoViewModel : UserInfoViewModel,
) {
    val listState = rememberScalingLazyListState()
    val coroutineScope = rememberCoroutineScope()
    val petCustomName by userInfoViewModel.petCustomName.observeAsState()
    val petGifName by userInfoViewModel.petGifName.observeAsState()

    val imageLoader = ImageLoader.Builder(LocalContext.current)
        .components {
            if (Build.VERSION.SDK_INT >= 28) {
                add(ImageDecoderDecoder.Factory())
            } else {
                add(GifDecoder.Factory())
            }
        }
        .build()

    val petGifNameWithJump = userInfoViewModel.petGifName.toString() + "jump"

    ExerciseTheme {
        Scaffold(positionIndicator = {
            PositionIndicator(
                scalingLazyListState = listState
            )
        },
            timeText = {
                TimeText(timeSource = TimeTextDefaults.timeSource(TimeTextDefaults.timeFormat()))
            }
        ) {
            val focusRequester = remember { FocusRequester() }
            ScalingLazyColumn(
                modifier = Modifier
                    .fillMaxSize()
                    .background(MaterialTheme.colors.background)
                    .onRotaryScrollEvent {
                        coroutineScope.launch {
                            listState.scrollBy(it.verticalScrollPixels)
                        }
                        true
                    }
                    .focusRequester(focusRequester)
                    .focusable(),
                verticalArrangement = Arrangement.spacedBy(10.dp),
                state = listState,

                ) {
                item { ListHeader { Text(stringResource(id = R.string.workout_complete)) } }

                item {
//                    Image(
//                        painter = painterResource(id = R.drawable.sparrow_png),
//                        contentDescription = ""
//                    )
                    // 운동 종료 GIF

                    val context = LocalContext.current
                    val drawableId = remember(petGifName+"_jump") {
                        context.resources.getIdentifier(
                            petGifName+"_jump",
                            "drawable",
                            context.packageName
                        )
                    }

                    Image(
                        painter = rememberAsyncImagePainter(drawableId, imageLoader),
                        contentDescription = "",
                    )

                }

                item {
                    Row(horizontalArrangement = Arrangement.Center,
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(5.dp),) {
                        Icon(
                            imageVector = Icons.Default.WatchLater,
                            contentDescription = stringResource(id = R.string.duration),
                        )
                        SummaryFormat(
                            value = elapsedTime,
                            metric = stringResource(id = R.string.duration),
                            modifier = Modifier.fillMaxWidth()
                        )
                    }
                }

                item {
                    Row(horizontalArrangement = Arrangement.Center,
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(5.dp),) {
                        Image(
                            painter = painterResource(id = R.drawable.calorie),
                            contentDescription = stringResource(id = R.string.calories)
                        )
                        SummaryFormat(
                            value = totalCalories,
                            metric = stringResource(id = R.string.calories),
                            modifier = Modifier.fillMaxWidth()
                        )
                    }
                }

                item {
                    Row(horizontalArrangement = Arrangement.Center,
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(5.dp),) {
                        Image(
                            painter = painterResource(id = R.drawable.heart),
                            contentDescription = stringResource(id = R.string.heart_rate)
                        )

                        SummaryFormat(
                            value = averageHeartRate,
                            metric = stringResource(id = R.string.avgHR),
                            modifier = Modifier.fillMaxWidth()
                        )
                    }
                }

                item {
                    Row(horizontalArrangement = Arrangement.Center,
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(5.dp),){
                        Icon(
                            imageVector = Icons.Default.DirectionsRun,
                            contentDescription = stringResource(id = R.string.distance)
                        )
                        SummaryFormat(
                            value = totalDistance,
                            metric = stringResource(id = R.string.distance),
                            modifier = Modifier.fillMaxWidth()
                        )
                    }
                }

                item {
                    Row(
                        horizontalArrangement = Arrangement.Center,
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(6.dp)
                    ) {
                        Button(
                            onClick = {
                                onRestartClick()
                            }, modifier = Modifier.fillMaxWidth()
                        ) {
                            Text(text = stringResource(id = R.string.HOME))
                        }
                    }
                }
            }
            LaunchedEffect(Unit) { focusRequester.requestFocus() }
        }
    }
}

//@Preview(device = Devices.WEAR_OS_SMALL_ROUND, showSystemUi = true)
//@Composable
//fun SummaryScreenPreview() {
//    SummaryScreen(averageHeartRate = "75.0",
//        totalDistance = "2 km",
//        totalCalories = "100",
//        elapsedTime = "17m01",
//        onRestartClick = {}
//    )
//}
