package dev.fluttercommunity.plus.share

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.IOException

/** Handles the method calls for the plugin.  */
internal class MethodCallHandler(private val share: Share) : MethodChannel.MethodCallHandler {

  override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "share" -> {
        expectMapArguments(call)
        // Android does not support showing the share sheet at a particular point on screen.
        share.share(
          call.argument<Any>("text") as String,
          call.argument<Any>("subject") as String?,
        )
        result.success(null)
      }
      "shareFiles" -> {
        expectMapArguments(call)

        // Android does not support showing the share sheet at a particular point on screen.
        try {
          share.shareFiles(
            call.argument<List<String>>("paths")!!,
            call.argument<List<String>?>("mimeTypes"),
            call.argument<String?>("text"),
            call.argument<String?>("subject"),
          )
          result.success(null)
        } catch (e: IOException) {
          result.error(e.message, null, null)
        }
      }
      else -> result.notImplemented()
    }
  }

  @Throws(IllegalArgumentException::class)
  private fun expectMapArguments(call: MethodCall) {
    require(call.arguments is Map<*, *>) { "Map arguments expected" }
  }
}
