# connectivity_plus_platform_interface

[![Flutter Community: connectivity_plus_platform_interface](https://fluttercommunity.dev/_github/header/connectivity_plus_platform_interface)](https://github.com/fluttercommunity/community)

[![pub package](https://img.shields.io/pub/v/connectivity_plus_platform_interface.svg)](https://pub.dev/packages/connectivity_plus_platform_interface)

A common platform interface for the [`connectivity_plus`][1] plugin.

This interface allows platform-specific implementations of the `connectivity_plus`
plugin, as well as the plugin itself, to ensure they are supporting the
same interface.

# Usage

To implement a new platform-specific implementation of `connectivity_plus`, extend
[`ConnectivityPlatform`][2] with an implementation that performs the
platform-specific behavior, and when you register your plugin, set the default
`ConnectivityPlatform` by calling
`ConnectivityPlatform.instance = MyPlatformConnectivity()`.

# Note on breaking changes

Strongly prefer non-breaking changes (such as adding a method to the interface)
over breaking changes for this package.

See https://flutter.dev/go/platform-interface-breaking-changes for a discussion
on why a less-clean interface is preferable to a breaking change.

[1]: ../
[2]: lib/connectivity_platform_interface.dart
