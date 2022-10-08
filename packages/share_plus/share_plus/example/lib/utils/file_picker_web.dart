/// Dummy implementation for non `dart.library.io` platforms.
Future<String?> pickFile() async {
  throw UnimplementedError();
}
