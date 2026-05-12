import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Local shim that calls the platform MethodChannel used by the plugin.
/// This ensures a stable symbol `MyNewPlugin.onLight` for UI code.
class MyNewPlugin {
  static const MethodChannel _channel = MethodChannel('my_torch_plugin');

  static Future<bool> onLight({BuildContext? context, bool? enable}) async {
    if (!Platform.isAndroid) {
      if (context != null) {
        showDialog<void>(
          context: context,
          builder: (c) => AlertDialog(
            title: const Text('Not supported'),
            content: const Text('Flashlight control is implemented only on Android.'),
            actions: [
              TextButton(onPressed: () => Navigator.of(c).pop(), child: const Text('OK')),
            ],
          ),
        );
      }
      return Future.value(false);
    }

    try {
      final result = await _channel.invokeMethod<bool>('toggleTorch', {'enable': enable});
      return result == true;
    } on PlatformException {
      return false;
    }
  }
}
