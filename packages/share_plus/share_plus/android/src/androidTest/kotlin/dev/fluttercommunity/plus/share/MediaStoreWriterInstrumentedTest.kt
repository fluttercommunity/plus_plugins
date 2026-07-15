package dev.fluttercommunity.plus.share

import android.content.ContentUris
import android.content.Context
import android.net.Uri
import android.os.Environment
import android.provider.MediaStore
import androidx.core.content.FileProvider
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.filters.SdkSuppress
import androidx.test.platform.app.InstrumentationRegistry
import java.io.File
import java.util.UUID
import org.junit.After
import org.junit.Assert.assertArrayEquals
import org.junit.Assert.assertEquals
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
@SdkSuppress(minSdkVersion = 34)
class MediaStoreWriterInstrumentedTest {
    private val context: Context
        get() = InstrumentationRegistry.getInstrumentation().targetContext

    private val createdMedia = mutableListOf<Uri>()
    private val sourceFolders = mutableListOf<File>()

    @After
    fun cleanUp() {
        createdMedia.forEach { context.contentResolver.delete(it, null, null) }
        sourceFolders.forEach { it.deleteRecursively() }
    }

    @Test
    fun savesImageToPictures() {
        val sourceBytes = byteArrayOf(1, 2, 3, 4, 5)
        val source = createSourceFile("png", sourceBytes)

        MediaStoreWriter.save(
            context,
            listOf(uriFor(source)),
            listOf("image/png"),
        )

        val foundDestination = findByDisplayName(
            MediaStore.Images.Media.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY),
            source.name,
        )
        assertNotNull(foundDestination)
        val destination = foundDestination!!
        createdMedia.add(destination)

        context.contentResolver.query(
            destination,
            arrayOf(
                MediaStore.MediaColumns.MIME_TYPE,
                MediaStore.MediaColumns.RELATIVE_PATH,
            ),
            null,
            null,
            null,
        )!!.use { cursor ->
            assertTrue(cursor.moveToFirst())
            assertEquals("image/png", cursor.getString(0))
            assertEquals(
                Environment.DIRECTORY_PICTURES,
                cursor.getString(1).trimEnd('/'),
            )
        }
        val savedBytes = context.contentResolver.openInputStream(destination)!!.use {
            it.readBytes()
        }
        assertArrayEquals(sourceBytes, savedBytes)
    }

    @Test
    fun rollsBackEarlierFilesWhenAnotherFileCannotBeRead() {
        val source = createSourceFile("png", byteArrayOf(1, 2, 3))
        val missingSource = Uri.parse(
            "content://${context.packageName}.missing/${UUID.randomUUID()}",
        )

        val result = runCatching {
            MediaStoreWriter.save(
                context,
                listOf(uriFor(source), missingSource),
                listOf("image/png", "image/png"),
            )
        }

        val remainingDestination = findByDisplayName(
            MediaStore.Images.Media.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY),
            source.name,
        )
        if (remainingDestination != null) createdMedia.add(remainingDestination)

        assertTrue(result.isFailure)
        assertNull(remainingDestination)
    }

    private fun createSourceFile(extension: String, bytes: ByteArray): File {
        val folder = File(context.cacheDir, "share_plus/test-${UUID.randomUUID()}")
            .apply { mkdirs() }
        sourceFolders.add(folder)
        return File(folder, "share-plus-test-${UUID.randomUUID()}.$extension").apply {
            writeBytes(bytes)
        }
    }

    private fun uriFor(file: File): Uri = FileProvider.getUriForFile(
        context,
        "${context.packageName}.flutter.share_provider",
        file,
    )

    private fun findByDisplayName(collection: Uri, displayName: String): Uri? {
        context.contentResolver.query(
            collection,
            arrayOf(MediaStore.MediaColumns._ID),
            "${MediaStore.MediaColumns.DISPLAY_NAME} = ?",
            arrayOf(displayName),
            null,
        )?.use { cursor ->
            if (cursor.moveToFirst()) {
                return ContentUris.withAppendedId(collection, cursor.getLong(0))
            }
        }
        return null
    }
}
