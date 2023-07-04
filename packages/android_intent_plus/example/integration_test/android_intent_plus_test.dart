import 'dart:convert';
import 'dart:io';

import 'package:android_intent_example/create_bundle_and_return.dart';
import 'package:android_intent_example/main.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// This is a smoke test that verifies that the example app builds and loads.
/// Because this plugin works by launching Android platform UIs it's not
/// possible to meaningfully test it through its Dart interface currently. There
/// are more useful unit tests for the platform logic under android/src/test/.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('testWidgets', () {
    testWidgets('Embedding example app loads', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Verify that the new embedding example app builds
      if (Platform.isAndroid) {
        expect(
          find.byWidgetPredicate(
            (Widget widget) =>
                widget is Text && widget.data!.startsWith('Tap here'),
          ),
          findsNWidgets(5),
        );
      } else {
        expect(
          find.byWidgetPredicate(
            (Widget widget) =>
                widget is Text &&
                widget.data!.startsWith('This plugin only works with Android'),
          ),
          findsOneWidget,
        );
      }
    });

    testWidgets('Launch throws when no Activity is found',
        (WidgetTester tester) async {
      // We can't test that any of this is really working, this is mostly just
      // checking that the plugin API is registered. Only works on Android.
      const intent = AndroidIntent(action: 'LAUNCH', package: 'foobar');
      await expectLater(() async => await intent.launch(),
          throwsA((Exception e) {
        return e is PlatformException &&
            e.message!.contains('No Activity found to handle Intent');
      }));
    }, skip: !Platform.isAndroid);

    testWidgets('Set an alarm on weekdays at 9:30pm should not throw',
        (WidgetTester tester) async {
      const intent = AndroidIntent(
          action: 'android.intent.action.SET_ALARM',
          arguments: <String, dynamic>{
            'android.intent.extra.alarm.DAYS': <int>[2, 3, 4, 5, 6],
            'android.intent.extra.alarm.HOUR': 21,
            'android.intent.extra.alarm.MINUTES': 30,
            'android.intent.extra.alarm.SKIP_UI': true,
            'android.intent.extra.alarm.MESSAGE': 'Just for Integration test',
          });
      await intent.launch();
    }, skip: !Platform.isAndroid);

    testWidgets('LaunchChooser should not throw', (WidgetTester tester) async {
      const intent = AndroidIntent(
        action: 'android.intent.action.SEND',
        type: 'plain/text',
        data: 'text example',
      );
      await intent.launchChooser('title');
    }, skip: !Platform.isAndroid);

    testWidgets('SendBroadcast should not throw', (WidgetTester tester) async {
      const intent = AndroidIntent(
        action: 'com.example.broadcast',
      );
      await intent.sendBroadcast();
    }, skip: !Platform.isAndroid);

    testWidgets(
        'CanResolveActivity returns true when example Activity is found',
        (WidgetTester tester) async {
      const intent = AndroidIntent(
        action: 'action_view',
        package: 'io.flutter.plugins.androidintentexample',
        componentName: 'io.flutter.plugins.androidintentexample.MainActivity',
      );
      await expectLater(await intent.canResolveActivity(), isTrue);
    }, skip: !Platform.isAndroid);

    testWidgets('CanResolveActivity returns false when no Activity is found',
        (WidgetTester tester) async {
      const intent = AndroidIntent(action: 'LAUNCH', package: 'foobar');
      await expectLater(await intent.canResolveActivity(), isFalse);
    }, skip: !Platform.isAndroid);
  });

  group('CreateBundleAndReturn', () {
    final bool Function(dynamic, dynamic) deepEq =
        const DeepCollectionEquality.unordered().equals;

    printComparison({
      required Map<String, dynamic> expectedValue,
      required Map<String, dynamic> actualValue,
    }) {
      debugPrint(
        'expectedValue: ${const JsonEncoder.withIndent(('  ')).convert(expectedValue)}',
      );
      debugPrint(
        'actualValue: ${const JsonEncoder.withIndent('  ').convert(actualValue)}',
      );
    }

    bool bundlesAreEqual(Bundles source, Bundles result) {
      final sourceAsMap = source.toJson();
      final resultAsMap = result.toJson();
      printComparison(
        expectedValue: sourceAsMap,
        actualValue: resultAsMap,
      );
      final isEqual = deepEq(sourceAsMap, resultAsMap);
      return isEqual;
    }

    Future<void> performTest(Bundles source) async {
      final result = await CreateBundleAndReturn.go(source);
      expect(bundlesAreEqual(source, result), true);
    }

    Future<void> performTestExpectedNotEqual(
      Bundles source,
      Bundles expectedResult,
    ) async {
      final result = await CreateBundleAndReturn.go(source);
      final resultAsMap = result.toJson();
      final expectedResultAsMap = expectedResult.toJson();
      printComparison(
        expectedValue: expectedResultAsMap,
        actualValue: resultAsMap,
      );
      expect(deepEq(expectedResultAsMap, resultAsMap), true);
    }

    test(
      'emptyBundle',
      () => performTest(TestValues.emptyBundle),
    );

    test(
      'bundleWithBoolean',
      () => performTest(TestValues.bundleWithBoolean),
    );

    test(
      'bundleWithBooleanArray',
      () => performTest(TestValues.bundleWithBooleanArray),
    );

    test(
      'bundleWithBundle',
      () => performTest(TestValues.bundleWithBundle),
    );

    test(
      'bundleWithByte',
      () => performTest(
        TestValues.bundleWithByte,
      ),
    );

    test(
      'bundleWithByteInvalidLowerBound',
      () {
        expect(
          () => performTest(
            TestValues.bundleWithByteInvalidLowerBound,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is RangeError &&
                  x.message == 'Value not in range' &&
                  x.name == 'value must be between -128 and 127, inclusive.' &&
                  x.invalidValue == -129,
            ),
          ),
        );
      },
    );

    test(
      'bundleWithByteInvalidUpperBound',
      () {
        expect(
          () => performTest(
            TestValues.bundleWithByteInvalidUpperBound,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is RangeError &&
                  x.message == 'Value not in range' &&
                  x.name == 'value must be between -128 and 127, inclusive.' &&
                  x.invalidValue == 128,
            ),
          ),
        );
      },
    );

    test(
      'bundleWithByteArray',
      () => performTest(
        TestValues.bundleWithByteArray,
      ),
    );

    test(
      'bundleWithByteArrayInvalidLowerBound',
      () {
        expect(
          () => performTest(
            TestValues.bundleWithByteArrayInvalidLowerBound,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is RangeError &&
                  x.message == 'Value not in range' &&
                  x.name == 'value must be between -128 and 127, inclusive.' &&
                  x.invalidValue == -129,
            ),
          ),
        );
      },
    );

    test(
      'bundleWithByteArrayInvalidUpperBound',
      () {
        expect(
          () => performTest(
            TestValues.bundleWithByteArrayInvalidUpperBound,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is RangeError &&
                  x.message == 'Value not in range' &&
                  x.name == 'value must be between -128 and 127, inclusive.' &&
                  x.invalidValue == 128,
            ),
          ),
        );
      },
    );

    test(
      'bundleWithChar',
      () => performTest(
        TestValues.bundleWithChar,
      ),
    );

    test(
      'bundleWithCharInvalidChar',
      () {
        expect(
          () => performTest(
            TestValues.bundleWithCharInvalidChar,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is RangeError &&
                  x.message == 'Value not in range' &&
                  x.name == 'value.length must be 1.' &&
                  x.invalidValue == 6,
            ),
          ),
        );
      },
    );

    //We do not expect the result to match, because a bundle stores a CharSequence as a String
    test(
      'bundleWithCharSequenceNotEqualsSource',
      () => performTestExpectedNotEqual(
        TestValues.bundleWithCharSequence,
        TestValues.bundleWithString,
      ),
    );

    //We do not expect the result to match, because a bundle stores a CharSequence as a String
    test(
      'bundleWithCharSequenceArray',
      () => performTestExpectedNotEqual(
        TestValues.bundleWithCharSequenceArray,
        TestValues.bundleWithStringArray,
      ),
    );

    //We do not expect the result to match, because a bundle stores a CharSequence as a String
    test(
      'bundleWithCharSequenceArrayList',
      () => performTestExpectedNotEqual(
        TestValues.bundleWithCharSequenceArrayList,
        TestValues.bundleWithStringArrayList,
      ),
    );

    test(
      'bundleWithDouble',
      () => performTest(
        TestValues.bundleWithDouble,
      ),
    );

    test(
      'bundleWithDoubleArray',
      () => performTest(
        TestValues.bundleWithDoubleArray,
      ),
    );

    test(
      'bundleWithFloat',
      () => performTest(
        TestValues.bundleWithFloat,
      ),
    );

    test(
      'bundleWithFloatArray',
      () => performTest(
        TestValues.bundleWithFloatArray,
      ),
    );

    test(
      'bundleWithInt',
      () => performTest(TestValues.bundleWithInt),
    );

    test(
      'bundleWithIntInvalidLowerBound',
      () {
        expect(
          () => performTest(
            TestValues.bundleWithIntInvalidLowerBound,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is RangeError &&
                  x.message == 'Value not in range' &&
                  x.name ==
                      'value must be between -2147483648 and 2147483647, inclusive.' &&
                  x.invalidValue == -2147483649,
            ),
          ),
        );
      },
    );

    test(
      'bundleWithIntInvalidUpperBound',
      () {
        expect(
          () => performTest(
            TestValues.bundleWithIntInvalidUpperBound,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is RangeError &&
                  x.message == 'Value not in range' &&
                  x.name ==
                      'value must be between -2147483648 and 2147483647, inclusive.' &&
                  x.invalidValue == 2147483648,
            ),
          ),
        );
      },
    );

    test(
      'bundleWithIntArray',
      () => performTest(
        TestValues.bundleWithIntArray,
      ),
    );

    test(
      'bundleWithIntArrayInvalidLowerBound',
      () {
        expect(
          () => performTest(
            TestValues.bundleWithIntArrayInvalidLowerBound,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is RangeError &&
                  x.message == 'Value not in range' &&
                  x.name ==
                      'value must be between -2147483648 and 2147483647, inclusive.' &&
                  x.invalidValue == -2147483649,
            ),
          ),
        );
      },
    );

    test(
      'bundleWithIntArrayInvalidUpperBound',
      () {
        expect(
          () => performTest(
            TestValues.bundleWithIntArrayInvalidUpperBound,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is RangeError &&
                  x.message == 'Value not in range' &&
                  x.name ==
                      'value must be between -2147483648 and 2147483647, inclusive.' &&
                  x.invalidValue == 2147483648,
            ),
          ),
        );
      },
    );

    test(
      'bundleWithIntegerArrayList',
      () => performTest(
        TestValues.bundleWithIntegerArrayList,
      ),
    );

    test(
      'bundleWithIntegerArrayListInvalidLowerBound',
      () {
        expect(
          () => performTest(
            TestValues.bundleWithIntegerArrayListInvalidLowerBound,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is RangeError &&
                  x.message == 'Value not in range' &&
                  x.name ==
                      'value must be between -2147483648 and 2147483647, inclusive.' &&
                  x.invalidValue == -2147483649,
            ),
          ),
        );
      },
    );

    test(
      'bundleWithIntegerArrayListInvalidUpperBound',
      () {
        expect(
          () => performTest(
            TestValues.bundleWithIntegerArrayListInvalidUpperBound,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is RangeError &&
                  x.message == 'Value not in range' &&
                  x.name ==
                      'value must be between -2147483648 and 2147483647, inclusive.' &&
                  x.invalidValue == 2147483648,
            ),
          ),
        );
      },
    );

    test(
      'bundleWithLong',
      () => performTest(
        TestValues.bundleWithLong,
      ),
    );

    test(
      'bundleWithLongArray',
      () => performTest(
        TestValues.bundleWithLongArray,
      ),
    );

    //Note that the result is not equal to the source, because a bundle stores a Parcelable as a Bundle
    test(
      'bundleWithParcelable',
      () => performTestExpectedNotEqual(
        TestValues.bundleWithParcelable,
        TestValues.bundleWithBundle,
      ),
    );

    test(
      'bundleWithParcelableArray',
      () => performTest(
        TestValues.bundleWithParcelableArray,
      ),
    );

    test(
      'bundleWithParcelableArrayList',
      () => performTest(
        TestValues.bundleWithParcelableArrayList,
      ),
    );

    test(
      'bundleWithShort',
      () => performTest(TestValues.bundleWithShort),
    );

    test(
      'bundleWithShortInvalidLowerBound',
      () {
        expect(
          () => performTest(
            TestValues.bundleWithShortInvalidLowerBound,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is RangeError &&
                  x.message == 'Value not in range' &&
                  x.name ==
                      'value must be between -32768 and 32768, inclusive.' &&
                  x.invalidValue == -32769,
            ),
          ),
        );
      },
    );

    test(
      'bundleWithShortInvalidUpperBound',
      () {
        expect(
          () => performTest(
            TestValues.bundleWithShortInvalidUpperBound,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is RangeError &&
                  x.message == 'Value not in range' &&
                  x.name ==
                      'value must be between -32768 and 32768, inclusive.' &&
                  x.invalidValue == 32768,
            ),
          ),
        );
      },
    );

    test(
      'bundleWithShortArray',
      () => performTest(TestValues.bundleWithShortArray),
    );

    test(
      'bundleWithShortArrayInvalidLowerBound',
      () {
        expect(
          () => performTest(
            TestValues.bundleWithShortArrayInvalidLowerBound,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is RangeError &&
                  x.message == 'Value not in range' &&
                  x.name ==
                      'value must be between -32768 and 32767, inclusive.' &&
                  x.invalidValue == -32769,
            ),
          ),
        );
      },
    );

    test(
      'bundleWithShortArrayInvalidUpperBound',
      () {
        expect(
          () => performTest(
            TestValues.bundleWithShortArrayInvalidUpperBound,
          ),
          throwsA(
            predicate(
              (x) =>
                  x is RangeError &&
                  x.message == 'Value not in range' &&
                  x.name ==
                      'value must be between -32768 and 32767, inclusive.' &&
                  x.invalidValue == 32768,
            ),
          ),
        );
      },
    );

    test(
      'bundleWithString',
      () => performTest(TestValues.bundleWithString),
    );

    test(
      'bundleWithStringArray',
      () => performTest(
        TestValues.bundleWithStringArray,
      ),
    );

    test(
      'bundleWithStringArrayList',
      () => performTest(
        TestValues.bundleWithStringArrayList,
      ),
    );

    test(
      'bundleWithUnknownPutBaseInBundle',
      () {
        expect(
          () {
            final data = TestValues.bundleWithUnknownPutBaseInBundle;
            Bundles.fromJson(jsonDecode(data));
          },
          throwsA(
            predicate(
              (x) =>
                  x is UnimplementedError &&
                  x.message == 'Unknown PutBase, javaClass: PutStringUNKNOWN',
            ),
          ),
        );
      },
    );

    test(
      'bundleWithUnknownBundleInParcelable',
      () {
        expect(
          () {
            final data = TestValues.bundleWithUnknownBundleInParcelable;
            Bundles.fromJson(jsonDecode(data));
          },
          throwsA(
            predicate(
              (x) =>
                  x is UnimplementedError &&
                  x.message ==
                      'Unknown PutParcelable, javaClass: BundleUNKNOWN',
            ),
          ),
        );
      },
    );

    test(
      'bundleWithUnknownBundleInParcelableArray',
      () {
        expect(
          () {
            final data = TestValues.bundleWithUnknownBundleInParcelableArray;
            Bundles.fromJson(jsonDecode(data));
          },
          throwsA(
            predicate(
              (x) =>
                  x is UnimplementedError &&
                  x.message ==
                      'Unknown PutParcelableArray, javaClass: BundleUNKNOWN',
            ),
          ),
        );
      },
    );

    test(
      'bundleWithUnknownBundleInParcelableArrayList',
      () {
        expect(
          () {
            final data =
                TestValues.bundleWithUnknownBundleInParcelableArrayList;
            Bundles.fromJson(jsonDecode(data));
          },
          throwsA(
            predicate(
              (x) =>
                  x is UnimplementedError &&
                  x.message ==
                      'Unknown PutParcelableArrayList, javaClass: BundleUNKNOWN',
            ),
          ),
        );
      },
    );
  });
}
