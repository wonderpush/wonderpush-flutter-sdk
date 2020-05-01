package com.wonderpush.sdk.flutter;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import com.wonderpush.sdk.WonderPush;

/**
 * WonderPushPlugin
 */
public class WonderPushPlugin implements FlutterPlugin, MethodCallHandler {
    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        WonderPush.setIntegrator("wonderpush_flutter-1.0.0");
        final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "wonderpushflutter");
        channel.setMethodCallHandler(new WonderPushPlugin());
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
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "wonderpushflutter");
        channel.setMethodCallHandler(new WonderPushPlugin());
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        try {
            switch (call.method) {
                case "isReady":
                    result.success(isReady());
                    break;
                case "subscribeToNotifications":
                    subscribeToNotifications();
                    result.success(null);
                    break;
                case "unsubscribeFromNotifications":
                    unsubscribeFromNotifications();
                    result.success(null);
                    break;
                case "isSubscribedToNotifications":
                    result.success(isSubscribedToNotifications());
                    break;
                case "removeAllTags":
                    removeAllTags();
                    result.success(null);
                    break;
                case "hasTag":
                    String tag = call.argument("tag");
                    result.success(hasTag(tag));
                    break;
                case "setUserId":
                    String userId = call.argument("userId");
                    setUserId(userId);
                    result.success(null);
                    break;
                case "getUserId":
                    result.success(getUserId());
                    break;
                case "getInstallationId":
                    result.success(getInstallationId());
                    break;
                case "getPushToken":
                    result.success(getPushToken());
                    break;
                case "setLogging":
                    boolean enable = call.argument("enable");
                    setLogging(enable);
                    result.success(null);
                    break;
                default:
                    result.notImplemented();
                    break;
            }
        } catch (Exception e) {
            result.error("", null, e);
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    }

    // Initialization

    public boolean isReady(){
         boolean status = WonderPush.isReady();
         return status;
    }
     // Subscribing users

    public void subscribeToNotifications() {
        WonderPush.subscribeToNotifications();
    }

    public void unsubscribeFromNotifications() {
        WonderPush.unsubscribeFromNotifications();
    }

    public boolean isSubscribedToNotifications() {
        boolean status = WonderPush.isSubscribedToNotifications();
        return status;
    }

    // Segmentation
    public void removeAllTags() {
        WonderPush.removeAllTags();
    }
    
     public boolean hasTag(String tag) {
        boolean status = WonderPush.hasTag(tag);
        return status;
    }
   
     // User IDs	

    public void setUserId(String userId) {
      WonderPush.setUserId(userId);
    }

    public String getUserId() {
        String userId = WonderPush.getUserId();
        return userId;
    }

    // Installation info	
    public String getInstallationId() {
        String installationId = WonderPush.getInstallationId();
        return installationId;
    }

    public String getPushToken() {
        String pushToken = WonderPush.getPushToken();
        return pushToken;
    }
    // Debug

    public void setLogging(boolean enable) {
        WonderPush.setLogging(enable);
    }
}
