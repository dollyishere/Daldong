package com.ssafy.daldong

import io.flutter.embedding.android.FlutterActivity
import android.annotation.SuppressLint
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.net.Uri
import android.os.Bundle
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.viewModels
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.lifecycleScope
import androidx.lifecycle.repeatOnLifecycle
import com.google.android.gms.wearable.Asset
import com.google.android.gms.wearable.CapabilityClient
import com.google.android.gms.wearable.DataClient
import com.google.android.gms.wearable.MessageClient
import com.google.android.gms.wearable.NodeClient
import com.google.android.gms.wearable.PutDataMapRequest
import com.google.android.gms.wearable.Wearable
import java.io.ByteArrayOutputStream
import java.time.Duration
import java.time.Instant
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.NonCancellable
import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.delay
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch
import kotlinx.coroutines.tasks.await
import kotlinx.coroutines.withContext
import androidx.lifecycle.ViewModelProvider
import io.flutter.embedding.android.FlutterFragment
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel
import androidx.fragment.app.FragmentActivity
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.FragmentTransaction
import androidx.activity.viewModels
import com.google.android.gms.wearable.DataMap
import android.content.Context
import androidx.datastore.core.DataStore
import androidx.datastore.preferences.core.Preferences
import androidx.datastore.preferences.preferencesDataStore

/**
 * Manages Wearable clients to showcase the [DataClient], [MessageClient], [CapabilityClient] and
 * [NodeClient].
 *
 * While resumed, this activity periodically sends a count through the [DataClient], and offers
 * the ability for the user to take and send a photo over the [DataClient].
 *
 * This activity also allows the user to launch the companion wear activity via the [MessageClient].
 *
 * While resumed, this activity also logs all interactions across the clients, which includes events
 * sent from this activity and from the watch(es).
 */
@SuppressLint("VisibleForTests")
class MainActivity : FlutterActivity() {

    private val CHANNEL = "login.method.channel"

    private val dataClient by lazy { Wearable.getDataClient(this) }
    private val messageClient by lazy { Wearable.getMessageClient(this) }
    private val capabilityClient by lazy { Wearable.getCapabilityClient(this) }

    lateinit var uid : String
    lateinit var mainPetCustomName : String
    lateinit var mainPetName : String

    lateinit var dataMap : DataMap

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // MethodChannel을 초기화합니다.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == InitInfoSendToKotlin) {
                    uid = call.argument<String>("uid").toString()
                    mainPetCustomName = call.argument<String>("mainPetCustomName").toString()
                    mainPetName = call.argument<String>("mainPetName").toString()

                    // DataMap 객체를 생성하고 데이터를 설정합니다.
                    dataMap = DataMap().apply {
                        putString("uid", uid)
                        putString("mainPetCustomName", mainPetCustomName)
                        putString("mainPetName", mainPetName)
                    }

                    // Flutter로부터 전달된 메시지를 처리합니다.
                    Log.d(TAG, "메소드 채널 코틀린")
                    handleMyMethod(uid, mainPetCustomName, mainPetName)

                    // 데이터를 Wear OS 기기로 전송합니다.
                    sendPetInfoToWear()

                    result.success(null) // 처리 완료를 알립니다.
                } else {
                    result.notImplemented() // 지원하지 않는 메소드를 호출했을 때 처리합니다.
                }
            }
    }

    private fun handleMyMethod(uid: String?, mainPetCustomName: String?, mainPetName: String?) {
        // Flutter로부터 전달된 메시지를 처리하는 로직을 구현합니다.
        println("Received message from Flutter:")
        println("uid: $uid")
        println("mainPetCustomName: $mainPetCustomName")
        println("mainPetName: $mainPetName")
    }

    private fun sendPetInfoToWear() {
        lifecycleScope.launch {
            try {
                val request = PutDataMapRequest.create(PET_INIT_PATH).apply {
                    dataMap
                }
                    .asPutDataRequest()
                    .setUrgent()

                val result = dataClient.putDataItem(request).await()
                Log.d(TAG, "wear 전달 성공: $result")
            } catch (cancellationException: CancellationException) {
                Log.d(TAG, "wear 전달 취소: $cancellationException")
                throw cancellationException
            } catch (exception: Exception) {
                Log.d(TAG, "wear 전달 실패: $exception")
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    companion object {
        private const val TAG = "앱 메인 액티비티"

        // wear <-> app PATH
        private val PET_INIT_PATH = "/PetInit"
        private val PET_CHANGE_COSTOM_NAME = "/PetChangeCostomName"

        // flutter <-> kotlin PATH
        private val InitInfoSendToKotlin = "InitInfoSendToKotlin"

//        private val countInterval = Duration.ofSeconds(5)
    }

}

