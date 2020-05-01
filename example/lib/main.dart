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
     bool result2 = await Wonderpushflutter.isSubscribedToNotifications;
      print('isSubscribedToNotifications Done. $result2');
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
        bool result3 = await Wonderpushflutter.isSubscribedToNotifications;
      print('isSubscribedToNotifications1 Done. $result3');
    } on PlatformException {
      print('isSubscribedToNotifications1: error occured');
    }

 try {
     await Wonderpushflutter.setUserId("rakesh");
      print('setUserId Done');
    } on PlatformException {
      print('setUserId: error occured');
    }

    try {
     var result6 = await Wonderpushflutter.getUserId;
      print('getUserId Done. $result6');
    } on PlatformException {
      print('getUserId: error occured');
    }

     try {
     var result7 = await Wonderpushflutter.isReady;
      print('isReady Done. $result7');
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
      var result8 = await Wonderpushflutter.hasTag("sports");
      print('hasTag Done. $result8');
    } on PlatformException {
      print('hasTag: error occured');
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
