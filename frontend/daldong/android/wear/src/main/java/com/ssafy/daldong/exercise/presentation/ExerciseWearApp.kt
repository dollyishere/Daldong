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
import androidx.compose.runtime.*
import androidx.compose.ui.tooling.preview.Preview
import androidx.hilt.navigation.compose.hiltViewModel
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.navigation.NavHostController
import androidx.navigation.NavType
import androidx.navigation.compose.rememberNavController
import androidx.navigation.navArgument
import androidx.wear.compose.navigation.SwipeDismissableNavHost
import androidx.wear.compose.navigation.composable
import com.ssafy.daldong.exercise.Screens
import com.ssafy.daldong.exercise.data.Room.ExerciseResult

/** Navigation for the exercise app. **/

@Composable
fun ExerciseWearApp(
    navController: NavHostController,
    startDestination: String,
    userInfoViewModel: UserInfoViewModel
) {
    var isLoading by remember { mutableStateOf(false) } // 비동기 작업 처리 완료 상태

    SwipeDismissableNavHost(
        navController = navController, startDestination = startDestination
    ) {
        composable(Screens.StartingUp.route) {
            val viewModel = hiltViewModel<ExerciseViewModel>()
            val uiState by viewModel.uiState.collectAsStateWithLifecycle()
            StartingUp(onAvailable = {
                navController.navigate(Screens.Home.route) {
                    popUpTo(navController.graph.id) {
                        inclusive = true
                    }
                }
            }, onUnavailable = {
                navController.navigate(Screens.ExerciseNotAvailable.route) {
                    popUpTo(navController.graph.id) {
                        inclusive = false
                    }
                }
            }, hasCapabilities = uiState.hasExerciseCapabilities

            )
        }

//        composable(Screens.Home.route) {
//            val viewModel = hiltViewModel<ExerciseViewModel>()
//            val serviceState by viewModel.exerciseServiceState
//            val permissions = viewModel.permissions
//            val uiState by viewModel.uiState.collectAsState()
//
//            // 작업 완료 여부를 나타내는 상태 변수들
//            var isPrepareExerciseFinished by remember { mutableStateOf(false) }
//            var isStartExerciseFinished by remember { mutableStateOf(false) }
//
//            // Request permissions prior to launching exercise.
//            val permissionLauncher = rememberLauncherForActivityResult(
//                ActivityResultContracts.RequestMultiplePermissions()
//            ) { result ->
//                if (result.all { it.value }) {
//                    Log.d("ㅁㅁExercise Wear App", "All required permissions granted")
//                    viewModel.prepareExercise()
//                    isPrepareExerciseFinished = true
//                }
//            }
//
//            val onStartClick: () -> Unit = {
//                navController.navigate(Screens.ExerciseScreen.route) {
//                    popUpTo(navController.graph.id) {
//                        inclusive = false // 기존
////                inclusive = true // 바꿈
//                    }
//                }
//            }
//
//            LaunchedEffect(isPrepareExerciseFinished) {
//                if (isPrepareExerciseFinished) {
//                    // prepareExercise 비동기 작업 수행 완료 후에 실행될 코드
//                    // onStartClick() 등을 호출하면 됩니다.
//                    onStartClick()
//                }
//            }
//
//            Home(
//                onStartClick = onStartClick,
//                prepareExercise = {
////                    viewModel.prepareExercise()
//                                  },
//                onStart = {
//                    viewModel.startExercise()
//                },
//                serviceState = serviceState,
//                permissions = permissions,
////                isTrackingAnotherExercise = uiState.isTrackingAnotherExercise,
//            )
//        }

        composable(Screens.Home.route) {
            val viewModel = hiltViewModel<ExerciseViewModel>()
            val serviceState by viewModel.exerciseServiceState
            val permissions = viewModel.permissions
            val uiState by viewModel.uiState.collectAsState()
            Home(
                onStartClick = {
                    navController.navigate(Screens.ExerciseScreen.route) {
                        popUpTo(navController.graph.id) {
                            inclusive = false // 기존
//                            inclusive = true // 바꿈
                        }
                    }
                },
                prepareExercise = { viewModel.prepareExercise() },
                onStart = { viewModel.startExercise() },
                serviceState = serviceState,
                permissions = permissions,
                userInfoViewModel = userInfoViewModel,
//                isTrackingAnotherExercise = uiState.isTrackingAnotherExercise,
            )
        }

        composable(Screens.ExerciseScreen.route) {
            val viewModel = hiltViewModel<ExerciseViewModel>()
            val serviceState by viewModel.exerciseServiceState

            var exerciseResult by remember { mutableStateOf<ExerciseResult?>(null) }

            ExerciseScreen(
                onPauseClick = { viewModel.pauseExercise() },
                onEndClick = { viewModel.endExercise() },
//                onEndClick = { exerciseResult?.let { result -> viewModel.endExercise(exerciseResult = result) } },
                onResumeClick = { viewModel.resumeExercise() },
                onStartClick = { viewModel.startExercise() },
                serviceState = serviceState,
                navController = navController,
                userInfoViewModel = userInfoViewModel,
            )
        }
        composable(Screens.ExerciseNotAvailable.route) {
            ExerciseNotAvailable()
        }
        composable(
            Screens.SummaryScreen.route + "/{averageHeartRate}/{totalDistance}/{totalCalories}/{elapsedTime}",
            arguments = listOf(navArgument("averageHeartRate") { type = NavType.StringType },
                navArgument("totalDistance") { type = NavType.StringType },
                navArgument("totalCalories") { type = NavType.StringType },
                navArgument("elapsedTime") { type = NavType.StringType })
        ) {
            SummaryScreen(averageHeartRate = it.arguments?.getString("averageHeartRate")!!,
                totalDistance = it.arguments?.getString("totalDistance")!!,
                totalCalories = it.arguments?.getString("totalCalories")!!,
                elapsedTime = it.arguments?.getString("elapsedTime")!!,
                onRestartClick = {
                    navController.navigate(Screens.StartingUp.route) {
                        popUpTo(navController.graph.id) {
                            inclusive = true
                        }
                    }
                },
                userInfoViewModel = userInfoViewModel,
            )
        }
    }
}
