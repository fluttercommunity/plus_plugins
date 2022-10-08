import 'package:filepicker_windows/filepicker_windows.dart';

/// Picks a file from the file system on Windows & returns it's path as [String].
Future<String?> pickFile() async {
  final picker = OpenFilePicker()
    ..filterSpecification = {'Images': '*.jpg;*.jpeg;*.png;*.gif'};
  final result = picker.getFile();
  return result?.path;
}
