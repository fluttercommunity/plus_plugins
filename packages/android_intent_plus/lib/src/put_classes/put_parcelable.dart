import 'package:android_intent_plus/src/parcelable_classes/base/parcelable_base.dart';
import 'package:android_intent_plus/src/parcelable_classes/bundle.dart';
import 'package:android_intent_plus/src/put_classes/base/put_base.dart';

class PutParcelable extends PutBase<ParcelableBase> {
  PutParcelable({required String key, required ParcelableBase value})
      : super(key: key, value: value);

  @override
  String get javaClass => 'PutParcelable';

  factory PutParcelable.fromJson({
    required String key,
    required dynamic value,
  }) {
    final javaClass = value['javaClass'];
    if (javaClass == 'Bundle') {
      return PutParcelable(
        key: key,
        value: Bundle.fromJson(value['value']),
      );
    } else {
      throw UnimplementedError('Unknown PutParcelable, javaClass: $javaClass');
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'key': key,
      'javaClass': javaClass,
      'value': value.toJson()
    };
  }
}
