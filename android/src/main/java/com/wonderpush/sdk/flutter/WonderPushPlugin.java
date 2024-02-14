package com.wonderpush.sdk.flutter;

import androidx.annotation.NonNull;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import android.content.BroadcastReceiver;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;

import io.flutter.embedding.engine.plugins.FlutterPlugin;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import android.location.Location;
import android.util.Log;

import com.wonderpush.sdk.WonderPush;
import com.wonderpush.sdk.WonderPushDelegate;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * WonderPushPlugin
 */
public class WonderPushPlugin implements FlutterPlugin, MethodCallHandler {

    static final String TAG = "WonderPushPlugin";
    private MethodChannel eventChannel = null;
    private boolean flutterDelegateRegistered = false;


    private static WonderPushPlugin instance;

    public WonderPushPlugin() {
        instance = this;
    }

    public static WonderPushPlugin getInstance() {
        if (instance == null) {
            instance = new WonderPushPlugin();
        }
        return instance;
    }

    static class FlutterCallback {
        String method;
        Object arguments;
        FlutterCallback(String m, Object a) {
            method = m;
            arguments = a;
        }
    }

    public static boolean isWonderPushPluginInstantiated() {
        return instance != null;
    }

    public static boolean isReadyToAcceptCallbacks() {
        boolean result = instance != null && instance.eventChannel != null && instance.flutterDelegateRegistered;
        if (!result) {
            Log.d(TAG, "Not ready to accept callbacks because: "
                    + ((instance == null) ? "[instance is null]" : "")
                    + (instance != null && instance.eventChannel == null ? "[event channel not ready]" : "")
                    + (instance != null && !instance.flutterDelegateRegistered ? "[delegate not registered]" : ""));
        }
        return result;
    }

    protected void executeCallback(FlutterCallback callback) {
        if (eventChannel == null) {
            Log.w(TAG, "Trying to execute callback [" + callback.method + "] when event channel not ready");
            return;
        }
        eventChannel.invokeMethod(callback.method, callback.arguments);
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        Log.d(TAG, "onAttachedToEngine");
        Context applicationContext = flutterPluginBinding.getApplicationContext();
        BinaryMessenger binaryMessenger = flutterPluginBinding.getBinaryMessenger();

        // Integrator
        WonderPush.setIntegrator("wonderpush_flutter-2.3.9");

        // Method channel
        final MethodChannel channel = new MethodChannel(binaryMessenger, "wonderpush_flutter");
        eventChannel = channel;
        channel.setMethodCallHandler(this);
        Log.d(TAG, "onAttachedToEngine method channel set up.");

    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {

    }

    private Delegate getOurDelegate() {
        WonderPushDelegate delegate = WonderPush.getDelegate();
        if (delegate instanceof Delegate) return (Delegate)delegate;
        return null;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        Log.d(TAG, "onMethodCall [" + call.method + "]");
        try {
            switch (call.method) {
                case "setFlutterDelegate": {
                    flutterDelegateRegistered = true;
                    Delegate ourDelegate = getOurDelegate();
                    if (ourDelegate != null) {
                        if (!ourDelegate.canStartFlutterEngine()) {
                            Log.i(TAG, "The delegate's onNotificationReceived will not be called when the app is not running. To start the app on the reception of a notification, configure the " + Delegate.DART_ENTRY_POINT_FUNCTION_NAME_METADATA + " meta-data in your AndroidManifest.xml with the name of the dart function to call. For example: <meta-data android:name=\"com.wonderpush.sdk.dartEntryPointFunctionName\" android:value=\"main\" />");
                        }
                        ourDelegate.drainPendingFlutterCallbacks();
                    }
                    result.success(null);
                }
                    break;
                case "subscribeToNotifications":
                    boolean fallbackToSettings = (boolean) call.arguments;
                    subscribeToNotifications(fallbackToSettings);
                    result.success(null);
                    break;
                case "unsubscribeFromNotifications":
                    unsubscribeFromNotifications();
                    result.success(null);
                    break;
                case "isSubscribedToNotifications":
                    result.success(isSubscribedToNotifications());
                    break;
                case "trackEvent":
                    String type = call.argument("type");
                    Map<String, Object> attributes = call.argument("attributes");
                    trackEvent(type, attributes);
                    result.success(null);
                    break;
                case "addTag":
                    ArrayList tagsToAdd = call.argument("tags");
                    addTag(tagsToAdd);
                    result.success(null);
                    break;
                case "removeTag":
                    ArrayList tagsToRemove = call.argument("tags");
                    removeTag(tagsToRemove);
                    result.success(null);
                    break;
                case "removeAllTags":
                    removeAllTags();
                    result.success(null);
                    break;
                case "hasTag":
                    String tag = call.argument("tag");
                    result.success(hasTag(tag));
                    break;
                case "getTags":
                    result.success(getTags());
                    break;
                case "getPropertyValue":
                    String propertyValueToGet = call.argument("property");
                    result.success(getPropertyValue(propertyValueToGet));
                    break;
                case "getPropertyValues":
                    String propertyValuesToGet = call.argument("property");
                    result.success(getPropertyValues(propertyValuesToGet));
                    break;
                case "addProperty":
                    String propertyToAdd = call.argument("property");
                    Object propertiesToAdd = call.argument("properties");
                    addProperty(propertyToAdd, propertiesToAdd);
                    result.success(null);
                    break;
                case "removeProperty":
                    String propertyToRemove = call.argument("property");
                    Object propertiesToRemove = call.argument("properties");
                    removeProperty(propertyToRemove, propertiesToRemove);
                    result.success(null);
                    break;
                case "setProperty":
                    String propertyToSet = call.argument("property");
                    Object propertiesToSet = call.argument("properties");
                    setProperty(propertyToSet, propertiesToSet);
                    result.success(null);
                    break;
                case "unsetProperty":
                    String property = call.argument("property");
                    unsetProperty(property);
                    result.success(null);
                    break;
                case "putProperties":
                    Map<String, Object> propertiesToPut = call.argument("properties");
                    putProperties(propertiesToPut);
                    result.success(null);
                    break;
                case "getProperties":
                    result.success(getProperties());
                    break;
                case "setCountry":
                    String country = call.argument("country");
                    setCountry(country);
                    result.success(null);
                    break;
                case "getCountry":
                    result.success(getCountry());
                    break;
                case "setCurrency":
                    String currency = call.argument("currency");
                    setCurrency(currency);
                    result.success(null);
                    break;
                case "getCurrency":
                    result.success(getCurrency());
                    break;
                case "setLocale":
                    String locale = call.argument("locale");
                    setLocale(locale);
                    result.success(null);
                    break;
                case "getLocale":
                    result.success(getLocale());
                    break;
                case "setTimeZone":
                    String timeZone = call.argument("timeZone");
                    setTimeZone(timeZone);
                    result.success(null);
                    break;
                case "getTimeZone":
                    result.success(getTimeZone());
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
                case "getDeviceId":
                    result.success(getDeviceId());
                    break;
                case "getAccessToken":
                    result.success(getAccessToken());
                    break;
                case "getUserConsent":
                    result.success(getUserConsent());
                    break;
                case "getPushToken":
                    result.success(getPushToken());
                    break;
                case "setRequiresUserConsent":
                    boolean isRequiresUserConsent = call.argument("isConsent");
                    setRequiresUserConsent(isRequiresUserConsent);
                    result.success(null);
                    break;
                case "setUserConsent":
                    boolean userConsent = call.argument("isConsent");
                    setUserConsent(userConsent);
                    result.success(null);
                    break;
                case "disableGeolocation":
                    disableGeolocation();
                    result.success(null);
                    break;
                case "enableGeolocation":
                    enableGeolocation();
                    result.success(null);
                    break;
                case "setGeolocation":
                    double lat = call.argument("lat");
                    double lon = call.argument("lon");
                    setGeolocation(lat, lon);
                    result.success(null);
                    break;
                case "clearEventsHistory":
                    clearEventsHistory();
                    result.success(null);
                    break;
                case "clearPreferences":
                    clearPreferences();
                    result.success(null);
                    break;
                case "clearAllData":
                    clearAllData();
                    result.success(null);
                    break;
                case "downloadAllData":
                    downloadAllData();
                    result.success(null);
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
            result.error("0", e.getLocalizedMessage(), null);
        }
    }

    // Subscribing users

    public void subscribeToNotifications(boolean fallbackToSettings) {
        WonderPush.subscribeToNotifications(fallbackToSettings);
    }

    public void unsubscribeFromNotifications() {
        WonderPush.unsubscribeFromNotifications();
    }

    public boolean isSubscribedToNotifications() {
        boolean status = WonderPush.isSubscribedToNotifications();
        return status;
    }

    // Segmentation

    public void trackEvent(String type, Map<String, Object> properties) throws JSONException {
        if (properties != null) {
            JSONObject jsonObject = toJsonObject(properties);
            WonderPush.trackEvent(type, jsonObject);
        } else {
            WonderPush.trackEvent(type);
        }
    }

    public void addTag(ArrayList tags) {
        String[] arrTags = new String[tags.size()];
        for (int i = 0; i < tags.size(); i++) {
            if (tags.get(i) instanceof String) {
                arrTags[i] = (String) tags.get(i);
            }
        }
        WonderPush.addTag(arrTags);
    }

    public void removeTag(ArrayList tags) {
        String[] arrTags = new String[tags.size()];
        for (int i = 0; i < tags.size(); i++) {
            if (tags.get(i) instanceof String) {
                arrTags[i] = (String) tags.get(i);
            }
        }
        WonderPush.removeTag(arrTags);
    }

    public void removeAllTags() {
        WonderPush.removeAllTags();
    }

    public boolean hasTag(String tag) {
        boolean status = WonderPush.hasTag(tag);
        return status;
    }

    public ArrayList getTags() {
        Set<String> tags = WonderPush.getTags();
        ArrayList<String> list = new ArrayList<>();
        for (String tag : tags)
            list.add(tag);
        return list;
    }

    public void addProperty(String property, Object properties) throws JSONException {
        WonderPush.addProperty(property, properties);
    }

    public void removeProperty(String property, Object properties) throws JSONException {
        WonderPush.removeProperty(property, properties);
    }

    public void setProperty(String property, Object properties) throws JSONException {
        WonderPush.setProperty(property, properties);
    }

    public void unsetProperty(String property) {
        WonderPush.unsetProperty(property);
    }

    public void putProperties(Map<String, Object> properties) throws JSONException {
        JSONObject jsonObject = toJsonObject(properties);
        WonderPush.putProperties(jsonObject);
    }

    public Object getPropertyValue(String property) throws JSONException {
        Object value = WonderPush.getPropertyValue(property);
        if (value instanceof JSONObject) {
            return (jsonToMap((JSONObject) value));
        } else if (value instanceof JSONArray) {
            return (jsonToList((JSONArray) value));
        } else if (value == null || value == JSONObject.NULL) {
            return null;
        } else {
            return value;
        }
    }

    public List getPropertyValues(String property) throws JSONException {
        List<Object> values = WonderPush.getPropertyValues(property);
        List<Object> properties = WonderPush.getPropertyValues(property);
        for (Object obj : values) {
            if (obj instanceof JSONObject) {
                properties.add(jsonToMap((JSONObject) obj));
            } else if (obj instanceof JSONArray) {
                properties.add(jsonToList((JSONArray) obj));
            } else if (obj == null || obj == JSONObject.NULL) {
                properties.add(obj);
            } else {
                properties.add(obj);
            }
        }
        return properties;
    }

    public Map getProperties() throws JSONException {
        JSONObject jsonObject = WonderPush.getProperties();
        Map map = jsonToMap(jsonObject);
        return map;
    }

    public String getCountry() {
        String country = WonderPush.getCountry();
        return country;
    }

    public void setCountry(String country) {
        WonderPush.setCountry(country);
    }

    public String getCurrency() {
        String currency = WonderPush.getCurrency();
        return currency;
    }

    public void setCurrency(String currency) {
        WonderPush.setCurrency(currency);
    }

    public String getLocale() {
        String locale = WonderPush.getLocale();
        return locale;
    }

    public void setLocale(String locale) {
        WonderPush.setLocale(locale);
    }

    public String getTimeZone() {
        String timeZone = WonderPush.getTimeZone();
        return timeZone;
    }

    public void setTimeZone(String timeZone) {
        WonderPush.setTimeZone(timeZone);
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

    public String getDeviceId() {
        String deviceId = WonderPush.getDeviceId();
        return deviceId;
    }

    public String getAccessToken() {
        String accessToken = WonderPush.getAccessToken();
        return accessToken;
    }

    public boolean getUserConsent() {
        boolean userConsent = WonderPush.getUserConsent();
        return userConsent;
    }

    public String getPushToken() {
        String pushToken = WonderPush.getPushToken();
        return pushToken;
    }

    // Privacy

    public void setRequiresUserConsent(Boolean isConsent) {
        WonderPush.setRequiresUserConsent(isConsent);
    }

    public void setUserConsent(Boolean isConsent) {
        WonderPush.setUserConsent(isConsent);
    }

    public void disableGeolocation() {
        WonderPush.disableGeolocation();
    }

    public void enableGeolocation() {
        WonderPush.enableGeolocation();
    }

    public void setGeolocation(double lat, double lon) {
        Location location = new Location("");
        location.setLatitude(lat);
        location.setLongitude(lon);
        WonderPush.setGeolocation(location);
    }

    public void clearEventsHistory() {
        WonderPush.clearEventsHistory();
    }

    public void clearPreferences() {
        WonderPush.clearPreferences();
    }

    public void clearAllData() {
        WonderPush.clearAllData();
    }

    public void downloadAllData() {
        WonderPush.downloadAllData();
    }
    // Debug

    public void setLogging(boolean enable) {
        WonderPush.setLogging(enable);
    }


    // Custom methods

    private static List<Object> jsonToList(JSONArray jsonArray) throws JSONException {
        List<Object> list = new ArrayList<>();
        for (int i = 0; i < jsonArray.length(); i++) {
            Object value = jsonArray.get(i);
            if (value instanceof JSONObject) {
                list.add(jsonToMap((JSONObject) value));
            } else if (value instanceof JSONArray) {
                list.add(jsonToList((JSONArray) value));
            } else if (value == JSONObject.NULL) {
                list.add(null);
            } else {
                list.add(value);
            }
        }
        return list;
    }

    private static Map<String, Object> jsonToMap(JSONObject jsonObject) throws JSONException {
        Map<String, Object> map = new HashMap<>();
        Iterator iterator = jsonObject.keys();
        while (iterator.hasNext()) {
            String key = (String) iterator.next();
            Object value = jsonObject.get(key);
            if (value instanceof JSONObject) {
                map.put(key, jsonToMap((JSONObject) value));
            } else if (value instanceof JSONArray) {
                map.put(key, jsonToList((JSONArray) value));
            } else if (value == null || value == JSONObject.NULL) {
                map.put(key, null);
            } else {
                map.put(key, value);
            }
        }
        return map;
    }

    @SuppressWarnings("unchecked")
    private JSONObject toJsonObject(Map<String, Object> map) throws JSONException {
        JSONObject object = new JSONObject();
        Iterator<String> iter = map.keySet().iterator();
        while (iter.hasNext()) {
            String key = iter.next();
            Object value = map.get(key);
            if (value instanceof Map) {
                object.put(key, toJsonObject((Map<String, Object>) value));
            } else if (value instanceof List) {
                object.put(key, toJsonArray((List<Object>) value));
            } else if (value == null || value == JSONObject.NULL) {
                object.put(key, JSONObject.NULL);
            } else {
                object.put(key, value);
            }
        }
        return object;
    }

    @SuppressWarnings("unchecked")
    private JSONArray toJsonArray(List<Object> list) throws JSONException {
        JSONArray array = new JSONArray();
        for (int idx = 0; idx < list.size(); idx++) {
            Object value = list.get(idx);
            if (value instanceof Map) {
                array.put(toJsonObject((Map<String, Object>) value));
            } else if (value instanceof List) {
                array.put(toJsonArray((List<Object>) value));
            } else if (value == null || value == JSONObject.NULL) {
                array.put(JSONObject.NULL);
            } else {
                array.put(value);
            }
        }
        return array;
    }

}

