import 'package:android_intent_plus/src/parcelable_classes/base/parcelable_base.dart';
import 'package:android_intent_plus/src/put_classes/base/put_base.dart';

class Bundle extends ParcelableBase<List<PutBase>> {
  Bundle({required List<PutBase> value}) : super(value: value);

  @override
  String get javaClass => 'Bundle';
}
