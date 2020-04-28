import 'dart:async';

import 'package:flutter/services.dart';

class Sdk {
  static const MethodChannel _channel =
      const MethodChannel('sdk');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  //Initialization
  static Future<dynamic> setLogging (bool enable) async {
    Map<String,bool> args = <String,bool>{};
    args.putIfAbsent("enable", () => enable);
    final Object version = await _channel.invokeMethod('setLogging', args);
    return version;
  }
}
