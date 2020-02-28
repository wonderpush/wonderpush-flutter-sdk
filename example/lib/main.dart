import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:wonderpush_flutter_plugin/wonderpush_flutter_sdk.dart';
import 'package:wonderpush_flutter_plugin_example/event_list.dart';
import 'config/constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _name = 'WonderPush Flutter Example';
  StreamSubscription streamSubscription;
  bool isLoading = true;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    streamSubscription = WonderpushFlutterPlugin.stream
        .receiveBroadcastStream()
        .listen((data) async {
      print("inside flutter stream $data");
      if (data == true) {
        //It means plugin setup is complete
        bool initialIzed = await init(clientId, clientSecret,senderId);
        if (initialIzed) {
          this.setState(() {
            isLoading = false;
          });
        }
      }
    });
  }

  Future<bool> init(String clientId, String clientSecret,String senderId) async {
    await WonderpushFlutterPlugin.initialize(
       clientId,  clientSecret,senderId);
    WonderpushFlutterPlugin.logging=true;
    return Future.value(true);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion, name;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await WonderpushFlutterPlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    try {
      name = await WonderpushFlutterPlugin.name;
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
    String result = await WonderpushFlutterPlugin.trackEvent(eventText);
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
          body: isLoading
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
