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
    final Object result = await _channel.invokeMethod('setLogging', args);
    return result;
  }

  static Future<dynamic> get subscribeToNotifications async {
    final Object result = await _channel.invokeMethod('subscribeToNotifications');
    return result;
  }

  static Future<dynamic> get unsubscribeFromNotifications async {
    final Object result = await _channel.invokeMethod('unsubscribeFromNotifications');
    return result;
  }

  static Future<dynamic> get isSubscribedToNotifications async {
    final Object result = await _channel.invokeMethod('isSubscribedToNotifications');
    return result;
  }

  static Future<dynamic> setUserId (String userId) async {
    Map<String,String> args = <String,String>{};
    args.putIfAbsent("userId", () => userId);
    final Object result = await _channel.invokeMethod('setUserId', args);
    return result;
  }

  static Future<String> get getUserId async {
    final String userId = await _channel.invokeMethod('getUserId');
    return userId;
  }

}
