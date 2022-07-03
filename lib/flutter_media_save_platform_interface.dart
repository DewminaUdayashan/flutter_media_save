import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_media_save_method_channel.dart';

abstract class FlutterMediaSavePlatform extends PlatformInterface {
  /// Constructs a FlutterMediaSavePlatform.
  FlutterMediaSavePlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterMediaSavePlatform _instance = MethodChannelFlutterMediaSave();

  /// The default instance of [FlutterMediaSavePlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterMediaSave].
  static FlutterMediaSavePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterMediaSavePlatform] when
  /// they register themselves.
  static set instance(FlutterMediaSavePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> saveFile({
    required Uint8List bytes,
    String? name,
    required String mimeType,
  }) {
    throw UnimplementedError('saveFile() has not been implemented.');
  }
}
