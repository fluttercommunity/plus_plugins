import 'package:android_intent_plus/src/parcelable_classes/base/parcelable_base.dart';
import 'package:android_intent_plus/src/put_classes/base/put_base.dart';

class PutParcelableArray extends PutBase<List<ParcelableBase>> {
  PutParcelableArray({required String key, required List<ParcelableBase> value})
      : super(key: key, value: value);

  @override
  String get javaClass => 'PutParcelableArray';
}
