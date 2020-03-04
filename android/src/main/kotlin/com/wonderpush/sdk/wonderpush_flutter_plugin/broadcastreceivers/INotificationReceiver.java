package com.wonderpush.sdk.wonderpush_flutter_plugin.broadcastreceivers;

import org.json.JSONObject;

import java.util.Map;

public interface INotificationReceiver {
    void sendNotificationData(Map<String, Object> data);
    void sendToken(String token);
}
