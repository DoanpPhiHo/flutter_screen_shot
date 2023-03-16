import 'dart:typed_data';

import 'flutter_screen_shot_platform_interface.dart';

class FlutterScreenShot {
  const FlutterScreenShot._();
  static const instance = FlutterScreenShot._();
  Future<Uint8List?> takeScreenShot() {
    return FlutterScreenShotPlatform.instance.takeScreenShot();
  }
}
