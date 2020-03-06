package com.wonderpush.sdk.wonderpush_flutter_plugin
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.PluginRegistry.Registrar
import android.content.Context
import com.wonderpush.sdk.WonderPush
import com.wonderpush.sdk.wonderpush_flutter_plugin.config.Constants
import io.flutter.plugin.common.*

/** WonderpushFlutterPlugin */
public class WonderpushFlutterPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var _channel: MethodChannel
    private lateinit var _appContext: Context

    private fun onAttachedToEngineMethod(context: Context, binaryMessenger: BinaryMessenger) {
        _appContext = context
        _channel = MethodChannel(binaryMessenger, Constants.METHOD_CHANNEL_NAME)
        _channel.setMethodCallHandler(this);
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        this.onAttachedToEngineMethod(flutterPluginBinding.applicationContext, flutterPluginBinding.binaryMessenger);
    }

    companion object {
        @JvmStatic
        fun <T> initialize(initializer: T) where T : Context, T : PluginRegistry.PluginRegistrantCallback {
        }

        @JvmStatic
        fun registerWith(registry: PluginRegistry) {
            registerWith(registry.registrarFor("com.wonderpush.sdk.wonderpush_flutter_plugin.WonderpushFlutterPlugin"))
        }

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val wonderpush = WonderpushFlutterPlugin()
            wonderpush.onAttachedToEngineMethod(registrar.context(), registrar.messenger())
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {

    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

        when (call.method) {


            "init" -> {
                setupWonderPush(_appContext, call.argument<Any>("clientId")!!.toString(), call.argument<Any>("clientSecret")!!.toString())
                result.success("Setup has completed")
            }

            "trackEvent" -> {
                val eventType = call.argument<String>("eventType")
                subscribeToEvent(eventType)
                result.success("Successfully subscribed to event " + eventType!!)
            }

            "isReady" -> result.success(WonderPush.isReady())

            "setLogging" -> {
                val enabled = call.argument<Boolean>("enabled")!!
                WonderPush.setLogging(enabled)
                result.success("Logging is set to$enabled")
            }


            "subscribeToNotifications" -> {
                WonderPush.subscribeToNotifications()
                result.success(true)
            }

            "isSubscribedToNotifications" -> result.success(WonderPush.isSubscribedToNotifications())

            "unsubscribeFromNotifications" -> {
                WonderPush.unsubscribeFromNotifications()
                result.success(true)
            }

            else -> result.notImplemented()
        }
    }


    fun setupWonderPush(ctx: Context, clientId: String, clientSecret: String) {
        WonderPush.setRequiresUserConsent(false)
        WonderPush.initialize(_appContext, clientId, clientSecret)
    }

    fun subscribeToEvent(eventType: String?) {
        WonderPush.trackEvent(eventType, null)
    }

}


