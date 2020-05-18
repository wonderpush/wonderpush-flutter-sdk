import 'dart:async';

import 'package:flutter/services.dart';

class Wonderpushflutter extends Object {
   static const MethodChannel methodchannel =  const MethodChannel('wonderpushflutter');




   
  // Initialization

  static Future<bool> isReady() async {
    final bool result = await methodchannel.invokeMethod('isReady');
    return result;
  }
  // Subscribing users

  static Future<void> subscribeToNotifications() async {
     await methodchannel.invokeMethod('subscribeToNotifications');
  }

  static Future<void> unsubscribeFromNotifications() async {
      await methodchannel.invokeMethod('unsubscribeFromNotifications');
  }

  static Future<bool> isSubscribedToNotifications() async {
    final bool result = await methodchannel.invokeMethod('isSubscribedToNotifications');
    return result;
  }

   // Segmentation

  static Future<void> trackEvent(String type, [Object attributes]) async {
     Map<String,Object> args = <String,Object>{};
     args.putIfAbsent("attributes", () => attributes);
      args.putIfAbsent("type", () => type);
     await methodchannel.invokeMethod('trackEvent',args);
  }
  static Future<void> addTag(var tags) async {
    if(!(tags is List)){
      tags = [tags];
    }
    Map<String,List> args = <String,List>{};
    args.putIfAbsent("tags", () => tags);
    await methodchannel.invokeMethod('addTag',args);
  }
   
  static Future<void> removeTag(var tags) async {
    if(!(tags is List)){
      tags = [tags];
    }
    Map<String,List> args = <String,List>{};
    args.putIfAbsent("tags", () => tags);
    await methodchannel.invokeMethod('removeTag',args);
  }

  static Future<void> removeAllTags() async {
      await methodchannel.invokeMethod('removeAllTags');
  }

  static Future<bool>  hasTag(String tag)  async {
     Map<String,String> args = <String,String>{};
     args.putIfAbsent("tag", () => tag);
     final bool result = await methodchannel.invokeMethod('hasTag',args);
     return result;
  }

  static Future<List> getTags() async {
     final List result = await methodchannel.invokeMethod('getTags');
     return result;
  }

  static Future<dynamic> getPropertyValue(String property) async{
     Map<String,String> args = <String,String>{};
     args.putIfAbsent("property", () => property);
     final Object result = await methodchannel.invokeMethod('getPropertyValue',args);
     return result;
  }

  static Future<List> getPropertyValues(String property) async {
     Map<String,String> args = <String,String>{};
     args.putIfAbsent("property", () => property);
     final List result = await methodchannel.invokeMethod('getPropertyValues',args);
     return result;
  }

   static Future<void> addProperty(String property, var properties) async {
     if(!(properties is List)){
       properties = [properties];
     }
     Map<String,Object> args = <String,Object>{};
     args.putIfAbsent("property", () => property);
     args.putIfAbsent("properties", () => properties);
     await methodchannel.invokeMethod('addProperty',args);
  }

  static Future<void> removeProperty(String property, Object properties) async{
    if(!(properties is List)){
       properties = [properties];
     }
     Map<String,Object> args = <String,Object>{};
     args.putIfAbsent("property", () => property);
     args.putIfAbsent("properties", () => properties);
    await methodchannel.invokeMethod('removeProperty',args);
  }

  static Future<void> setProperty(String property, Object properties) async{
     Map<String,Object> args = <String,Object>{};
     args.putIfAbsent("property", () => property);
     args.putIfAbsent("properties", () => properties);
     await methodchannel.invokeMethod('setProperty',args);
  }
  
  static Future<void> unsetProperty(String property) async {
     Map<String,String> args = <String,String>{};
     args.putIfAbsent("property", () => property);
     await methodchannel.invokeMethod('unsetProperty',args);
  }

  static Future<void> putProperties(Object properties) async {
     Map<String,Object> args = <String,Object>{};
     args.putIfAbsent("properties", () => properties);
     await methodchannel.invokeMethod('putProperties',args);
  }

   static Future<Object> getProperties() async{
     final Map result = await methodchannel.invokeMethod('getProperties');
     return result;
  }

  static Future<void> setCountry(String country) async {
    Map<String,String> args = <String,String>{};
    args.putIfAbsent("country", () => country);
     await methodchannel.invokeMethod('setCountry', args);
  }

  static Future<String> getCountry() async {
    final String country = await methodchannel.invokeMethod('getCountry');
    return country;
  }

  static Future<void> setCurrency(String currency) async {
    Map<String,String> args = <String,String>{};
    args.putIfAbsent("currency", () => currency);
     await methodchannel.invokeMethod('setCurrency', args);
  }

  static Future<String> getCurrency() async {
    final String currency = await methodchannel.invokeMethod('getCurrency');
    return currency;
  }

  static Future<void> setLocale(String locale) async{
    Map<String,String> args = <String,String>{};
    args.putIfAbsent("locale", () => locale);
    await methodchannel.invokeMethod('setLocale', args);
  }

  static Future<String> getLocale() async {
    final String locale = await methodchannel.invokeMethod('getLocale');
    return locale;
  }

  static Future<void> setTimeZone(String timeZone) async{
    Map<String,String> args = <String,String>{};
    args.putIfAbsent("timeZone", () => timeZone);
    await methodchannel.invokeMethod('setTimeZone', args);
  }

  static Future<String> getTimeZone() async {
    final String timeZone = await methodchannel.invokeMethod('getTimeZone');
    return timeZone;
  }


   // User IDs	

  static Future<void> setUserId(String userId)  async {
    Map<String,String> args = <String,String>{};
    args.putIfAbsent("userId", () => userId);
    await methodchannel.invokeMethod('setUserId', args);
  }

  static Future<String>  getUserId() async {
    final String userId = await methodchannel.invokeMethod('getUserId');
    return userId;
  }
  
  // Installation info	
  static Future<String> getPushToken() async {
    final String pushToken = await methodchannel.invokeMethod('getPushToken');
    return pushToken;
  }

  static Future<String> getInstallationId() async {
    final String installationId = await methodchannel.invokeMethod('getInstallationId');
    return installationId;
  }

    // Privacy

  static Future<void> setRequiresUserConsent(bool isConsent) async {
      Map<String,bool> args = <String,bool>{};
      args.putIfAbsent("isConsent", () => isConsent);
      await methodchannel.invokeMethod('setRequiresUserConsent', args);
  }

  static Future<void> setUserConsent(bool isConsent) async {
      Map<String,bool> args = <String,bool>{};
      args.putIfAbsent("isConsent", () => isConsent);
      await methodchannel.invokeMethod('setUserConsent', args);
  }

  static Future<void> disableGeolocation() async {
       await methodchannel.invokeMethod('disableGeolocation');
  }

  static Future<void> enableGeolocation() async {
       await methodchannel.invokeMethod('enableGeolocation');
  }

  static Future<void> setGeolocation(double lat, double lon) async {
      Map<String,double> args = <String,double>{};
      args.putIfAbsent("lat", () => lat);
      args.putIfAbsent("lon", () => lon);
     await methodchannel.invokeMethod('setGeolocation',args);
  }

  static Future<void> clearEventsHistory() async {
       await methodchannel.invokeMethod('clearEventsHistory');
  }

  static Future<void> clearPreferences() async {
       await methodchannel.invokeMethod('clearPreferences');
  }

  static Future<void> clearAllData() async {
       methodchannel.invokeMethod('clearAllData');
  }
  
  static Future<dynamic> downloadAllData() async {
      final Object data = await methodchannel.invokeMethod('downloadAllData');
      return data;
  }

  // Debug

  static Future<void> setLogging(bool enable) async {
      Map<String,bool> args = <String,bool>{};
      args.putIfAbsent("enable", () => enable);
     await methodchannel.invokeMethod('setLogging', args);
  }
}
