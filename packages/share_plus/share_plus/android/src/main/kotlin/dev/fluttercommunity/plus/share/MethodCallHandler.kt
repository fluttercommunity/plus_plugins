package dev.fluttercommunity.plus.share

import android.os.Build
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/** Handles the method calls for the plugin.  */
internal class MethodCallHandler(
    private val share: Share,
    private val manager: ShareSuccessManager,
) : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        expectMapArguments(call)

        // We don't attempt to return a result if the current API version doesn't support it
        val isWithResult =
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1

        if (isWithResult)
            manager.setCallback(result)

        try {
            when (call.method) {
                "share" -> {
                    share.share(
                        arguments = call.arguments<Map<String, Any>>()!!,
                        withResult = isWithResult,
                    )
                    success(isWithResult, result)
                }
                else -> result.notImplemented()
            }
        } catch (e: Throwable) {
            manager.clear()
            result.error("Share failed", e.message, e)
        }
    }

    private fun success(
        isWithResult: Boolean,
        result: MethodChannel.Result
    ) {
        if (!isWithResult) {
            result.success("dev.fluttercommunity.plus/share/unavailable")
        }
    }

    @Throws(IllegalArgumentException::class)
    private fun expectMapArguments(call: MethodCall) {
        require(call.arguments is Map<*, *>) { "Map arguments expected" }
    }
}
