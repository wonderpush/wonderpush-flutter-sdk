package com.wonderpush.sdk.wonderpush_flutter_plugin.handlers;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import com.google.firebase.messaging.RemoteMessage;
import com.wonderpush.sdk.WonderPush;
import com.wonderpush.sdk.WonderPushFirebaseMessagingService;
import com.wonderpush.sdk.WonderPushUserPreferences;
import com.wonderpush.sdk.wonderpush_flutter_plugin.WPFirebaseMessagingService;
import com.wonderpush.sdk.wonderpush_flutter_plugin.WonderPushInstance;
import org.json.JSONArray;
import org.json.JSONObject;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import io.flutter.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MethodHandler  implements MethodChannel.MethodCallHandler{

    MethodChannel.Result result;
    MethodCall call;
    Context context;
    Activity mainActivity;

    public MethodHandler(Context context,Activity activity){
        this.context=context;
        this.mainActivity=activity;

    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        this.result = result;
        this.call = call;

        switch (call.method){

            case "getPlatformVersion":
                result.success("My Android ${android.os.Build.VERSION.RELEASE}");
                break;

            case "FcmDartService#start":
                long setupCallbackHandle = 0;
                long backgroundMessageHandle = 0;
                try {
                    @SuppressWarnings("unchecked")
                    Map<String, Long> callbacks = ((Map<String, Long>) call.arguments);
                    setupCallbackHandle = callbacks.get("setupHandle");
                    backgroundMessageHandle = callbacks.get("backgroundHandle");
                } catch (Exception e) {
                    //Log.e(TAG, "There was an exception when getting callback handle from Dart side");
                    e.printStackTrace();
                }
                WPFirebaseMessagingService.setBackgroundSetupHandle(this.context, setupCallbackHandle);
                WPFirebaseMessagingService.startBackgroundIsolate(this.context, setupCallbackHandle);
                WPFirebaseMessagingService.setBackgroundMessageHandle(
                    this.context, backgroundMessageHandle);

                result.success(true);
                break;

            case "configure":
                //channel.invokeMethod("onToken", task.getResult().getToken());
                if (mainActivity != null) {
                    //sendMessageFromIntent("onLaunch", mainActivity.getIntent());
                  }
                result.success(WonderPush.getPushToken());
                break;


            case "init":
                WonderPushInstance.getInstance().setupWonderPush(this.context,call.argument("clientId").toString(),call.argument("clientSecret").toString());
                result.success("Setup has completed");
                break;

            case "trackEvent":
                String eventType=call.argument("eventType");
               // String eventName=call.argument("eventName");
                WonderPushInstance.getInstance().subscribeToEvent(eventType);
                result.success("Successfully subscribed to event "+eventType);
                break;

            case "setUserId":
                    String userId=call.argument("userId");
                    WonderPush.setUserId(userId);
                    result.success("Successfully set user id to "+userId);
                    break;
            case "isReady":
                result.success(WonderPush.isReady());
                break;

            case "setLogging":
                boolean enabled=call.argument("enabled");
                WonderPush.setLogging(enabled);
                result.success("Logging is set to" +enabled);
                break;

            case "getUserId":
                result.success(WonderPush.getUserId());
                break;

            case "getInstallationId":
                result.success(WonderPush.getInstallationId());
                break;

            case "getDeviceId":
                result.success(WonderPush.getDeviceId());
                break;

            case "getPushToken":
                result.success(WonderPush.getPushToken());
                break;

            case "getAccessToken":
                result.success(WonderPush.getAccessToken());
                break;

            case "addTag":
                WonderPushInstance.getInstance().updateTags(call.argument("tags"),"addTag");
                break;

            case "removeTag":
                WonderPushInstance.getInstance().updateTags(call.argument("tags"),"removeTag");
                break;

            case "removeAllTags":
                WonderPush.removeAllTags();
                result.success("All tags removed successfully");
                break;

            case "getTags":
                result.success(new JSONArray(WonderPush.getTags()));
                break;

            case "hasTag":
                result.success(WonderPush.hasTag(call.argument("tag").toString()));
                break;

            case "setProperty":
                String field = call.argument("key");
                Object value = call.argument("value");
                WonderPush.setProperty(field, value);
                result.success(true);
                break;

            case "unsetProperty":
                String key = call.argument("key");
                WonderPush.unsetProperty(key);
                result.success(true);
                break;

            case "addProperty":
                String addPropertyKey = call.argument("key");
                Object addPropertyValue = call.argument("value");
                WonderPush.addProperty(addPropertyKey, addPropertyValue);
                result.success(true);
                break;

            case "removeProperty":
                String removePropertyKey = call.argument("key");
                Object removePropertyValue = call.argument("value");
                WonderPush.removeProperty(removePropertyKey, removePropertyValue);
                result.success(true);
                break;

            case "getPropertyValue":
                String getPropertyValueKey = call.argument("key");
                result.success( new JSONObject(Collections.singletonMap("__wrapped", WonderPush.getPropertyValue(getPropertyValueKey))));
                break;

            case "getPropertyValues":
                String getPropertyValuesKey = call.argument("key");
                result.success(new JSONArray(WonderPush.getPropertyValues(getPropertyValuesKey)));
                break;

            case "getProperties":
                result.success(WonderPush.getProperties());
                break;

            case "putProperties":
                JSONObject properties = call.argument("key");
                WonderPush.putProperties(properties);
                result.success(true);
                break;

            case "getInstallationCustomProperties":
                result.success(WonderPush.getInstallationCustomProperties());
                break;

            case "putInstallationCustomProperties":

                JSONObject custom = call.argument("custom");;
                WonderPush.putInstallationCustomProperties(custom);
                break;

            case "subscribeToNotifications":
                WonderPush.subscribeToNotifications();
                result.success(true);
                break;

            case "isSubscribedToNotifications":
                result.success( WonderPush.isSubscribedToNotifications());
                break;

            case "unsubscribeFromNotifications":
                WonderPush.unsubscribeFromNotifications();
                result.success(true);
                break;

            case "getNotificationEnabled":
                result.success(WonderPush.getNotificationEnabled());
                break;

            case "setNotificationEnabled":
                Boolean isNotificationEnabled = call.argument("isNotificationEnabled");;
                result.success(isNotificationEnabled);
                break;

            case "getUserConsent":
                result.success(WonderPush.getUserConsent());
                break;

            case "setUserConsent":
                Boolean isUserConsent = call.argument("isUserConsent");;
                result.success(isUserConsent);
                break;

            case "clearAllData":
                WonderPush.clearAllData();
                result.success(true);
                break;

            case "clearEventsHistory":
                WonderPush.clearEventsHistory();
                result.success(true);
                break;

            case "clearPreferences":
                WonderPush.clearPreferences();
                result.success(true);
                break;

            case "downloadAllData":
                WonderPush.downloadAllData();
                result.success(true);
                break;

            case "UserPreferences_getDefaultChannelId":
                result.success(WonderPushUserPreferences.getDefaultChannelId());
                break;

            case "UserPreferences_setDefaultChannelId":
                String id = call.argument("id");
                WonderPushUserPreferences.setDefaultChannelId(id);
                result.success(true);
                break;


            case "FcmDartService#initialized":
                WPFirebaseMessagingService.onInitialized();
                result.success(true);
                break;

//            case "UserPreferences_getChannelGroup":
//
//                String groupId = call.argument("id");
//                JSONObject rtn = this.jsonSerializeWonderPushChannelGroup(WonderPushUserPreferences.getChannelGroup(groupId));
//                if (rtn == null) {
//                    result.success(null);
//                } else {
//                    result.success(rtn);
//                }
//                break;

//                if (action.equals("UserPreferences_getChannel")) {
//
//                String id = args.getString(0);
//                JSONObject rtn = this.jsonSerializeWonderPushChannel(WonderPushUserPreferences.getChannel(id));
//                if (rtn == null) {
//                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, (String) null));
//                } else {
//                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, rtn));
//                }
//
//            } else if (action.equals("UserPreferences_setChannelGroups")) {
//
//                JSONArray groupsJson = args.getJSONArray(0);
//                List<WonderPushChannelGroup> groups = new ArrayList<>(groupsJson.length());
//                for (int i = 0, e = groupsJson.length(); i < e; ++i) {
//                    groups.add(this.jsonDeserializeWonderPushChannelGroup(groupsJson.optJSONObject(i)));
//                }
//                WonderPushUserPreferences.setChannelGroups(groups);
//                callbackContext.success();
//
//            } else if (action.equals("UserPreferences_setChannels")) {
//
//                JSONArray channelsJson = args.getJSONArray(0);
//                List<WonderPushChannel> channels = new ArrayList<>(channelsJson.length());
//                for (int i = 0, e = channelsJson.length(); i < e; ++i) {
//                    channels.add(this.jsonDeserializeWonderPushChannel(channelsJson.optJSONObject(i)));
//                }
//                WonderPushUserPreferences.setChannels(channels);
//                callbackContext.success();
//
//            } else if (action.equals("UserPreferences_putChannelGroup")) {
//
//                JSONObject groupJson = args.getJSONObject(0);
//                WonderPushChannelGroup group = this.jsonDeserializeWonderPushChannelGroup(groupJson);
//                WonderPushUserPreferences.putChannelGroup(group);
//                callbackContext.success();
//
//            } else if (action.equals("UserPreferences_putChannel")) {
//
//                JSONObject channelJson = args.getJSONObject(0);
//                WonderPushChannel channel = this.jsonDeserializeWonderPushChannel(channelJson);
//                WonderPushUserPreferences.putChannel(channel);
//                callbackContext.success();
//
//            } else if (action.equals("UserPreferences_removeChannelGroup")) {
//
//                String id = args.getString(0);
//                WonderPushUserPreferences.removeChannelGroup(id);
//                callbackContext.success();
//
//            } else if (action.equals("UserPreferences_removeChannel")) {
//
//                String id = args.getString(0);
//                WonderPushUserPreferences.removeChannel(id);
//                callbackContext.success();
//
//            }

            default:
                    result.notImplemented();

        }
    }


}



