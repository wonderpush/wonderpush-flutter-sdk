package com.wonderpush.sdk.flutter;
import static com.wonderpush.sdk.flutter.WonderPushPlugin.TAG;

import io.flutter.FlutterInjector;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.FlutterEngineGroup;
import io.flutter.embedding.engine.FlutterEngineGroupCache;
import io.flutter.embedding.engine.loader.FlutterLoader;

import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;

import io.flutter.embedding.engine.dart.DartExecutor;

import io.flutter.plugin.common.MethodChannel;

import android.util.Log;

import com.wonderpush.sdk.DeepLinkEvent;
import com.wonderpush.sdk.WonderPushDelegate;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CountDownLatch;

public class Delegate implements WonderPushDelegate {

    private Context context;
    private String dartEntryPointFunctionName;
    private final List<WonderPushPlugin.FlutterCallback> pendingFlutterCallbacks = new ArrayList<>();
    public static final String DART_ENTRY_POINT_FUNCTION_NAME_METADATA = "com.wonderpush.sdk.dartEntryPointFunctionName";

    @Override
    public void setContext(Context context) {
        Log.d(TAG, "Delegate.setContext()");
        this.context = context.getApplicationContext();
        try {
            Bundle metaData = this.context.getPackageManager().getApplicationInfo(context.getPackageName(), PackageManager.GET_META_DATA).metaData;
            this.dartEntryPointFunctionName = metaData != null ? metaData.getString(DART_ENTRY_POINT_FUNCTION_NAME_METADATA) : null;
        } catch (PackageManager.NameNotFoundException e) {
            Log.w(TAG, "Could not get dart entry point function name, listening to notifications received while the app is not running won't work.", e);
        }

    }

    public boolean canStartFlutterEngine() {
        return this.dartEntryPointFunctionName != null;
    }

    private void startFlutterEngine() {

        if (this.dartEntryPointFunctionName == null) {
            Log.d(TAG, "startFlutterEngine no entry point specified, skipping.");
            return;
        }

        Log.d(TAG, "startFlutterEngine");

        final String entryPointFunctionName = this.dartEntryPointFunctionName;
        Runnable init = () -> {
            Log.d(TAG, "Starting flutter engine with entry point [" + entryPointFunctionName + "]");
            FlutterEngineGroup group = new FlutterEngineGroup(context);
            FlutterLoader flutterLoader = FlutterInjector.instance().flutterLoader();
            DartExecutor.DartEntrypoint entrypoint = new DartExecutor.DartEntrypoint(flutterLoader.findAppBundlePath(), dartEntryPointFunctionName);
            group.createAndRunEngine(context, entrypoint);
        };

        // Run init synchronously on main thread
        if (Looper.myLooper() != Looper.getMainLooper()) {
            final CountDownLatch latch = new CountDownLatch(1);
            new Handler(Looper.getMainLooper()).post(() -> {
                init.run();
                latch.countDown();
            });
            try {
                latch.await();  // Current thread waits here until latch count is zero
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        } else {
            init.run();
        }

    }

    @Override
    public String urlForDeepLink(DeepLinkEvent event) {
        return event.getUrl();
    }

    @Override
    public void onNotificationOpened(JSONObject notif, int buttonIndex) {

        Log.d(TAG, "onNotificationOpened " + notif.toString());

        final List<Object> arguments = new ArrayList<>();
        arguments.add(notif.toString());
        arguments.add(buttonIndex);

        String method = "onNotificationOpened";

        if (!WonderPushPlugin.isReadyToAcceptCallbacks()) {
            Log.d(TAG, "Notification opened while flutter not ready or event channel not yet setup. Keeping for later.");
            savePendingCallback(method, arguments);
            return;
        }

        new Handler(Looper.getMainLooper()).post(() -> {
            Log.d(TAG, "onNotificationOpened");
            WonderPushPlugin.getInstance().executeCallback(new WonderPushPlugin.FlutterCallback(method, arguments));
        });

    }

    @Override
    public void onNotificationReceived(JSONObject notif) {

        Log.d(TAG, "onNotificationReceived " + notif.toString());
        if (!WonderPushPlugin.isFlutterStarted() && canStartFlutterEngine()) {
            startFlutterEngine();
        }

        final String method = "onNotificationReceived";
        final String arguments = notif.toString();

        if (!WonderPushPlugin.isReadyToAcceptCallbacks()) {
            if (canStartFlutterEngine()) {
                Log.d(TAG, "Notification received while plugin not ready to accept callbacks, saving for later");
                savePendingCallback(method, arguments);
            } else {
                Log.d(TAG, "Notification received while plugin not ready to accept callbacks, dropping");
            }
            return;
        }

        new Handler(Looper.getMainLooper()).post(() -> {
            WonderPushPlugin.getInstance().executeCallback(new WonderPushPlugin.FlutterCallback(method, arguments));
        });

    }

    /**
     * If any call to the event channel has been withheld because flutter wasn't ready, fire them now.
     */
    public void drainPendingFlutterCallbacks() {
        Log.d(TAG, "drainPendingFlutterCallbacks");
        new Handler(Looper.getMainLooper()).post(this::executePendingCallbacks);
    }

    private synchronized void savePendingCallback(String method, Object arguments) {
        Log.d(TAG, "savePendingCallback [" + method + "]");
        pendingFlutterCallbacks.add(new WonderPushPlugin.FlutterCallback(method, arguments));
    }

    private synchronized void executePendingCallbacks() {
        Log.d(TAG, "executePendingCallbacks");
        if (!WonderPushPlugin.isReadyToAcceptCallbacks()) {
            Log.w(TAG, "Trying to execute callbacks when WonderPushPlugin not ready");
            return;
        }
        for (WonderPushPlugin.FlutterCallback callback : pendingFlutterCallbacks) {
            Log.d(TAG, "executePendingCallbacks [" + callback.method + "]");
            WonderPushPlugin.getInstance().executeCallback(callback);
        }
        pendingFlutterCallbacks.clear();
    }
}
