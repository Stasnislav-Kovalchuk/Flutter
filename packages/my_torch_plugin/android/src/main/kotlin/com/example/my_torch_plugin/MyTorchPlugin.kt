package com.example.my_torch_plugin

import android.content.Context
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** MyTorchPlugin */
class MyTorchPlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var channel : MethodChannel
  private var cameraManager: CameraManager? = null
  private var torchCameraId: String? = null

  override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(binding.binaryMessenger, "my_torch_plugin")
    channel.setMethodCallHandler(this)
    cameraManager = binding.applicationContext.getSystemService(Context.CAMERA_SERVICE) as CameraManager
    try {
      for (id in cameraManager!!.cameraIdList) {
        val char = cameraManager!!.getCameraCharacteristics(id)
        val hasFlash = char.get(CameraCharacteristics.FLASH_INFO_AVAILABLE) ?: false
        if (hasFlash) {
          torchCameraId = id
          break
        }
      }
    } catch (e: Exception) {
      // ignore
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "toggleTorch" -> {
        if (torchCameraId == null || cameraManager == null) {
          result.error("NO_FLASH", "Device has no flash or camera not available", null)
          return
        }
        val enable = call.argument<Boolean>("enable")
        try {
          val target = enable ?: true
          cameraManager!!.setTorchMode(torchCameraId!!, target)
          result.success(true)
        } catch (e: Exception) {
          result.error("ERROR", e.message, null)
        }
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
