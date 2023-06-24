/*
 * Copyright 2021 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.ssafy.daldong

import android.annotation.SuppressLint
import android.text.SpannedString
import android.util.Log
import androidx.annotation.StringRes
import androidx.lifecycle.ViewModel
import com.google.android.gms.wearable.CapabilityClient
import com.google.android.gms.wearable.CapabilityInfo
import com.google.android.gms.wearable.DataClient
import com.google.android.gms.wearable.DataEvent
import com.google.android.gms.wearable.DataEventBuffer
import com.google.android.gms.wearable.MessageClient
import com.google.android.gms.wearable.MessageEvent
import java.time.LocalDateTime
import java.util.LinkedList

/**
 * A state holder for the client data.
 */
class AppDataViewModel :
    ViewModel(),
    DataClient.OnDataChangedListener,
    MessageClient.OnMessageReceivedListener,
    CapabilityClient.OnCapabilityChangedListener {

//    private val _events = mutableStateListOf<ExerciseState>()
    private val _events = LinkedList<Event>()
    val events: List<Event> = _events
//    val events: Queue<ExerciseState> = _events

    @SuppressLint("VisibleForTests")
    override fun onDataChanged(dataEvents: DataEventBuffer) {
        Log.d(TAG, "${dataEvents.toString()}")
        _events.addAll(
            dataEvents.map { dataEvent ->
                val title = when (dataEvent.type) {
                    DataEvent.TYPE_CHANGED -> R.string.data_item_changed
                    DataEvent.TYPE_DELETED -> R.string.data_item_deleted
                    else -> R.string.data_item_unknown
                }

                Event(
                    title = title,
                    text = dataEvent.dataItem.toString()
                )
            }
        )


//
//
//        for (event in dataEvent) {
////            // 각 DataEvent에서 필요한 데이터를 추출하고 ExerciseState 객체를 만듭니다.
////            val exerciseState = ExerciseState(
////                calories = event.dataItem.getAsset(EXERCISE_STATE_CALORIES).asDouble(),
////                heartRate = event.dataItem.getAsset(EXERCISE_STATE_HEART_RATE).asDouble(),
////                elapsedTime = event.dataItem.getAsset(EXERCISE_STATE_ELAPSED_TIME).asString()
////            )
////            events.offer(exerciseState)
//        }

//        events.offer(dataEvent)
//            dataEvents.map { dataEvent ->
//                val title = when (dataEvent.type) {
//                    DataEvent.TYPE_CHANGED -> {
//                        Log.d(TAG, "데이터 바뀜")
//
//                    }
//                    DataEvent.TYPE_DELETED -> {
//                        Log.d(TAG, "데이터 삭제")
//
//                    }
//                    else -> {Log.d(TAG, "데이터 타입이 없습니다.")}
//                }
//
////                ExerciseState(
////                    title = title,
////                    text = dataEvent.dataItem.toString()
////                )
//
////        _events.offer()
//
//            }
//        )
    }

    override fun onMessageReceived(messageEvent: MessageEvent) {
        _events.add(
            Event(
                title = R.string.message_from_watch,
                text = messageEvent.toString()
            )
        )
    }

    override fun onCapabilityChanged(capabilityInfo: CapabilityInfo) {
        _events.add(
            Event(
                title = R.string.capability_changed,
                text = capabilityInfo.toString()
            )
        )
    }

    companion object {
        private const val TAG = "앱 데이터 뷰모델"
    }
}

/**
 * A data holder describing a client event.
 */
data class Event(
    @StringRes val title: Int,
    val text: String
)


data class ExerciseState(
    val caloriesHistory: MutableList<Double>, // 운동 중에 쌓인 칼로리 기록
    val heartRateHistory: MutableList<Double>, // 운동 중에 쌓인 심박수 기록
    var elapsedTime: String, // 운동 경과 시간
    val startTime : LocalDateTime,
    var endTime : LocalDateTime,
    var calories: SpannedString,
    var heartRate: Int = 0,
    var distance: SpannedString,
)