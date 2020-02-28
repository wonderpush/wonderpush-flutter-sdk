part of wonderpush_flutter_plugin;

typedef CallbackHandle _GetCallbackHandle(
    Function(String, String, String) callback);

class WonderpushFlutterPlugin {
  static const MethodChannel _channel =
      const MethodChannel('wonderpush_flutter_plugin');
  static const EventChannel stream =
      const EventChannel('wonderpush_data_stream');

  String _clientId;
  String _clientSecret;

  static _GetCallbackHandle _getCallbackHandle =
      (Function callback) => PluginUtilities.getCallbackHandle(callback);

  static Future<bool> initialize(final String clientId,
      final String clientSecret, final String senderId) async {
    final CallbackHandle handle = _getCallbackHandle(
        _wpSetupBackgroundChannel(clientId, clientSecret, senderId));
    if (handle == null) {
      return false;
    }
    final bool r = await _channel.invokeMethod<bool>(
        'AlarmService.start', <dynamic>[handle.toRawHandle()]);
    return r ?? false;
  }

  static _wpSetupBackgroundChannel(
      String clientId, String clientSecret, String senderId) async {
    // Setup Flutter state needed for MethodChannels.
    WidgetsFlutterBinding.ensureInitialized();
    _channel.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'handleBackgroundMessage') {
        final CallbackHandle handle =
            CallbackHandle.fromRawHandle(call.arguments['handle']);
        final Function handlerFunction =
            PluginUtilities.getCallbackFromHandle(handle);
        try {
          await handlerFunction(
              Map<String, dynamic>.from(call.arguments['message']));
        } catch (e) {
          print('Unable to handle incoming background message.');
          print(e);
        }
        return Future<void>.value();
      }
    });

    // This is where the magic happens and we handle background events from the
    // native portion of the plugin.

    // Once we've finished initializing, let the native portion of the plugin
    // know that it can start scheduling handling messages.
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> get name async {
    return Future.value("FlutterWonderPush");
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
