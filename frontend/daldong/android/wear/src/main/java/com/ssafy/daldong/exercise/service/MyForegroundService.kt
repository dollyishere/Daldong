package com.ssafy.daldong.exercise.service

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import com.ssafy.daldong.R

class MyForegroundService : Service() {
    companion object {
        const val NOTIFICATION_CHANNEL_ID = "MyForegroundServiceChannel"
        const val NOTIFICATION_ID = 1
    }

    override fun onCreate() {
        super.onCreate()

        // Notification Channel 생성
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notificationChannel = NotificationChannel(
                NOTIFICATION_CHANNEL_ID,
                "MyForegroundService Channel",
                NotificationManager.IMPORTANCE_DEFAULT
            )

            // Notification Manager에 등록
            getSystemService(NotificationManager::class.java)?.createNotificationChannel(notificationChannel)
        }

        // Notification 생성
        val notification = NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID)
            .setContentTitle("MyForegroundService")
            .setContentText("Foreground Service is running...")
            .setSmallIcon(R.drawable.ic_daldong)
            .build()

        // Foreground Service 시작
        startForeground(NOTIFICATION_ID, notification)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // Foreground Service 로직 작성
        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? {
        // Binding 처리
        return null
    }

    override fun onDestroy() {
        super.onDestroy()
        // Foreground Service 종료 처리
    }
}