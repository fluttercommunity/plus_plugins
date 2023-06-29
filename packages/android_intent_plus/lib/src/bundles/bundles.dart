import 'package:android_intent_plus/src/parcelable_classes/bundle.dart';

class Bundles {
  Bundles({required this.bundles});

  String get javaClass => 'Bundles';

  final List<Bundle> bundles;

  Map<String, dynamic> toJson() => {
        'javaClass': javaClass,
        'value': bundles.map((e) => e.toJson()).toList(),
      };

  factory Bundles.fromJson(Map<String, dynamic> json) {
    final bundles = <Bundle>[];
    for (final item in json['value']) {
      bundles.add(Bundle.fromJson(item['value']));
    }
    return Bundles(bundles: bundles);
  }
}
