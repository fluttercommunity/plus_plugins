import 'package:android_intent_plus/src/parcelable_classes/base/parcelable_base.dart';
import 'package:android_intent_plus/src/parcelable_classes/bundle.dart';
import 'package:android_intent_plus/src/put_classes/base/put_base.dart';

class PutParcelableArrayList extends PutBase<List<ParcelableBase>> {
  PutParcelableArrayList(
      {required String key, required List<ParcelableBase> value})
      : super(key: key, value: value);

  @override
  String get javaClass => 'PutParcelableArrayList';

  factory PutParcelableArrayList.fromJson({
    required String key,
    required dynamic value,
  }) {
    final parcelablesAsMap = List<Map<String, dynamic>>.from(value);

    final parcelables = <ParcelableBase>[];

    for (final item in parcelablesAsMap) {
      final javaClass = item['javaClass'];
      if (javaClass == 'Bundle') {
        parcelables.add(Bundle.fromJson(item['value']));
      } else {
        throw UnimplementedError(
            'Unknown PutParcelableArrayList, javaClass: $javaClass');
      }
    }

    return PutParcelableArrayList(
      key: key,
      value: parcelables,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'key': key,
      'javaClass': javaClass,
      'value': value.map((e) => e.toJson()).toList(),
    };
  }
}
