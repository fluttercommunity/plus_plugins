// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
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
          extras: <Bundle>[],
          channel: mockChannel,
          platform: FakePlatform(operatingSystem: 'android'),
        );
        await androidIntent.sendBroadcast();
        verify(mockChannel.invokeMethod<void>('sendBroadcast', <String, Object>{
          'action': 'com.example.broadcast',
          'extras': '[]',
        }));
      });

      test('send a broadcast with extras', () async {
        androidIntent = AndroidIntent.private(
          action: 'com.example.broadcast',
          extras: <Bundle>[
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
          ],
          channel: mockChannel,
          platform: FakePlatform(operatingSystem: 'android'),
        );
        await androidIntent.sendBroadcast();
        verify(mockChannel.invokeMethod<void>('sendBroadcast', <String, Object>{
          'action': 'com.example.broadcast',
          'extras': '''
[
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
]''',
        }));
      });
    });
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
