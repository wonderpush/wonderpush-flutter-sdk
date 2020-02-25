import 'dart:async';

import 'package:flutter/services.dart';

class WonderpushFlutterPlugin {
  static const MethodChannel _channel =
      const MethodChannel('wonderpush_flutter_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> get name async {
    return Future.value("FlutterWonderPush");
  }

  static Future<bool> init() async {
    return Future.value(true);
  }

  static Future<bool> get isReady async {
    return Future.value(true);
  }

  static Future<String> get accessToken async {
    final String version = await _channel.invokeMethod('getAccessToken');
    return version;
  }

  static Future<String> get delegate async {
    final String version = await _channel.invokeMethod('getDelegate');
    return version;
  }

  static Future<String> get deviceId async {
    final String version = await _channel.invokeMethod('getDeviceId');
    return version;
  }

  static Future<String> get installationCustomProperties async {
    final String version =
        await _channel.invokeMethod('getInstallationCustomProperties');
    return version;
  }

  static Future<String> get installationId async {
    final String version = await _channel.invokeMethod('getInstallationId');
    return version;
  }

  static Future<String> get notificationEnabled async {
    final String version =
        await _channel.invokeMethod('getNotificationEnabled');
    return version;
  }

  static Future<String> get pushToken async {
    final String version = await _channel.invokeMethod('getPushToken');
    return version;
  }

  static Future<String> get userId async {
    final String version = await _channel.invokeMethod('getUserId');
    return version;
  }

  static set logging(bool shouldLog) {
    // code to set logging for wonderpush
  }

  static set userId(String userId) {
    // code to set wonderpush userid
  }

  static set trackEvent(String type) {
    // code to set wonderpush userid
  }
}
