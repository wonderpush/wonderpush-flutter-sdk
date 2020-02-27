package com.wonderpush.sdk.wonderpush_flutter_plugin;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import com.wonderpush.sdk.WonderPush;
import com.wonderpush.sdk.wonderpush_flutter_plugin.broadcastreceivers.ButtonActionBroadCastReceiver;
import com.wonderpush.sdk.wonderpush_flutter_plugin.broadcastreceivers.MainBroadCastReceiver;
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
       WonderPush.initialize(context,clientId,clientSecret);
       if (!WonderPush.isReady()) {
           LocalBroadcastManager.getInstance(context).registerReceiver(mainBroadCastReceiver,new IntentFilter(WonderPush.INTENT_INTIALIZED));
           IntentFilter registeredMethodIntentFilter = new IntentFilter();
           registeredMethodIntentFilter.addAction(WonderPush.INTENT_NOTIFICATION_BUTTON_ACTION_METHOD_ACTION);
           registeredMethodIntentFilter.addDataScheme(WonderPush.INTENT_NOTIFICATION_BUTTON_ACTION_METHOD_SCHEME);
           registeredMethodIntentFilter.addDataAuthority(WonderPush.INTENT_NOTIFICATION_BUTTON_ACTION_METHOD_AUTHORITY, null);
           LocalBroadcastManager.getInstance(context).registerReceiver(buttonActionBroadCastReceiver,registeredMethodIntentFilter);
       }else{
           System.out.println("Wonderpush is ready");
       }
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

}
