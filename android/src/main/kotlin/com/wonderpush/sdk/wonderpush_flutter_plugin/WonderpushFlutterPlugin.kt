package com.wonderpush.sdk.wonderpush_flutter_plugin

import android.app.Activity
import android.content.BroadcastReceiver
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.PluginRegistry.Registrar
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import com.google.firebase.messaging.RemoteMessage
import com.wonderpush.sdk.WonderPush
import com.wonderpush.sdk.WonderPushUserPreferences
import com.wonderpush.sdk.wonderpush_flutter_plugin.config.Constants
import com.wonderpush.sdk.wonderpush_flutter_plugin.handlers.DataStreamHandler
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.*
import org.json.JSONArray
import org.json.JSONObject
import java.util.*

/** WonderpushFlutterPlugin */
public class WonderpushFlutterPlugin : FlutterPlugin, ActivityAware, MethodChannel.MethodCallHandler, BroadcastReceiver() {
    private lateinit var _channel: MethodChannel
    private lateinit var _bgchannel: MethodChannel
    private lateinit var _appContext: Context
    private lateinit var _eventChannel: EventChannel
    private var mainActivity: Activity? = null


    private fun onAttachedToEngineMethod(context: Context, binaryMessenger: BinaryMessenger) {
        _appContext = context

        _channel = MethodChannel(binaryMessenger, Constants.METHOD_CHANNEL_NAME)
//    var methodHandler=MethodHandler(context,mainActivity,_channel);
        _channel.setMethodCallHandler(this);
        _bgchannel = MethodChannel(binaryMessenger, Constants.METHOD_CHANNEL_NAME_BACKGROUND)
        _bgchannel.setMethodCallHandler(this);

        _eventChannel = EventChannel(binaryMessenger, Constants.STREAM_CHANNEL_NAME);
        val dataHandler = DataStreamHandler();
        _eventChannel.setStreamHandler(dataHandler);
        WPFirebaseMessagingService.setBackgroundChannel(_bgchannel);
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        this.onAttachedToEngineMethod(flutterPluginBinding.applicationContext, flutterPluginBinding.binaryMessenger);
    }

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
            val wonderpush = WonderpushFlutterPlugin()
            wonderpush.onAttachedToEngineMethod(registrar.context(), registrar.messenger())
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        //mainActivity=binding.activity;
    }


    fun setActivity(activity: Activity) {
        mainActivity = activity

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


    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {

        when (call.method) {

            "getPlatformVersion" -> result.success("My Android \${android.os.Build.VERSION.RELEASE}")

            "FcmDartService#start" -> {
                var setupCallbackHandle: Long = 0
                var backgroundMessageHandle: Long = 0
                try {
                    val callbacks = call.arguments as Map<String, Long>
                    setupCallbackHandle = callbacks["setupHandle"]!!
                    backgroundMessageHandle = callbacks["backgroundHandle"]!!
                } catch (e: Exception) {
                    //Log.e(TAG, "There was an exception when getting callback handle from Dart side");
                    e.printStackTrace()
                }

                WPFirebaseMessagingService.setBackgroundSetupHandle(_appContext, setupCallbackHandle)
                WPFirebaseMessagingService.startBackgroundIsolate(_appContext, setupCallbackHandle)
                WPFirebaseMessagingService.setBackgroundMessageHandle(
                        _appContext, backgroundMessageHandle)

                result.success(true)
            }

            "configure" -> {
                //channel.invokeMethod("onToken", task.getResult().getToken());
                if (mainActivity != null) {
                    //sendMessageFromIntent("onLaunch", mainActivity.getIntent());
                }
                result.success(WonderPush.getPushToken())
            }


            "init" -> {
                setupWonderPush(_appContext, call.argument<Any>("clientId")!!.toString(), call.argument<Any>("clientSecret")!!.toString())
                result.success("Setup has completed")
            }

            "trackEvent" -> {
                val eventType = call.argument<String>("eventType")
                // String eventName=call.argument("eventName");
                subscribeToEvent(eventType)
                result.success("Successfully subscribed to event " + eventType!!)
            }

            "setUserId" -> {
                val userId = call.argument<String>("userId")
                WonderPush.setUserId(userId)
                result.success("Successfully set user id to " + userId!!)
            }
            "isReady" -> result.success(WonderPush.isReady())

            "setLogging" -> {
                val enabled = call.argument<Boolean>("enabled")!!
                WonderPush.setLogging(enabled)
                result.success("Logging is set to$enabled")
            }

            "getUserId" -> result.success(WonderPush.getUserId())

            "getInstallationId" -> result.success(WonderPush.getInstallationId())

            "getDeviceId" -> result.success(WonderPush.getDeviceId())

            "getPushToken" -> result.success(WonderPush.getPushToken())

            "getAccessToken" -> result.success(WonderPush.getAccessToken())

//      "addTag" -> updateTags(call.argument<Any>("tags"), "addTag")
//
//      "removeTag" -> updateTags(call.argument<Any>("tags"), "removeTag")

            "removeAllTags" -> {
                WonderPush.removeAllTags()
                result.success("All tags removed successfully")
            }

            "getTags" -> result.success(JSONArray(WonderPush.getTags()))

            "hasTag" -> result.success(WonderPush.hasTag(call.argument<Any>("tag")!!.toString()))

            "setProperty" -> {
                val field = call.argument<String>("key")
                val value = call.argument<Any>("value")
                WonderPush.setProperty(field, value)
                result.success(true)
            }

            "unsetProperty" -> {
                val key = call.argument<String>("key")
                WonderPush.unsetProperty(key)
                result.success(true)
            }

            "addProperty" -> {
                val addPropertyKey = call.argument<String>("key")
                val addPropertyValue = call.argument<Any>("value")
                WonderPush.addProperty(addPropertyKey, addPropertyValue)
                result.success(true)
            }

            "removeProperty" -> {
                val removePropertyKey = call.argument<String>("key")
                val removePropertyValue = call.argument<Any>("value")
                WonderPush.removeProperty(removePropertyKey, removePropertyValue)
                result.success(true)
            }

            "getPropertyValue" -> {
                val getPropertyValueKey = call.argument<String>("key")
                result.success(JSONObject(Collections.singletonMap("__wrapped", WonderPush.getPropertyValue(getPropertyValueKey))))
            }

            "getPropertyValues" -> {
                val getPropertyValuesKey = call.argument<String>("key")
                result.success(JSONArray(WonderPush.getPropertyValues(getPropertyValuesKey)))
            }

            "getProperties" -> result.success(WonderPush.getProperties())

            "putProperties" -> {
                val properties = call.argument<JSONObject>("key")
                WonderPush.putProperties(properties)
                result.success(true)
            }

            "getInstallationCustomProperties" -> result.success(WonderPush.getInstallationCustomProperties())

            "putInstallationCustomProperties" -> {

                val custom = call.argument<JSONObject>("custom")
                WonderPush.putInstallationCustomProperties(custom)
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

            "getNotificationEnabled" -> result.success(WonderPush.getNotificationEnabled())

            "setNotificationEnabled" -> {
                val isNotificationEnabled = call.argument<Boolean>("isNotificationEnabled")
                result.success(isNotificationEnabled)
            }

            "getUserConsent" -> result.success(WonderPush.getUserConsent())

            "setUserConsent" -> {
                val isUserConsent = call.argument<Boolean>("isUserConsent")
                result.success(isUserConsent)
            }

            "clearAllData" -> {
                WonderPush.clearAllData()
                result.success(true)
            }

            "clearEventsHistory" -> {
                WonderPush.clearEventsHistory()
                result.success(true)
            }

            "clearPreferences" -> {
                WonderPush.clearPreferences()
                result.success(true)
            }

            "downloadAllData" -> {
                WonderPush.downloadAllData()
                result.success(true)
            }

            "UserPreferences_getDefaultChannelId" -> result.success(WonderPushUserPreferences.getDefaultChannelId())

            "UserPreferences_setDefaultChannelId" -> {
                val id = call.argument<String>("id")
                WonderPushUserPreferences.setDefaultChannelId(id)
                result.success(true)
            }


            "FcmDartService#initialized" -> {
                WPFirebaseMessagingService.onInitialized()
                result.success(true)
            }

            //            case "UserPreferences_getChannelGroup":
            //
            //                String groupId = call.argument("id");
            //                JSONObject rtn = this.jsonSerializeWonderPushChannelGroup(WonderPushUserPreferences.getChannelGroup(groupId));
            //                if (rtn == null) {
            //                    result.success(null);
            //                } else {
            //                    result.success(rtn);
            //                }
            //                break;

            //                if (action.equals("UserPreferences_getChannel")) {
            //
            //                String id = args.getString(0);
            //                JSONObject rtn = this.jsonSerializeWonderPushChannel(WonderPushUserPreferences.getChannel(id));
            //                if (rtn == null) {
            //                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, (String) null));
            //                } else {
            //                    callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, rtn));
            //                }
            //
            //            } else if (action.equals("UserPreferences_setChannelGroups")) {
            //
            //                JSONArray groupsJson = args.getJSONArray(0);
            //                List<WonderPushChannelGroup> groups = new ArrayList<>(groupsJson.length());
            //                for (int i = 0, e = groupsJson.length(); i < e; ++i) {
            //                    groups.add(this.jsonDeserializeWonderPushChannelGroup(groupsJson.optJSONObject(i)));
            //                }
            //                WonderPushUserPreferences.setChannelGroups(groups);
            //                callbackContext.success();
            //
            //            } else if (action.equals("UserPreferences_setChannels")) {
            //
            //                JSONArray channelsJson = args.getJSONArray(0);
            //                List<WonderPushChannel> channels = new ArrayList<>(channelsJson.length());
            //                for (int i = 0, e = channelsJson.length(); i < e; ++i) {
            //                    channels.add(this.jsonDeserializeWonderPushChannel(channelsJson.optJSONObject(i)));
            //                }
            //                WonderPushUserPreferences.setChannels(channels);
            //                callbackContext.success();
            //
            //            } else if (action.equals("UserPreferences_putChannelGroup")) {
            //
            //                JSONObject groupJson = args.getJSONObject(0);
            //                WonderPushChannelGroup group = this.jsonDeserializeWonderPushChannelGroup(groupJson);
            //                WonderPushUserPreferences.putChannelGroup(group);
            //                callbackContext.success();
            //
            //            } else if (action.equals("UserPreferences_putChannel")) {
            //
            //                JSONObject channelJson = args.getJSONObject(0);
            //                WonderPushChannel channel = this.jsonDeserializeWonderPushChannel(channelJson);
            //                WonderPushUserPreferences.putChannel(channel);
            //                callbackContext.success();
            //
            //            } else if (action.equals("UserPreferences_removeChannelGroup")) {
            //
            //                String id = args.getString(0);
            //                WonderPushUserPreferences.removeChannelGroup(id);
            //                callbackContext.success();
            //
            //            } else if (action.equals("UserPreferences_removeChannel")) {
            //
            //                String id = args.getString(0);
            //                WonderPushUserPreferences.removeChannel(id);
            //                callbackContext.success();
            //
            //            }

            else -> result.notImplemented()
        }
    }


    private fun parseRemoteMessage(message: RemoteMessage): Map<String, Any> {
        val content = HashMap<String, Any>()
        content["data"] = message.data
        val notification = message.notification
        val notificationMap = HashMap<String, Any>()
        if(notification!=null){
            val title = notification?.title
            notificationMap["title"] = title!!
            val body = "Hello"
            notificationMap["body"] = body!!
        }
        content["notification"] = notificationMap
        return content
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        val action = intent?.getAction() ?: return
        if (action == WPFirebaseMessagingService.ACTION_TOKEN) {
            val token = intent.getStringExtra(WPFirebaseMessagingService.EXTRA_TOKEN)
//      iNotificationReceiver.sendToken(token)
            _channel.invokeMethod("onToken", token)
        } else if (action == WPFirebaseMessagingService.ACTION_REMOTE_MESSAGE) {
            val message = intent.getParcelableExtra<RemoteMessage>(WPFirebaseMessagingService.EXTRA_REMOTE_MESSAGE)
            val content = parseRemoteMessage(message)
            println(action)
            //iNotificationReceiver.sendNotificationData(content);
            _channel.invokeMethod("onMessage", content, object : MethodChannel.Result {
                override fun success(o: Any?) {
                    println(o)
                    // this will be called with o = "some string"
                }

                override fun error(s: String, s1: String?, o: Any?) {
                    println(s)
                    println(s1)
                    println(o)
                }

                override fun notImplemented() {
                    println("No implemented")
                }
            })
        }
    }


    fun setupWonderPush(ctx: Context, clientId: String, clientSecret: String) {

        WonderPush.setRequiresUserConsent(false)
        WonderPush.initialize(_appContext, clientId, clientSecret)
        if (!WonderPush.isReady()) {
            val intentFilter = IntentFilter()
            intentFilter.addAction(WPFirebaseMessagingService.ACTION_TOKEN)
            intentFilter.addAction(WPFirebaseMessagingService.ACTION_REMOTE_MESSAGE)
            LocalBroadcastManager.getInstance(_appContext).registerReceiver(this, intentFilter)
//      val registeredMethodIntentFilter = IntentFilter()
//      registeredMethodIntentFilter.addAction(WPFirebaseMessagingService.ACTION_TOKEN)
//      registeredMethodIntentFilter.addAction(WPFirebaseMessagingService.ACTION_REMOTE_MESSAGE)
//      registeredMethodIntentFilter.addAction(WonderPush.INTENT_NOTIFICATION_BUTTON_ACTION_METHOD_ACTION)
//      registeredMethodIntentFilter.addDataScheme(WonderPush.INTENT_NOTIFICATION_BUTTON_ACTION_METHOD_SCHEME)
//      registeredMethodIntentFilter.addDataAuthority(WonderPush.INTENT_NOTIFICATION_BUTTON_ACTION_METHOD_AUTHORITY, null)
//      LocalBroadcastManager.getInstance(_appContext).registerReceiver(buttonActionBroadCastReceiver, registeredMethodIntentFilter)
            //extraSetUp();

        }
        //       IntentFilter intentFilter= new IntentFilter(WonderPush.INTENT_INTIALIZED);
        //       intentFilter.addAction(WPFirebaseMessagingService.ACTION_TOKEN);
        //       intentFilter.addAction(WPFirebaseMessagingService.ACTION_REMOTE_MESSAGE);
        //       LocalBroadcastManager.getInstance(context).registerReceiver(mainBroadCastReceiver,intentFilter);
        //
        //       System.out.println("Wonderpush is ready");
    }

    fun subscribeToEvent(eventType: String?) {
        WonderPush.trackEvent(eventType, null)
    }

    internal fun unSubscribeFromEvent(eventType: String) {
        WonderPush.removeTag()
    }


    fun updateTags(value: Any, action: String) {
        try {
            var tags: Array<String>? = null
            // can be a string or an array of strings
            if (value is JSONArray) {
                val tagsList = LinkedList<String>()
                for (i in 0 until value.length()) {
                    val v = value.get(i)
                    if (v is String) {
                        tagsList.add(v)
                    }
                }
                tags = tagsList.toTypedArray()
            } else if (value is String) {
                tags = arrayOf(value)
            }
            if (tags != null) {
                if (action == "addTag") {
                    WonderPush.addTag(*tags)
                } else {
                    WonderPush.removeTag(*tags)
                }
            }

        } catch (e: Exception) {
            e.printStackTrace()
        }

    }
}


