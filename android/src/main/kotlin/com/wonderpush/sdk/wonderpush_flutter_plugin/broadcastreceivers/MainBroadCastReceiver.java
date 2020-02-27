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

public class MainBroadCastReceiver extends BroadcastReceiver {


    private static INotificationReceiver iNotificationReceiver;

    @Override
    public void onReceive(Context context, Intent intent) {

        Intent pushNotif = intent.getParcelableExtra(WonderPush.INTENT_NOTIFICATION_WILL_OPEN_EXTRA_RECEIVED_PUSH_NOTIFICATION);
        Bundle extras = pushNotif == null ? null : pushNotif.getExtras();
        if (extras == null || extras.isEmpty()) {
            return;
        }

        JSONObject notification = new JSONObject();
        for (String key : extras.keySet()) {
            try {
                Object value = extras.get(key);
                if (value instanceof String) {
                    String valueStr = (String) value;
                    if (valueStr.charAt(0) == '{' && valueStr.charAt(valueStr.length() - 1) == '}') {
                        try {
                            value = new JSONObject(valueStr);
                        } catch (JSONException ex) {
                            Log.d("WonderPush", "Tried to parse a seemingly JSON value for notification field " + key + " with value " + valueStr, ex);
                        }
                    }
                }
                notification.putOpt(key, JSONUtil.wrap(value));
            } catch (JSONException ex) {
                Log.e("WonderPush", "Unexpected error while transforming received notification intent to JSON for property " + key + " of value " + extras.get(key), ex);
            }
        }

        JSONObject event = new JSONObject();
        try {
            event.put("type", "notificationOpen");
            event.put("notification", notification);
            event.put("notificationType", intent.getStringExtra(WonderPush.INTENT_NOTIFICATION_WILL_OPEN_EXTRA_NOTIFICATION_TYPE));
        } catch (JSONException ex) {
            Log.e("WonderPush", "Unexpected error while creating notificationOpen event", ex);
            return;
        }

        iNotificationReceiver.sendNotificationData(event);
    }

    public void registerCallback(INotificationReceiver iNotificationReceiver) {
        this.iNotificationReceiver = iNotificationReceiver;
    }
}
