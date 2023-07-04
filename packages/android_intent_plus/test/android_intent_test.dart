// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:platform/platform.dart';

void main() {
  AndroidIntent androidIntent;
  late MockMethodChannel mockChannel;
  setUp(() {
    mockChannel = MockMethodChannel();
  });

  group('AndroidIntent', () {
    test('raises error if neither an action nor a component is provided', () {
      try {
        androidIntent = AndroidIntent(data: 'https://flutter.dev');
        fail('should raise an AssertionError');
      } on AssertionError catch (e) {
        expect(e.message, 'action or component (or both) must be specified');
      } catch (e) {
        fail('should raise an AssertionError');
      }
    });

    group('launch', () {
      test('pass right params', () async {
        androidIntent = AndroidIntent.private(
            action: 'action_view',
            data: Uri.encodeFull('https://flutter.dev'),
            flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
            channel: mockChannel,
            platform: FakePlatform(operatingSystem: 'android'),
            type: 'video/*');
        await androidIntent.launch();
        verify(mockChannel.invokeMethod<void>('launch', <String, Object>{
          'action': 'action_view',
          'data': Uri.encodeFull('https://flutter.dev'),
          'flags':
              androidIntent.convertFlags(<int>[Flag.FLAG_ACTIVITY_NEW_TASK]),
          'type': 'video/*',
        }));
      });

      test('can send Intent with an action and no component', () async {
        androidIntent = AndroidIntent.private(
          action: 'action_view',
          channel: mockChannel,
          platform: FakePlatform(operatingSystem: 'android'),
        );
        await androidIntent.launch();
        verify(mockChannel.invokeMethod<void>('launch', <String, Object>{
          'action': 'action_view',
        }));
      });

      test('can send Intent with a component and no action', () async {
        androidIntent = AndroidIntent.private(
          package: 'packageName',
          componentName: 'componentName',
          channel: mockChannel,
          platform: FakePlatform(operatingSystem: 'android'),
        );
        await androidIntent.launch();
        verify(mockChannel.invokeMethod<void>('launch', <String, Object>{
          'package': 'packageName',
          'componentName': 'componentName',
        }));
      });

      test('call in ios platform', () async {
        androidIntent = AndroidIntent.private(
            action: 'action_view',
            channel: mockChannel,
            platform: FakePlatform(operatingSystem: 'ios'));
        await androidIntent.launch();
        verifyZeroInteractions(mockChannel);
      });
    });

    group('canResolveActivity', () {
      test('pass right params', () async {
        androidIntent = AndroidIntent.private(
            action: 'action_view',
            data: Uri.encodeFull('https://flutter.dev'),
            flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
            channel: mockChannel,
            platform: FakePlatform(operatingSystem: 'android'),
            type: 'video/*');
        await androidIntent.canResolveActivity();
        verify(mockChannel
            .invokeMethod<void>('canResolveActivity', <String, Object>{
          'action': 'action_view',
          'data': Uri.encodeFull('https://flutter.dev'),
          'flags':
              androidIntent.convertFlags(<int>[Flag.FLAG_ACTIVITY_NEW_TASK]),
          'type': 'video/*',
        }));
      });

      test('can send Intent with an action and no component', () async {
        androidIntent = AndroidIntent.private(
          action: 'action_view',
          channel: mockChannel,
          platform: FakePlatform(operatingSystem: 'android'),
        );
        await androidIntent.canResolveActivity();
        verify(mockChannel
            .invokeMethod<void>('canResolveActivity', <String, Object>{
          'action': 'action_view',
        }));
      });

      test('can send Intent with a component and no action', () async {
        androidIntent = AndroidIntent.private(
          package: 'packageName',
          componentName: 'componentName',
          channel: mockChannel,
          platform: FakePlatform(operatingSystem: 'android'),
        );
        await androidIntent.canResolveActivity();
        verify(mockChannel
            .invokeMethod<void>('canResolveActivity', <String, Object>{
          'package': 'packageName',
          'componentName': 'componentName',
        }));
      });

      test('call in ios platform', () async {
        androidIntent = AndroidIntent.private(
            action: 'action_view',
            channel: mockChannel,
            platform: FakePlatform(operatingSystem: 'ios'));
        await androidIntent.canResolveActivity();
        verifyZeroInteractions(mockChannel);
      });
    });

    group('launchChooser', () {
      test('pass title', () async {
        androidIntent = AndroidIntent.private(
          action: 'action_view',
          channel: mockChannel,
          platform: FakePlatform(operatingSystem: 'android'),
        );
        await androidIntent.launchChooser('title');
        verify(mockChannel.invokeMethod<void>('launchChooser', <String, Object>{
          'action': 'action_view',
          'chooserTitle': 'title',
        }));
      });
    });

    group('sendBroadcast', () {
      test('send a broadcast', () async {
        androidIntent = AndroidIntent.private(
          action: 'com.example.broadcast',
          channel: mockChannel,
          platform: FakePlatform(operatingSystem: 'android'),
        );
        await androidIntent.sendBroadcast();
        verify(mockChannel.invokeMethod<void>('sendBroadcast', <String, Object>{
          'action': 'com.example.broadcast',
        }));
      });

      test('send a broadcast with empty extras', () async {
        androidIntent = AndroidIntent.private(
          action: 'com.example.broadcast',
          extras: Bundles(bundles: <Bundle>[]),
          channel: mockChannel,
          platform: FakePlatform(operatingSystem: 'android'),
        );
        await androidIntent.sendBroadcast();
        verify(mockChannel.invokeMethod<void>('sendBroadcast', <String, Object>{
          'action': 'com.example.broadcast',
          'extras': '''
{
  "javaClass": "Bundles",
  "value": []
}''',
        }));
      });

      test('send a broadcast with extras', () async {
        androidIntent = AndroidIntent.private(
          action: 'com.example.broadcast',
          extras: Bundles(bundles: <Bundle>[
            Bundle(
              value: [
                PutBundle(
                  key: 'com.symbol.datawedge.api.SET_CONFIG',
                  value: [
                    PutString(
                      key: 'PROFILE_NAME',
                      value: 'com.dalosy.count_app',
                    ),
                    PutParcelableArray(
                      key: 'APP_LIST',
                      value: [
                        Bundle(
                          value: [
                            PutString(
                              key: 'PACKAGE_NAME',
                              value: 'com.dalosy.package',
                            ),
                            PutStringArray(
                              key: 'ACTIVITY_LIST',
                              value: ['*'],
                            ),
                            PutStringArrayList(
                              key: 'ACTIVITY_ARRAY_LIST',
                              value: ['1', '2'],
                            )
                          ],
                        )
                      ],
                    ),
                    PutParcelableArrayList(
                      key: 'PLUGIN_CONFIG',
                      value: [
                        Bundle(
                          value: [
                            PutString(
                              key: 'PLUGIN_NAME',
                              value: 'BARCODE',
                            ),
                            PutBool(
                              key: 'RESET_CONFIG',
                              value: true,
                            ),
                            PutBundle(
                              key: 'PARAM_LIST',
                              value: [
                                PutString(
                                  key: 'scanner_selection',
                                  value: 'auto',
                                ),
                                PutInt(
                                  key: 'picklist',
                                  value: 1,
                                ),
                                PutIntArray(
                                  key: 'int_array_test',
                                  value: [1, 2, 3, 4, 5],
                                ),
                                PutIntegerArrayList(
                                  key: 'int_array_list_test',
                                  value: [1, 2, 3, 4, 5, 6],
                                ),
                                PutBoolArray(
                                  key: 'bool_array_test',
                                  value: [true, false, false, true],
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
            Bundle(
              value: [],
            ),
          ]),
          channel: mockChannel,
          platform: FakePlatform(operatingSystem: 'android'),
        );
        await androidIntent.sendBroadcast();
        verify(mockChannel.invokeMethod<void>('sendBroadcast', <String, Object>{
          'action': 'com.example.broadcast',
          'extras': '''
{
  "javaClass": "Bundles",
  "value": [
    {
      "javaClass": "Bundle",
      "value": [
        {
          "key": "com.symbol.datawedge.api.SET_CONFIG",
          "javaClass": "PutBundle",
          "value": [
            {
              "key": "PROFILE_NAME",
              "javaClass": "PutString",
              "value": "com.dalosy.count_app"
            },
            {
              "key": "APP_LIST",
              "javaClass": "PutParcelableArray",
              "value": [
                {
                  "javaClass": "Bundle",
                  "value": [
                    {
                      "key": "PACKAGE_NAME",
                      "javaClass": "PutString",
                      "value": "com.dalosy.package"
                    },
                    {
                      "key": "ACTIVITY_LIST",
                      "javaClass": "PutStringArray",
                      "value": [
                        "*"
                      ]
                    },
                    {
                      "key": "ACTIVITY_ARRAY_LIST",
                      "javaClass": "PutStringArrayList",
                      "value": [
                        "1",
                        "2"
                      ]
                    }
                  ]
                }
              ]
            },
            {
              "key": "PLUGIN_CONFIG",
              "javaClass": "PutParcelableArrayList",
              "value": [
                {
                  "javaClass": "Bundle",
                  "value": [
                    {
                      "key": "PLUGIN_NAME",
                      "javaClass": "PutString",
                      "value": "BARCODE"
                    },
                    {
                      "key": "RESET_CONFIG",
                      "javaClass": "PutBool",
                      "value": true
                    },
                    {
                      "key": "PARAM_LIST",
                      "javaClass": "PutBundle",
                      "value": [
                        {
                          "key": "scanner_selection",
                          "javaClass": "PutString",
                          "value": "auto"
                        },
                        {
                          "key": "picklist",
                          "javaClass": "PutInt",
                          "value": 1
                        },
                        {
                          "key": "int_array_test",
                          "javaClass": "PutIntArray",
                          "value": [
                            1,
                            2,
                            3,
                            4,
                            5
                          ]
                        },
                        {
                          "key": "int_array_list_test",
                          "javaClass": "PutIntegerArrayList",
                          "value": [
                            1,
                            2,
                            3,
                            4,
                            5,
                            6
                          ]
                        },
                        {
                          "key": "bool_array_test",
                          "javaClass": "PutBoolArray",
                          "value": [
                            true,
                            false,
                            false,
                            true
                          ]
                        }
                      ]
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
    },
    {
      "javaClass": "Bundle",
      "value": []
    }
  ]
}''',
        }));
      });
    });
  });

  group('toAndFromJson', () {
    final Function deepEq = const DeepCollectionEquality.unordered().equals;

    Future<void> performTest({
      required Bundles source,
      required String testName,
    }) async {
      final sourceAsMap = source.toJson();
      final prettyJson =
          const JsonEncoder.withIndent(('  ')).convert(sourceAsMap);
      debugPrint('source:\r\n$prettyJson');
      final String jsonString = jsonEncode(sourceAsMap);
      final Bundles resultBundles = Bundles.fromJson(jsonDecode(jsonString));
      final resultAsMap = resultBundles.toJson();
      expect(deepEq(sourceAsMap, resultAsMap), true);
    }

    test(
      'emptyBundle',
      () async => await performTest(
        source: TestValues.emptyBundle,
        testName: 'emptyBundle',
      ),
    );

    test(
      'bundleWithBoolean',
      () async => await performTest(
        source: TestValues.bundleWithBoolean,
        testName: 'bundleWithBoolean',
      ),
    );

    test(
      'bundleWithBooleanArray',
      () async => await performTest(
        source: TestValues.bundleWithBooleanArray,
        testName: 'bundleWithBooleanArray',
      ),
    );

    test(
      'bundleWithBundle',
      () async => await performTest(
        source: TestValues.bundleWithBundle,
        testName: 'bundleWithBundle',
      ),
    );

    test(
      'bundleWithByte',
      () async => await performTest(
        source: TestValues.bundleWithByte,
        testName: 'bundleWithByte',
      ),
    );

    test(
      'bundleWithByteInvalidLowerBound',
      () {
        expect(
          () => TestValues.bundleWithByteInvalidLowerBound,
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
          () => TestValues.bundleWithByteInvalidUpperBound,
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
      () async => await performTest(
        source: TestValues.bundleWithByteArray,
        testName: 'bundleWithByteArray',
      ),
    );

    test(
      'bundleWithByteArrayInvalidLowerBound',
      () {
        expect(
          () => TestValues.bundleWithByteArrayInvalidLowerBound,
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
          () => TestValues.bundleWithByteArrayInvalidUpperBound,
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
      () async => await performTest(
        source: TestValues.bundleWithChar,
        testName: 'bundleWithChar',
      ),
    );

    test(
      'bundleWithCharInvalidChar',
      () {
        expect(
          () => TestValues.bundleWithCharInvalidChar,
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

    test(
      'bundleWithCharArray',
      () async => await performTest(
        source: TestValues.bundleWithCharArray,
        testName: 'bundleWithCharArray',
      ),
    );

    test(
      'bundleWithCharArrayInvalidChar',
      () {
        expect(
          () => TestValues.bundleWithCharArrayInvalidChar,
          throwsA(
            predicate(
              (x) =>
                  x is RangeError &&
                  x.message == 'Value not in range' &&
                  x.name == 'value.length must be 1.' &&
                  x.invalidValue == 3,
            ),
          ),
        );
      },
    );

    test(
      'bundleWithCharSequence',
      () async => await performTest(
        source: TestValues.bundleWithCharSequence,
        testName: 'bundleWithCharSequence',
      ),
    );

    test(
      'bundleWithCharSequenceArray',
      () async => await performTest(
        source: TestValues.bundleWithCharSequenceArray,
        testName: 'bundleWithCharSequenceArray',
      ),
    );

    test(
      'bundleWithCharSequenceArrayList',
      () async => await performTest(
        source: TestValues.bundleWithCharSequenceArrayList,
        testName: 'bundleWithCharSequenceArrayList',
      ),
    );

    test(
      'bundleWithDouble',
      () async => await performTest(
        source: TestValues.bundleWithDouble,
        testName: 'bundleWithDouble',
      ),
    );

    test(
      'bundleWithDoubleArray',
      () async => await performTest(
        source: TestValues.bundleWithDoubleArray,
        testName: 'bundleWithDoubleArray',
      ),
    );

    test(
      'bundleWithFloat',
      () async => await performTest(
        source: TestValues.bundleWithFloat,
        testName: 'bundleWithFloat',
      ),
    );

    test(
      'bundleWithFloatArray',
      () async => await performTest(
        source: TestValues.bundleWithFloatArray,
        testName: 'bundleWithFloatArray',
      ),
    );

    test(
      'bundleWithInt',
      () async => await performTest(
        source: TestValues.bundleWithInt,
        testName: 'bundleWithInt',
      ),
    );

    test(
      'bundleWithIntInvalidLowerBound',
      () {
        expect(
          () => TestValues.bundleWithIntInvalidLowerBound,
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
          () => TestValues.bundleWithIntInvalidUpperBound,
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
      () async => await performTest(
        source: TestValues.bundleWithIntArray,
        testName: 'bundleWithIntArray',
      ),
    );

    test(
      'bundleWithIntArrayInvalidLowerBound',
      () {
        expect(
          () => TestValues.bundleWithIntArrayInvalidLowerBound,
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
          () => TestValues.bundleWithIntArrayInvalidUpperBound,
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
      () async => await performTest(
        source: TestValues.bundleWithIntegerArrayList,
        testName: 'bundleWithIntegerArrayList',
      ),
    );

    test(
      'bundleWithIntegerArrayListInvalidLowerBound',
      () {
        expect(
          () => TestValues.bundleWithIntegerArrayListInvalidLowerBound,
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
          () => TestValues.bundleWithIntegerArrayListInvalidUpperBound,
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
      () async => await performTest(
        source: TestValues.bundleWithLong,
        testName: 'bundleWithLong',
      ),
    );

    test(
      'bundleWithLongArray',
      () async => await performTest(
        source: TestValues.bundleWithLongArray,
        testName: 'bundleWithLongArray',
      ),
    );

    test(
      'bundleWithParcelable',
      () async => await performTest(
        source: TestValues.bundleWithParcelable,
        testName: 'bundleWithParcelable',
      ),
    );

    test(
      'bundleWithParcelableArray',
      () async => await performTest(
        source: TestValues.bundleWithParcelableArray,
        testName: 'bundleWithParcelableArray',
      ),
    );

    test(
      'bundleWithParcelableArrayList',
      () async => await performTest(
        source: TestValues.bundleWithParcelableArrayList,
        testName: 'bundleWithParcelableArrayList',
      ),
    );

    test(
      'bundleWithShort',
      () async => await performTest(
        source: TestValues.bundleWithShort,
        testName: 'bundleWithShort',
      ),
    );

    test(
      'bundleWithShortInvalidLowerBound',
      () {
        expect(
          () => TestValues.bundleWithShortInvalidLowerBound,
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
          () => TestValues.bundleWithShortInvalidUpperBound,
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
      () async => await performTest(
        source: TestValues.bundleWithShortArray,
        testName: 'bundleWithShortArray',
      ),
    );

    test(
      'bundleWithShortArrayInvalidLowerBound',
      () {
        expect(
          () => TestValues.bundleWithShortArrayInvalidLowerBound,
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
          () => TestValues.bundleWithShortArrayInvalidUpperBound,
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
      () async => await performTest(
        source: TestValues.bundleWithString,
        testName: 'bundleWithString',
      ),
    );

    test(
      'bundleWithStringArray',
      () async => await performTest(
        source: TestValues.bundleWithStringArray,
        testName: 'bundleWithStringArray',
      ),
    );

    test(
      'bundleWithStringArrayList',
      () async => await performTest(
        source: TestValues.bundleWithStringArrayList,
        testName: 'bundleWithStringArrayList',
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

  group('convertFlags ', () {
    androidIntent = const AndroidIntent(
      action: 'action_view',
    );
    test('add filled flag list', () async {
      final flags = <int>[];
      flags.add(Flag.FLAG_ACTIVITY_NEW_TASK);
      flags.add(Flag.FLAG_ACTIVITY_NEW_DOCUMENT);
      expect(
        androidIntent.convertFlags(flags),
        268959744,
      );
    });
    test('add flags whose values are not power of 2', () async {
      final flags = <int>[];
      flags.add(100);
      flags.add(10);
      expect(
        () => androidIntent.convertFlags(flags),
        throwsArgumentError,
      );
    });
    test('add empty flag list', () async {
      final flags = <int>[];
      expect(
        androidIntent.convertFlags(flags),
        0,
      );
    });
  });
}

// https://github.com/dart-lang/mockito/issues/316
class MockMethodChannel extends Mock implements MethodChannel {
  @override
  Future<T?> invokeMethod<T>(String method, [dynamic arguments]) async {
    return super
            .noSuchMethod(Invocation.method(#invokeMethod, [method, arguments]))
        as dynamic;
  }
}
