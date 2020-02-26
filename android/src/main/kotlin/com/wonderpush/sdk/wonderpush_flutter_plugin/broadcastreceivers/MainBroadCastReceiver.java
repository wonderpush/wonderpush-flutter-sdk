package com.wonderpush.sdk.wonderpush_flutter_plugin.broadcastreceivers;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import com.wonderpush.sdk.WonderPush;

public class MainBroadCastReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {

        Intent pushNotif = intent.getParcelableExtra(WonderPush.INTENT_NOTIFICATION_WILL_OPEN_EXTRA_RECEIVED_PUSH_NOTIFICATION);
        Bundle extras = pushNotif == null ? null : pushNotif.getExtras();
        if (extras == null || extras.isEmpty()) {
            return;
        }
        System.out.println(extras);
    }
}
