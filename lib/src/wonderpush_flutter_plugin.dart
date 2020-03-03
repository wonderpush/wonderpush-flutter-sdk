part of wonderpush_flutter_plugin;

class WonderpushFlutterPlugin {
  static const MethodChannel _channel =
      const MethodChannel('wonderpush_flutter_plugin');
  static const EventChannel stream =
      const EventChannel('wonderpush_data_stream');

  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static final CallbackHandle handle =
      PluginUtilities.getCallbackHandle(callbackDispatcher);

  String _clientId;
  String _clientSecret;

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> get name async {
    return Future.value("FlutterWonderPush");
  }

  static Future<bool> initBG() async {
    // final SharedPreferences prefs = await _prefs;
    // String clientId = prefs.getString('clientId');
    // String clientSecret = prefs.getString('clientSecret');
    // String senderId = prefs.getString('userId');

    const String clientId =
        "7b61b48bdaf2bc40da311b96812e3a833c9ee48d"; //set your client id here
    const String clientSecret =
        "08fd5728caa4df728e2deff50bf01466224326f7015c26c7df7ce917523eb305";

    const String senderId = "";
    await init(
        clientId: clientId, clientSecret: clientSecret, senderId: senderId);
  }

  static Future<bool> init(
      {@required String clientId,
      @required String clientSecret,
      String senderId}) async {
    if (clientId == null) {
      throw ArgumentError.notNull('clientId');
    }

    if (clientSecret == null) {
      throw ArgumentError.notNull('clientSecret');
    }

    _channel.invokeMethod<bool>(
      'handleFunction',
      <String, dynamic>{
        'setupHandle': handle.toRawHandle(),
        'backgroundHandle': handle.toRawHandle()
      },
    );

    await _channel.invokeMethod(
        'init', {"clientId": clientId, "clientSecret": clientSecret});

    if (senderId != null && senderId.trim().isNotEmpty) {
      _channel.invokeMethod('setUserId', {"userId": senderId});
    }
    final SharedPreferences prefs = await _prefs;
    prefs.setString("clientId", clientId);
    prefs.setString("clientSecret", clientSecret);
    prefs.setString("userId", senderId);
    return Future.value(true);
  }

  static Future<bool> get isReady async {
    return Future.value(true);
  }

  static Future<String> get accessToken async {
    final String version = await _channel.invokeMethod('getAccessToken');
    return version;
  }

  static Future<String> get delegate async {
    final String version = await _channel.invokeMethod('getDelegate');
    return version;
  }

  static Future<String> get deviceId async {
    final String version = await _channel.invokeMethod('getDeviceId');
    return version;
  }

  static Future<String> get installationCustomProperties async {
    final String version =
        await _channel.invokeMethod('getInstallationCustomProperties');
    return version;
  }

  static Future<String> get installationId async {
    final String version = await _channel.invokeMethod('getInstallationId');
    return version;
  }

  static Future<String> get notificationEnabled async {
    final String version =
        await _channel.invokeMethod('getNotificationEnabled');
    return version;
  }

  static Future<String> get pushToken async {
    final String version = await _channel.invokeMethod('getPushToken');
    return version;
  }

  static Future<String> get userId async {
    final String version = await _channel.invokeMethod('getUserId');
    return version;
  }

  static set logging(bool shouldLog) {
    _channel.invokeMethod('setLogging', {"enabled": shouldLog});

    // code to set logging for wonderpush
  }

  static set userId(String userId) {
    // code to set wonderpush userid
  }

  static Future<dynamic> trackEvent(String type) async {
    return await _channel.invokeMethod('trackEvent', {"eventType": type});
    // code to set wonderpush userid
  }
}
