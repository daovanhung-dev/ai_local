package com.localai.chatbot

import android.app.ActivityManager
import android.content.Context
import android.os.Build
import android.os.PowerManager
import android.os.StatFs
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.localai.chatbot/device",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "deviceStats" -> result.success(deviceStats())
                "availableStorageBytes" -> result.success(availableStorageBytes())
                else -> result.notImplemented()
            }
        }
    }

    private fun deviceStats(): Map<String, Any> {
        val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memoryInfo = ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(memoryInfo)
        val thermalState = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val powerManager = getSystemService(PowerManager::class.java)
            when (powerManager.currentThermalStatus) {
                PowerManager.THERMAL_STATUS_NONE -> "normal"
                PowerManager.THERMAL_STATUS_LIGHT -> "light"
                PowerManager.THERMAL_STATUS_MODERATE -> "moderate"
                PowerManager.THERMAL_STATUS_SEVERE -> "severe"
                PowerManager.THERMAL_STATUS_CRITICAL -> "critical"
                PowerManager.THERMAL_STATUS_EMERGENCY -> "emergency"
                else -> "unknown"
            }
        } else {
            "unknown"
        }
        return mapOf(
            "totalMemoryBytes" to memoryInfo.totalMem,
            "availableMemoryBytes" to memoryInfo.availMem,
            "availableStorageBytes" to availableStorageBytes(),
            "thermalState" to thermalState,
        )
    }

    private fun availableStorageBytes(): Long = StatFs(filesDir.absolutePath).availableBytes
}
