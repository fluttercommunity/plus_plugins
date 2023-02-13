import 'package:android_intent_plus/src/put_classes/base/put_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'put_int.g.dart';

@JsonSerializable(createFactory: false)
class PutInt extends PutBase {
  PutInt({required String key, required this.value}) : super(key: key);
  final int value;

  @override
  String get javaClass => 'PutInt';

  @override
  Map<String, dynamic> toJson() => _$PutIntToJson(this);
}
