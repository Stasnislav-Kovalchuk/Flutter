import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyNewPlugin {
  static const MethodChannel _channel = MethodChannel('my_torch_plugin');

  /// Toggle the device flashlight.
  /// If [enable] is null, plugin will toggle current state (Android).
  /// Optionally provide a [context] to show a platform-not-supported dialog on unsupported platforms.
  static Future<bool> onLight({BuildContext? context, bool? enable}) async {
    if (!Platform.isAndroid) {
      if (context != null) {
        // Show a simple alert dialog informing user that native implementation is Android-only.
        showDialog<void>(
          context: context,
          builder: (c) => AlertDialog(
            title: const Text('Not supported'),
            content: const Text(
                'Flashlight control is implemented only on Android in this lab.'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(c).pop(),
                  child: const Text('OK')),
            ],
          ),
        );
      }
      return Future.value(false);
    }

    try {
      final result =
          await _channel.invokeMethod<bool>('toggleTorch', {'enable': enable});
      return result == true;
    } on PlatformException {
      return false;
    }
  }
}
