abstract class ParcelableBase<T> {
  ParcelableBase({required this.value});

  String get javaClass;

  final T value;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'javaClass': javaClass,
        'value': value,
      };
}
