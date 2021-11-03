/// The Windows implementation of `device_info_plus`.
library device_info_plus_windows;

import 'dart:ffi';

import 'package:device_info_plus_platform_interface/device_info_plus_platform_interface.dart';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

/// The Windows implementation of [DeviceInfoPlatform].
class DeviceInfoWindows extends DeviceInfoPlatform {
  /// Register this dart class as the platform implementation for linux
  static void registerWith() {
    DeviceInfoPlatform.instance = DeviceInfoWindows();
  }

  /// Returns a [WindowsDeviceInfo] with information about the device.
  @override
  Future<WindowsDeviceInfo> windowsInfo() {
    final system_info = _getInfoStructPointer();

    GetSystemInfo(system_info);

    final data = WindowsDeviceInfo(
      numberOfCores: system_info.ref.dwNumberOfProcessors,
      computerName: _getComputerName(),
      systemMemoryInMegabytes: _getSystemMemoryInMegabytes(),
    );
    calloc.free(system_info);
    return Future.value(data);
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
