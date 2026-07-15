package dev.fluttercommunity.plus.share

import android.app.Activity
import android.content.ContentValues
import android.content.Context
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.os.Handler
import android.os.Looper
import android.provider.MediaStore
import android.provider.OpenableColumns
import android.util.Log
import android.view.Gravity
import android.widget.LinearLayout
import android.widget.ProgressBar
import android.widget.TextView
import android.widget.Toast
import androidx.annotation.RequiresApi
import java.io.File
import java.io.IOException
import java.util.Collections
import java.util.concurrent.Executors

/** Saves files selected through the Android 14+ Sharesheet action to MediaStore. */
class SharePlusSaveActivity : Activity() {
    private var operationKey: String? = null
    private var saveOperation: SaveOperation? = null
    private lateinit var successLabel: String
    private lateinit var failureLabel: String
    private val saveObserver: (Result<Unit>) -> Unit = { result ->
        handleSaveResult(result)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Custom ChooserActions do not populate EXTRA_CHOSEN_COMPONENT. Record
        // the selection explicitly so ShareResult reports success rather than
        // treating the completed chooser interaction as a dismissal.
        SharePlusPendingIntent.result = SharePlusPendingIntent.SAVE_ACTION_RESULT
        setFinishOnTouchOutside(false)

        val savingLabel = intent.getStringExtra(EXTRA_SAVING_LABEL)
        val successLabel = intent.getStringExtra(EXTRA_SUCCESS_LABEL)
        val failureLabel = intent.getStringExtra(EXTRA_FAILURE_LABEL)
        if (savingLabel == null || successLabel == null || failureLabel == null) {
            finish()
            return
        }
        this.successLabel = successLabel
        this.failureLabel = failureLabel
        showProgress(savingLabel)

        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            finish()
            return
        }

        val uris = intent.getParcelableArrayListExtra(EXTRA_URIS, Uri::class.java).orEmpty()
        val mimeTypes = intent.getStringArrayListExtra(EXTRA_MIME_TYPES).orEmpty()
        val cacheFolder = intent.getStringExtra(EXTRA_CACHE_FOLDER)
        markCacheFolderActive(cacheFolder)
        if (uris.isEmpty()) {
            deleteCacheFolder(applicationContext, cacheFolder)
            finish()
            return
        }

        val key = intent.action ?: cacheFolder ?: uris.joinToString()
        operationKey = key
        saveOperation = getOrStartSaveOperation(
            key,
            applicationContext,
            uris,
            mimeTypes,
            cacheFolder,
        ).also { it.observe(saveObserver) }
    }

    override fun onDestroy() {
        saveOperation?.let { operation ->
            operation.removeObserver(saveObserver)
            if (!isChangingConfigurations) {
                operationKey?.let { releaseSaveOperation(it, operation) }
            }
        }
        super.onDestroy()
    }

    private fun handleSaveResult(result: Result<Unit>) {
        val operation = saveOperation ?: return
        operation.removeObserver(saveObserver)
        operationKey?.let { releaseSaveOperation(it, operation) }
        saveOperation = null

        if (isFinishing || isDestroyed) return
        if (result.isSuccess) {
            Toast.makeText(this, successLabel, Toast.LENGTH_SHORT).show()
        } else {
            Toast.makeText(this, failureLabel, Toast.LENGTH_LONG).show()
        }
        finish()
    }

    private fun showProgress(savingLabel: String) {
        val density = resources.displayMetrics.density
        val padding = (24 * density).toInt()
        val content = LinearLayout(this).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            setPadding(padding, padding, padding, padding)
            addView(ProgressBar(this@SharePlusSaveActivity))
            addView(TextView(this@SharePlusSaveActivity).apply {
                text = savingLabel
                setPadding(padding, 0, 0, 0)
            })
        }
        setContentView(content)
    }

    companion object {
        const val EXTRA_URIS = "dev.fluttercommunity.plus.share.extra.SAVE_URIS"
        const val EXTRA_MIME_TYPES = "dev.fluttercommunity.plus.share.extra.SAVE_MIME_TYPES"
        const val EXTRA_CACHE_FOLDER = "dev.fluttercommunity.plus.share.extra.SAVE_CACHE_FOLDER"
        const val EXTRA_SAVING_LABEL = "dev.fluttercommunity.plus.share.extra.SAVING_LABEL"
        const val EXTRA_SUCCESS_LABEL = "dev.fluttercommunity.plus.share.extra.SUCCESS_LABEL"
        const val EXTRA_FAILURE_LABEL = "dev.fluttercommunity.plus.share.extra.FAILURE_LABEL"
        private const val TAG = "SharePlusSave"
        private val activeCacheFolders: MutableSet<String> =
            Collections.synchronizedSet(HashSet())
        // Keeps one save job alive while Android recreates its progress activity.
        private val saveOperations = mutableMapOf<String, SaveOperation>()

        private fun markCacheFolderActive(path: String?) {
            if (path != null) activeCacheFolders.add(File(path).absolutePath)
        }

        fun isCacheFolderActive(folder: File): Boolean =
            activeCacheFolders.contains(folder.absolutePath)

        @RequiresApi(Build.VERSION_CODES.UPSIDE_DOWN_CAKE)
        private fun getOrStartSaveOperation(
            key: String,
            context: Context,
            uris: List<Uri>,
            mimeTypes: List<String>,
            cacheFolder: String?,
        ): SaveOperation = synchronized(saveOperations) {
            saveOperations[key] ?: SaveOperation(
                context,
                uris,
                mimeTypes,
                cacheFolder,
            ).also { operation ->
                saveOperations[key] = operation
                operation.start()
            }
        }

        private fun releaseSaveOperation(key: String, operation: SaveOperation) {
            synchronized(saveOperations) {
                if (saveOperations[key] === operation) saveOperations.remove(key)
            }
        }

        private fun deleteCacheFolder(context: Context, path: String?) {
            if (path == null) return
            try {
                runCatching {
                    val shareCache = File(context.cacheDir, "share_plus").canonicalFile
                    val folder = File(path).canonicalFile
                    if (folder.parentFile == shareCache) folder.deleteRecursively()
                }
            } finally {
                activeCacheFolders.remove(File(path).absolutePath)
            }
        }

        private class SaveOperation(
            private val context: Context,
            private val uris: List<Uri>,
            private val mimeTypes: List<String>,
            private val cacheFolder: String?,
        ) {
            private val executor = Executors.newSingleThreadExecutor()
            private val mainHandler = Handler(Looper.getMainLooper())
            private var observer: ((Result<Unit>) -> Unit)? = null
            private var completedResult: Result<Unit>? = null

            @RequiresApi(Build.VERSION_CODES.Q)
            fun start() {
                executor.execute {
                    val result = runCatching {
                        MediaStoreWriter.save(context, uris, mimeTypes)
                    }
                    if (result.isFailure) {
                        Log.e(TAG, "Unable to save shared files", result.exceptionOrNull())
                    }
                    deleteCacheFolder(context, cacheFolder)
                    complete(result)
                    executor.shutdown()
                }
            }

            fun observe(observer: (Result<Unit>) -> Unit) {
                val result = synchronized(this) {
                    this.observer = observer
                    completedResult
                }
                if (result != null) dispatch(observer, result)
            }

            fun removeObserver(observer: (Result<Unit>) -> Unit) {
                synchronized(this) {
                    if (this.observer === observer) this.observer = null
                }
            }

            private fun complete(result: Result<Unit>) {
                val currentObserver = synchronized(this) {
                    completedResult = result
                    observer
                }
                if (currentObserver != null) dispatch(currentObserver, result)
            }

            private fun dispatch(
                observer: (Result<Unit>) -> Unit,
                result: Result<Unit>,
            ) {
                mainHandler.post {
                    val isAttached = synchronized(this@SaveOperation) {
                        this@SaveOperation.observer === observer
                    }
                    if (isAttached) observer(result)
                }
            }
        }
    }
}

@RequiresApi(Build.VERSION_CODES.Q)
internal object MediaStoreWriter {
    fun save(context: Context, sourceUris: List<Uri>, providedMimeTypes: List<String>) {
        val resolver = context.contentResolver
        val createdUris = mutableListOf<Uri>()

        try {
            sourceUris.forEachIndexed { index, sourceUri ->
                val displayName = resolveDisplayName(context, sourceUri)
                val mimeType = resolveMimeType(
                    context,
                    sourceUri,
                    providedMimeTypes.getOrNull(index),
                    displayName,
                )
                val (collection, relativePath) = destinationFor(mimeType)
                val values = ContentValues().apply {
                    put(MediaStore.MediaColumns.DISPLAY_NAME, displayName)
                    put(MediaStore.MediaColumns.MIME_TYPE, mimeType)
                    put(MediaStore.MediaColumns.RELATIVE_PATH, relativePath)
                    put(MediaStore.MediaColumns.IS_PENDING, 1)
                }
                val destinationUri = resolver.insert(collection, values)
                    ?: throw IOException("MediaStore did not create a destination")
                createdUris.add(destinationUri)

                resolver.openInputStream(sourceUri).use { input ->
                    if (input == null) throw IOException("Unable to read $sourceUri")
                    resolver.openOutputStream(destinationUri, "w").use { output ->
                        if (output == null) throw IOException("Unable to write $destinationUri")
                        input.copyTo(output)
                    }
                }

                values.clear()
                values.put(MediaStore.MediaColumns.IS_PENDING, 0)
                if (resolver.update(destinationUri, values, null, null) != 1) {
                    throw IOException("Unable to publish $destinationUri")
                }
            }
        } catch (error: Throwable) {
            createdUris.forEach { resolver.delete(it, null, null) }
            throw error
        }
    }

    private fun destinationFor(mimeType: String): Pair<Uri, String> = when {
        mimeType.startsWith("image/", ignoreCase = true) -> Pair(
            MediaStore.Images.Media.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY),
            Environment.DIRECTORY_PICTURES,
        )
        mimeType.startsWith("video/", ignoreCase = true) -> Pair(
            MediaStore.Video.Media.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY),
            Environment.DIRECTORY_MOVIES,
        )
        else -> Pair(
            MediaStore.Downloads.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY),
            Environment.DIRECTORY_DOWNLOADS,
        )
    }

    private fun resolveDisplayName(context: Context, uri: Uri): String {
        var name: String? = null
        context.contentResolver.query(
            uri,
            arrayOf(OpenableColumns.DISPLAY_NAME),
            null,
            null,
            null,
        )?.use { cursor ->
            if (cursor.moveToFirst()) name = cursor.getString(0)
        }
        val fallback = uri.lastPathSegment?.substringAfterLast('/') ?: "shared_file"
        return (name ?: fallback)
            .replace('/', '_')
            .replace('\\', '_')
            .takeUnless { it.isBlank() || it == "." || it == ".." }
            ?: "shared_file"
    }

    private fun resolveMimeType(
        context: Context,
        uri: Uri,
        providedMimeType: String?,
        displayName: String,
    ): String {
        if (!providedMimeType.isNullOrBlank() && !providedMimeType.contains('*')) {
            return providedMimeType
        }
        context.contentResolver.getType(uri)?.takeUnless { it.contains('*') }?.let { return it }
        val extension = File(displayName).extension.lowercase()
        android.webkit.MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension)?.let {
            return it
        }
        return providedMimeType?.takeUnless { it.isBlank() } ?: "application/octet-stream"
    }
}
