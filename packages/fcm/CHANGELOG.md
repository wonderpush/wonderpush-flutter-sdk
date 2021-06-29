## 1.0.3

* Update to WonderPush Android SDK FCM module v1.0.3:
  * Upgrade `firebase-messaging` to get rid of a dependency on pre-AndroidX support libraries. Without this change you needed to use `android.enableJetifier=true`.
  * Upgrade `firebase-messaging` to be compatible with versions 22+, as they replaced their Instance ID SDK with their Installations SDK.
    WonderPush failed to retrieve a push token with such versions of the dependency. This only affected users that depended on Firebase outside of WonderPush if one of their dependencies forced the `firebase-messaging` to use version 22+.

## 1.0.2

If you faced one of these errors:

```
W/WonderPush.Push.FCM.FCMPushService: The Google Play Services have not been added to the application
    java.lang.ClassNotFoundException: com.google.android.gms.common.GooglePlayServicesUtil
     Caused by: java.lang.ClassNotFoundException: Didn't find class "com.google.android.gms.common.GooglePlayServicesUtil" on path: DexPathList[…]
D/WonderPush.Push: Used push service: (none)
```

```
E/WonderPush: Failed to show the notification
    java.lang.IllegalArgumentException: Invalid notification (no valid small icon)
```

then this update is for you.
Other users are encouraged to update too.

**Changelog:**

* Null safety (this package contains no Dart code, but it depends on Dart 2.12 now)
* Integrates Android dependency `com.wonderpush:wonderpush-android-sdk-fcm` v1.0.2.
  * Fix compatibility with recent Firebase modules

## 1.0.1

* Integrates Android dependency `com.wonderpush:wonderpush-android-sdk-fcm` v1.0.1.
