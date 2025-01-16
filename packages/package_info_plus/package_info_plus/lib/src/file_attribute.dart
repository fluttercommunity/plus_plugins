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
    final attributesPtr = getFileAttributes(filePath);

    if (attributesPtr != null) {
      creationTime = fileTimeToDartDateTime(attributesPtr.ref.ftCreationTime);
      lastWriteTime = fileTimeToDartDateTime(attributesPtr.ref.ftLastWriteTime);

      free(attributesPtr);
    } else {
      creationTime = null;
      lastWriteTime = null;
    }
  }

  static Pointer<FILEATTRIBUTEDATA>? getFileAttributes(String filePath) {
    if (!File(filePath).existsSync()) {
      throw ArgumentError.value(filePath, 'filePath', 'File not present');
    }

    final lptstrFilename = TEXT(filePath);
    final lpFileInformation = calloc<FILEATTRIBUTEDATA>();

    try {
      if (GetFileAttributesEx(lptstrFilename, 0, lpFileInformation) == 0) {
        free(lpFileInformation);

        return null;
      }

      return lpFileInformation;
    } finally {}
  }

  static DateTime? fileTimeToDartDateTime(FILETIME? fileTime) {
    if (fileTime == null) return null;

    final high = fileTime.dwHighDateTime;
    final low = fileTime.dwLowDateTime;

    final fileTime64 = (high << 32) + low;

    final unixTimeMs = ((fileTime64 ~/ 10000) - 11644473600000);

    return DateTime.fromMillisecondsSinceEpoch(unixTimeMs);
  }
}
