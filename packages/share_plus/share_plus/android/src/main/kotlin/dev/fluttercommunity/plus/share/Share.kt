package dev.fluttercommunity.plus.share

import android.app.Activity
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.drawable.Icon
import android.net.Uri
import android.os.Build
import android.service.chooser.ChooserAction
import androidx.annotation.RequiresApi
import androidx.core.content.FileProvider
import java.io.File
import java.io.IOException
import java.util.UUID

/**
 * Handles share intent. The `context` and `activity` are used to start the share
 * intent. The `activity` might be null when constructing the [Share] object and set
 * to non-null when an activity is available using [.setActivity].
 */
internal class Share(
    private val context: Context,
    private var activity: Activity?,
    private val manager: ShareSuccessManager
) {
    private val providerAuthority: String by lazy {
        getContext().packageName + ".flutter.share_provider"
    }

    private val shareCacheFolder: File
        get() = File(getContext().cacheDir, "share_plus")

    /**
     * Setting mutability flags as API v31+ requires.
     */
    private val immutabilityIntentFlags: Int by lazy {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            PendingIntent.FLAG_MUTABLE
        } else {
            0
        }
    }

    private fun getContext(): Context {
        return if (activity != null) {
            activity!!
        } else {
            context
        }
    }

    /**
     * Sets the activity when an activity is available. When the activity becomes unavailable, use
     * this method to set it to null.
     */
    fun setActivity(activity: Activity?) {
        this.activity = activity
    }

    @Throws(IOException::class)
    fun share(arguments: Map<String, Any>, withResult: Boolean) {
        clearShareCacheFolder()

        val text = arguments["text"] as String?
        val uri = arguments["uri"] as String?
        val subject = arguments["subject"] as String?
        val title = arguments["title"] as String?
        val paths = (arguments["paths"] as List<*>?)?.filterIsInstance<String>()
        val mimeTypes = (arguments["mimeTypes"] as List<*>?)?.filterIsInstance<String>()
        val includeSaveAction = arguments["androidIncludeSaveAction"] as? Boolean ?: false
        val saveActionLabels = if (includeSaveAction) {
            getSaveActionLabels(arguments)
        } else {
            null
        }
        val sharedFiles = paths?.let { getUrisForPaths(paths) }
        val fileUris = sharedFiles?.uris

        // Create Share Intent
        val shareIntent = Intent()
        if (fileUris == null) {
            shareIntent.apply {
                action = Intent.ACTION_SEND
                type = "text/plain"
                putExtra(Intent.EXTRA_TEXT, uri ?: text)
                if (!subject.isNullOrBlank()) putExtra(Intent.EXTRA_SUBJECT, subject)
                if (!title.isNullOrBlank()) putExtra(Intent.EXTRA_TITLE, title)
            }
        } else {
            when {
                fileUris.isEmpty() -> {
                    throw IOException("Error sharing files: No files found")
                }

                fileUris.size == 1 -> {
                    val mimeType = if (!mimeTypes.isNullOrEmpty()) {
                        mimeTypes.first()
                    } else {
                        "*/*"
                    }
                    shareIntent.apply {
                        action = Intent.ACTION_SEND
                        type = mimeType
                        putExtra(Intent.EXTRA_STREAM, fileUris.first())
                    }
                }

                else -> {
                    shareIntent.apply {
                        action = Intent.ACTION_SEND_MULTIPLE
                        type = reduceMimeTypes(mimeTypes)
                        putParcelableArrayListExtra(Intent.EXTRA_STREAM, fileUris)
                    }
                }
            }

            shareIntent.apply {
                if (!text.isNullOrBlank()) putExtra(Intent.EXTRA_TEXT, text)
                if (!subject.isNullOrBlank()) putExtra(Intent.EXTRA_SUBJECT, subject)
                if (!title.isNullOrBlank()) putExtra(Intent.EXTRA_TITLE, title)
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            }
        }

        // Create the chooser intent
        val chooserIntent =
            if (withResult && Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP_MR1) {
                // Build chooserIntent with broadcast to ShareSuccessManager on success
                Intent.createChooser(
                    shareIntent,
                    title,
                    PendingIntent.getBroadcast(
                        context,
                        0,
                        Intent(context, SharePlusPendingIntent::class.java),
                        PendingIntent.FLAG_UPDATE_CURRENT or immutabilityIntentFlags
                    ).intentSender
                )
            } else {
                Intent.createChooser(shareIntent, title)
            }

        if (
            includeSaveAction &&
            !fileUris.isNullOrEmpty() &&
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE
        ) {
            addSaveAction(
                chooserIntent,
                fileUris,
                mimeTypes,
                sharedFiles.cacheFolder,
                requireNotNull(saveActionLabels),
            )
        }

        // Grant permissions to all apps that can handle the files shared
        if (fileUris != null) {
            val resInfoList = getContext().packageManager.queryIntentActivities(
                chooserIntent, PackageManager.MATCH_DEFAULT_ONLY
            )
            resInfoList.forEach { resolveInfo ->
                val packageName = resolveInfo.activityInfo.packageName
                fileUris.forEach { fileUri ->
                    getContext().grantUriPermission(
                        packageName,
                        fileUri,
                        Intent.FLAG_GRANT_WRITE_URI_PERMISSION or Intent.FLAG_GRANT_READ_URI_PERMISSION,
                    )
                }
            }
        }

        // Launch share intent
        startActivity(chooserIntent, withResult)
    }

    private fun startActivity(intent: Intent, withResult: Boolean) {
        if (activity != null) {
            if (withResult) {
                activity!!.startActivityForResult(intent, ShareSuccessManager.ACTIVITY_CODE)
            } else {
                activity!!.startActivity(intent)
            }
        } else {
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            if (withResult) {
                // We need to cancel the callback to avoid deadlocking on the Dart side
                manager.unavailable()
            }
            context.startActivity(intent)
        }
    }

    @Throws(IOException::class)
    private fun getUrisForPaths(paths: List<String>): SharedFiles {
        val uris = ArrayList<Uri>(paths.size)
        val requestFolder = File(shareCacheFolder, UUID.randomUUID().toString())
        try {
            paths.forEach { path ->
                var file = File(path)
                if (fileIsInShareCache(file)) {
                    throw IOException("Shared file can not be located in '${shareCacheFolder.canonicalPath}'")
                }
                file = copyToShareCacheFolder(file, requestFolder)
                uris.add(FileProvider.getUriForFile(getContext(), providerAuthority, file))
            }
        } catch (error: Throwable) {
            requestFolder.deleteRecursively()
            throw error
        }
        return SharedFiles(uris, requestFolder)
    }

    @RequiresApi(Build.VERSION_CODES.UPSIDE_DOWN_CAKE)
    private fun addSaveAction(
        chooserIntent: Intent,
        fileUris: ArrayList<Uri>,
        mimeTypes: List<String>?,
        cacheFolder: File,
        labels: SaveActionLabels,
    ) {
        val saveIntent = Intent(getContext(), SharePlusSaveActivity::class.java).apply {
            action = "${getContext().packageName}.share_plus.SAVE.${UUID.randomUUID()}"
            putParcelableArrayListExtra(SharePlusSaveActivity.EXTRA_URIS, fileUris)
            putStringArrayListExtra(
                SharePlusSaveActivity.EXTRA_MIME_TYPES,
                ArrayList(mimeTypes.orEmpty()),
            )
            putExtra(SharePlusSaveActivity.EXTRA_CACHE_FOLDER, cacheFolder.absolutePath)
            putExtra(SharePlusSaveActivity.EXTRA_SAVING_LABEL, labels.saving)
            putExtra(SharePlusSaveActivity.EXTRA_SUCCESS_LABEL, labels.success)
            putExtra(SharePlusSaveActivity.EXTRA_FAILURE_LABEL, labels.failure)
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        }
        val savePendingIntent = PendingIntent.getActivity(
            getContext(),
            0,
            saveIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        val saveAction = ChooserAction.Builder(
            Icon.createWithResource(getContext(), R.drawable.share_plus_ic_save),
            labels.save,
            savePendingIntent,
        ).build()

        chooserIntent.putExtra(
            Intent.EXTRA_CHOOSER_CUSTOM_ACTIONS,
            arrayOf(saveAction),
        )
    }

    private fun getSaveActionLabels(arguments: Map<String, Any>): SaveActionLabels {
        val labels = arguments["androidSaveActionLabels"] as? Map<*, *>
            ?: throw IllegalArgumentException("androidSaveActionLabels must be provided")

        fun getLabel(name: String): String = labels[name] as? String
            ?: throw IllegalArgumentException("androidSaveActionLabels.$name must be provided")

        return SaveActionLabels(
            save = getLabel("save"),
            saving = getLabel("saving"),
            success = getLabel("success"),
            failure = getLabel("failure"),
        )
    }

    /**
     * Reduces provided MIME types to a common one to provide [Intent] with a correct type to share
     * multiple files
     */
    private fun reduceMimeTypes(mimeTypes: List<String>?): String {
        if (mimeTypes?.isEmpty() != false) return "*/*"
        if (mimeTypes.size == 1) return mimeTypes.first()

        var commonMimeType = mimeTypes.first()
        for (i in 1..mimeTypes.lastIndex) {
            if (commonMimeType != mimeTypes[i]) {
                if (getMimeTypeBase(commonMimeType) == getMimeTypeBase(mimeTypes[i])) {
                    commonMimeType = getMimeTypeBase(mimeTypes[i]) + "/*"
                } else {
                    commonMimeType = "*/*"
                    break
                }
            }
        }
        return commonMimeType
    }

    /**
     * Returns the first part of provided MIME type, which comes before '/' symbol
     */
    private fun getMimeTypeBase(mimeType: String?): String {
        return if (mimeType == null || !mimeType.contains("/")) {
            "*"
        } else {
            mimeType.substring(0, mimeType.indexOf("/"))
        }
    }

    private fun fileIsInShareCache(file: File): Boolean {
        return try {
            val filePath = file.canonicalPath
            val cachePath = shareCacheFolder.canonicalPath
            filePath == cachePath || filePath.startsWith(cachePath + File.separator)
        } catch (e: IOException) {
            false
        }
    }

    private fun clearShareCacheFolder() {
        val folder = shareCacheFolder
        folder.listFiles()?.forEach { file ->
            if (!SharePlusSaveActivity.isCacheFolderActive(file)) {
                file.deleteRecursively()
            }
        }
        if (folder.listFiles().isNullOrEmpty()) folder.delete()
    }

    @Throws(IOException::class)
    private fun copyToShareCacheFolder(file: File, folder: File): File {
        if (!folder.exists()) {
            folder.mkdirs()
        }
        var newFile = File(folder, file.name)
        var suffix = 1
        while (newFile.exists()) {
            val baseName = file.nameWithoutExtension
            val extension = file.extension.takeIf { it.isNotEmpty() }?.let { ".$it" }.orEmpty()
            newFile = File(folder, "$baseName ($suffix)$extension")
            suffix++
        }
        file.copyTo(newFile, true)
        return newFile
    }

    private data class SharedFiles(
        val uris: ArrayList<Uri>,
        val cacheFolder: File,
    )

    private data class SaveActionLabels(
        val save: String,
        val saving: String,
        val success: String,
        val failure: String,
    )
}
