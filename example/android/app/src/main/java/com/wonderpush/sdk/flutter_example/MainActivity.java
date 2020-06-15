package com.wonderpush.sdk.flutter_example;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;
import com.wonderpush.sdk.flutter.WonderPushPlugin;

import android.os.Bundle;
import android.os.Handler;
import android.os.PersistableBundle;
import android.widget.Toast;

public class MainActivity extends FlutterActivity {
  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);
  }
}
