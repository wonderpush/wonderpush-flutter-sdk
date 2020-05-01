import 'dart:async';

import 'package:flutter/services.dart';

class Wonderpushflutter {
  static const MethodChannel _channel =
      const MethodChannel('wonderpushflutter');

  // Initialization

  static Future<bool> get isReady async {
    final bool result = await _channel.invokeMethod('isReady');
    return result;
  }
  // Subscribing users

  static Future<void> get subscribeToNotifications async {
    await _channel.invokeMethod('subscribeToNotifications');
  }

  static Future<void> get unsubscribeFromNotifications async {
     await _channel.invokeMethod('unsubscribeFromNotifications');
  }

  static Future<bool> get isSubscribedToNotifications async {
    final bool result = await _channel.invokeMethod('isSubscribedToNotifications');
    return result;
  }

   // Segmentation
  static Future<void> get removeAllTags async {
     await _channel.invokeMethod('removeAllTags');
  }

  static Future<bool>  hasTag (String tag)  async {
     Map<String,String> args = <String,String>{};
     args.putIfAbsent("tag", () => tag);
     final bool result = await _channel.invokeMethod('hasTag',args);
     return result;
  }

   // User IDs	

  static Future<void> setUserId (String userId) async {
    Map<String,String> args = <String,String>{};
    args.putIfAbsent("userId", () => userId);
    await _channel.invokeMethod('setUserId', args);
  }

  static Future<String> get getUserId async {
    final String userId = await _channel.invokeMethod('getUserId');
    return userId;
  }

  // Installation info	

  // Debug

  static Future<void> setLogging (bool enable) async {
      Map<String,bool> args = <String,bool>{};
      args.putIfAbsent("enable", () => enable);
      await _channel.invokeMethod('setLogging', args);
  }
}
