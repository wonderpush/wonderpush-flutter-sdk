import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:wonderpush_flutter_plugin/wonderpush_flutter_sdk.dart';
import 'package:wonderpush_flutter_plugin_example/event_list.dart';
import 'package:wonderpush_flutter_plugin_example/model/remote_message.dart';
import 'config/constants.dart';





void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final WonderpushFlutterPlugin _wonderpushFlutterPlugin =
      WonderpushFlutterPlugin();
  String _platformVersion = 'Unknown';
  String _name = 'WonderPush Flutter Example';
  StreamSubscription streamSubscription;
  bool isLoading = true;
  static var _scaffoldKey = new GlobalKey<ScaffoldState>();

  static Future<dynamic> _backgroundMessageHandler(
      Map<String, dynamic> message) {
        parseMessage(message);
  }

  static parseMessage(Map<String, dynamic> message){
     if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
      print("_backgroundMessageHandler data: ${data}");
      showMessage(data);
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      print("_backgroundMessageHandler notification: ${notification}");

      showMessage(notification);
    }
  }

  // void _showItemDialog(Map<String, dynamic> message) {
  //   showDialog<bool>(
  //     context: context,
  //     builder: (_) => _buildDialog(context, _itemForMessage(message)),
  //   ).then((bool shouldNavigate) {
  //     if (shouldNavigate == true) {
  //       // _navigateToItemDetail(message);
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();
    streamSubscription = _wonderpushFlutterPlugin.stream
        .receiveBroadcastStream()
        .listen((data) async {
      print("Flutter event stream is getting data $data");

      if (data == true) {
        //It means plugin setup is complete
        bool initialIzed = await init(clientId, clientSecret, senderId);
        if (initialIzed) {
          _wonderpushFlutterPlugin.configure(
              onMessage: (Map<String, dynamic> message) async {
                print("onMessage: $message");
                parseMessage(message);
              },
              onLaunch: (Map<String, dynamic> message) async {
                print("onLaunch: $message");
              },
              onResume: (Map<String, dynamic> message) async {
                print("onResume: $message");
              },
              onBackgroundMessage: _backgroundMessageHandler);
          _wonderpushFlutterPlugin.requestNotificationPermissions(
              const IosNotificationSettings(
                  sound: true, badge: true, alert: true, provisional: true));
          _wonderpushFlutterPlugin.onIosSettingsRegistered
              .listen((IosNotificationSettings settings) {
            print("Settings registered: $settings");
          });
          _wonderpushFlutterPlugin.getToken().then((String token) {
            //
            setState(() {
              //_homeScreenText = "";
            });
            print("Push Messaging token: $token");
          });
          this.setState(() {
            isLoading = false;
          });
        }
      } else {
        print(data);
        showMessage(data);
      }
    });
  }

  static showMessage(dynamic result) {
   // if(message.containsKey('notification'))
  //  Data data= result["data"] as Data;
    // print("coming here $result");
    try{
     // RemoteMessage message=RemoteMessage.fromJson(result);

        //   print("coming here $message");

    final snackBar = SnackBar(content: Text("$result"));
    if (_scaffoldKey.currentState != null){
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }else{
      print("app is in background $result");
    }
      
    }catch(e){
      print(e.message);
    }
    

  }

  Future<bool> init(
      String clientId, String clientSecret, String senderId) async {
    _wonderpushFlutterPlugin.logging = true;
    await _wonderpushFlutterPlugin.init(
        clientId: clientId, clientSecret: clientSecret, senderId: senderId);
    return Future.value(true);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion, name;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await _wonderpushFlutterPlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    try {
      name = await _wonderpushFlutterPlugin.name;
    } on PlatformException {
      name = 'Failed to get name';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _name = name;
    });
  }

  void onTap(String eventText) async {
    String result = await _wonderpushFlutterPlugin.trackEvent(eventText);
    final snackBar = SnackBar(content: Text("$result"));
    if (_scaffoldKey.currentState != null)
      _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text("$_name"),
          ),
          body: Material(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    color: Color.fromRGBO(221, 221, 221, 1.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Events available'.toUpperCase(),
                            style: TextStyle(
                                fontSize: 18.00, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: EventList(onTap: onTap),
                        )
                      ],
                    ),
                  ),
          )),
    );
  }

  @override
  void dispose() {
    if (streamSubscription != null) {
      streamSubscription.cancel();
      streamSubscription = null;
    }
    super.dispose();
  }
}
