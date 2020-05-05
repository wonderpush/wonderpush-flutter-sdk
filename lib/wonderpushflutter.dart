import 'dart:async';

import 'package:flutter/services.dart';

class Wonderpushflutter {
  static const MethodChannel _channel =
      const MethodChannel('wonderpushflutter');

  // Initialization

  static Future<bool> isReady() async {
    final bool result = await _channel.invokeMethod('isReady');
    return result;
  }
  // Subscribing users

  static void  subscribeToNotifications()  {
     _channel.invokeMethod('subscribeToNotifications');
  }

  static void unsubscribeFromNotifications()  {
      _channel.invokeMethod('unsubscribeFromNotifications');
  }

  static Future<bool> isSubscribedToNotifications() async {
    final bool result = await _channel.invokeMethod('isSubscribedToNotifications');
    return result;
  }

   // Segmentation

  static void addTag(var tags)  {
    if(tags is String){
      tags = [tags];
    }
    Map<String,List> args = <String,List>{};
    args.putIfAbsent("tags", () => tags);
     _channel.invokeMethod('addTag',args);
  }
   
  static void removeTag(var tags)  {
    if(tags is String){
      tags = [tags];
    }
    Map<String,List> args = <String,List>{};
    args.putIfAbsent("tags", () => tags);
     _channel.invokeMethod('removeTag',args);
  }

  static void removeAllTags() {
      _channel.invokeMethod('removeAllTags');
  }

  static Future<bool>  hasTag(String tag)  async {
     Map<String,String> args = <String,String>{};
     args.putIfAbsent("tag", () => tag);
     final bool result = await _channel.invokeMethod('hasTag',args);
     return result;
  }

  static Future<List> getTags() async {
     final List result = await _channel.invokeMethod('getTags');
     return result;
  }

  static void unsetProperty(String property) {
     Map<String,String> args = <String,String>{};
     args.putIfAbsent("property", () => property);
     _channel.invokeMethod('unsetProperty',args);
  }

  static void setCountry(String country)  {
    Map<String,String> args = <String,String>{};
    args.putIfAbsent("country", () => country);
     _channel.invokeMethod('setCountry', args);
  }

  static Future<String> getCountry() async {
    final String country = await _channel.invokeMethod('getCountry');
    return country;
  }

  static void setCurrency (String currency) {
    Map<String,String> args = <String,String>{};
    args.putIfAbsent("currency", () => currency);
     _channel.invokeMethod('setCurrency', args);
  }

  static Future<String> getCurrency() async {
    final String currency = await _channel.invokeMethod('getCurrency');
    return currency;
  }


  static void setLocale(String locale) {
    Map<String,String> args = <String,String>{};
    args.putIfAbsent("locale", () => locale);
     _channel.invokeMethod('setLocale', args);
  }

  static Future<String> getLocale() async {
    final String locale = await _channel.invokeMethod('getLocale');
    return locale;
  }

  static void setTimeZone(String timeZone) {
    Map<String,String> args = <String,String>{};
    args.putIfAbsent("timeZone", () => timeZone);
     _channel.invokeMethod('setTimeZone', args);
  }

  static Future<String> getTimeZone() async {
    final String timeZone = await _channel.invokeMethod('getTimeZone');
    return timeZone;
  }


   // User IDs	

  static void setUserId(String userId)  {
    Map<String,String> args = <String,String>{};
    args.putIfAbsent("userId", () => userId);
     _channel.invokeMethod('setUserId', args);
  }

  static Future<String>  getUserId() async {
    final String userId = await _channel.invokeMethod('getUserId');
    return userId;
  }
  
  // Installation info	
  static Future<String> getPushToken() async {
    final String pushToken = await _channel.invokeMethod('getPushToken');
    return pushToken;
  }

  static Future<String> getInstallationId() async {
    final String installationId = await _channel.invokeMethod('getInstallationId');
    return installationId;
  }

    // Privacy

  static void setRequiresUserConsent(bool isConsent) {
      Map<String,bool> args = <String,bool>{};
      args.putIfAbsent("isConsent", () => isConsent);
      _channel.invokeMethod('setRequiresUserConsent', args);
  }

  static void setUserConsent(bool isConsent) {
      Map<String,bool> args = <String,bool>{};
      args.putIfAbsent("isConsent", () => isConsent);
      _channel.invokeMethod('setUserConsent', args);
  }

  static void disableGeolocation() {
       _channel.invokeMethod('disableGeolocation');
  }

  static void enableGeolocation() {
       _channel.invokeMethod('enableGeolocation');
  }

  static void setGeolocation(double lat, double lon) {
      Map<String,double> args = <String,double>{};
      args.putIfAbsent("lat", () => lat);
      args.putIfAbsent("lon", () => lon);
     _channel.invokeMethod('setGeolocation',args);
  }

  static void clearEventsHistory() {
       _channel.invokeMethod('clearEventsHistory');
  }

  static void clearPreferences() {
       _channel.invokeMethod('clearPreferences');
  }

  static void clearAllData() {
       _channel.invokeMethod('clearAllData');
  }
  
  static Future<dynamic> downloadAllData() async {
      final Object data = await _channel.invokeMethod('downloadAllData');
      return data;
  }

  // Debug

  static void setLogging (bool enable) {
      Map<String,bool> args = <String,bool>{};
      args.putIfAbsent("enable", () => enable);
     _channel.invokeMethod('setLogging', args);
  }
}
