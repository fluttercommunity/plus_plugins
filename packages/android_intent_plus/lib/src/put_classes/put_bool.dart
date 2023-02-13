import 'package:android_intent_plus/src/put_classes/base/put_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'put_bool.g.dart';

@JsonSerializable(createFactory: false)
class PutBool extends PutBase {
  PutBool({required String key, required this.value}) : super(key: key);

  final bool value;

  @override
  String get javaClass => 'PutBool';

  @override
  Map<String, dynamic> toJson() => _$PutBoolToJson(this);
}
