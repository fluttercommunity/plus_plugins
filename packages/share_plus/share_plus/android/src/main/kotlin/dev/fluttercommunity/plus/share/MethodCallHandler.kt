package dev.fluttercommunity.plus.share

import android.os.Build
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.IOException

/** Handles the method calls for the plugin.  */
internal class MethodCallHandler(
    private val share: Share,
    private val manager: ShareSuccessManager
) : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        // The user used a *WithResult method
        val isResultRequested =
            call.method.endsWith("WithResult") || call.method.endsWith("Internal")
        // We don't attempt to return a result if the current API version doesn't support it
        val isWithResult =
            isResultRequested && Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1

        when (call.method) {
            // all platform methods get unified
            "shareInternal", "share", "shareWithResult", "shareFiles", "shareFilesWithResult" -> {
                expectMapArguments(call)
                // to redirect the result from the share intent to Flutter
                if (isWithResult && !manager.setCallback(result)) return
                try {
                    share.share(
                        text = call.argument<Any>("text") as String?,
                        subject = call.argument<Any>("subject") as String?,
                        url = call.argument<Any>("url") as String?,
                        paths = call.argument<List<String>?>("paths"),
                        mimeTypes = call.argument<List<String>?>("mimeTypes"),
                        withResult = isWithResult,
                    )
                    if (!isWithResult) {
                        if (isResultRequested) {
                            result.success("dev.fluttercommunity.plus/share/unavailable")
                        } else {
                            result.success(null)
                        }
                    }
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
