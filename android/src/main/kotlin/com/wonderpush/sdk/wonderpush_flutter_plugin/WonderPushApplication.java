package com.wonderpush.sdk.wonderpush_flutter_plugin;

import android.content.BroadcastReceiver;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Color;
import android.net.Uri;
import android.os.PatternMatcher;
import android.widget.Toast;

import androidx.core.app.NotificationManagerCompat;
import androidx.localbroadcastmanager.content.LocalBroadcastManager;

import com.wonderpush.sdk.DeepLinkEvent;
import com.wonderpush.sdk.WonderPush;
import com.wonderpush.sdk.WonderPushAbstractDelegate;
import com.wonderpush.sdk.WonderPushChannel;
import com.wonderpush.sdk.WonderPushUserPreferences;

import io.flutter.Log;
import io.flutter.app.FlutterApplication;

public class WonderPushApplication extends FlutterApplication {
    private final String SHARED_PREF_FILE = "wonderpushdemo";
    private final String SHARED_PREF_KEY_REQUIRES_USER_CONSENT = "requiresUserConsent";
    private final boolean SHARED_PREF_DEFAULT_REQUIRES_USER_CONSENT = true;

    private static WonderPushApplication singleton = null;

    public static WonderPushApplication getInstance() {
        return singleton;
    }

    public WonderPushApplication() {
        singleton = this;
    }

    public boolean getRequiresUserConsent() {
        return this.getSharedPreferences(SHARED_PREF_FILE, 0)
                .getBoolean(SHARED_PREF_KEY_REQUIRES_USER_CONSENT, SHARED_PREF_DEFAULT_REQUIRES_USER_CONSENT);
    }

    public void setRequiresUserConsent(boolean value) {
        this.getSharedPreferences(SHARED_PREF_FILE, 0)
                .edit()
                .putBoolean(SHARED_PREF_KEY_REQUIRES_USER_CONSENT, value)
                .apply();
    }

    @Override
    public void onCreate() {
        super.onCreate();

        LocalBroadcastManager.getInstance(this).registerReceiver(new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                String oldPushToken = intent.getStringExtra(WonderPush.INTENT_PUSH_TOKEN_CHANGED_EXTRA_OLD_KNOWN_PUSH_TOKEN);
                String pushToken = intent.getStringExtra(WonderPush.INTENT_PUSH_TOKEN_CHANGED_EXTRA_PUSH_TOKEN);
                Toast.makeText(getApplicationContext(), "TOKEN CHANGED from " + oldPushToken + " to " + pushToken, Toast.LENGTH_LONG).show();
            }
        }, new IntentFilter(WonderPush.INTENT_PUSH_TOKEN_CHANGED));
        // Inform of INTENT_NOTIFICATION_OPENED intents
        LocalBroadcastManager.getInstance(this).registerReceiver(new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                Toast.makeText(getApplicationContext(), "RECEIVED PUSH: " + String.valueOf(intent), Toast.LENGTH_LONG).show();
            }
        }, new IntentFilter(WonderPush.INTENT_NOTIFICATION_OPENED));

        // Example deeplink handles by application logic
        LocalBroadcastManager.getInstance(this).registerReceiver(new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                if (!WonderPush.INTENT_NOTIFICATION_WILL_OPEN_EXTRA_NOTIFICATION_TYPE_DATA.equals(
                        intent.getStringExtra(WonderPush.INTENT_NOTIFICATION_WILL_OPEN_EXTRA_NOTIFICATION_TYPE))) {
                    Toast.makeText(getApplicationContext(), "Deeplink resolved programmatically", Toast.LENGTH_SHORT).show();
//                    Intent openIntent = new Intent();
//                    openIntent.setClass(context, NavigationActivity.class);
//                    openIntent.fillIn(intent, 0);
//                    openIntent.putExtra("resolvedProgrammatically", true);
//                    TaskStackBuilder stackBuilder = TaskStackBuilder.create(context);
//                    stackBuilder.addNextIntentWithParentStack(openIntent);
//                    stackBuilder.startActivities();
                }
            }
        }, new IntentFilter(WonderPush.INTENT_NOTIFICATION_WILL_OPEN));

        // Example data notification handled by application logic
        LocalBroadcastManager.getInstance(this).registerReceiver(new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                if (WonderPush.INTENT_NOTIFICATION_WILL_OPEN_EXTRA_NOTIFICATION_TYPE_DATA.equals(
                        intent.getStringExtra(WonderPush.INTENT_NOTIFICATION_WILL_OPEN_EXTRA_NOTIFICATION_TYPE))) {
                    Toast.makeText(getApplicationContext(), "Data notification received for " + getPackageManager().getApplicationLabel(getApplicationInfo()), Toast.LENGTH_SHORT).show();

                    // If you want to manually display a notification in response to a data notification, do the following
                    Intent pushNotif = intent.getParcelableExtra(WonderPush.INTENT_NOTIFICATION_WILL_OPEN_EXTRA_RECEIVED_PUSH_NOTIFICATION);
                    String message = pushNotif.getStringExtra("manual_display_message");
                    if (message != null) {
//                        Toast.makeText(getApplicationContext(), "Building notification manually", Toast.LENGTH_SHORT).show();
//                        Intent openIntent = new Intent(context, NavigationActivity.class);
//                        // Copy the push notification payload
//                        openIntent.putExtras(pushNotif);
//                        // Copy the local intent extras so that the WonderPush SDK can track the click
//                        openIntent.putExtras(intent);
//                        PendingIntent pendingIntent = PendingIntent.getActivity(getApplicationContext(), 0, openIntent, PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_ONE_SHOT);
//
//                        NotificationCompat.Builder builder = new NotificationCompat.Builder(getApplicationContext(), "default")
//                                .setAutoCancel(true)
//                                .setSmallIcon(R.drawable.notification_icon)
//                                .setContentTitle(getPackageManager().getApplicationLabel(getApplicationInfo()) + " manual data notif")
//                                .setContentText(message)
//                                .setStyle(new NotificationCompat.BigTextStyle()
//                                        .bigText(message))
//                                .setContentIntent(pendingIntent);
//                        android.app.NotificationManager mNotificationManager = (android.app.NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
//                        mNotificationManager.notify(null, new Random().nextInt(), builder.build());
                    }

                }
            }
        }, new IntentFilter(WonderPush.INTENT_NOTIFICATION_WILL_OPEN));

        // Example notification button action `method` receiver
        IntentFilter exampleMethodIntentFilter = new IntentFilter();
        exampleMethodIntentFilter.addAction(WonderPush.INTENT_NOTIFICATION_BUTTON_ACTION_METHOD_ACTION);
        exampleMethodIntentFilter.addDataScheme(WonderPush.INTENT_NOTIFICATION_BUTTON_ACTION_METHOD_SCHEME);
        exampleMethodIntentFilter.addDataAuthority(WonderPush.INTENT_NOTIFICATION_BUTTON_ACTION_METHOD_AUTHORITY, null);
        exampleMethodIntentFilter.addDataPath("/example", PatternMatcher.PATTERN_LITERAL); // Note: prepend a / to the actual method name
        LocalBroadcastManager.getInstance(this).registerReceiver(new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                String arg = intent.getStringExtra(WonderPush.INTENT_NOTIFICATION_BUTTON_ACTION_METHOD_EXTRA_ARG);
                Toast.makeText(context, "Example method successfully called with arg: " + arg,  Toast.LENGTH_LONG).show();
            }
        }, exampleMethodIntentFilter);

        // Catch-all notification button action `method` receiver, to show the user that a method was called
        IntentFilter catchallMethodIntentFilter = new IntentFilter();
        catchallMethodIntentFilter.addAction(WonderPush.INTENT_NOTIFICATION_BUTTON_ACTION_METHOD_ACTION);
        catchallMethodIntentFilter.addDataScheme(WonderPush.INTENT_NOTIFICATION_BUTTON_ACTION_METHOD_SCHEME);
        catchallMethodIntentFilter.addDataAuthority(WonderPush.INTENT_NOTIFICATION_BUTTON_ACTION_METHOD_AUTHORITY, null);
        LocalBroadcastManager.getInstance(this).registerReceiver(new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                String method = intent.getStringExtra(WonderPush.INTENT_NOTIFICATION_BUTTON_ACTION_METHOD_EXTRA_METHOD);
                if ("example".equals(method)) {
                    // The above receiver already took care of the "example" method
                    return;
                }
                String arg = intent.getStringExtra(WonderPush.INTENT_NOTIFICATION_BUTTON_ACTION_METHOD_EXTRA_ARG);
                Toast.makeText(context, "Method " + method + " called with arg: " + arg, Toast.LENGTH_LONG).show();
            }
        }, catchallMethodIntentFilter);

        WonderPush.setDelegate(new WonderPushAbstractDelegate() {
            @Override
            public String urlForDeepLink(DeepLinkEvent event) {
                Log.d("WonderPushDemo", "handleNotificationOpenTargetUrl(" + event + ")");
                Uri uri = Uri.parse(event.getUrl());
                if ("toast".equals(uri.getScheme())) {
                    // Let's handle toast: URLs with a toast, and no activity
                    Toast.makeText(getApplicationContext(), "Handled deep-link: " + event.getUrl(), Toast.LENGTH_LONG).show();
                    return null;
                }
                return super.urlForDeepLink(event);
            }
        });

        // Note that we set this to true in the BuildConfig to possibly set it to false now, which is a valid pattern
        WonderPush.setRequiresUserConsent(this.getRequiresUserConsent());

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
                        .setSoundUri(new Uri.Builder()
                                .scheme(ContentResolver.SCHEME_ANDROID_RESOURCE)
                                .authority(getPackageName())
                                //.path(String.valueOf(R.raw.sound))
                                .build())
                        .setVibrate(true)
                        .setVibrateInSilentMode(true)
                        .setVibrationPattern(new long[]{200, 50, 200, 50, 200})
        );
    }

}
