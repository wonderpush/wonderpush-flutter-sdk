package com.wonderpush.sdk.wonderpush_flutter_plugin.handlers;
import android.content.Context;
import com.wonderpush.sdk.wonderpush_flutter_plugin.WonderPushInstance;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MethodHandler implements MethodChannel.MethodCallHandler{

    MethodChannel.Result result;
    MethodCall call;
    Context context;

    public MethodHandler(Context context){
        this.context=context;
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        this.result = result;
        this.call = call;

        switch (call.method){

            case "getPlatformVersion":
                result.success("My Android ${android.os.Build.VERSION.RELEASE}");
                break;

            case "init":
                WonderPushInstance.getInstance().setupWonderPush(this.context,call.argument("clientId").toString(),call.argument("clientSecret").toString());
                result.success("Setup has completed");
                break;

            case "trackEvent":
                String eventType=call.argument("eventType");
               // String eventName=call.argument("eventName");
                WonderPushInstance.getInstance().subscribeToEvent(eventType);
                result.success("Successfully subscribed to event "+eventType);
                break;

                default:
                    result.notImplemented();


        }
    }

}
