import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wonderpush_flutter_plugin/wonderpush_flutter_sdk.dart';


void callbackDispatcher() {
  const MethodChannel _backgroundChannel = MethodChannel('wonderpush_flutter_plugin_bg');
  WidgetsFlutterBinding.ensureInitialized();

  _backgroundChannel.setMethodCallHandler((MethodCall call) async {

    print('_backgroundChannel.setMethodCallHandler');

    final List<dynamic> args = call.arguments;
    final Function callback = PluginUtilities.getCallbackFromHandle(CallbackHandle.fromRawHandle(args[0]));
    
    assert(callback != null);
    print(args.sublist(1));
    callback(args.sublist(1));
  });

  WonderpushFlutterPlugin.initBG();
}