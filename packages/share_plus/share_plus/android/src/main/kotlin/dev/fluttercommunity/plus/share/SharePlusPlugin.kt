package dev.fluttercommunity.plus.share

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel

/** Plugin method host for presenting a share sheet via Intent  */
class SharePlusPlugin : FlutterPlugin, ActivityAware {
  private lateinit var share: Share
  private lateinit var methodChannel: MethodChannel

  override fun onAttachedToEngine(binding: FlutterPluginBinding) {
    methodChannel = MethodChannel(binding.binaryMessenger, CHANNEL)
    share = Share(context = binding.applicationContext, activity = null)
    val handler = MethodCallHandler(share)
    methodChannel.setMethodCallHandler(handler)
  }

  override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
    methodChannel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    share.setActivity(binding.activity)
  }

  override fun onDetachedFromActivity() {
    share.setActivity(null)
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity()
  }

  companion object {
    private const val CHANNEL = "dev.fluttercommunity.plus/share"
  }
}
