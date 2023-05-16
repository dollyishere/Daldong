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
package com.ssafy.daldong.exercise

import android.annotation.SuppressLint
import android.app.Application
import android.graphics.Bitmap
import android.text.SpannedString
import android.util.Log
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateListOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.lifecycle.AndroidViewModel
import com.google.android.gms.wearable.CapabilityClient
import com.google.android.gms.wearable.CapabilityInfo
import com.google.android.gms.wearable.DataClient
import com.google.android.gms.wearable.DataEventBuffer
import com.google.android.gms.wearable.MessageClient
import com.google.android.gms.wearable.MessageEvent
import kotlinx.coroutines.Job
import java.time.LocalDateTime

class WearDataViewModel(application: Application) :
    AndroidViewModel(application),
    DataClient.OnDataChangedListener,
    MessageClient.OnMessageReceivedListener,
    CapabilityClient.OnCapabilityChangedListener {

    private val _events = mutableStateListOf<Event>()

    /**
     * The list of events from the clients.
     */
    val events: List<Event> = _events

    /**
     * The currently received image (if any), available to display.
     */
    var image by mutableStateOf<Bitmap?>(null)
        private set

    private var loadPhotoJob: Job = Job().apply { complete() }

    @SuppressLint("VisibleForTests")
    override fun onDataChanged(dataEvent: DataEventBuffer) {
        Log.d(TAG, "데이터 바뀜 ${dataEvent.toString()}")

//        _events.addAll(
//            dataEvents.map { dataEvent ->
//                val title = when (dataEvent.type) {
//                    DataEvent.TYPE_CHANGED -> R.string.data_item_changed
//                    DataEvent.TYPE_DELETED -> R.string.data_item_deleted
//                    else -> R.string.data_item_unknown
//                }
//
//                Event(
//                    title = title,
//                    text = dataEvent.dataItem.toString()
//                )
//            }
//        )

        // Do additional work for specific events
//        dataEvents.forEach { dataEvent ->
//            when (dataEvent.type) {
//                DataEvent.TYPE_CHANGED -> {
//                    when (dataEvent.dataItem.uri.path) {
//                        DataLayerListenerService.IMAGE_PATH -> {
//                            loadPhotoJob.cancel()
//                            loadPhotoJob = viewModelScope.launch {
//                                image = loadBitmap(
//                                    DataMapItem.fromDataItem(dataEvent.dataItem)
//                                        .dataMap
//                                        .getAsset(DataLayerListenerService.IMAGE_KEY)
//                                )
//                            }
//                        }
//                    }
//                }
//            }
//        }
    }

    override fun onMessageReceived(messageEvent: MessageEvent) {
        Log.d(TAG, "메세지 수신 ${messageEvent.toString()}")
        _events.add(
            Event(
                title = "메세지 onMessageReceived",
                text = messageEvent.toString()
            )
        )
    }

    override fun onCapabilityChanged(capabilityInfo: CapabilityInfo) {
        Log.d(TAG, "Capability변경 ${capabilityInfo.toString()}")
        _events.add(
            Event(
                title = "메세지 : onCapabilityChanged",
                text = capabilityInfo.toString()
            )
        )
    }

    companion object {
        private const val TAG = "워치 데이터 뷰모델"
    }
}

data class Event(
    val title: String,
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