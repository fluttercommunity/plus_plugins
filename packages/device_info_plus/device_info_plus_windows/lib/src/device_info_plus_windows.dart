/// The Windows implementation of `device_info_plus`.
library device_info_plus_windows;

import 'dart:ffi';
import 'dart:typed_data';

import 'package:device_info_plus_platform_interface/device_info_plus_platform_interface.dart';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

/// The Windows implementation of [DeviceInfoPlatform].
class DeviceInfoWindows extends DeviceInfoPlatform {
  /// Register this dart class as the platform implementation for windows
  static void registerWith() {
    DeviceInfoPlatform.instance = DeviceInfoWindows();
  }

  WindowsDeviceInfo? _cache;

  /// Returns Windows information like major version, minor version, build number & platform ID.
  void Function(Pointer<OSVERSIONINFOEX>)? _rtlGetVersion;

  /// Returns a [WindowsDeviceInfo] with information about the device.
  @override
  Future<WindowsDeviceInfo> windowsInfo() {
    return Future.value(_cache ??= _getInfo());
  }

  WindowsDeviceInfo _getInfo() {
    if (_rtlGetVersion == null) {
      _rtlGetVersion = DynamicLibrary.open('ntdll.dll').lookupFunction<
          Void Function(Pointer<OSVERSIONINFOEX>),
          void Function(Pointer<OSVERSIONINFOEX>)>('RtlGetVersion');
    }
    final systemInfo = _getInfoStructPointer();
    final osVersionInfo = _getOSVERSIONINFOEXPointer();
    // Some registry keys can be modified/deleted by users.
    // Thus, enclosed in a try-catch block for preventing errors due to any missing value.
    var buildLab = '';
    var buildLabEx = '';
    var digitalProductId = Uint8List.fromList([]);
    var displayVersion = '';
    var editionId = '';
    var installDate = DateTime.now();
    var productId = '';
    var productName = '';
    var registeredOwner = '';
    var releaseId = '';
    var deviceId = '';
    try {
      buildLab = _getRegistryValue(
        HKEY_LOCAL_MACHINE,
        'SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\',
        'BuildLab',
      ) as String;
    } catch (_) {}
    try {
      buildLabEx = _getRegistryValue(
        HKEY_LOCAL_MACHINE,
        'SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\',
        'BuildLabEx',
      ) as String;
    } catch (_) {}
    try {
      digitalProductId = _getRegistryValue(
        HKEY_LOCAL_MACHINE,
        'SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\',
        'DigitalProductId',
      ) as Uint8List;
    } catch (_) {}
    try {
      displayVersion = _getRegistryValue(
        HKEY_LOCAL_MACHINE,
        'SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\',
        'DisplayVersion',
      ) as String;
    } catch (_) {}
    try {
      editionId = _getRegistryValue(
        HKEY_LOCAL_MACHINE,
        'SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\',
        'EditionID',
      ) as String;
    } catch (_) {}
    try {
      installDate = DateTime.fromMillisecondsSinceEpoch(
        (_getRegistryValue(
              HKEY_LOCAL_MACHINE,
              'SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\',
              'InstallDate',
            ) as int) *
            1000,
      );
    } catch (_) {}
    try {
      productId = _getRegistryValue(
        HKEY_LOCAL_MACHINE,
        'SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\',
        'ProductId',
      ) as String;
    } catch (_) {}
    try {
      productName = _getRegistryValue(
        HKEY_LOCAL_MACHINE,
        'SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\',
        'ProductName',
      ) as String;
    } catch (_) {}
    try {
      registeredOwner = _getRegistryValue(
        HKEY_LOCAL_MACHINE,
        'SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\',
        'RegisteredOwner',
      ) as String;
    } catch (_) {}
    try {
      releaseId = _getRegistryValue(
        HKEY_LOCAL_MACHINE,
        'SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\',
        'ReleaseId',
      ) as String;
    } catch (_) {}
    try {
      deviceId = _getRegistryValue(
        HKEY_LOCAL_MACHINE,
        'SOFTWARE\\Microsoft\\SQMClient\\',
        'MachineId',
      ) as String;
    } catch (_) {}
    GetSystemInfo(systemInfo);
    // Use `RtlGetVersion` from `ntdll.dll` to get the Windows version.
    _rtlGetVersion!(osVersionInfo);
    // Handle [productName] for Windows 11 separately (as per Raymond Chen's comment).
    // https://stackoverflow.com/questions/69460588/how-can-i-find-the-windows-product-name-in-windows-11
    if (osVersionInfo.ref.dwBuildNumber >= 22000) {
      productName = productName.replaceAll('10', '11');
    }
    final data = WindowsDeviceInfo(
      numberOfCores: systemInfo.ref.dwNumberOfProcessors,
      computerName: _getComputerName(),
      systemMemoryInMegabytes: _getSystemMemoryInMegabytes(),
      userName: _getUserName(),
      majorVersion: osVersionInfo.ref.dwMajorVersion,
      minorVersion: osVersionInfo.ref.dwMinorVersion,
      buildNumber: osVersionInfo.ref.dwBuildNumber,
      platformId: osVersionInfo.ref.dwPlatformId,
      csdVersion: osVersionInfo.ref.szCSDVersion,
      servicePackMajor: osVersionInfo.ref.wServicePackMajor,
      servicePackMinor: osVersionInfo.ref.wServicePackMinor,
      suitMask: osVersionInfo.ref.wSuiteMask,
      productType: osVersionInfo.ref.wProductType,
      reserved: osVersionInfo.ref.wReserved,
      buildLab: buildLab,
      buildLabEx: buildLabEx,
      digitalProductId: digitalProductId,
      displayVersion: displayVersion,
      editionId: editionId,
      installDate: installDate,
      productId: productId,
      productName: productName,
      registeredOwner: registeredOwner,
      releaseId: releaseId,
      deviceId: deviceId,
    );
    calloc.free(systemInfo);
    calloc.free(osVersionInfo);
    return data;
  }
}

int _getSystemMemoryInMegabytes() {
  final memory = calloc<Uint64>();

  try {
    final result = GetPhysicallyInstalledSystemMemory(memory);
    if (result != 0) {
      return memory.value ~/ 1024;
    } else {
      final error = GetLastError();
      throw WindowsException(HRESULT_FROM_WIN32(error));
    }
  } finally {
    calloc.free(memory);
  }
}

String _getComputerName() {
  final nameLength = calloc<Uint32>();
  String name;

  GetComputerNameEx(
      COMPUTER_NAME_FORMAT.ComputerNameDnsFullyQualified, nullptr, nameLength);

  final namePtr = calloc<Uint16>(nameLength.value).cast<Utf16>();

  try {
    final result = GetComputerNameEx(
        COMPUTER_NAME_FORMAT.ComputerNameDnsFullyQualified,
        namePtr,
        nameLength);

    if (result != 0) {
      name = namePtr.toDartString();
    } else {
      throw WindowsException(HRESULT_FROM_WIN32(GetLastError()));
    }
  } finally {
    calloc.free(namePtr);
    calloc.free(nameLength);
  }
  return name;
}

String _getUserName() {
  const UNLEN = 256;
  final pcbBuffer = calloc<DWORD>()..value = UNLEN + 1;
  final lpBuffer = wsalloc(UNLEN + 1);
  try {
    final result = GetUserName(lpBuffer, pcbBuffer);
    if (result != 0) {
      return lpBuffer.toDartString();
    } else {
      throw WindowsException(HRESULT_FROM_WIN32(GetLastError()));
    }
  } finally {
    free(pcbBuffer);
    free(lpBuffer);
  }
}

Pointer<SYSTEM_INFO> _getInfoStructPointer() {
  final pointer = calloc<SYSTEM_INFO>();
  pointer.ref
    ..wProcessorArchitecture = 0
    ..wReserved = 0
    ..dwPageSize = 0
    ..lpMaximumApplicationAddress = nullptr
    ..lpMaximumApplicationAddress = nullptr
    ..dwActiveProcessorMask = 0
    ..dwNumberOfProcessors = 0
    ..dwProcessorType = 0
    ..dwAllocationGranularity = 0
    ..wProcessorLevel = 0
    ..wProcessorRevision = 0;
  return pointer;
}

Pointer<OSVERSIONINFOEX> _getOSVERSIONINFOEXPointer() {
  final pointer = calloc<OSVERSIONINFOEX>();
  pointer.ref
    ..dwOSVersionInfoSize = sizeOf<OSVERSIONINFOEX>()
    ..dwBuildNumber = 0
    ..dwMajorVersion = 0
    ..dwMinorVersion = 0
    ..dwPlatformId = 0
    ..szCSDVersion = ''
    ..wServicePackMajor = 0
    ..wServicePackMinor = 0
    ..wSuiteMask = 0
    ..wProductType = 0
    ..wReserved = 0;
  return pointer;
}

/// Helper function derived from https://github.com/timsneath/win32/blob/main/example/sysinfo.dart.
dynamic _getRegistryValue(int key, String subKey, String valueName) {
  dynamic dataValue;
  final subKeyPtr = TEXT(subKey);
  final valueNamePtr = TEXT(valueName);
  final openKeyPtr = calloc<HANDLE>();
  final dataType = calloc<DWORD>();
  final data = calloc<BYTE>(256);
  final dataSize = calloc<DWORD>()..value = 512;
  try {
    var result = RegOpenKeyEx(key, subKeyPtr, 0, KEY_READ, openKeyPtr);
    if (result == ERROR_SUCCESS) {
      result = RegQueryValueEx(
          openKeyPtr.value, valueNamePtr, nullptr, dataType, data, dataSize);

      if (result == ERROR_SUCCESS) {
        if (dataType.value == REG_DWORD) {
          dataValue = data.cast<DWORD>().value;
        } else if (dataType.value == REG_QWORD) {
          dataValue = data.cast<QWORD>().value;
        } else if (dataType.value == REG_SZ) {
          dataValue = data.cast<Utf16>().toDartString();
        } else if (dataType.value == REG_BINARY) {
          final values = <int>[];
          for (int i = 0; i < 256; i++) {
            values.add(data.cast<Uint8>().elementAt(i).value);
          }
          dataValue = Uint8List.fromList(values);
        } else {
          throw WindowsException(HRESULT_FROM_WIN32(ERROR_INVALID_DATA));
        }
      } else {
        throw WindowsException(HRESULT_FROM_WIN32(result));
      }
    } else {
      throw WindowsException(HRESULT_FROM_WIN32(result));
    }
  } finally {
    free(subKeyPtr);
    free(valueNamePtr);
    free(openKeyPtr);
    free(data);
    free(dataSize);
  }
  RegCloseKey(openKeyPtr.value);

  return dataValue;
}
