import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_media_save/flutter_media_save.dart';
import 'package:flutter_media_save/flutter_media_save_platform_interface.dart';
import 'package:flutter_media_save/flutter_media_save_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterMediaSavePlatform 
    with MockPlatformInterfaceMixin
    implements FlutterMediaSavePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterMediaSavePlatform initialPlatform = FlutterMediaSavePlatform.instance;

  test('$MethodChannelFlutterMediaSave is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterMediaSave>());
  });

  test('getPlatformVersion', () async {
    FlutterMediaSave flutterMediaSavePlugin = FlutterMediaSave();
    MockFlutterMediaSavePlatform fakePlatform = MockFlutterMediaSavePlatform();
    FlutterMediaSavePlatform.instance = fakePlatform;
  
    expect(await flutterMediaSavePlugin.getPlatformVersion(), '42');
  });
}
