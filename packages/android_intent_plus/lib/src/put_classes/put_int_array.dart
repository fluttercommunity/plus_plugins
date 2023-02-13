import 'package:android_intent_plus/src/put_classes/base/put_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'put_int_array.g.dart';

@JsonSerializable(createFactory: false)
class PutIntArray extends PutBase {
  PutIntArray({required String key, required this.values}) : super(key: key);

  final List<int> values;

  @override
  String get javaClass => 'PutIntArray';

  @override
  Map<String, dynamic> toJson() => _$PutIntArrayToJson(this);
}
