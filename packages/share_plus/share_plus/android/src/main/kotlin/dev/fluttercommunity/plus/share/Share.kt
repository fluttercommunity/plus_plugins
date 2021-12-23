package dev.fluttercommunity.plus.share

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import androidx.core.content.FileProvider
import java.io.File
import java.io.IOException

/**
 * Handles share intent. The `context` and `activity` are used to start the share
 * intent. The `activity` might be null when constructing the [Share] object and set
 * to non-null when an activity is available using [.setActivity].
 */
internal class Share(private val context: Context?, private var activity: Activity?) {
  private val providerAuthority: String by lazy {
    getContext().packageName + ".flutter.share_provider"
  }

  private val shareCacheFolder: File
    get() = File(getContext().cacheDir, "share_plus")

  private fun getContext(): Context {
    if (activity != null) {
      return activity!!
    }
    if (context != null) {
      return context
    }
    throw IllegalStateException("Both context and activity are null")
  }

  /**
   * Sets the activity when an activity is available. When the activity becomes unavailable, use
   * this method to set it to null.
   */
  fun setActivity(activity: Activity?) {
    this.activity = activity
  }

  fun share(text: String, subject: String?) {
    val shareIntent = Intent().apply {
      action = Intent.ACTION_SEND
      type = "text/plain"
      putExtra(Intent.EXTRA_TEXT, text)
      putExtra(Intent.EXTRA_SUBJECT, subject)
    }

    val chooserIntent = Intent.createChooser(shareIntent, null /* dialog title optional */)
    startActivity(chooserIntent)
  }

  @Throws(IOException::class)
  fun shareFiles(
    paths: List<String>,
    mimeTypes: List<String>?,
    text: String?,
    subject: String?
  ) {
    clearShareCacheFolder()
    val fileUris = getUrisForPaths(paths)
    val shareIntent = Intent()
    when {
      (fileUris.isEmpty() && !text.isNullOrBlank()) -> {
        share(text, subject)
        return
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
    if (text != null) shareIntent.putExtra(Intent.EXTRA_TEXT, text)
    if (subject != null) shareIntent.putExtra(Intent.EXTRA_SUBJECT, subject)
    shareIntent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
    val chooserIntent = Intent.createChooser(shareIntent, null /* dialog title optional */)
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
    startActivity(chooserIntent)
  }

  private fun startActivity(intent: Intent) {
    when {
      activity != null -> {
        activity!!.startActivity(intent)
      }
      context != null -> {
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(intent)
      }
      else -> {
        throw IllegalStateException("Both context and activity are null")
      }
    }
  }

  @Throws(IOException::class)
  private fun getUrisForPaths(paths: List<String>): ArrayList<Uri> {
    val uris = ArrayList<Uri>(paths.size)
    paths.forEach { path ->
      var file = File(path)
      if (fileIsInShareCache(file)) {
        // If file is saved in '.../caches/share_plus' it will be erased by 'clearShareCacheFolder()'
        throw IOException("Shared file can not be located in '${shareCacheFolder.canonicalPath}'")
      }
      file = copyToShareCacheFolder(file)
      uris.add(FileProvider.getUriForFile(getContext(), providerAuthority, file))
    }
    return uris
  }

  /**
   * Reduces provided MIME types to a common one to provide [Intent] with a correct type
   * to share multiple files
   */
  private fun reduceMimeTypes(mimeTypes: List<String>?): String {
    var reducedMimeType = "*/*"

    mimeTypes?.let { types ->
      {
        if (types.size == 1) {
          reducedMimeType = types.first()
        } else if (types.size > 1) {
          var commonMimeType = types.first()
          for (i in 1..types.lastIndex) {
            if (commonMimeType != types[i]) {
              if (getMimeTypeBase(commonMimeType) == getMimeTypeBase(types[i])) {
                commonMimeType = getMimeTypeBase(types[i]) + "/*"
              } else {
                commonMimeType = "*/*"
                break
              }
            }
          }
          reducedMimeType = commonMimeType
        }
      }
    }
    return reducedMimeType
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
      filePath.startsWith(shareCacheFolder.canonicalPath)
    } catch (e: IOException) {
      false
    }
  }

  private fun clearShareCacheFolder() {
    val folder = shareCacheFolder
    val files = folder.listFiles()
    if (folder.exists() && !files.isNullOrEmpty()) {
      files.forEach { it.delete() }
      folder.delete()
    }
  }

  @Throws(IOException::class)
  private fun copyToShareCacheFolder(file: File): File {
    val folder = shareCacheFolder
    if (!folder.exists()) {
      folder.mkdirs()
    }
    val newFile = File(folder, file.name)
    file.copyTo(newFile, true)
    return newFile
  }
}
