package com.wonderpush.sdk.wonderpush_flutter_plugin.broadcastreceivers;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import com.wonderpush.sdk.WonderPush;
import org.json.JSONException;
import org.json.JSONObject;
import io.flutter.plugin.common.JSONUtil;

public class ButtonActionBroadCastReceiver extends BroadcastReceiver {


    private static INotificationReceiver iNotificationReceiver;

    @Override
    public void onReceive(Context context, Intent intent) {

//        String method = intent.getStringExtra(WonderPush.INTENT_NOTIFICATION_BUTTON_ACTION_METHOD_EXTRA_METHOD);
//        String arg = intent.getStringExtra(WonderPush.INTENT_NOTIFICATION_BUTTON_ACTION_METHOD_EXTRA_ARG);
//
//        JSONObject event = new JSONObject();
//        try {
//            event.put("type", "registeredCallback");
//            event.put("method", method);
//            event.put("arg", arg);
//        } catch (JSONException ex) {
//            Log.e("WonderPush", "Unexpected error while creating registeredCallback event", ex);
//            return;
//        }
//
//        iNotificationReceiver.sendNotificationData(event);
    }

    public void registerCallback(INotificationReceiver iNotificationReceiver) {
        this.iNotificationReceiver = iNotificationReceiver;
    }
}
