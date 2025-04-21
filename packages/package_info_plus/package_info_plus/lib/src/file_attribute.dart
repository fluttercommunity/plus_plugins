import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

base class FILEATTRIBUTEDATA extends Struct {
  @DWORD()
  external int dwFileAttributes;

  external FILETIME ftCreationTime;

  external FILETIME ftLastAccessTime;

  external FILETIME ftLastWriteTime;

  @DWORD()
  external int nFileSizeHigh;

  @DWORD()
  external int nFileSizeLow;
}

class FileAttributes {
  final String filePath;

  late final DateTime? creationTime;
  late final DateTime? lastWriteTime;

  FileAttributes(this.filePath) {
    final (:creationTime, :lastWriteTime) =
        getFileCreationAndLastWriteTime(filePath);

    this.creationTime = creationTime;
    this.lastWriteTime = lastWriteTime;
  }

  static ({
    DateTime? creationTime,
    DateTime? lastWriteTime,
  }) getFileCreationAndLastWriteTime(String filePath) {
    if (!File(filePath).existsSync()) {
      throw ArgumentError.value(filePath, 'filePath', 'File not present');
    }

    final lptstrFilename = TEXT(filePath);
    final lpFileInformation = calloc<FILEATTRIBUTEDATA>();

    try {
      if (GetFileAttributesEx(lptstrFilename, 0, lpFileInformation) == 0) {
        throw WindowsException(HRESULT_FROM_WIN32(GetLastError()));
      }

      final FILEATTRIBUTEDATA fileInformation = lpFileInformation.ref;

      return (
        creationTime: fileTimeToDartDateTime(
          fileInformation.ftCreationTime,
        ),
        lastWriteTime: fileTimeToDartDateTime(
          fileInformation.ftLastWriteTime,
        ),
      );
    } finally {
      free(lptstrFilename);
      free(lpFileInformation);
    }
  }

  static DateTime? fileTimeToDartDateTime(FILETIME? fileTime) {
    if (fileTime == null) return null;

    final high = fileTime.dwHighDateTime;
    final low = fileTime.dwLowDateTime;

    final fileTime64 = (high << 32) + low;

    final windowsTimeMillis = fileTime64 ~/ 10000;
    final unixTimeMillis = windowsTimeMillis - 11644473600000;

    return DateTime.fromMillisecondsSinceEpoch(unixTimeMillis);
  }
}
