package com.wonderpush.sdk.wonderpush_flutter_plugin

import android.app.Activity
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.PluginRegistry.Registrar
import android.content.Context
import androidx.annotation.Nullable
import com.wonderpush.sdk.wonderpush_flutter_plugin.config.Constants
import com.wonderpush.sdk.wonderpush_flutter_plugin.handlers.DataStreamHandler
import com.wonderpush.sdk.wonderpush_flutter_plugin.handlers.MethodHandler
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.*

/** WonderpushFlutterPlugin */
public class WonderpushFlutterPlugin: FlutterPlugin,ActivityAware {
//  override fun registerWith(registry: PluginRegistry?) {
//    WPFirebaseMessagingService.setPluginRegistrant(this);
//    TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
//  }
//

  private lateinit var _channel: MethodChannel
  private lateinit var _bgchannel: MethodChannel
  private lateinit var _appContext: Context
  private lateinit var _eventChannel: EventChannel

  private lateinit var mainActivity: Activity;


  private fun onAttachedToEngineMethod(context: Context, binaryMessenger: BinaryMessenger ) {
    _appContext = context
    _channel = MethodChannel(binaryMessenger, Constants.METHOD_CHANNEL_NAME)
    _channel.setMethodCallHandler(MethodHandler(context));
    _bgchannel = MethodChannel(binaryMessenger, Constants.METHOD_CHANNEL_NAME_BACKGROUND)
    _bgchannel.setMethodCallHandler(MethodHandler(context));
     WPFirebaseMessagingService.setBackgroundChannel(_bgchannel);
    _eventChannel=EventChannel(binaryMessenger, Constants.STREAM_CHANNEL_NAME);
     val dataHandler=DataStreamHandler();
    _eventChannel.setStreamHandler(dataHandler);
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
      this.onAttachedToEngineMethod(flutterPluginBinding.applicationContext, flutterPluginBinding.binaryMessenger);
    //WPFirebaseMessagingService.setPluginRegistrant(flutterPluginBinding.binaryMessenger.);
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
    fun <T> initialize(initializer: T) where T : Context, T : PluginRegistry.PluginRegistrantCallback {
      WPFirebaseMessagingService.setPluginRegistrant(initializer);

    }

    @JvmStatic
    fun registerWith(registry: PluginRegistry) {
      registerWith(registry.registrarFor("com.wonderpush.sdk.wonderpush_flutter_plugin.WonderpushFlutterPlugin"))
    }

    @JvmStatic
    fun registerWith(registrar: Registrar) {

//      this.mainActivity=registrar.activity();

      WonderpushFlutterPlugin().onAttachedToEngineMethod(registrar.context(), registrar.messenger())
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    mainActivity=binding.activity;
  }

  override fun onDetachedFromActivity() {

    TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
  }

  override fun onDetachedFromActivityForConfigChanges() {
    TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
  }


}
