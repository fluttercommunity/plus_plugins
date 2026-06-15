package dev.fluttercommunity.plus.share

import android.os.Build
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/** Handles the method calls for the plugin.  */
internal class MethodCallHandler(
    private val share: Share,
    private val manager: ShareSuccessManager,
) : MethodChannel.MethodCallHandler {

    private val mainScope = CoroutineScope(Dispatchers.Main + SupervisorJob())

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        expectMapArguments(call)

        // We don't attempt to return a result if the current API version doesn't support it
        val isWithResult =
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1

        if (isWithResult)
            manager.setCallback(result)

        when (call.method) {
            "share" -> {
                mainScope.launch {
                    try {
                        val arguments = call.arguments<Map<String, Any>>()!!
                        withContext(Dispatchers.IO) {
                            share.share(
                                arguments = arguments,
                                withResult = isWithResult,
                            )
                        }
                        success(isWithResult, result)
                    } catch (e: Throwable) {
                        manager.clear()
                        result.error("Share failed", e.message, e)
                    }
                }
            }

            else -> result.notImplemented()
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
