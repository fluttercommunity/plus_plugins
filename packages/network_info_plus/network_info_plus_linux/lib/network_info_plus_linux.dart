/// The Linux implementation of `network_info_plus`.
library network_info_plus_linux;

// network_info_plus_linux depends on dbus which uses FFI internally; export
// a stub for platforms that don't support FFI (e.g., web) to avoid having
// transitive dependencies break web compilation.
export 'src/network_info_stub.dart'
    if (dart.library.ffi) 'src/network_info_real.dart';
