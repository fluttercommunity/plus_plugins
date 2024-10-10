import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus_example/main.dart';
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
    await expectLater(() async => await intent.launch(), throwsA((Exception e) {
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

  testWidgets('Parse and Launch should not throw', (WidgetTester tester) async {
    const intent = 'intent:#Intent;'
        'action=android.intent.action.SET_ALARM;'
        'B.android.intent.extra.alarm.SKIP_UI=true;'
        'S.android.intent.extra.alarm.MESSAGE=Create%20a%20Flutter%20app;'
        'i.android.intent.extra.alarm.MINUTES=30;'
        'i.android.intent.extra.alarm.HOUR=21;'
        'end';

    AndroidIntent.parseAndLaunch(intent);
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

  testWidgets('CanResolveActivity returns true when example Activity is found',
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

  testWidgets(
      'getResolvedActivity return activity details when example Activity is found',
      (WidgetTester tester) async {
    final intent = AndroidIntent(
      action: 'action_view',
      data: Uri.encodeFull('http://'),
    );
    await expectLater(await intent.getResolvedActivity(), isNotNull);
  }, skip: !Platform.isAndroid);

  testWidgets('getResolvedActivity returns null when no Activity is found',
      (WidgetTester tester) async {
    final intent = AndroidIntent(
      action: 'action_view',
      data: Uri.encodeFull('mycustomscheme://'),
    );
    await expectLater(await intent.getResolvedActivity(), isNull);
  }, skip: !Platform.isAndroid);
}
