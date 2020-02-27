package com.wonderpush.sdk.wonderpush_flutter_plugin.handlers;
import com.wonderpush.sdk.wonderpush_flutter_plugin.WonderPushInstance;
import com.wonderpush.sdk.wonderpush_flutter_plugin.broadcastreceivers.ButtonActionBroadCastReceiver;
import com.wonderpush.sdk.wonderpush_flutter_plugin.broadcastreceivers.INotificationReceiver;
import com.wonderpush.sdk.wonderpush_flutter_plugin.broadcastreceivers.MainBroadCastReceiver;
import com.wonderpush.sdk.wonderpush_flutter_plugin.handlers.BaseStreamHandler;

import org.json.JSONObject;

import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;

public class DataStreamHandler extends BaseStreamHandler implements INotificationReceiver {

    private static MainBroadCastReceiver mainBroadCastReceiver= WonderPushInstance.mainBroadCastReceiver;
    private static ButtonActionBroadCastReceiver buttonActionBroadCastReceiver= WonderPushInstance.buttonActionBroadCastReceiver;
    private static INotificationReceiver iNotificationReceiver;

    public DataStreamHandler(){
        iNotificationReceiver =this;
        mainBroadCastReceiver.registerCallback(iNotificationReceiver);
        buttonActionBroadCastReceiver.registerCallback(iNotificationReceiver);
    }

    @Override
    public void sendNotificationData(final JSONObject data) {
        executor.execute(new Runnable() {
            @Override
            public void run() {
                if (DataStreamHandler.super.sink != null)
                    DataStreamHandler.super.sink.success(data);
            }
        });
    }

    public void sendBool(final boolean data) {
        executor.execute(new Runnable() {
            @Override
            public void run() {
                if (DataStreamHandler.super.sink != null)
                    DataStreamHandler.super.sink.success(data);
            }
        });

    }

    public void sendData(final String data) {
        executor.execute(new Runnable() {
            @Override
            public void run() {
                if (DataStreamHandler.super.sink != null)
                    DataStreamHandler.super.sink.success(data);
            }
        });

    }

    public void sendMapData(final Map<String, Object> data) {
        executor.execute(new Runnable() {
            @Override
            public void run() {
                if (DataStreamHandler.super.sink != null)
                    DataStreamHandler.super.sink.success(data);
            }
        });

    }

    public void sendListMapData(final List<Map<String, Object>> data) {
        executor.execute(new Runnable() {
            @Override
            public void run() {
                if (DataStreamHandler.super.sink != null) {
                    DataStreamHandler.super.sink.success(data);
                } else {
                    System.out.println(DataStreamHandler.super.sink);
                }
            }
        });
    }

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        super.onListen(o, eventSink);

        eventSink.success(true);
    }

    @Override
    public void onCancel(Object o) {
        super.onCancel(o);
    }


}
