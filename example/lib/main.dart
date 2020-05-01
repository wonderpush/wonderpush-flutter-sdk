import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:wonderpushflutter/wonderpushflutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    var result;
    try {
      await Wonderpushflutter.setLogging(true);
      print('setLogging Done.');
    } on PlatformException {
      print('setLogging: error occured');
    }

    try {
      await Wonderpushflutter.subscribeToNotifications;
      print('subscribeToNotifications Done.');
    } on PlatformException {
      print('subscribeToNotifications: error occured');
    }
     try {
     result = await Wonderpushflutter.isSubscribedToNotifications;
      print('isSubscribedToNotifications Done. $result');
    } on PlatformException {
      print('isSubscribedToNotifications: error occured');
    }

       try {
        await Wonderpushflutter.unsubscribeFromNotifications;
        print('unsubscribeFromNotifications Done.');
    } on PlatformException {
      print('unsubscribeFromNotifications: error occured');
    }
       try {
        result = await Wonderpushflutter.isSubscribedToNotifications;
      print('isSubscribedToNotifications1 Done. $result');
    } on PlatformException {
      print('isSubscribedToNotifications1: error occured');
    }

   try {
     await Wonderpushflutter.setCountry("US");
      print('setCountry Done');
    } on PlatformException {
      print('setCountry: error occured');
    }

    try {
     result = await Wonderpushflutter.getCountry;
      print('getCountry Done. $result');
    } on PlatformException {
      print('getCountry: error occured');
    }

  try {
     await Wonderpushflutter.setCurrency("USD");
      print('setCurrency Done');
    } on PlatformException {
      print('setCurrency: error occured');
    }

    try {
     result = await Wonderpushflutter.getCurrency;
      print('getCurrency Done. $result');
    } on PlatformException {
      print('getCurrency: error occured');
    }

try {
     await Wonderpushflutter.setLocale("en_US");
      print('setLocale Done');
    } on PlatformException {
      print('setLocale: error occured');
    }

    try {
     result = await Wonderpushflutter.getLocale;
      print('getLocale Done. $result');
    } on PlatformException {
      print('getLocale: error occured');
    }
    
    try {
     await Wonderpushflutter.setTimeZone("Europe/Paris");
      print('setTimeZone Done');
    } on PlatformException {
      print('setTimeZone: error occured');
    }

    try {
     result = await Wonderpushflutter.getTimeZone;
      print('getTimeZone Done. $result');
    } on PlatformException {
      print('getTimeZone: error occured');
    }
    

    try {
     await Wonderpushflutter.setUserId("rakesh");
      print('setUserId Done');
    } on PlatformException {
      print('setUserId: error occured');
    }

    try {
     result = await Wonderpushflutter.getUserId;
      print('getUserId Done. $result');
    } on PlatformException {
      print('getUserId: error occured');
    }

     try {
      result = await Wonderpushflutter.isReady;
      print('isReady Done. $result');
    } on PlatformException {
      print('isReady: error occured');
    }

    try {
      await Wonderpushflutter.removeAllTags;
      print('removeAllTags Done');
    } on PlatformException {
      print('isReadremoveAllTagsy: error occured');
    }

     try {
      result = await Wonderpushflutter.hasTag("sports");
      print('hasTag Done. $result');
    } on PlatformException {
      print('hasTag: error occured');
    }

    try {
     var result9 = await Wonderpushflutter.getInstallationId;
      print('getInstallationId Done. $result9');
    } on PlatformException {
      print('getInstallationId: error occured');
    }

    try {
     result = await Wonderpushflutter.getPushToken;
      print('getPushToken Done. $result');
    } on PlatformException {
      print('getPushToken: error occured');
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
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
          child: Text('Running'),
        ),
      ),
    );
  }
}
