/// The Linux implementation of `battery_plus`.
library battery_plus_linux;

// battery_plus_linux depends on dbus which uses FFI internally; export a stub
// for platforms that don't support FFI (e.g., web) to avoid having transitive
// dependencies break web compilation.
export 'src/battery_plus_linux_stub.dart'
    if (dart.library.ffi) 'src/battery_plus_linux_real.dart';
