// package_info_plus_windows is implemented using FFI; export a stub for
// platforms that don't support FFI (e.g., web) to avoid having transitive
// dependencies break web compilation.
export 'src/package_info_plus_windows_stub.dart'
    if (dart.library.ffi) 'src/package_info_plus_windows_real.dart';
