import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_screen_shot/flutter_screen_shot.dart';

void main() {
  runApp(MaterialApp(key: key, home: const MyApp()));
}

final key = GlobalKey();

//#region screenshot
Future<ui.Image?> captureAsUiImage({
  double? pixelRatio = 1,
  Duration delay = const Duration(milliseconds: 20),
  required GlobalKey globalKey,
}) {
  //Delay is required. See Issue https://github.com/flutter/flutter/issues/22308
  return Future.delayed(delay, () async {
    try {
      var findRenderObject = globalKey.currentContext?.findRenderObject();
      if (findRenderObject == null) {
        return null;
      }
      RenderRepaintBoundary boundary =
          findRenderObject as RenderRepaintBoundary;
      BuildContext? context = globalKey.currentContext;
      if (pixelRatio == null) {
        if (context != null) {
          pixelRatio = pixelRatio ?? MediaQuery.of(context).devicePixelRatio;
        }
      }
      ui.Image image = await boundary.toImage(pixelRatio: pixelRatio ?? 1);
      return image;
    } catch (e) {
      rethrow;
    }
  });
}

Future<Uint8List?> capture({
  double? pixelRatio,
  Duration delay = const Duration(milliseconds: 20),
  required GlobalKey globalKey,
}) {
  //Delay is required. See Issue https://github.com/flutter/flutter/issues/22308
  return Future.delayed(delay, () async {
    try {
      ui.Image? image = await captureAsUiImage(
        delay: Duration.zero,
        pixelRatio: pixelRatio,
        globalKey: globalKey,
      );
      ByteData? byteData =
          await image?.toByteData(format: ui.ImageByteFormat.png);
      image?.dispose();

      Uint8List? pngBytes = byteData?.buffer.asUint8List();

      return pngBytes;
    } catch (e) {
      rethrow;
    }
  });
}
//#endregion

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Uint8List? _image;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _initPlatformState() async {
    try {
      final image = await FlutterScreenShot.instance.takeScreenShot();
      // final image = await capture(globalKey: key);
      if (!mounted) return;
      setState(() {
        _image = image;
      });
    } on PlatformException {
      log('Failed to get platform version.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: _image != null
          ? Container(
              decoration: BoxDecoration(border: Border.all()),
              child: Image.memory(
                _image!,
                width: double.infinity,
                height: 500,
                fit: BoxFit.fitHeight,
              ),
            )
          : const Text('hehe'),
      floatingActionButton: FloatingActionButton(
        heroTag: 'hhh',
        onPressed: _initPlatformState,
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
