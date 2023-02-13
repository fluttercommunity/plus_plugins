import 'package:android_intent_plus/src/put_classes/base/put_base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'put_bundle.g.dart';

@JsonSerializable(createFactory: false)
class PutBundle extends PutBase {
  PutBundle({required String key, required this.values}) : super(key: key);

  final List<PutBase> values;

  @override
  String get javaClass => 'PutBundle';

  @override
  Map<String, dynamic> toJson() => _$PutBundleToJson(this);
}
