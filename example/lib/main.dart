import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:wonderpush_flutter/wonderpush_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    
            WonderPush.methodchannel.setMethodCallHandler(_handleMethod);

    initPlatformState();


  }

 Future<void> _handleMethod(MethodCall call) async {
      final String method = call.method;
      dynamic argument = call.arguments;
                  print("_handleMethod"); 
      switch(method) { 
          case "wonderPushWillOpenURL": {  
            print("wonderPushWillOpenURL $argument");
          } 
          break; 
          case "wonderPushReceivedPushNotification": {  
            print("wonderPushReceivedPushNotification $argument");
          } 
          break; 
          default: { 
            print("Invalid choice"); 
          } 
          break; 
      } 
}

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
                     print("initPlatformState");


    // Platform messages may fail, so we use a try/catch PlatformException.
    var result;
    try {
       await WonderPush.setLogging(true);
      print('setLogging Done.');
    } on PlatformException {
      print('setLogging: error occured');
    }

    try {
      await WonderPush.subscribeToNotifications();
      print('subscribeToNotifications Done.');
    } on PlatformException {
      print('subscribeToNotifications: error occured');
    }
     result = await WonderPush.isSubscribedToNotifications();
      print('isSubscribedToNotifications Done. $result');
   

    // try {
    //     await WonderPush.unsubscribeFromNotifications();
    //     print('unsubscribeFromNotifications Done.');
    // } on PlatformException {
    //   print('unsubscribeFromNotifications: error occured');
    // }
    //    try {
    //     result = await WonderPush.isSubscribedToNotifications();
    //     print('isSubscribedToNotifications1 Done. $result');
    //   } on PlatformException {
    //      print('isSubscribedToNotifications1: error occured');
    //   }

   try {
      await WonderPush.setCountry("US");
      print('WonderPush Done');
    } on PlatformException {
      print('setCountry: error occured');
    }

    try {
     result =  await WonderPush.getCountry();
      print('WonderPush Done. $result');
    } on PlatformException {
      print('getCountry: error occured');
    }

  try {
      await WonderPush.setCurrency("USD");
      print('setCurrency Done');
    } on PlatformException {
      print('setCurrency: error occured');
    }

    try {
     result = await WonderPush.getCurrency();
      print('getCurrency Done. $result');
    } on PlatformException {
      print('getCurrency: error occured');
    }

    try {
      await WonderPush.setLocale("en_US");
      print('setLocale Done');
    } on PlatformException {
      print('setLocale: error occured');
    }

    try {
     result = await WonderPush.getLocale();
      print('getLocale Done. $result');
    } on PlatformException {
      print('getLocale: error occured');
    }
    
    try {
      await WonderPush.setTimeZone("Europe/Paris");
      print('setTimeZone Done');
    } on PlatformException {
      print('setTimeZone: error occured');
    }

    try {
     result = await WonderPush.getTimeZone();
      print('getTimeZone Done. $result');
    } on PlatformException {
      print('getTimeZone: error occured');
    }
    

    try {
      await WonderPush.setUserId("rakesh");
      print('setUserId Done');
    } on PlatformException {
      print('setUserId: error occured');
    }

    try {
     result =  await WonderPush.getUserId();
      print('getUserId Done. $result');
    } on PlatformException {
      print('getUserId: error occured');
    }

     try {
      result = await WonderPush.isReady();
      print('isReady Done. $result');
    } on PlatformException {
      print('isReady: error occured');
    }

    try {
       await WonderPush.addTag(["sports","food","entertainment"]);
      print('addTag Done');
    } on PlatformException {
      print('addTag: error occured');
    }
     try {
        await WonderPush.trackEvent('type', { 'product': 123 });
        print('trackEvent: purchase Done');
        await WonderPush.trackEvent('visit');
        print('trackEvent: visit Done');
      } on PlatformException {
      print('addTag1: error occured');
    }
    try {
      await WonderPush.addTag("science");
      print('addTag1 Done');
    } on PlatformException {
      print('addTag1: error occured');
    }

     try {
      result = await WonderPush.hasTag("science");
      print(result ? "User is a customer" : "User is not a customer");
    } on PlatformException {
      print('hasTag1: error occured');
    }

      try {
      result = await WonderPush.getTags();
      print('getTags Done. $result');
    } on PlatformException {
      print('getTags: error occured');
    }

    try {
      await WonderPush.removeTag("food");
      print('removeTag Done');
    } on PlatformException {
      print('removeTag: error occured');
    }

    try {
      result = await WonderPush.hasTag("food");
      print('hasTag12 Done. $result');
    } on PlatformException {
      print('hasTag2: error occured');
    }

  try {
      await WonderPush.removeAllTags();
      print('removeAllTags Done');
    } on PlatformException {
      print('isReadremoveAllTagsy: error occured');
    }

    try {
        await WonderPush.addProperty("string_value", "foo");
        print('addProperty Done string_value');
        await WonderPush.addProperty("string_values",  ["sport", "entertainment"]);
        print('addProperty Done string_values');
           await WonderPush.addProperty("short_value",  11);
        print('addProperty Done short_value');
        await WonderPush.addProperty("short_values",  [12,13,14]);
        print('addProperty Done short_values');
           await WonderPush.addProperty("byte_value",  1);
        print('addProperty Done byte_value');
        await WonderPush.addProperty("byte_values",  [1,2,3]);
        print('addProperty Done byte_values');
        await WonderPush.addProperty("int_value",  40);
        print('addProperty Done int_value');
        await WonderPush.addProperty("int_values",  [40,50,60]);
        print('addProperty Done int_values');
        await WonderPush.addProperty("long_value",  100);
        print('addProperty Done long_value');
        await WonderPush.addProperty("long_values",  [100,200,300]);
        print('addProperty Done long_values');
         await WonderPush.addProperty("float_value",  100.1);
        print('addProperty Done float_value');
        await WonderPush.addProperty("float_values",  [101.1,200.2,300.3]);
        print('addProperty Done float_values');
         await WonderPush.addProperty("double_value",  1000.1);
        print('addProperty Done double_value');
        await WonderPush.addProperty("double_values",  [1001.1,2000.2,3000.3]);
        print('addProperty Done double_values');
        await WonderPush.addProperty("bool_value",  true);
        print('addProperty Done bool_value');
        await WonderPush.addProperty("bool_values",  [true,false,true]);
        print('addProperty Done bool_values');
        await WonderPush.addProperty("date_value",  '2020-04-14T06:51:57+0000');
        print('addProperty Done date_interests1');
        await WonderPush.addProperty('date_value1', 1586279937000);
        print('addProperty Done date_interests');
    } on PlatformException {
      print('isReadremoveAllTagsy: error occured');
    }

  try {
       await WonderPush.setProperty("string_interests", ["sport", "entertainment"]);
        print('setProperty Done');
    } on PlatformException {
      print('setProperty: error occured');
    }

       try {
       await WonderPush.putProperties({ 'string_interests1': ['sport1', 'test1'] });
       print('putProperties string_interests1 Done');
       await WonderPush.putProperties({ 'int_age1': 40 });
       print('putProperties int_age1 Done');
       await WonderPush.putProperties({ 'int_age2': 40 });
       print('putProperties int_age2 Done');
          await WonderPush.putProperties({ 'geoloc_foo4': { 'lat': 2.9,'lon': 2.8 } });
       print('putProperties int_age2 Done');
       await WonderPush.putProperties({ 'int_age3': 1,
                  'string_foo3': 'bar',
                  'byte_foo3': 1,
                  'short_foo3': 1,
                  'long_foo3': 1,
                  'float_foo3': 1,
                  'double_foo3': 1,
                  'bool_foo3': true,
                  'date_foo3': '2015-10-21T16:29:00-07:00',
                  'date_bar3': 1445470140000,
                  'geoloc_foo3': { 'lat': 1.9,'lon': 1.8 }
              });
        print('putProperties Done');
    } on PlatformException {
      print('putProperties: error occured');
    }

    try {
        result = await WonderPush.getProperties();
        print('getProperties Done. $result');
    } on PlatformException {
      print('getProperties: error occured');
    }

  try {
        result = await WonderPush.getPropertyValue("bool_isCustomer");
        print('getPropertyValue Done. $result');
    } on PlatformException {
      print('getPropertyValue: error occured');
    }

     try {
        result = await WonderPush.getPropertyValues("string_interests");
        print('getPropertyValues Done. $result');
    } on PlatformException {
      print('getPropertyValues: error occured');
    }

    try {
        await WonderPush.removeProperty("string_interests", "sport");
        print('removeProperty Done');
    } on PlatformException {
      print('removeProperty: error occured');
    }

     try {
     await WonderPush.unsetProperty("string_favoritePlayers");
      print('unsetProperty Done.');
    } on PlatformException {
      print('unsetProperty: error occured');
    }

    try {
      result = await WonderPush.getInstallationId();
      print('getInstallationId Done. $result');
    } on PlatformException {
      print('getInstallationId: error occured');
    }

    try {
      result = await WonderPush.getPushToken();
      print('getPushToken Done. $result');
    } on PlatformException {
      print('getPushToken: error occured');
    }

     try {
     await WonderPush.setRequiresUserConsent(true);
      print('setRequiresUserConsent Done.');
    } on PlatformException {
      print('setRequiresUserConsent: error occured');
    }

    try {
     await WonderPush.setUserConsent(true);
      print('setUserConsent Done.');
    } on PlatformException {
      print('setUserConsent: error occured');
    }

  try {
      await WonderPush.disableGeolocation();
      print('disableGeolocation Done.');
    } on PlatformException {
      print('disableGeolocation: error occured');
    }

    try {
      await WonderPush.enableGeolocation();
      print('enableGeolocation Done.');
    } on PlatformException {
      print('enableGeolocation: error occured');
    }

  try {
      await WonderPush.setGeolocation(1.0,1.0);
      print('setGeolocation Done.');
    } on PlatformException {
      print('setGeolocation: error occured');
    }

    try {
      await WonderPush.clearEventsHistory();
      print('clearEventsHistory Done.');
    } on PlatformException {
      print('clearEventsHistory: error occured');
    }

    try {
      await WonderPush.clearPreferences();
      print('clearPreferences Done.');
    } on PlatformException {
      print('clearPreferences: error occured');
    }

    try {
       await WonderPush.clearAllData();
      print('clearAllData Done.');
    } on PlatformException {
      print('clearAllData: error occured');
    }

    // try {
    //   result = await WonderPush.downloadAllData();
    //   print('downloadAllData Done. $result');
    // } on PlatformException {
    //   print('downloadAllData: error occured');
    // }

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
