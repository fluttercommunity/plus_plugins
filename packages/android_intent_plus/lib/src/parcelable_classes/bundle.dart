import 'package:android_intent_plus/src/parcelable_classes/base/parcelable_base.dart';
import 'package:android_intent_plus/src/put_classes/base/put_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bundle.g.dart';

@JsonSerializable(createFactory: false)
class Bundle extends ParcelableBase {
  Bundle({required this.values});

  final List<PutBase> values;

  @override
  String get javaClass => 'Bundle';

  @override
  Map<String, dynamic> toJson() => _$BundleToJson(this);
}
