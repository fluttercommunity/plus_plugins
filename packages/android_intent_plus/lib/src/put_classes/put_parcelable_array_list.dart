import 'package:android_intent_plus/src/parcelable_classes/base/parcelable_base.dart';
import 'package:android_intent_plus/src/put_classes/base/put_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'put_parcelable_array_list.g.dart';

@JsonSerializable(createFactory: false)
class PutParcelableArrayList extends PutBase {
  PutParcelableArrayList({required String key, required this.values})
      : super(key: key);

  final List<ParcelableBase> values;

  @override
  String get javaClass => 'PutParcelableArrayList';

  @override
  Map<String, dynamic> toJson() => _$PutParcelableArrayListToJson(this);
}
