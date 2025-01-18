package dev.fluttercommunity.plus.share

import android.content.ComponentName
import android.content.Intent
import android.os.Build
import io.flutter.BuildConfig
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.IOException

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
                "shareUri" -> {
                    share.share(
                        call.argument<Any>("uri") as String,
                        subject = null,
                        withResult = isWithResult,
                        shareIntent = obtainIntent(call)
                    )
                    success(isWithResult, result)
                }

                "share" -> {
                    share.share(
                        call.argument<Any>("text") as String,
                        call.argument<Any>("subject") as String?,
                        isWithResult,
                        shareIntent = obtainIntent(call)
                    )
                    success(isWithResult, result)
                }

                "shareFiles" -> {
                    share.shareFiles(
                        call.argument<List<String>>("paths")!!,
                        call.argument<List<String>?>("mimeTypes"),
                        call.argument<String?>("text"),
                        call.argument<String?>("subject"),
                        isWithResult,
                        shareIntent = obtainIntent(call)
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

    private fun obtainIntent(call: MethodCall): Intent {
        val flags = call.argument<Int?>("flags")
        val packageName = call.argument<String?>("packageName")
        val componentName = call.argument<String?>("componentName")

        return Intent().apply {
            if (flags != null) {
                addFlags(flags);
            }
            when {
                !componentName.isNullOrBlank() && !packageName.isNullOrBlank() -> {
                    setComponent(ComponentName(packageName, componentName))
                }

                !packageName.isNullOrBlank() -> {
                    setPackage(packageName)
                }
            }
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
