import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_media_save/flutter_media_save_method_channel.dart';

void main() {
  MethodChannelFlutterMediaSave platform = MethodChannelFlutterMediaSave();
  const MethodChannel channel = MethodChannel('flutter_media_save');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
