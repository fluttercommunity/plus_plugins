/// The Linux implementation of `connectivity_plus`.
library connectivity_plus_linux;

// connectivity_plus_linux depends on dbus which uses FFI internally; export
// a stub for platforms that don't support FFI (e.g., web) to avoid having
// transitive dependencies break web compilation.
export 'src/connectivity_stub.dart'
    if (dart.library.ffi) 'src/connectivity_real.dart';
