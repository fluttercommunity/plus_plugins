import 'package:android_intent_plus/src/parcelable_classes/base/parcelable_base.dart';
import 'package:android_intent_plus/src/put_classes/base/put_base.dart';

class PutParcelableArrayList extends PutBase<List<ParcelableBase>> {
  PutParcelableArrayList(
      {required String key, required List<ParcelableBase> value})
      : super(key: key, value: value);

  @override
  String get javaClass => 'PutParcelableArrayList';
}
