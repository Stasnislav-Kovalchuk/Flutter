import 'dart:io';

/// Android-емулятор: `localhost` — це сам емулятор; хост-машина — [10.0.2.2].
/// iOS-симулятор / macOS / desktop: [127.0.0.1].
String mqttLoopbackBroker() =>
    Platform.isAndroid ? '10.0.2.2' : '127.0.0.1';
