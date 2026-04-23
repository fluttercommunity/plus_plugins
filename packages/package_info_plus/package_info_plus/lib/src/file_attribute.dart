import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

class FileAttributes {
  final String filePath;

  late final DateTime? creationTime;
  late final DateTime? lastWriteTime;

  FileAttributes(this.filePath) {
    final (:creationTime, :lastWriteTime) = getFileCreationAndLastWriteTime(
      filePath,
    );

    this.creationTime = creationTime;
    this.lastWriteTime = lastWriteTime;
  }

  static ({DateTime? creationTime, DateTime? lastWriteTime})
  getFileCreationAndLastWriteTime(String filePath) {
    if (!File(filePath).existsSync()) {
      throw ArgumentError.value(filePath, 'filePath', 'File not present');
    }

    final lptstrFilename = filePath.toPcwstr();
    final lpFileInformation = calloc<WIN32_FILE_ATTRIBUTE_DATA>();

    try {
      final result = GetFileAttributesEx(
        lptstrFilename,
        GetFileExInfoStandard,
        lpFileInformation,
      );
      if (!result.value) {
        throw WindowsException(result.error.toHRESULT());
      }

      final WIN32_FILE_ATTRIBUTE_DATA fileInformation = lpFileInformation.ref;

      return (
        creationTime: fileInformation.ftCreationTime.toDateTime(),
        lastWriteTime: fileInformation.ftLastWriteTime.toDateTime(),
      );
    } finally {
      free(lptstrFilename);
      free(lpFileInformation);
    }
  }
}
