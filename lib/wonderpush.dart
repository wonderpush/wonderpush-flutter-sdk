import 'dart:async';

import 'package:flutter/services.dart';

class WonderPush {
  static const MethodChannel _channel =
      const MethodChannel('wonderpush');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
