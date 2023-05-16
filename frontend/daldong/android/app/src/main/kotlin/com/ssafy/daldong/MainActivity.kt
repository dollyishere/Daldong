package com.ssafy.daldong

import io.flutter.embedding.android.FlutterActivity
import android.annotation.SuppressLint
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.net.Uri
import android.os.Bundle
import android.util.Log
import androidx.activity.ComponentActivity
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
import androidx.fragment.app.FragmentActivity
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.FragmentTransaction
import androidx.activity.viewModels

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
class MainActivity : FlutterActivity()  {


//    private val flutterEngine by lazy { FlutterEngine(this) }

//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//
//        FlutterEngineCache.getInstance().put("my_engine_id", flutterEngine)
//
//        val flutterFragment : FlutterFragment = FlutterFragment.withCachedEngine("my_engine_id").build()
//
////        supportFragmentManager.beginTransaction()
////            .add(R.id.fragment_container_view_tag, flutterFragment)
////            .commit()
//
//        val clientDataViewModel = ViewModelProvider(flutterFragment).get(ClientDataViewModel::class.java)
//        // ViewModel 사용 예시
////        clientDataViewModel.events.offer(ExerciseState())
//    }



    private val dataClient by lazy { Wearable.getDataClient(this) }
    private val messageClient by lazy { Wearable.getMessageClient(this) }
    private val capabilityClient by lazy { Wearable.getCapabilityClient(this) }
//
//    private val clientDataViewModel by activityViewModels<ClientDataViewModel>()
//
//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//
//        var count = 0
//
//        lifecycleScope.launch {
//            lifecycle.repeatOnLifecycle(Lifecycle.State.RESUMED) {
//                // Set the initial trigger such that the first count will happen in one second.
//                var lastTriggerTime = Instant.now() - (countInterval - Duration.ofSeconds(1))
//                while (isActive) {
//                    // Figure out how much time we still have to wait until our next desired trigger
//                    // point. This could be less than the count interval if sending the count took
//                    // some time.
//                    delay(
//                        Duration.between(Instant.now(), lastTriggerTime + countInterval).toMillis()
//                    )
//                    // Update when we are triggering sending the count
//                    lastTriggerTime = Instant.now()
//                    sendCount(count)
//
//                    // Increment the count to send next time
//                    count++
//                }
//            }
//        }
//    }
//
//    override fun onResume() {
//        super.onResume()
//        dataClient.addListener(clientDataViewModel)
//        messageClient.addListener(clientDataViewModel)
//        capabilityClient.addListener(
//            clientDataViewModel,
//            Uri.parse("wear://"),
//            CapabilityClient.FILTER_REACHABLE
//        )
//    }
//
//    override fun onPause() {
//        super.onPause()
//        dataClient.removeListener(clientDataViewModel)
//        messageClient.removeListener(clientDataViewModel)
//        capabilityClient.removeListener(clientDataViewModel)
//
//        lifecycleScope.launch {
//            // This is a judicious use of NonCancellable.
//            // This is asynchronous clean-up, since the capability is no longer available.
//            // If we allow this to be cancelled, we may leave the capability in-place for other
//            // nodes to see.
//            withContext(NonCancellable) {
//                try {
//                    capabilityClient.removeLocalCapability(CAMERA_CAPABILITY).await()
//                } catch (exception: Exception) {
//                    Log.e(TAG, "Could not remove capability: $exception")
//                }
//            }
//        }
//    }
//
//    private fun startWearableActivity() {
//        lifecycleScope.launch {
//            try {
//                val nodes = capabilityClient
//                    .getCapability(WEAR_CAPABILITY, CapabilityClient.FILTER_REACHABLE)
//                    .await()
//                    .nodes
//
//                // Send a message to all nodes in parallel
//                nodes.map { node ->
//                    async {
//                        messageClient.sendMessage(node.id, START_ACTIVITY_PATH, byteArrayOf())
//                            .await()
//                    }
//                }.awaitAll()
//
//                Log.d(TAG, "Starting activity requests sent successfully")
//            } catch (cancellationException: CancellationException) {
//                throw cancellationException
//            } catch (exception: Exception) {
//                Log.d(TAG, "Starting activity failed: $exception")
//            }
//        }
//    }
//
//    private suspend fun sendCount(count: Int) {
//        try {
//            val request = PutDataMapRequest.create(COUNT_PATH).apply {
//                dataMap.putInt(COUNT_KEY, count)
//            }
//                .asPutDataRequest()
//                .setUrgent()
//
//            val result = dataClient.putDataItem(request).await()
//
//            Log.d(TAG, "DataItem saved: $result")
//        } catch (cancellationException: CancellationException) {
//            throw cancellationException
//        } catch (exception: Exception) {
//            Log.d(TAG, "Saving DataItem failed: $exception")
//        }
//    }
//
//    /**
//     * Converts the [Bitmap] to an asset, compress it to a png image in a background thread.
//     */
//    private suspend fun Bitmap.toAsset(): Asset =
//        withContext(Dispatchers.Default) {
//            ByteArrayOutputStream().use { byteStream ->
//                compress(Bitmap.CompressFormat.PNG, 100, byteStream)
//                Asset.createFromBytes(byteStream.toByteArray())
//            }
//        }

    companion object {
        private const val TAG = "MainActivity"

        private const val START_ACTIVITY_PATH = "/start-activity"
        private const val COUNT_PATH = "/count"
        private const val IMAGE_PATH = "/image"
        private const val IMAGE_KEY = "photo"
        private const val TIME_KEY = "time"
        private const val COUNT_KEY = "count"
        private const val CAMERA_CAPABILITY = "camera"
        private const val WEAR_CAPABILITY = "wear"

        private val countInterval = Duration.ofSeconds(5)
    }

}

