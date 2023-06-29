import 'package:android_intent_plus/src/parcelable_classes/base/parcelable_base.dart';
import 'package:android_intent_plus/src/put_classes/base/put_base.dart';
import 'package:android_intent_plus/src/put_classes/put_bool.dart';
import 'package:android_intent_plus/src/put_classes/put_bool_array.dart';
import 'package:android_intent_plus/src/put_classes/put_bundle.dart';
import 'package:android_intent_plus/src/put_classes/put_byte.dart';
import 'package:android_intent_plus/src/put_classes/put_byte_array.dart';
import 'package:android_intent_plus/src/put_classes/put_char.dart';
import 'package:android_intent_plus/src/put_classes/put_char_array.dart';
import 'package:android_intent_plus/src/put_classes/put_char_sequence.dart';
import 'package:android_intent_plus/src/put_classes/put_char_sequence_array.dart';
import 'package:android_intent_plus/src/put_classes/put_char_sequence_array_list.dart';
import 'package:android_intent_plus/src/put_classes/put_double.dart';
import 'package:android_intent_plus/src/put_classes/put_double_array.dart';
import 'package:android_intent_plus/src/put_classes/put_float.dart';
import 'package:android_intent_plus/src/put_classes/put_float_array.dart';
import 'package:android_intent_plus/src/put_classes/put_int.dart';
import 'package:android_intent_plus/src/put_classes/put_int_array.dart';
import 'package:android_intent_plus/src/put_classes/put_integer_array_list.dart';
import 'package:android_intent_plus/src/put_classes/put_long.dart';
import 'package:android_intent_plus/src/put_classes/put_long_array.dart';
import 'package:android_intent_plus/src/put_classes/put_parcelable.dart';
import 'package:android_intent_plus/src/put_classes/put_parcelable_array.dart';
import 'package:android_intent_plus/src/put_classes/put_parcelable_array_list.dart';
import 'package:android_intent_plus/src/put_classes/put_short.dart';
import 'package:android_intent_plus/src/put_classes/put_short_array.dart';
import 'package:android_intent_plus/src/put_classes/put_string.dart';
import 'package:android_intent_plus/src/put_classes/put_string_array.dart';
import 'package:android_intent_plus/src/put_classes/put_string_array_list.dart';

class Bundle extends ParcelableBase<List<PutBase>> {
  Bundle({required List<PutBase> value}) : super(value: value);

  @override
  String get javaClass => 'Bundle';

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'javaClass': javaClass,
        'value': value.map((e) => e.toJson()).toList(),
      };

  factory Bundle.fromJson(List<dynamic> items) {
    final values = <PutBase>[];
    for (final putBase in items) {
      final String key = putBase['key'];
      final String javaClass = putBase['javaClass'];
      final dynamic value = putBase['value'];
      switch (javaClass) {
        case 'PutBool':
          values.add(PutBool.fromJson(key: key, value: value));
          break;
        case 'PutBoolArray':
          values.add(PutBoolArray.fromJson(key: key, value: value));
          break;
        case 'PutBundle':
          values.add(PutBundle.fromJson(key: key, value: value));
          break;
        case 'PutByte':
          values.add(PutByte.fromJson(key: key, value: value));
          break;
        case 'PutByteArray':
          values.add(PutByteArray.fromJson(key: key, value: value));
          break;
        case 'PutChar':
          values.add(PutChar.fromJson(key: key, value: value));
          break;
        case 'PutCharArray':
          values.add(PutCharArray.fromJson(key: key, value: value));
          break;
        case 'PutCharSequence':
          values.add(PutCharSequence.fromJson(key: key, value: value));
          break;
        case 'PutCharSequenceArray':
          values.add(PutCharSequenceArray.fromJson(key: key, value: value));
          break;
        case 'PutCharSequenceArrayList':
          values.add(PutCharSequenceArrayList.fromJson(key: key, value: value));
          break;
        case 'PutDouble':
          values.add(PutDouble.fromJson(key: key, value: value));
          break;
        case 'PutDoubleArray':
          values.add(PutDoubleArray.fromJson(key: key, value: value));
          break;
        case 'PutFloat':
          values.add(PutFloat.fromJson(key: key, value: value));
          break;
        case 'PutFloatArray':
          values.add(PutFloatArray.fromJson(key: key, value: value));
          break;
        case 'PutInt':
          values.add(PutInt.fromJson(key: key, value: value));
          break;
        case 'PutIntArray':
          values.add(PutIntArray.fromJson(key: key, value: value));
          break;
        case 'PutIntegerArrayList':
          values.add(PutIntegerArrayList.fromJson(key: key, value: value));
          break;
        case 'PutLong':
          values.add(PutLong.fromJson(key: key, value: value));
          break;
        case 'PutLongArray':
          values.add(PutLongArray.fromJson(key: key, value: value));
          break;
        case 'PutParcelable':
          values.add(PutParcelable.fromJson(key: key, value: value));
          break;
        case 'PutParcelableArray':
          values.add(PutParcelableArray.fromJson(key: key, value: value));
          break;
        case 'PutParcelableArrayList':
          values.add(PutParcelableArrayList.fromJson(key: key, value: value));
          break;
        case 'PutShort':
          values.add(PutShort.fromJson(key: key, value: value));
          break;
        case 'PutShortArray':
          values.add(PutShortArray.fromJson(key: key, value: value));
          break;
        case 'PutString':
          values.add(PutString.fromJson(key: key, value: value));
          break;
        case 'PutStringArray':
          values.add(PutStringArray.fromJson(key: key, value: value));
          break;
        case 'PutStringArrayList':
          values.add(PutStringArrayList.fromJson(key: key, value: value));
          break;
        default:
          throw UnimplementedError('Unknown PutBase, javaClass: $javaClass');
      }
    }
    return Bundle(value: values);
  }
}
