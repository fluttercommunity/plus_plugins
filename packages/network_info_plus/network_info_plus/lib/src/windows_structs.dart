// ignore_for_file: camel_case_types, non_constant_identifier_names

// Created structs for SOCKADDR_IN and SOCKADDR_IN6 that are missing in win32 library.

import 'dart:ffi';

/// The SOCKADDR_IN structure specifies a transport address and port for the AF_INET address family.
///
/// {@category struct}
class SOCKADDR_IN extends Struct {
  @Uint16()
  external int sin_family;

  @Uint16()
  external int sin_port;

  @Uint32()
  external int sin_addr;

  @Array(8)
  external Array<Uint8> sin_zero;
}

/// The SOCKADDR_IN6 structure specifies a transport address and port for the AF_INET6 address family.
///
/// {@category struct}
class SOCKADDR_IN6 extends Struct {
  @Uint16()
  external int sin6_family;

  @Uint16()
  external int sin6_port;

  @Uint32()
  external int sin6_flowinfo;

  @Array(16)
  external Array<Uint8> sin6_addr;

  @Uint32()
  external int sin6_scope_id;
}
