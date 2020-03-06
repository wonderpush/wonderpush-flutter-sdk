part of wonderpush_flutter_plugin;

class WonderpushFlutterPlugin {
  factory WonderpushFlutterPlugin() => _instance;
  @visibleForTesting
  WonderpushFlutterPlugin.private(MethodChannel channel) : _channel = channel;

  static final WonderpushFlutterPlugin _instance =
      WonderpushFlutterPlugin.private(
          const MethodChannel('wonderpush_flutter_plugin'));

  final MethodChannel _channel;
  Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<String> get name async {
    return Future.value("FlutterWonderPush");
  }

  Future<bool> init(
      {@required String clientId,
      @required String clientSecret,
      String senderId}) async {
    if (clientId == null) {
      throw ArgumentError.notNull('clientId');
    }

    if (clientSecret == null) {
      throw ArgumentError.notNull('clientSecret');
    }
    await _channel.invokeMethod(
        'init', {"clientId": clientId, "clientSecret": clientSecret});

    if (senderId != null && senderId.trim().isNotEmpty) {
      _channel.invokeMethod('setUserId', {"userId": senderId});
    }
    return Future.value(true);
  }

  static Future<bool> get isReady async {
    return Future.value(true);
  }

  Future<String> get accessToken async {
    final String version = await _channel.invokeMethod('getAccessToken');
    return version;
  }

  Future<String> get delegate async {
    final String version = await _channel.invokeMethod('getDelegate');
    return version;
  }

  Future<String> get deviceId async {
    final String version = await _channel.invokeMethod('getDeviceId');
    return version;
  }

  Future<String> get installationCustomProperties async {
    final String version =
        await _channel.invokeMethod('getInstallationCustomProperties');
    return version;
  }

  Future<String> get installationId async {
    final String version = await _channel.invokeMethod('getInstallationId');
    return version;
  }

  Future<String> get notificationEnabled async {
    final String version =
        await _channel.invokeMethod('getNotificationEnabled');
    return version;
  }

  Future<String> get pushToken async {
    final String version = await _channel.invokeMethod('getPushToken');
    return version;
  }

  final StreamController<String> _tokenStreamController =
      StreamController<String>.broadcast();

  /// Fires when a new FCM token is generated.
  Stream<String> get onTokenRefresh {
    return _tokenStreamController.stream;
  }
  set logging(bool shouldLog) {
    _channel.invokeMethod('setLogging', {"enabled": shouldLog});
  }
  
  Future<dynamic> trackEvent(String type) async {
    return await _channel.invokeMethod('trackEvent', {"eventType": type});
    // code to set wonderpush userid
  }
}
