import 'dart:typed_data';

import 'flutter_media_save_platform_interface.dart';

class FlutterMediaSave {
  Future<int?> getPlatformVersion() {
    return FlutterMediaSavePlatform.instance.getPlatformVersion();
  }

  Future<bool?> saveFile({
    required Uint8List bytes,
    String? name,
    required String mimeType,
  }) {
    return FlutterMediaSavePlatform.instance.saveFile(
      bytes: bytes,
      name: name,
      mimeType: mimeType,
    );
  }
}
