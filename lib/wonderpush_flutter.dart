import 'dart:async';

import 'package:flutter/services.dart';

class WonderPush extends Object {
  static const MethodChannel _methodChannel = const MethodChannel('wonderpush_flutter');

  // Initialization

  static Future<bool> isReady() async {
    final bool result = await _methodChannel.invokeMethod('isReady');
    return result;
  }

  // Subscribing users

  static Future<void> subscribeToNotifications() async {
    await _methodChannel.invokeMethod('subscribeToNotifications');
  }

  static Future<void> unsubscribeFromNotifications() async {
    await _methodChannel.invokeMethod('unsubscribeFromNotifications');
  }

  static Future<bool> isSubscribedToNotifications() async {
    final bool result = await _methodChannel.invokeMethod('isSubscribedToNotifications');
    return result;
  }

  // Segmentation

  static Future<void> trackEvent(String type, [Object attributes]) async {
    Map<String, Object> args = <String, Object>{};
    args.putIfAbsent("attributes", () => attributes);
    args.putIfAbsent("type", () => type);
    await _methodChannel.invokeMethod('trackEvent', args);
  }

  static Future<void> addTag(var tags) async {
    if (!(tags is List)) {
      tags = [tags];
    }
    Map<String, List> args = <String, List>{};
    args.putIfAbsent("tags", () => tags);
    await _methodChannel.invokeMethod('addTag', args);
  }

  static Future<void> removeTag(var tags) async {
    if (!(tags is List)) {
      tags = [tags];
    }
    Map<String, List> args = <String, List>{};
    args.putIfAbsent("tags", () => tags);
    await _methodChannel.invokeMethod('removeTag', args);
  }

  static Future<void> removeAllTags() async {
    await _methodChannel.invokeMethod('removeAllTags');
  }

  static Future<bool> hasTag(String tag) async {
    Map<String, String> args = <String, String>{};
    args.putIfAbsent("tag", () => tag);
    final bool result = await _methodChannel.invokeMethod('hasTag', args);
    return result;
  }

  static Future<List> getTags() async {
    final List result = await _methodChannel.invokeMethod('getTags');
    return result;
  }

  static Future<dynamic> getPropertyValue(String property) async {
    Map<String, String> args = <String, String>{};
    args.putIfAbsent("property", () => property);
    final Object result = await _methodChannel.invokeMethod('getPropertyValue', args);
    return result;
  }

  static Future<List> getPropertyValues(String property) async {
    Map<String, String> args = <String, String>{};
    args.putIfAbsent("property", () => property);
    final List result = await _methodChannel.invokeMethod('getPropertyValues', args);
    return result;
  }

  static Future<void> addProperty(String property, var properties) async {
    if (!(properties is List)) {
      properties = [properties];
    }
    Map<String, Object> args = <String, Object>{};
    args.putIfAbsent("property", () => property);
    args.putIfAbsent("properties", () => properties);
    await _methodChannel.invokeMethod('addProperty', args);
  }

  static Future<void> removeProperty(String property, Object properties) async {
    if (!(properties is List)) {
      properties = [properties];
    }
    Map<String, Object> args = <String, Object>{};
    args.putIfAbsent("property", () => property);
    args.putIfAbsent("properties", () => properties);
    await _methodChannel.invokeMethod('removeProperty', args);
  }

  static Future<void> setProperty(String property, Object properties) async {
    Map<String, Object> args = <String, Object>{};
    args.putIfAbsent("property", () => property);
    args.putIfAbsent("properties", () => properties);
    await _methodChannel.invokeMethod('setProperty', args);
  }

  static Future<void> unsetProperty(String property) async {
    Map<String, String> args = <String, String>{};
    args.putIfAbsent("property", () => property);
    await _methodChannel.invokeMethod('unsetProperty', args);
  }

  static Future<void> putProperties(Object properties) async {
    Map<String, Object> args = <String, Object>{};
    args.putIfAbsent("properties", () => properties);
    await _methodChannel.invokeMethod('putProperties', args);
  }

  static Future<Object> getProperties() async {
    final Map result = await _methodChannel.invokeMethod('getProperties');
    return result;
  }

  static Future<void> setCountry(String country) async {
    Map<String, String> args = <String, String>{};
    args.putIfAbsent("country", () => country);
    await _methodChannel.invokeMethod('setCountry', args);
  }

  static Future<String> getCountry() async {
    final String country = await _methodChannel.invokeMethod('getCountry');
    return country;
  }

  static Future<void> setCurrency(String currency) async {
    Map<String, String> args = <String, String>{};
    args.putIfAbsent("currency", () => currency);
    await _methodChannel.invokeMethod('setCurrency', args);
  }

  static Future<String> getCurrency() async {
    final String currency = await _methodChannel.invokeMethod('getCurrency');
    return currency;
  }

  static Future<void> setLocale(String locale) async {
    Map<String, String> args = <String, String>{};
    args.putIfAbsent("locale", () => locale);
    await _methodChannel.invokeMethod('setLocale', args);
  }

  static Future<String> getLocale() async {
    final String locale = await _methodChannel.invokeMethod('getLocale');
    return locale;
  }

  static Future<void> setTimeZone(String timeZone) async {
    Map<String, String> args = <String, String>{};
    args.putIfAbsent("timeZone", () => timeZone);
    await _methodChannel.invokeMethod('setTimeZone', args);
  }

  static Future<String> getTimeZone() async {
    final String timeZone = await _methodChannel.invokeMethod('getTimeZone');
    return timeZone;
  }


  // User IDs

  static Future<void> setUserId(String userId) async {
    Map<String, String> args = <String, String>{};
    args.putIfAbsent("userId", () => userId);
    await _methodChannel.invokeMethod('setUserId', args);
  }

  static Future<String> getUserId() async {
    final String userId = await _methodChannel.invokeMethod('getUserId');
    return userId;
  }

  // Installation info	
  static Future<String> getPushToken() async {
    final String pushToken = await _methodChannel.invokeMethod('getPushToken');
    return pushToken;
  }

  static Future<String> getInstallationId() async {
    final String installationId = await _methodChannel.invokeMethod('getInstallationId');
    return installationId;
  }

  // Privacy

  static Future<void> setRequiresUserConsent(bool isConsent) async {
    Map<String, bool> args = <String, bool>{};
    args.putIfAbsent("isConsent", () => isConsent);
    await _methodChannel.invokeMethod('setRequiresUserConsent', args);
  }

  static Future<void> setUserConsent(bool isConsent) async {
    Map<String, bool> args = <String, bool>{};
    args.putIfAbsent("isConsent", () => isConsent);
    await _methodChannel.invokeMethod('setUserConsent', args);
  }

  static Future<void> disableGeolocation() async {
    await _methodChannel.invokeMethod('disableGeolocation');
  }

  static Future<void> enableGeolocation() async {
    await _methodChannel.invokeMethod('enableGeolocation');
  }

  static Future<void> setGeolocation(double lat, double lon) async {
    Map<String, double> args = <String, double>{};
    args.putIfAbsent("lat", () => lat);
    args.putIfAbsent("lon", () => lon);
    await _methodChannel.invokeMethod('setGeolocation', args);
  }

  static Future<void> clearEventsHistory() async {
    await _methodChannel.invokeMethod('clearEventsHistory');
  }

  static Future<void> clearPreferences() async {
    await _methodChannel.invokeMethod('clearPreferences');
  }

  static Future<void> clearAllData() async {
    _methodChannel.invokeMethod('clearAllData');
  }

  static Future<dynamic> downloadAllData() async {
    final Object data = await _methodChannel.invokeMethod('downloadAllData');
    return data;
  }

  // Debug

  static Future<void> setLogging(bool enable) async {
    Map<String, bool> args = <String, bool>{};
    args.putIfAbsent("enable", () => enable);
    await _methodChannel.invokeMethod('setLogging', args);
  }
}
