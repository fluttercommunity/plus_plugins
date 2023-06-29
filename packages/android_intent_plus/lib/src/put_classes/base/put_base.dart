abstract class PutBase<T> {
  PutBase({required this.key, required this.value});

  final String key;

  String get javaClass;

  final T value;

  Map<String, dynamic> toJson();
}
