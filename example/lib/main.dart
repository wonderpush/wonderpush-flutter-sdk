import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:wonderpush_flutter_plugin/wonderpush_flutter_plugin.dart';
import 'package:wonderpush_flutter_plugin_example/event_list.dart';
import 'config/constants.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final WonderpushFlutterPlugin _wonderpushFlutterPlugin =
      WonderpushFlutterPlugin();
  String _name = 'WonderPush Flutter Example';
  static var _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    init(clientId, clientSecret, senderId);
  }

  Future<bool> init(
      String clientId, String clientSecret, String senderId) async {
    _wonderpushFlutterPlugin.logging = true;
    await _wonderpushFlutterPlugin.init(
        clientId: clientId, clientSecret: clientSecret, senderId: senderId);
    return Future.value(true);
  }

  Future<void> initPlatformState() async {
    String platformVersion, name;

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
    if (!mounted) return;
    setState(() {
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
            child: Container(
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
    super.dispose();
  }
}
