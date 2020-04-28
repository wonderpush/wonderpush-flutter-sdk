import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sdk/sdk.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await Sdk.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    try {
     var result = await Sdk.setLogging(true);
      print('setLogging Done. $result');
    } on PlatformException {
      print('setLogging: error occured');
    }
    try {
     var result1 = await Sdk.subscribeToNotifications;
      print('subscribeToNotifications Done. $result1');
    } on PlatformException {
      print('subscribeToNotifications: error occured');
    }
     try {
     bool result2 = await Sdk.isSubscribedToNotifications;
      print('isSubscribedToNotifications Done. $result2');
    } on PlatformException {
      print('isSubscribedToNotifications: error occured');
    }

       try {
       var result3 =  await Sdk.unsubscribeFromNotifications;
      print('unsubscribeFromNotifications Done. $result3');
    } on PlatformException {
      print('unsubscribeFromNotifications: error occured');
    }
       try {
     var result4 = await Sdk.isSubscribedToNotifications;
      print('isSubscribedToNotifications1 Done. $result4');
    } on PlatformException {
      print('isSubscribedToNotifications1: error occured');
    }
 try {
     var result5 = await Sdk.setUserId("rakesh");
      print('setUserId Done. $result5');
    } on PlatformException {
      print('setUserId: error occured');
    }

    try {
     var result6 = await Sdk.getUserId;
      print('getUserId Done. $result6');
    } on PlatformException {
      print('getUserId: error occured');
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
