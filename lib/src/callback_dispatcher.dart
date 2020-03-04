// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// void callbackDispatcher() {
//   const MethodChannel _backgroundChannel =
//       MethodChannel('wonderpush_flutter_plugin_bg');
//   WidgetsFlutterBinding.ensureInitialized();
//   _backgroundChannel.setMethodCallHandler((MethodCall call) async {
//     if (call.method == 'handleBackgroundMessage') {
//       final CallbackHandle handle =
//           CallbackHandle.fromRawHandle(call.arguments['handle']);
//       final Function handlerFunction =
//           PluginUtilities.getCallbackFromHandle(handle);
//       try {
//         await handlerFunction(
//             Map<String, dynamic>.from(call.arguments['message']));
//       } catch (e) {
//         print('Unable to handle incoming background message.');
//         print(e);
//       }
//       return Future<void>.value();
//     }
//   });
//   try {
//     _backgroundChannel.invokeMethod<void>('FcmDartService#initialized');
//   } catch (e) {}
// }
