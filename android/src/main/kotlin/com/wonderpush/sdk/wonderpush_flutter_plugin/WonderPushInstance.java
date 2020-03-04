package com.wonderpush.sdk.wonderpush_flutter_plugin;
import android.content.BroadcastReceiver;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.os.Bundle;
import com.wonderpush.sdk.WonderPush;
import com.wonderpush.sdk.WonderPushChannel;
import com.wonderpush.sdk.WonderPushUserPreferences;
import com.wonderpush.sdk.wonderpush_flutter_plugin.broadcastreceivers.ButtonActionBroadCastReceiver;
import com.wonderpush.sdk.wonderpush_flutter_plugin.broadcastreceivers.MainBroadCastReceiver;

import androidx.core.app.NotificationManagerCompat;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;
import org.json.JSONArray;
import java.util.LinkedList;
import java.util.List;


public class WonderPushInstance {
    private static final WonderPushInstance ourInstance = new WonderPushInstance();
    public static final MainBroadCastReceiver mainBroadCastReceiver= new MainBroadCastReceiver();
    public static final ButtonActionBroadCastReceiver buttonActionBroadCastReceiver= new ButtonActionBroadCastReceiver();
    private Context context;
    public static final String TAG = "WonderPushFlutter";

   public static WonderPushInstance getInstance() {
        return ourInstance;
    }

    private WonderPushInstance() {

    }

   public void setupWonderPush(Context ctx, String clientId,String clientSecret){
       context=ctx;
        WonderPush.setRequiresUserConsent(false);
       WonderPush.initialize(context,clientId,clientSecret);
       if (!WonderPush.isReady()) {
           IntentFilter intentFilter= new IntentFilter();
           intentFilter.addAction(WPFirebaseMessagingService.ACTION_TOKEN);
           intentFilter.addAction(WPFirebaseMessagingService.ACTION_REMOTE_MESSAGE);
           LocalBroadcastManager.getInstance(context).registerReceiver(mainBroadCastReceiver,intentFilter);
           IntentFilter registeredMethodIntentFilter = new IntentFilter();
           registeredMethodIntentFilter.addAction(WPFirebaseMessagingService.ACTION_TOKEN);
           registeredMethodIntentFilter.addAction(WPFirebaseMessagingService.ACTION_REMOTE_MESSAGE);
           registeredMethodIntentFilter.addAction(WonderPush.INTENT_NOTIFICATION_BUTTON_ACTION_METHOD_ACTION);
           registeredMethodIntentFilter.addDataScheme(WonderPush.INTENT_NOTIFICATION_BUTTON_ACTION_METHOD_SCHEME);
           registeredMethodIntentFilter.addDataAuthority(WonderPush.INTENT_NOTIFICATION_BUTTON_ACTION_METHOD_AUTHORITY, null);
           LocalBroadcastManager.getInstance(context).registerReceiver(buttonActionBroadCastReceiver,registeredMethodIntentFilter);
           //extraSetUp();

       }
//       IntentFilter intentFilter= new IntentFilter(WonderPush.INTENT_INTIALIZED);
//       intentFilter.addAction(WPFirebaseMessagingService.ACTION_TOKEN);
//       intentFilter.addAction(WPFirebaseMessagingService.ACTION_REMOTE_MESSAGE);
//       LocalBroadcastManager.getInstance(context).registerReceiver(mainBroadCastReceiver,intentFilter);
//
//       System.out.println("Wonderpush is ready");
    }

    public void subscribeToEvent(String eventType){
        WonderPush.trackEvent(eventType, null);
    }

    void unSubscribeFromEvent(String eventType){
        WonderPush.removeTag();
    }


    public void updateTags(Object value,String action){
        try{
            String[] tags = null;
            // can be a string or an array of strings
            if (value instanceof JSONArray) {
                JSONArray argTags = (JSONArray) value;
                List<String> tagsList = new LinkedList<>();
                for (int i = 0; i < argTags.length(); ++i) {
                    Object v = argTags.get(i);
                    if (v instanceof String) {
                        tagsList.add((String) v);
                    }
                }
                tags = tagsList.toArray(new String[]{});
            } else if (value instanceof String) {
                tags = new String[]{(String) value};
            }
            if (tags != null) {
                if (action.equals("addTag")) {
                    WonderPush.addTag(tags);
                } else {
                    WonderPush.removeTag(tags);
                }
            }

        }catch (Exception e){
            e.printStackTrace();
        }

    }


    void extraSetUp(){

      

        WonderPushUserPreferences.setDefaultChannelId("default");
        if (WonderPushUserPreferences.getChannel("default") == null) {
            // The wrapping if serves to not modify existing preferences (as we don't store them elsewhere)
            // Note: We mainly create the channel to ensure its existence for the PreferenceActivity
            WonderPushUserPreferences.putChannel(
                    new WonderPushChannel("default", null)
                            .setName("Default")
                            .setDescription("Miscellaneous notifications.")
            );
        }
        // Here we declare a new channel
        // On Android O this would create it once and leave it unchanged (except for name and description)
        // On Android pre O, this would reset the user preferences stored in WonderPush
        WonderPushUserPreferences.putChannel(
                new WonderPushChannel("important", null)
                        .setName("Important")
                        .setDescription("Important notifications you should not overlook.")
                        .setImportance(NotificationManagerCompat.IMPORTANCE_MAX)
                        .setColor(Color.RED)
                        .setLights(true)
                        .setLightColor(Color.RED)
                        .setSound(true)
//                        .setSoundUri(new Uri.Builder()
//                                .scheme(ContentResolver.SCHEME_ANDROID_RESOURCE)
//                                .authority(getPackageName())
////                                .path(String.valueOf(R.raw.sound))
//                                .build())
                        .setVibrate(true)
                        .setVibrateInSilentMode(true)
                        .setVibrationPattern(new long[]{200, 50, 200, 50, 200})
        );


    }


}
