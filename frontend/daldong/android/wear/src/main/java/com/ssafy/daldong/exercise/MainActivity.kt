package com.ssafy.daldong.exercise

import android.os.Bundle
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.viewModels
import androidx.compose.ui.tooling.preview.Preview
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.lifecycleScope
import androidx.navigation.NavHostController
import androidx.wear.compose.navigation.rememberSwipeDismissableNavController
import com.ssafy.daldong.exercise.presentation.ExerciseViewModel
import com.ssafy.daldong.exercise.presentation.ExerciseWearApp
import dagger.hilt.android.AndroidEntryPoint
import kotlinx.coroutines.launch

@AndroidEntryPoint
class MainActivity : ComponentActivity() {

    private lateinit var navController: NavHostController

    private val exerciseViewModel by viewModels<ExerciseViewModel>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        lifecycleScope.launch {

            /** Check if we have an active exercise. If true, set our destination as the
             * Exercise Screen. If false, route to preparing a new exercise. **/
            Log.d("메인 액티비티", exerciseViewModel.toString())

            val destination = when (exerciseViewModel.isExerciseInProgress()) {
                false -> Screens.StartingUp.route
                true -> Screens.ExerciseScreen.route
            }

            setContent {
                navController = rememberSwipeDismissableNavController()

                ExerciseWearApp(
                    navController,
                    startDestination = destination
                )
            }
        }
    }
}