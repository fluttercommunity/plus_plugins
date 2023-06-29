import 'package:android_intent_plus/src/parcelable_classes/bundle.dart';

class Bundles {
  Bundles({required this.value});

  String get javaClass => 'Bundles';

  final List<Bundle> value;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'value': value,
        'javaClass': javaClass,
      };
}
