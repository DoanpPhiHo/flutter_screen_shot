import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screen_shot/flutter_screen_shot.dart';
import 'package:flutter_screen_shot/flutter_screen_shot_platform_interface.dart';
import 'package:flutter_screen_shot/flutter_screen_shot_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterScreenShotPlatform
    with MockPlatformInterfaceMixin
    implements FlutterScreenShotPlatform {
  @override
  Future<String?> takeScreenShot() => Future.value('42');
}

void main() {
  final FlutterScreenShotPlatform initialPlatform =
      FlutterScreenShotPlatform.instance;

  test('$MethodChannelFlutterScreenShot is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterScreenShot>());
  });

  test('getPlatformVersion', () async {
    FlutterScreenShot flutterScreenShotPlugin = FlutterScreenShot();
    MockFlutterScreenShotPlatform fakePlatform =
        MockFlutterScreenShotPlatform();
    FlutterScreenShotPlatform.instance = fakePlatform;

    expect(await flutterScreenShotPlugin.getPlatformVersion(), '42');
  });
}
