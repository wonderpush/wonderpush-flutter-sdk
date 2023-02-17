import 'dart:async';

import 'package:flutter/services.dart';

/// The WonderPush SDK main class.
class WonderPush extends Object {
  static const MethodChannel _methodChannel =
      const MethodChannel('wonderpush_flutter');

  // Subscribing users

  /// Prompts user to subscribe to push notifications on iOS, subscribes the user directly on Android.
  static Future<void> subscribeToNotifications([bool fallbackToSettings = false]) async {
    await _methodChannel.invokeMethod('subscribeToNotifications', fallbackToSettings);
  }

  /// Unsubscribes user from push notifications.
  static Future<void> unsubscribeFromNotifications() async {
    await _methodChannel.invokeMethod('unsubscribeFromNotifications');
  }

  /// Tells whether user is subscribed to push notifications.
  static Future<bool> isSubscribedToNotifications() async {
    final bool? result =
        await _methodChannel.invokeMethod('isSubscribedToNotifications');
    return result ?? false;
  }

  // Segmentation

  /// Sends an event with of type [type] and [attributes] of your choice.
  static Future<void> trackEvent(String type, [Object? attributes]) async {
    Map<String, Object?> args = <String, Object?>{};
    args.putIfAbsent("attributes", () => attributes);
    args.putIfAbsent("type", () => type);
    await _methodChannel.invokeMethod('trackEvent', args);
  }

  /// Adds one or more tags to this installation.
  /// [tags] can be a list or a string.
  static Future<void> addTag(var tags) async {
    if (!(tags is List)) {
      tags = [tags];
    }
    Map<String, List> args = <String, List>{};
    args.putIfAbsent("tags", () => tags);
    await _methodChannel.invokeMethod('addTag', args);
  }

  /// Removes one or more tags to this installation.
  /// [tags] can be a list or a string.
  static Future<void> removeTag(var tags) async {
    if (!(tags is List)) {
      tags = [tags];
    }
    Map<String, List> args = <String, List>{};
    args.putIfAbsent("tags", () => tags);
    await _methodChannel.invokeMethod('removeTag', args);
  }

  /// Removes all tags.
  static Future<void> removeAllTags() async {
    await _methodChannel.invokeMethod('removeAllTags');
  }

  /// Tells whether the current installation as a tag [tag].
  static Future<bool> hasTag(String tag) async {
    Map<String, String> args = <String, String>{};
    args.putIfAbsent("tag", () => tag);
    final bool? result = await _methodChannel.invokeMethod('hasTag', args);
    return result ?? false;
  }

  /// Returns a list of tags associated with the current installation.
  static Future<List> getTags() async {
    final List? result = await _methodChannel.invokeMethod('getTags');
    return result ?? [];
  }

  /// Returns the value of a given [property] associated to this installation.
  /// If the property stores an array, only the first value is returned.
  /// This way you don’t have to deal with potential arrays if that property is not supposed to hold one.
  /// Returns null if the property is absent or has an empty array value.
  static Future<dynamic> getPropertyValue(String property) async {
    Map<String, String> args = <String, String>{};
    args.putIfAbsent("property", () => property);
    final Object? result =
        await _methodChannel.invokeMethod('getPropertyValue', args);
    return result;
  }

  /// Returns an list of the values of a given property associated to this installation.
  /// If the property does not store an array, an array is returned nevertheless.
  /// This way you don’t have to deal with potential scalar values if that property is supposed to hold an array.
  /// Returns an empty array if the property is absent or null.
  /// Returns an array wrapping any scalar value held by the property.
  static Future<List> getPropertyValues(String property) async {
    Map<String, String> args = <String, String>{};
    args.putIfAbsent("property", () => property);
    final List? result =
        await _methodChannel.invokeMethod('getPropertyValues', args);
    return result ?? [];
  }

  /// Adds the [value] to a given [property] associated to this installation.
  /// [value] can be a list or an individual value.
  /// The stored value is made an array if not already one.
  /// If the given value is an array, all its values are added.
  /// If a value is already present in the stored value, it won’t be added.
  static Future<void> addProperty(String property, var value) async {
    if (!(value is List)) {
      value = [value];
    }
    Map<String, Object> args = <String, Object>{};
    args.putIfAbsent("property", () => property);
    args.putIfAbsent("properties", () => (value as List));
    await _methodChannel.invokeMethod('addProperty', args);
  }

  /// Removes the value from a given [property] associated to the current installation.
  /// If [value] is a list, all its values are removed.
  /// If a value is present multiple times in the stored value, they will all be removed.
  static Future<void> removeProperty(String property, Object value) async {
    if (!(value is List)) {
      value = [value];
    }
    Map<String, Object> args = <String, Object>{};
    args.putIfAbsent("property", () => property);
    args.putIfAbsent("properties", () => value);
    await _methodChannel.invokeMethod('removeProperty', args);
  }

  /// Sets the [value] to a given [property] associated to the current installation.
  /// The previous value is replaced entirely.
  /// The [value] can be a string, number, object, list or null (which has the same effect as [unsetProperty]).
  /// See [format of property names](https://docs.wonderpush.com/docs/properties#section-property-names) for detailed syntax.
  static Future<void> setProperty(String property, Object? value) async {
    Map<String, Object?> args = <String, Object?>{};
    args.putIfAbsent("property", () => property);
    args.putIfAbsent("properties", () => value);
    await _methodChannel.invokeMethod('setProperty', args);
  }

  /// Removes the value of a given property associated to the current installation.
  static Future<void> unsetProperty(String property) async {
    Map<String, String> args = <String, String>{};
    args.putIfAbsent("property", () => property);
    await _methodChannel.invokeMethod('unsetProperty', args);
  }

  /// Updates the [properties] of the current installation.
  /// Omitting a previously set property leaves it untouched.
  /// To remove a property, you must pass it explicitly with a value of null.
  static Future<void> putProperties(Object properties) async {
    Map<String, Object> args = <String, Object>{};
    args.putIfAbsent("properties", () => properties);
    await _methodChannel.invokeMethod('putProperties', args);
  }

  /// Returns an object containing the properties of the current installation.
  static Future<Object> getProperties() async {
    final Map? result = await _methodChannel.invokeMethod('getProperties');
    return result ?? {};
  }

  /// Overrides the user's [country].
  /// Defaults to getting the country code from the system default locale.
  /// You should use an ISO 3166-1 alpha-2 country code, eg: US, FR, GB.
  /// Use null to disable the override.
  static Future<void> setCountry(String country) async {
    Map<String, String> args = <String, String>{};
    args.putIfAbsent("country", () => country);
    await _methodChannel.invokeMethod('setCountry', args);
  }

  /// Returns the user's country, either as previously stored, or as guessed from the system.
  static Future<String?> getCountry() async {
    final String? country = await _methodChannel.invokeMethod('getCountry');
    return country;
  }

  /// Overrides the user's [currency].
  /// Defaults to getting the currency code from the system default locale.
  /// You should use an ISO 4217 currency code, eg: USD, EUR, GBP.
  /// Use null to disable the override.
  static Future<void> setCurrency(String currency) async {
    Map<String, String> args = <String, String>{};
    args.putIfAbsent("currency", () => currency);
    await _methodChannel.invokeMethod('setCurrency', args);
  }

  /// Returns the user's currency, either as previously stored, or as guessed from the system.
  static Future<String?> getCurrency() async {
    final String? currency = await _methodChannel.invokeMethod('getCurrency');
    return currency;
  }

  /// Overrides the user's [locale].
  /// Defaults to getting the language and country codes from the system default locale.
  /// You should use an xx-XX form of RFC 1766, composed of a lowercase ISO 639-1 language code, an underscore or a dash, and an uppercase ISO 3166-1 alpha-2 country code.
  // Use null to disable the override.
  static Future<void> setLocale(String locale) async {
    Map<String, String> args = <String, String>{};
    args.putIfAbsent("locale", () => locale);
    await _methodChannel.invokeMethod('setLocale', args);
  }

  /// Returns the user's locale, either as previously stored, or as guessed from the system.
  static Future<String?> getLocale() async {
    final String? locale = await _methodChannel.invokeMethod('getLocale');
    return locale;
  }

  /// Overrides the user's [timeZone].
  /// Defaults to getting the time zone code from the system default locale.
  /// You should use an IANA time zone database codes, Continent/Country style preferably like Europe/Paris, or abbreviations like CET, PST, UTC, which have the drawback of changing on daylight saving transitions.
  /// Use null to disable the override.
  static Future<void> setTimeZone(String timeZone) async {
    Map<String, String> args = <String, String>{};
    args.putIfAbsent("timeZone", () => timeZone);
    await _methodChannel.invokeMethod('setTimeZone', args);
  }

  /// Returns the user's time zone, either as previously stored, or as guessed from the system.
  static Future<String?> getTimeZone() async {
    final String? timeZone = await _methodChannel.invokeMethod('getTimeZone');
    return timeZone;
  }

  // User IDs

  /// Assigns your own user ID to an installation. See [User IDs](https://docs.wonderpush.com/docs/user-ids).
  static Future<void> setUserId(String userId) async {
    Map<String, String> args = <String, String>{};
    args.putIfAbsent("userId", () => userId);
    await _methodChannel.invokeMethod('setUserId', args);
  }

  /// Returns the userId you've assigned to this installation, or null. See [User IDs](https://docs.wonderpush.com/docs/user-ids).
  static Future<String?> getUserId() async {
    final String? userId = await _methodChannel.invokeMethod('getUserId');
    return userId;
  }

  // Installation info
  /// Returns the push token of this installation, or null.
  static Future<String?> getPushToken() async {
    final String? pushToken = await _methodChannel.invokeMethod('getPushToken');
    return pushToken;
  }

  /// Returns the installationId, or null if the WonderPush servers have not been contacted just yet.
  static Future<String?> getInstallationId() async {
    final String? installationId =
        await _methodChannel.invokeMethod('getInstallationId');
    return installationId;
  }

  /// Returns the deviceId
  static Future<String?> getDeviceId() async {
    final String? deviceId =
        await _methodChannel.invokeMethod('getDeviceId');
    return deviceId;
  }

  /// Returns the accessToken
  static Future<String?> getAccessToken() async {
    final String? accessToken =
        await _methodChannel.invokeMethod('getAccessToken');
    return accessToken;
  }

  /// Returns the userConsent
  static Future<bool?> getUserConsent() async {
    final bool? userConsent =
        await _methodChannel.invokeMethod('getUserConsent');
    return userConsent;
  }

  // Privacy

  /// Sets whether user consent is required before the SDK takes any action.
  /// See https://docs.wonderpush.com/docs/gdpr-compliance#section-declaring-that-consent-is-required
  /// By default, user consent is not required.
  /// Note that the value is not remembered between runs, it is rather a mode that you enable.
  static Future<void> setRequiresUserConsent(bool isConsent) async {
    Map<String, bool> args = <String, bool>{};
    args.putIfAbsent("isConsent", () => isConsent);
    await _methodChannel.invokeMethod('setRequiresUserConsent', args);
  }

  /// Sets user privacy consent according to [consentGiven].
  /// Works in conjunction with the [setRequiresUserConsent] method.
  /// If user consent is required, the SDK takes no action until user consent it provided by calling setUserConsent(true).
  /// Calling setUserConsent(false) blocks the SDK again.
  static Future<void> setUserConsent(bool consentGiven) async {
    Map<String, bool> args = <String, bool>{};
    args.putIfAbsent("isConsent", () => consentGiven);
    await _methodChannel.invokeMethod('setUserConsent', args);
  }

  /// Disables the collection of the user's geolocation.
  static Future<void> disableGeolocation() async {
    await _methodChannel.invokeMethod('disableGeolocation');
  }

  /// Enables the collection of the user's geolocation.
  /// You still need the appropriate geolocation permissions in your AndroidManifest.xml for Android and Info.plist for iOS to be able to read the user's location.
  static Future<void> enableGeolocation() async {
    await _methodChannel.invokeMethod('enableGeolocation');
  }

  /// Overrides the user's geolocation.
  /// Lets you set the user's location you've collected yourself.
  /// Calling this method with null has the same effect as calling [disableGeolocation].
  static Future<void> setGeolocation(double lat, double lon) async {
    Map<String, double> args = <String, double>{};
    args.putIfAbsent("lat", () => lat);
    args.putIfAbsent("lon", () => lon);
    await _methodChannel.invokeMethod('setGeolocation', args);
  }

  /// Instructs to delete any event associated with the all installations present on the device, locally and on WonderPush servers.
  /// See https://docs.wonderpush.com/docs/gdpr-compliance#giving-users-control-over-their-data
  static Future<void> clearEventsHistory() async {
    await _methodChannel.invokeMethod('clearEventsHistory');
  }

  /// Instructs to delete any custom data (including installation properties) associated with the all installations present on the device, locally and on WonderPush servers.
  /// See https://docs.wonderpush.com/docs/gdpr-compliance#giving-users-control-over-their-data
  static Future<void> clearPreferences() async {
    await _methodChannel.invokeMethod('clearPreferences');
  }

  /// Instructs to delete any event, installation and potential user objects associated with all installations present on the device, locally and on WonderPush servers.
  /// See https://docs.wonderpush.com/docs/gdpr-compliance#giving-users-control-over-their-data
  static Future<void> clearAllData() async {
    _methodChannel.invokeMethod('clearAllData');
  }

  /// Initiates the download of all the WonderPush data relative to the current installation and opens a user interface to let users use it as they wish.
  static Future<void> downloadAllData() async {
    await _methodChannel.invokeMethod('downloadAllData');
  }

  // Debug

  /// Enables or disables verbose logging of WonderPush.
  static Future<void> setLogging(bool enable) async {
    Map<String, bool> args = <String, bool>{};
    args.putIfAbsent("enable", () => enable);
    await _methodChannel.invokeMethod('setLogging', args);
  }
}
