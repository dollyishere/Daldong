package com.ssafy.daldong.exercise.theme

import androidx.compose.runtime.Composable
import androidx.wear.compose.material.MaterialTheme
import com.ssafy.daldong.presentation.theme.wearColorPalette

@Composable
fun ExerciseTheme(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        colors = wearColorPalette,
        typography = Typography,
        content = content
    )
}
