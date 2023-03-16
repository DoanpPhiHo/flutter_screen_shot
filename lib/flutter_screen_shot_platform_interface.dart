import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_screen_shot_method_channel.dart';

abstract class FlutterScreenShotPlatform extends PlatformInterface {
  /// Constructs a FlutterScreenShotPlatform.
  FlutterScreenShotPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterScreenShotPlatform _instance = MethodChannelFlutterScreenShot();

  /// The default instance of [FlutterScreenShotPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterScreenShot].
  static FlutterScreenShotPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterScreenShotPlatform] when
  /// they register themselves.
  static set instance(FlutterScreenShotPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<Uint8List?> takeScreenShot() {
    throw UnimplementedError('takeScreenShot() has not been implemented.');
  }
}
