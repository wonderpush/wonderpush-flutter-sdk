package com.wonderpush.flutter.sdk;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import com.wonderpush.sdk.WonderPush;

/** SdkPlugin */
public class SdkPlugin implements FlutterPlugin, MethodCallHandler {
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    WonderPush.setIntegrator("flutter-wonderpush-1.0.0");
    final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "sdk");
    channel.setMethodCallHandler(new SdkPlugin());
  }
   

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "sdk");
    channel.setMethodCallHandler(new SdkPlugin());
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method){
      case "getPlatformVersion":
        result.success(getPlatformVersion());
        break;
      case "setLogging":
        boolean enable = call.argument("enable");
        result.success(setLogging(enable));
        break;
      case "subscribeToNotifications":
        result.success(subscribeToNotifications());
        break;
      case "unsubscribeFromNotifications":
        result.success(unsubscribeFromNotifications());
        break;
      case "isSubscribedToNotifications":
        result.success(isSubscribedToNotifications());
        break;
      case "setUserId":
        String userId = call.argument("userId");
        result.success(setUserId(userId));
        break;
      case "getUserId":
        result.success(getUserId());
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }

  public String getPlatformVersion(){
    return android.os.Build.VERSION.RELEASE.toString();
  }

  public Object setLogging(boolean enable){
     try {
      WonderPush.setLogging(enable);
      return null;
    } catch (Exception e) {
      return e;
    }
  }

  public Object subscribeToNotifications(){
    try {
      WonderPush.subscribeToNotifications();
      return null;
    } catch (Exception e) {
      return e;
    }
  } 

  public Object unsubscribeFromNotifications(){
    try {
      WonderPush.unsubscribeFromNotifications();
      return null;
    } catch (Exception e) {
      return e;
    }
  } 

   public Object isSubscribedToNotifications(){
    try {
      WonderPush.isSubscribedToNotifications();
      return null;
    } catch (Exception e) {
      return e;
    }
  } 

   public Object setUserId(String userId) {
      try {
        WonderPush.setUserId(userId);
        return null;
     } catch (Exception e) {
        return e;
      }
    }

    public String getUserId() {
        try {
            String userId = WonderPush.getUserId();
            return userId;
        } catch (Exception e) {
           return e.toString();
        }
    }
}


