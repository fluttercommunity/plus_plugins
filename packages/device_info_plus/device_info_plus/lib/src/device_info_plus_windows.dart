/// The Windows implementation of `device_info_plus`.
library device_info_plus_windows;

import 'dart:ffi';
import 'dart:typed_data';

import 'package:device_info_plus_platform_interface/device_info_plus_platform_interface.dart';
import 'package:ffi/ffi.dart';
import 'package:meta/meta.dart';
import 'package:win32/win32.dart';

/// The Windows implementation of [DeviceInfoPlatform].
class DeviceInfoPlusWindowsPlugin extends DeviceInfoPlatform {
  /// Register this dart class as the platform implementation for windows
  static void registerWith() {
    DeviceInfoPlatform.instance = DeviceInfoPlusWindowsPlugin();
  }

  WindowsDeviceInfo? _cache;

  /// Returns Windows information like major version, minor version, build number & platform ID.
  void Function(Pointer<OSVERSIONINFOEX>)? _rtlGetVersion;

  /// Returns a [WindowsDeviceInfo] with information about the device.
  @override
  Future<WindowsDeviceInfo> windowsInfo() {
    return Future.value(_cache ??= getInfo());
  }

  @visibleForTesting
  WindowsDeviceInfo getInfo() {
    _rtlGetVersion ??= DynamicLibrary.open('ntdll.dll').lookupFunction<
        Void Function(Pointer<OSVERSIONINFOEX>),
        void Function(Pointer<OSVERSIONINFOEX>)>('RtlGetVersion');

    final systemInfo = getSYSTEMINFOPointer();
    final osVersionInfo = getOSVERSIONINFOEXPointer();
    final buildLab = getRegistryValue(
      HKEY_LOCAL_MACHINE,
      'SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\',
      'BuildLab',
      '',
    ) as String;
    final buildLabEx = getRegistryValue(
      HKEY_LOCAL_MACHINE,
      'SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\',
      'BuildLabEx',
      '',
    ) as String;
    final digitalProductId = getRegistryValue(
      HKEY_LOCAL_MACHINE,
      'SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\',
      'DigitalProductId',
      Uint8List.fromList([]),
    ) as Uint8List;
    final displayVersion = getRegistryValue(
      HKEY_LOCAL_MACHINE,
      'SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\',
      'DisplayVersion',
      '',
    ) as String;
    final editionId = getRegistryValue(
        HKEY_LOCAL_MACHINE,
        'SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\',
        'EditionID',
        '') as String;
    final installDate = DateTime.fromMillisecondsSinceEpoch(1000 *
        getRegistryValue(
          HKEY_LOCAL_MACHINE,
          'SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\',
          'InstallDate',
          0,
        ) as int);
    final productId = getRegistryValue(
      HKEY_LOCAL_MACHINE,
      'SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\',
      'ProductId',
      '',
    ) as String;
    var productName = getRegistryValue(
      HKEY_LOCAL_MACHINE,
      'SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\',
      'ProductName',
      '',
    ) as String;
    final registeredOwner = getRegistryValue(
      HKEY_LOCAL_MACHINE,
      'SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\',
      'RegisteredOwner',
      '',
    ) as String;
    final releaseId = getRegistryValue(
      HKEY_LOCAL_MACHINE,
      'SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\',
      'ReleaseId',
      '',
    ) as String;
    final deviceId = getRegistryValue(
      HKEY_LOCAL_MACHINE,
      'SOFTWARE\\Microsoft\\SQMClient\\',
      'MachineId',
      '',
    ) as String;
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
      computerName: getComputerName(),
      systemMemoryInMegabytes: getSystemMemoryInMegabytes(),
      userName: getUserName(),
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

  @visibleForTesting
  int getSystemMemoryInMegabytes() {
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

  @visibleForTesting
  String getComputerName() {
    final nameLength = calloc<Uint32>();
    String name;

    GetComputerNameEx(
      COMPUTER_NAME_FORMAT.ComputerNameDnsFullyQualified,
      nullptr,
      nameLength,
    );
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

  @visibleForTesting
  String getUserName() {
    const unLen = 256;
    final pcbBuffer = calloc<DWORD>()..value = unLen + 1;
    final lpBuffer = wsalloc(unLen + 1);
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

  @visibleForTesting
  Pointer<SYSTEM_INFO> getSYSTEMINFOPointer() {
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

  @visibleForTesting
  Pointer<OSVERSIONINFOEX> getOSVERSIONINFOEXPointer() {
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
  @visibleForTesting
  dynamic getRegistryValue(
    int key,
    String subKey,
    String valueName,
    dynamic fallbackValue,
  ) {
    dynamic dataValue;
    final subKeyPtr = TEXT(subKey);
    final valueNamePtr = TEXT(valueName);
    final openKeyPtr = calloc<HANDLE>();
    final dataType = calloc<DWORD>();
    final data = calloc<BYTE>(256);
    final dataSize = calloc<DWORD>()..value = 512;
    var result = RegOpenKeyEx(key, subKeyPtr, 0, KEY_READ, openKeyPtr);
    void freeAllocations() {
      free(subKeyPtr);
      free(valueNamePtr);
      free(openKeyPtr);
      free(data);
      free(dataSize);
      RegCloseKey(openKeyPtr.value);
    }

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
        freeAllocations();
        return dataValue;
      } else {
        freeAllocations();
        return fallbackValue;
      }
    } else {
      freeAllocations();
      return fallbackValue;
    }
  }
}
