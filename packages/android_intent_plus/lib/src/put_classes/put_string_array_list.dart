import 'package:android_intent_plus/src/put_classes/base/put_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'put_string_array_list.g.dart';

@JsonSerializable(createFactory: false)
class PutStringArrayList extends PutBase {
  PutStringArrayList({required String key, required this.values})
      : super(key: key);

  final List<String> values;

  @override
  String get javaClass => 'PutStringArrayList';

  @override
  Map<String, dynamic> toJson() => _$PutStringArrayListToJson(this);
}
