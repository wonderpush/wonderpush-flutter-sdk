package com.wonderpush.sdk.flutter;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import android.location.Location;
import com.wonderpush.sdk.WonderPush;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Set;

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
               case "unsetProperty":
                    String property = call.argument("property");
                    unsetProperty(property);
                    result.success(null);
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
                    setGeolocation(lat,lon);
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
            result.error("0", e.getLocalizedMessage(), e);
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

    public void addTag(ArrayList tags){
        String[] arrTags = new String[tags.size()];
        for (int i = 0; i < tags.size(); i++) {
            if(tags.get(i) instanceof String) {
                arrTags[i] = (String) tags.get(i);
            }
        }
        WonderPush.addTag(arrTags);
    }

    public void removeTag(ArrayList tags){
        String[] arrTags = new String[tags.size()];
        for (int i = 0; i < tags.size(); i++) {
            if(tags.get(i) instanceof String) {
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

    public ArrayList getTags(){
        Set<String> tags = WonderPush.getTags();
        ArrayList<String> list = new ArrayList<>();
        for (String tag : tags)
            list.add(tag);
        return list;
    }

    public void unsetProperty(String property) {
        WonderPush.unsetProperty(property);
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
        Location location = new Location("WonderPush");
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
}

