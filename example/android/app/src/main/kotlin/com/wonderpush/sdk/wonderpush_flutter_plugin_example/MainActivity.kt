package com.wonderpush.sdk.wonderpush_flutter_plugin_example

import androidx.annotation.NonNull;
import com.wonderpush.sdk.wonderpush_flutter_plugin.WPFirebaseMessagingService
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }
}
