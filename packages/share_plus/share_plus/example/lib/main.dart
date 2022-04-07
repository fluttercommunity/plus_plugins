// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

import 'image_previews.dart';

void main() {
  runApp(const DemoApp());
}

class DemoApp extends StatefulWidget {
  const DemoApp({Key? key}) : super(key: key);

  @override
  DemoAppState createState() => DemoAppState();
}

class DemoAppState extends State<DemoApp> {
  String text = '';
  String subject = '';
  List<String> imagePaths = [];
  String filePath = '';

  ShareWithApp appSelected = ShareWithApp.BY_DEFAULT_APP;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Share Plus Plugin Demo',
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Share Plus Plugin Demo'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Share text:',
                      hintText: 'Enter some text and/or link to share',
                    ),
                    maxLines: 2,
                    onChanged: (String value) => setState(() {
                      text = value;
                    }),
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Share subject:',
                      hintText: 'Enter subject to share (optional)',
                    ),
                    maxLines: 2,
                    onChanged: (String value) => setState(() {
                      subject = value;
                    }),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 12.0)),
                  ImagePreviews(imagePaths, onDelete: _onDeleteImage),
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text('Add image'),
                    onTap:() async {
                      final imagePicker = ImagePicker();
                      final pickedFile = await imagePicker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (pickedFile != null) {
                        setState(() {
                          imagePaths.add(pickedFile.path);
                        });
                      }
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(top: 12.0)),
                  Builder(
                    builder: (BuildContext context) {
                      return ElevatedButton(
                        onPressed: text.isEmpty && imagePaths.isEmpty ? null : () => _onShare(context),
                        child: const Text('Share'),
                      );
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(top: 12.0)),
                  Builder(
                    builder: (BuildContext context) {
                      return ElevatedButton(
                        onPressed: text.isEmpty && imagePaths.isEmpty ? null : () => _onShareWithResult(context),
                        child: const Text('Share With Result'),
                      );
                    },
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20.0)),
                  Divider(),
                  Text(
                    'File Share, Windows only',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 8)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 200,
                        child: ListTile(
                          leading: const Icon(Icons.add),
                          title: const Text('Choose file'),
                          onTap:() async {
                            FilePickerResult? result = await FilePicker.platform.pickFiles();
                            if (result != null) {
                              setState(() {
                                filePath = result.files.single.path!;
                              });
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          '${filePath}',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    ],
                  ),
                  Visibility(
                    visible: filePath.isNotEmpty,
                    child: Wrap(
                        children: List.generate(ShareWithApp.values.length, (index) {
                      return Container(
                        width: 200,
                        child: ListTile(
                          title: Text(
                            describeEnum(ShareWithApp.values[index]),
                            style: TextStyle(fontSize: 12),
                          ),
                          leading: Radio(
                            value: ShareWithApp.values[index],
                            groupValue: appSelected,
                            onChanged: (ShareWithApp? value) {
                              setState(() {
                                appSelected = value!;
                              });
                            },
                          ),
                        ),
                      );
                    })),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 8)),
                  Builder(
                    builder: (BuildContext context) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: filePath.isEmpty ? null : () => _onShareWithApp(context),
                            child: const Text('Share With App'),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          )),
    );
  }

  void _onDeleteImage(int position) {
    setState(() {
      imagePaths.removeAt(position);
    });
  }

  void _onShare(BuildContext context) async {
    // A builder is used to retrieve the context immediately
    // surrounding the ElevatedButton.
    //
    // The context's `findRenderObject` returns the first
    // RenderObject in its descendent tree when it's not
    // a RenderObjectWidget. The ElevatedButton's RenderObject
    // has its position and size after it's built.
    final box = context.findRenderObject() as RenderBox?;

    if (imagePaths.isNotEmpty) {
      await Share.shareFiles(imagePaths, text: text, subject: subject, sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }
  }

  void _onShareWithResult(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    ShareResult result;
    if (imagePaths.isNotEmpty) {
      result =
          await Share.shareFilesWithResult(imagePaths, text: text, subject: subject, sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } else {
      result = await Share.shareWithResult(text, subject: subject, sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Share result: ${result.status}"),
    ));
  }

  void _onShareWithApp(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;

    await Share.shareFiles([filePath], appName: appSelected);
  }
}
