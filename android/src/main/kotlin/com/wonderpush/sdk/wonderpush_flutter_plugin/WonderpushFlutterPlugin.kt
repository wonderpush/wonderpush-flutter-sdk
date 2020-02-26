package com.wonderpush.sdk.wonderpush_flutter_plugin

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import io.flutter.plugin.common.BinaryMessenger
import android.content.Context
import com.wonderpush.sdk.wonderpush_flutter_plugin.config.Constants
import com.wonderpush.sdk.wonderpush_flutter_plugin.handlers.DataStreamHandler
import com.wonderpush.sdk.wonderpush_flutter_plugin.handlers.MethodHandler
import io.flutter.plugin.common.EventChannel

/** WonderpushFlutterPlugin */
public class WonderpushFlutterPlugin: FlutterPlugin {

  private lateinit var _channel: MethodChannel
  private lateinit var _appContext: Context
  private lateinit var _eventChannel: EventChannel


  private fun onAttachedToEngineMethod(context: Context, binaryMessenger: BinaryMessenger) {
    _appContext = context
    _channel = MethodChannel(binaryMessenger, Constants.METHOD_CHANNEL_NAME)
    _channel.setMethodCallHandler(MethodHandler(context));
    _eventChannel=EventChannel(binaryMessenger, Constants.STREAM_CHANNEL_NAME);
     val dataHandler=DataStreamHandler();
    _eventChannel.setStreamHandler(dataHandler);
    // just to tell flutter that plugin as initailised
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {

    this.onAttachedToEngineMethod(flutterPluginBinding.applicationContext, flutterPluginBinding.binaryMessenger)

  }
  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  companion object {

    @JvmStatic
    fun registerWith(registrar: Registrar) {
      WonderpushFlutterPlugin().onAttachedToEngineMethod(registrar.context(), registrar.messenger())
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
  }
}
