package com.wonderpush.sdk.wonderpush_flutter_plugin_example;

import android.content.Context;

import androidx.multidex.MultiDex;

import com.wonderpush.sdk.wonderpush_flutter_plugin.WonderpushFlutterPlugin;

import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;

import io.flutter.app.FlutterApplication;

import io.flutter.plugins.GeneratedPluginRegistrant;

public class MyApp extends FlutterApplication implements PluginRegistrantCallback {

    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        MultiDex.install(this);
    }

    @Override
    public void onCreate() {
        super.onCreate();
        WonderpushFlutterPlugin.initialize(this);

    }

    @Override
    public void registerWith(PluginRegistry registry) {
        WonderpushFlutterPlugin.registerWith(registry);
    }
}
