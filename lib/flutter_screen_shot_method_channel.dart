import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_screen_shot_platform_interface.dart';

/// An implementation of [FlutterScreenShotPlatform] that uses method channels.
class MethodChannelFlutterScreenShot extends FlutterScreenShotPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_screen_shot');

  @override
  Future<Uint8List?> takeScreenShot() async {
    final data = await methodChannel.invokeMethod<dynamic>('takeScreenShot');
    final uint8List = (data as List?)?.cast<int>();
    return uint8List != null ? Uint8List.fromList(uint8List) : null;
  }
}
