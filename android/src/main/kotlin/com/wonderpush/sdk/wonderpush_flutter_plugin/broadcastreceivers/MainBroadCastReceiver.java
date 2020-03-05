//package com.wonderpush.sdk.wonderpush_flutter_plugin.broadcastreceivers;
//
//import android.content.BroadcastReceiver;
//import android.content.Context;
//import android.content.Intent;
//import android.os.Bundle;
//import android.util.Log;
//
//import androidx.annotation.NonNull;
//
//import com.google.firebase.messaging.RemoteMessage;
//import com.wonderpush.sdk.WonderPush;
//import com.wonderpush.sdk.wonderpush_flutter_plugin.WPFirebaseMessagingService;
//
//import org.json.JSONException;
//import org.json.JSONObject;
//
//import java.util.HashMap;
//import java.util.Map;
//
//import io.flutter.plugin.common.JSONUtil;
//import io.flutter.plugin.common.MethodChannel;
//
//public class MainBroadCastReceiver extends BroadcastReceiver {
//
//
//    private static INotificationReceiver iNotificationReceiver;
//    private static  MethodChannel channel;
//
//    public MainBroadCastReceiver(MethodChannel methodChannel){
//        this.channel=methodChannel;
//    }
//
//    @Override
//    public void onReceive(Context context, Intent intent) {
//        String action = intent.getAction();
//        if (action == null) {
//            return;
//        }
//        if (action.equals(WPFirebaseMessagingService.ACTION_TOKEN)) {
//            String token = intent.getStringExtra(WPFirebaseMessagingService.EXTRA_TOKEN);
//            iNotificationReceiver.sendToken(token);
//            channel.invokeMethod("onToken", token);
//        } else if (action.equals(WPFirebaseMessagingService.ACTION_REMOTE_MESSAGE)) {
//            RemoteMessage message =
//                    intent.getParcelableExtra(WPFirebaseMessagingService.EXTRA_REMOTE_MESSAGE);
//            Map<String, Object> content = parseRemoteMessage(message);
//            System.out.println(action);
//            //iNotificationReceiver.sendNotificationData(content);
//            channel.invokeMethod("onMessage", content, new MethodChannel.Result() {
//                @Override
//                public void success(Object o) {
//                   System.out.println(o);
//                    // this will be called with o = "some string"
//                }
//
//                @Override
//                public void error(String s, String s1, Object o) {
//                    System.out.println(s);
//                    System.out.println(s1);
//                    System.out.println(o);
//
//                }
//
//                @Override
//                public void notImplemented() {
//                    System.out.println("No implemented");
//                }
//            });
//        }
//    }
//
//    public void registerCallback(INotificationReceiver iNotificationReceiver) {
//        this.iNotificationReceiver = iNotificationReceiver;
//    }
//
//
//    @NonNull
//    private Map<String, Object> parseRemoteMessage(RemoteMessage message) {
//        Map<String, Object> content = new HashMap<>();
//        content.put("data", message.getData());
//        RemoteMessage.Notification notification = message.getNotification();
//        Map<String, Object> notificationMap = new HashMap<>();
//        String title = notification != null ? notification.getTitle() : null;
//        notificationMap.put("title", title);
//        String body = notification != null ? notification.getBody() : null;
//        notificationMap.put("body", body);
//        content.put("notification", notificationMap);
//        return content;
//    }
//
//}
