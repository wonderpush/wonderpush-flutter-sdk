package com.wonderpush.sdk.wonderpush_flutter_plugin.broadcastreceivers;

import org.json.JSONObject;

public interface INotificationReceiver {
    void sendNotificationData(JSONObject data);
}
