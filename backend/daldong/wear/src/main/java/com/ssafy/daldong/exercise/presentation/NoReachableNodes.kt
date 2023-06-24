package com.ssafy.daldong.exercise.presentation

import android.app.Activity
import androidx.compose.foundation.layout.*
import androidx.wear.compose.material.Button
import androidx.wear.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp

@Composable
fun NoReachableNodes() {
    val activity = LocalContext.current as Activity

    Column(
        modifier = Modifier.fillMaxWidth(),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        Text(
            text = "달려동물 앱을 설치 후 실행해주시기 바랍니다.",
            textAlign = TextAlign.Center,
            modifier = Modifier.padding(16.dp)
        )

        Button(onClick = { activity.finish() }) {
            Text("종 료")
        }
    }
}