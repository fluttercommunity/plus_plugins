import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

class VersionHelper {
  static VersionHelper instance = VersionHelper._();

  /// Whether the current OS is Windows 10 Redstone 5 or later.
  /// This is used to determine whether the modern Share UI i.e. `DataTransferManager` is available or not.
  ///
  /// References: https://en.wikipedia.org/wiki/Windows_10_version_history
  ///             https://docs.microsoft.com/en-us/windows/win32/api/winnt/ns-winnt-osversioninfoexa
  ///
  bool isWindows10RS5OrGreater = false;

  static const int kWindows10RS5BuildNumber = 17763;

  VersionHelper._() {
    if (Platform.isWindows) {
      final pointer = calloc<OSVERSIONINFOEX>()
        ..ref.dwOSVersionInfoSize = sizeOf<OSVERSIONINFOEX>();
      RtlGetVersion(pointer.cast());
      isWindows10RS5OrGreater =
          pointer.ref.dwBuildNumber >= kWindows10RS5BuildNumber;
      calloc.free(pointer);
    }
  }
}
