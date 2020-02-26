package com.wonderpush.sdk.wonderpush_flutter_plugin;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import com.wonderpush.sdk.WonderPush;
import com.wonderpush.sdk.wonderpush_flutter_plugin.broadcastreceivers.MainBroadCastReceiver;

import androidx.localbroadcastmanager.content.LocalBroadcastManager;


public class WonderPushInstance {
    private static final WonderPushInstance ourInstance = new WonderPushInstance();
    private Context context;

   public static WonderPushInstance getInstance() {
        return ourInstance;
    }

    private WonderPushInstance() {
    }

   public void setupWonderPush(Context ctx, String clientId,String clientSecret){
       context=ctx;
       WonderPush.initialize(context,clientId,clientSecret);
       if (!WonderPush.isReady()) {

           LocalBroadcastManager.getInstance(context).registerReceiver(new MainBroadCastReceiver(),new IntentFilter(WonderPush.INTENT_INTIALIZED));

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

}
