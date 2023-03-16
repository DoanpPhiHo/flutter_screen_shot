import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screen_shot/flutter_screen_shot_method_channel.dart';

void main() {
  MethodChannelFlutterScreenShot platform = MethodChannelFlutterScreenShot();
  const MethodChannel channel = MethodChannel('flutter_screen_shot');

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
    expect(await platform.takeScreenShot(), '42');
  });
}
