package com.wonderpush.sdk.wonderpush_flutter_plugin.utils;

import android.os.Handler;
import android.os.Looper;

import java.util.concurrent.Executor;

public class MainThreadExecutor implements Executor {

    final Handler handler = new Handler(Looper.getMainLooper());

    @Override
    public void execute(Runnable command) {
        handler.post(command);
    }
}
