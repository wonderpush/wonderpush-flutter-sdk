import 'dart:async';

import 'package:flutter/services.dart';

class Wonderpushflutter {
  static const MethodChannel _channel =
      const MethodChannel('wonderpushflutter');
//Initialization
  static Future<void> setLogging (bool enable) async {
    Map<String,bool> args = <String,bool>{};
    args.putIfAbsent("enable", () => enable);
    await _channel.invokeMethod('setLogging', args);
  }

  static Future<void> get subscribeToNotifications async {
    await _channel.invokeMethod('subscribeToNotifications');
  }

  static Future<void> get unsubscribeFromNotifications async {
     await _channel.invokeMethod('unsubscribeFromNotifications');
  }

  static Future<dynamic> get isSubscribedToNotifications async {
    final Object result = await _channel.invokeMethod('isSubscribedToNotifications');
    return result;
  }

  static Future<void> setUserId (String userId) async {
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
