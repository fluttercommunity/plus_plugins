// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:convert';
import 'dart:io';
import 'package:file_selector/file_selector.dart'
    hide XFile; // hides to test if share_plus exports XFile
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart'
    hide XFile; // hides to test if share_plus exports XFile
import 'package:share_plus/share_plus.dart';

import 'excluded_activity_type.dart';
import 'image_previews.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Share Plus Plugin Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0x9f4376f8),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<StatefulWidget> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  String text = '';
  String subject = '';
  String title = '';
  String uri = '';
  String fileName = '';
  List<String> imageNames = [];
  List<String> imagePaths = [];
  List<CupertinoActivityType> excludedCupertinoActivityType = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Plus Plugin Demo'),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Share text',
                hintText: 'Enter some text and/or link to share',
              ),
              maxLines: null,
              onChanged: (String value) => setState(() {
                text = value;
              }),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Share subject',
                hintText: 'Enter subject to share (optional)',
              ),
              maxLines: null,
              onChanged: (String value) => setState(() {
                subject = value;
              }),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Share title',
                hintText: 'Enter title to share (optional)',
              ),
              maxLines: null,
              onChanged: (String value) => setState(() {
                title = value;
              }),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Share uri',
                hintText: 'Enter the uri you want to share',
              ),
              maxLines: null,
              onChanged: (String value) {
                setState(() => uri = value);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Share Text as File',
                hintText: 'Enter the filename you want to share your text as',
              ),
              maxLines: null,
              onChanged: (String value) {
                setState(() => fileName = value);
              },
            ),
            const SizedBox(height: 16),
            ImagePreviews(imagePaths, onDelete: _onDeleteImage),
            ElevatedButton.icon(
              label: const Text('Add image'),
              onPressed: () async {
                // Using `package:image_picker` to get image from gallery.
                if (!kIsWeb &&
                    (Platform.isMacOS ||
                        Platform.isLinux ||
                        Platform.isWindows)) {
                  // Using `package:file_selector` on windows, macos & Linux, since `package:image_picker` is not supported.
                  const XTypeGroup typeGroup = XTypeGroup(
                    label: 'images',
                    extensions: <String>['jpg', 'jpeg', 'png', 'gif'],
                  );
                  final file = await openFile(
                      acceptedTypeGroups: <XTypeGroup>[typeGroup]);
                  if (file != null) {
                    setState(() {
                      imagePaths.add(file.path);
                      imageNames.add(file.name);
                    });
                  }
                } else {
                  final imagePicker = ImagePicker();
                  final pickedFile = await imagePicker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      imagePaths.add(pickedFile.path);
                      imageNames.add(pickedFile.name);
                    });
                  }
                }
              },
              icon: const Icon(Icons.add),
            ),
            if (Platform.isIOS || Platform.isMacOS) const SizedBox(height: 16),
            if (Platform.isIOS || Platform.isMacOS)
              ElevatedButton(
                onPressed: _onSelectExcludedActivityType,
                child: const Text('Add Excluded Activity Type'),
              ),
            const SizedBox(height: 32),
            Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: text.isEmpty && imagePaths.isEmpty
                      ? null
                      : () => _onShareWithResult(context),
                  child: const Text('Share'),
                );
              },
            ),
            const SizedBox(height: 16),
            Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    _onShareXFileFromAssets(context);
                  },
                  child: const Text('Share XFile from Assets'),
                );
              },
            ),
            const SizedBox(height: 16),
            Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: fileName.isEmpty || text.isEmpty
                      ? null
                      : () => _onShareTextAsXFile(context),
                  child: const Text('Share text as XFile'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onDeleteImage(int position) {
    setState(() {
      imagePaths.removeAt(position);
      imageNames.removeAt(position);
    });
  }

  void _onSelectExcludedActivityType() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ExcludedCupertinoActivityTypePage(
          excludedActivityType: excludedCupertinoActivityType,
        ),
      ),
    );
    if (result != null) {
      excludedCupertinoActivityType = result;
    }
  }

  void _onShareWithResult(BuildContext context) async {
    // A builder is used to retrieve the context immediately
    // surrounding the ElevatedButton.
    //
    // The context's `findRenderObject` returns the first
    // RenderObject in its descendent tree when it's not
    // a RenderObjectWidget. The ElevatedButton's RenderObject
    // has its position and size after it's built.
    final box = context.findRenderObject() as RenderBox?;

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    ShareResult shareResult;
    if (imagePaths.isNotEmpty) {
      final files = <XFile>[];
      for (var i = 0; i < imagePaths.length; i++) {
        files.add(XFile(imagePaths[i], name: imageNames[i]));
      }
      shareResult = await SharePlus.instance.share(
        ShareParams(
          text: text.isEmpty ? null : text,
          subject: subject.isEmpty ? null : subject,
          title: title.isEmpty ? null : title,
          files: files,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
          excludedCupertinoActivities: [CupertinoActivityType.airDrop],
        ),
      );
    } else if (uri.isNotEmpty) {
      shareResult = await SharePlus.instance.share(
        ShareParams(
          uri: Uri.parse(uri),
          subject: subject.isEmpty ? null : subject,
          title: title.isEmpty ? null : title,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
          excludedCupertinoActivities: excludedCupertinoActivityType,
        ),
      );
    } else {
      shareResult = await SharePlus.instance.share(
        ShareParams(
          text: text.isEmpty ? null : text,
          subject: subject.isEmpty ? null : subject,
          title: title.isEmpty ? null : title,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
          excludedCupertinoActivities: excludedCupertinoActivityType,
        ),
      );
    }
    scaffoldMessenger.showSnackBar(getResultSnackBar(shareResult));
  }

  void _onShareXFileFromAssets(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      final data = await rootBundle.load('assets/flutter_logo.png');
      final buffer = data.buffer;
      final shareResult = await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(
              buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
              name: 'flutter_logo.png',
              mimeType: 'image/png',
            ),
          ],
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
          downloadFallbackEnabled: true,
          excludedCupertinoActivities: excludedCupertinoActivityType,
        ),
      );
      scaffoldMessenger.showSnackBar(getResultSnackBar(shareResult));
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _onShareTextAsXFile(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final shareResult = await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile.fromData(
              utf8.encode(text),
              // name: fileName, // Notice, how setting the name here does not work.
              mimeType: 'text/plain',
            ),
          ],
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
          fileNameOverrides: [fileName],
          downloadFallbackEnabled: true,
          excludedCupertinoActivities: excludedCupertinoActivityType,
        ),
      );

      scaffoldMessenger.showSnackBar(getResultSnackBar(shareResult));
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  SnackBar getResultSnackBar(ShareResult result) {
    return SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Share result: ${result.status}"),
          if (result.status == ShareResultStatus.success)
            Text("Shared to: ${result.raw}")
        ],
      ),
    );
  }
}
