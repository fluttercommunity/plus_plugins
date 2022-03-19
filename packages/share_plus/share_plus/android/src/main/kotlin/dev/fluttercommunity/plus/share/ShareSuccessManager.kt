package dev.fluttercommunity.plus.share

import android.content.*
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener
import java.util.concurrent.atomic.AtomicBoolean

/**
 * Handles the callback based status information about a successful or dismissed
 * share. Used to link multiple different callbacks together for easier use.
 */
internal class ShareSuccessManager(private val context: Context) : BroadcastReceiver(),
    ActivityResultListener {
    private var callback: MethodChannel.Result? = null
    private var calledBack: AtomicBoolean = AtomicBoolean(true)

    /**
     * Register listener. Must be called before any share sheet is opened.
     */
    fun register() {
        context.registerReceiver(this, IntentFilter(BROADCAST_CHANNEL))
    }

    /**
     * Deregister listener. Must be called before the base activity is invalidated.
     */
    fun discard() {
        context.unregisterReceiver(this)
    }

    /**
     * Set result callback that will wait for the share-sheet to close and get either
     * the componentname of the chosen option or an empty string on dismissal.
     */
    fun setCallback(callback: MethodChannel.Result): Boolean {
        return if (calledBack.compareAndSet(true, false)) {
            calledBack.set(false)
            this.callback = callback
            true
        } else {
            callback.error(
                "Share callback error",
                "prior share-sheet did not call back, did you await it? Maybe use non-result variant",
                null,
            )
            false
        }
    }

    /**
     * Must be called if `.startActivityForResult` is not available to avoid deadlocking.
     */
    fun unavailable() {
        returnResult("dev.fluttercommunity.plus/share/unavailable")
    }

    /**
     * Send the result to flutter by invoking the previously set callback.
     */
    private fun returnResult(result: String) {
        if (calledBack.compareAndSet(false, true) && callback != null) {
            callback!!.success(result)
            callback = null
        }
    }

    /**
     * Handler called after a share sheet was closed. Called regardless of success or
     * dismissal.
     */
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == ACTIVITY_CODE) {
            returnResult("")
            return true
        }

        return false
    }

    /**
     * Handler called after a sharesheet was closed. Called only on success.
     */
    override fun onReceive(context: Context, intent: Intent) {
        returnResult(
            intent.getParcelableExtra<ComponentName>(Intent.EXTRA_CHOSEN_COMPONENT).toString()
        )
    }

    companion object {
        const val BROADCAST_CHANNEL = "dev.fluttercommunity.plus/share/success"
        const val ACTIVITY_CODE = 17062003
    }
}
