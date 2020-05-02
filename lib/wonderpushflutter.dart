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

  static Future<bool>  hasTag(String tag)  async {
     Map<String,String> args = <String,String>{};
     args.putIfAbsent("tag", () => tag);
     final bool result = await _channel.invokeMethod('hasTag',args);
     return result;
  }

  static Future<void> setCountry(String country) async {
    Map<String,String> args = <String,String>{};
    args.putIfAbsent("country", () => country);
    await _channel.invokeMethod('setCountry', args);
  }

  static Future<String> get getCountry async {
    final String country = await _channel.invokeMethod('getCountry');
    return country;
  }

  static Future<void> setCurrency (String currency) async {
    Map<String,String> args = <String,String>{};
    args.putIfAbsent("currency", () => currency);
    await _channel.invokeMethod('setCurrency', args);
  }

  static Future<String> get getCurrency async {
    final String currency = await _channel.invokeMethod('getCurrency');
    return currency;
  }


  static Future<void> setLocale(String locale) async {
    Map<String,String> args = <String,String>{};
    args.putIfAbsent("locale", () => locale);
    await _channel.invokeMethod('setLocale', args);
  }

  static Future<String> get getLocale async {
    final String locale = await _channel.invokeMethod('getLocale');
    return locale;
  }

  static Future<void> setTimeZone(String timeZone) async {
    Map<String,String> args = <String,String>{};
    args.putIfAbsent("timeZone", () => timeZone);
    await _channel.invokeMethod('setTimeZone', args);
  }

  static Future<String> get getTimeZone async {
    final String timeZone = await _channel.invokeMethod('getTimeZone');
    return timeZone;
  }


   // User IDs	

  static Future<void> setUserId(String userId) async {
    Map<String,String> args = <String,String>{};
    args.putIfAbsent("userId", () => userId);
    await _channel.invokeMethod('setUserId', args);
  }

  static Future<String> get getUserId async {
    final String userId = await _channel.invokeMethod('getUserId');
    return userId;
  }
  
  // Installation info	
  static Future<String> get getPushToken async {
    final String pushToken = await _channel.invokeMethod('getPushToken');
    return pushToken;
  }

  static Future<String> get getInstallationId async {
    final String installationId = await _channel.invokeMethod('getInstallationId');
    return installationId;
  }

    // Privacy

   static Future<void> setRequiresUserConsent(bool isConsent) async {
      Map<String,bool> args = <String,bool>{};
      args.putIfAbsent("isConsent", () => isConsent);
      await _channel.invokeMethod('setRequiresUserConsent', args);
  }

  static Future<void> setUserConsent(bool isConsent) async {
      Map<String,bool> args = <String,bool>{};
      args.putIfAbsent("isConsent", () => isConsent);
      await _channel.invokeMethod('setUserConsent', args);
  }

  static Future<void> disableGeolocation() async {
      await _channel.invokeMethod('disableGeolocation');
  }

  static Future<void> enableGeolocation() async {
      await _channel.invokeMethod('enableGeolocation');
  }

  static Future<void> setGeolocation(double lat, double lon) async {
      Map<String,double> args = <String,double>{};
      args.putIfAbsent("lat", () => lat);
      args.putIfAbsent("lat", () => lon);
      await _channel.invokeMethod('setGeolocation',args);
  }

  static Future<void> clearEventsHistory() async {
        await _channel.invokeMethod('clearEventsHistory');
  }

  static Future<void> clearPreferences() async {
        await _channel.invokeMethod('clearPreferences');
  }

  static Future<void> clearAllData() async {
        await _channel.invokeMethod('clearAllData');
  }
  
  static Future<dynamic> downloadAllData() async {
      final Object data = await _channel.invokeMethod('downloadAllData');
      return data;
  }

  // Debug

  static Future<void> setLogging (bool enable) async {
      Map<String,bool> args = <String,bool>{};
      args.putIfAbsent("enable", () => enable);
      await _channel.invokeMethod('setLogging', args);
  }
}
