import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_media_save/flutter_media_save.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flutterMediaSavePlugin = FlutterMediaSave();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> saveFile() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) {
      return;
    }
    final bytes = await file.readAsBytes();

    final result = await _flutterMediaSavePlugin.saveFile(
      bytes: bytes,
      mimeType: 'image/png',
    );

    print(result);
  }

  Future<void> initPlatformState() async {
    String platformVersion;

    try {
      platformVersion = await _flutterMediaSavePlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => saveFile(),
          child: const Icon(Icons.save),
        ),
      ),
    );
  }
}
