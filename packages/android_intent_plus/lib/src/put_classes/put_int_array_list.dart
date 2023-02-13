import 'package:android_intent_plus/src/put_classes/base/put_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'put_int_array_list.g.dart';

@JsonSerializable(createFactory: false)
class PutIntArrayList extends PutBase {
  PutIntArrayList({required String key, required this.values})
      : super(key: key);

  final List<int> values;

  @override
  String get javaClass => 'PutIntArrayList';

  @override
  Map<String, dynamic> toJson() => _$PutIntArrayListToJson(this);
}
