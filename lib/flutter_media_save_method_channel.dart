import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_media_save_platform_interface.dart';

/// An implementation of [FlutterMediaSavePlatform] that uses method channels.
class MethodChannelFlutterMediaSave extends FlutterMediaSavePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_media_save');

  @override
  Future<int?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<int>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool?> saveFile({
    required Uint8List bytes,
    String? name,
    required String mimeType,
  }) async {
    final result = await methodChannel.invokeMethod<bool>('saveFile', {
      'bytes': bytes.buffer.asUint8List(),
      'name': name,
      'mimeType': mimeType,
    });
    return result;
  }
}
