import 'package:android_intent_plus/src/put_classes/base/put_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'put_string.g.dart';

@JsonSerializable(createFactory: false)
class PutString extends PutBase {
  PutString({required String key, required this.value}) : super(key: key);

  final String value;

  @override
  String get javaClass => 'PutString';

  @override
  Map<String, dynamic> toJson() => _$PutStringToJson(this);
}
