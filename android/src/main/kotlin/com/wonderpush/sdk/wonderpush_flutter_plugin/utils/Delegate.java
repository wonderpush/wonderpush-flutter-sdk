//package com.wonderpush.sdk.wonderpush_flutter_plugin.utils;
//
//import android.util.Log;
//
//import com.wonderpush.sdk.DeepLinkEvent;
//import com.wonderpush.sdk.WonderPushDelegate;
//import com.wonderpush.sdk.wonderpush_flutter_plugin.WonderPushInstance;
//import com.wonderpush.sdk.wonderpush_flutter_plugin.WonderpushFlutterPlugin;
//
//import org.json.JSONException;
//import org.json.JSONObject;
//
//import java.util.Map;
//import java.util.UUID;
//import java.util.concurrent.ArrayBlockingQueue;
//import java.util.concurrent.BlockingQueue;
//import java.util.concurrent.ConcurrentHashMap;
//import java.util.concurrent.TimeUnit;
//import java.util.concurrent.TimeoutException;
//import java.util.concurrent.atomic.AtomicReference;
//
//public class Delegate implements WonderPushDelegate {
//
//    private Map<String, BlockingQueue<Object>> jsCallbackWaiters = new ConcurrentHashMap<>();
//
//    @Override
//    public String urlForDeepLink(DeepLinkEvent event) {
//       // CallbackContext delegate = WonderpushFlutterPlugin.this.jsDelegate;
////        if (delegate == null) {
////            return event.getUrl();
////        }
//        String jsCallbackWaiterId = createJsCallbackWaiter();
//        try {
//            JSONObject info = new JSONObject();
//            info.put("method", "urlForDeepLink"); // that's the Android name of this method
//            info.put("__callbackId", jsCallbackWaiterId);
//            info.put("url", event.getUrl());
////            PluginResult call = new PluginResult(PluginResult.Status.OK, info);
////            call.setKeepCallback(true);
////            delegate.sendPluginResult(call);
//        } catch (JSONException ex) {
//            Log.e(WonderPushInstance.TAG, "Unexpected JSONException while calling JavaScript plugin delegate", ex);
//        }
//        AtomicReference<Object> valueRef = waitJsCallback(jsCallbackWaiterId, 3, TimeUnit.SECONDS);
//        Object value = valueRef == null ? null : valueRef.get();
//        if (valueRef != null && value != null && !(value instanceof String)) {
//            Log.e(WonderPushInstance.TAG, "WonderPushDelegate.urlForDeepLink expected a string from JavaScript, got a " + value.getClass().getCanonicalName() + ": " + value, new IllegalArgumentException());
//            valueRef = null;
//            value = null;
//        }
//        if (valueRef != null && (value == null || value instanceof String)) {
//            return (String) value;
//        } else {
//            return event.getUrl();
//        }
//         }
//
//
//    private String createJsCallbackWaiter() {
//        String id = UUID.randomUUID().toString();
//        jsCallbackWaiters.put(id, new ArrayBlockingQueue(1));
//        return id;
//    }
//
//    private AtomicReference<Object> waitJsCallback(String id, long timeout, TimeUnit unit) {
//        if (id == null) {
//            Log.e(WonderPushInstance.TAG, "Cannot wait for JavaScript, callback with a null id", new NullPointerException());
//            return null;
//        }
//        BlockingQueue<Object> queue = jsCallbackWaiters.get(id);
//        if (queue == null) {
//            Log.e(WonderPushInstance.TAG, "Cannot wait for JavaScript, callback does not exist: " + id, new IllegalStateException());
//            return null;
//        }
//        try {
//            Object value = queue.poll(timeout, unit);
//            if (value == null) {
//                Log.w(WonderPushInstance.TAG, "Timed out while waiting for a JavaScript callback: " + id, new TimeoutException());
//                return null;
//            }
//            return new AtomicReference<Object>(value);
//        } catch (InterruptedException ex) {
//            Log.e(WonderPushInstance.TAG, "Interrupted while waiting for a JavaScript callback: " + id, ex);
//            return null;
//        } finally {
//            jsCallbackWaiters.remove(id);
//        }
//    }
//
//
//    private void jsCalledBack(String id, Object value) {
//        if (value == null) value = JSONObject.NULL;
//        BlockingQueue<Object> queue = jsCallbackWaiters.get(id);
//        if (queue == null) {
//            Log.e(WonderPushInstance.TAG, "Cannot record a JavaScript callback, callback does not exist (too late?): " + id, new IllegalStateException());
//            return;
//        }
//        boolean succeeded = queue.offer(value);
//        if (!succeeded) {
//            Log.e(WonderPushInstance.TAG, "Cannot record a JavaScript callback, value already recorded: " + id, new IllegalStateException());
//        }
//    }
//
//}
