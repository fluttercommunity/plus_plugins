package dev.fluttercommunity.plus.share

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.IOException

/** Handles the method calls for the plugin.  */
internal class MethodCallHandler(
    private val share: Share,
    private val manager: ShareSuccessManager
) : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "share" -> {
                expectMapArguments(call)
                // Android does not support showing the share sheet at a particular point on screen.
                share.share(
                    call.argument<Any>("text") as String,
                    call.argument<Any>("subject") as String?,
                    false,
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
                        false,
                    )
                    result.success(null)
                } catch (e: IOException) {
                    result.error("Share failed", e.message, null)
                }
            }
            "shareWithResult" -> {
                expectMapArguments(call)
                if (!manager.setCallback(result)) return

                // Android does not support showing the share sheet at a particular point on screen.
                share.share(
                    call.argument<Any>("text") as String,
                    call.argument<Any>("subject") as String?,
                    true,
                )
            }
            "shareFilesWithResult" -> {
                expectMapArguments(call)
                if (!manager.setCallback(result)) return

                // Android does not support showing the share sheet at a particular point on screen.
                try {
                    share.shareFiles(
                        call.argument<List<String>>("paths")!!,
                        call.argument<List<String>?>("mimeTypes"),
                        call.argument<String?>("text"),
                        call.argument<String?>("subject"),
                        true,
                    )
                } catch (e: IOException) {
                    result.error("Share failed", e.message, null)
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
