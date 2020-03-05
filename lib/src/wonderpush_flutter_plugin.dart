part of wonderpush_flutter_plugin;

typedef Future<dynamic> MessageHandler(Map<String, dynamic> message);
void _wpSetupBackgroundChannel(
    {MethodChannel backgroundChannel =
        const MethodChannel('wonderpush_flutter_plugin_bg')}) async {
  // Setup Flutter state needed for MethodChannels.
  WidgetsFlutterBinding.ensureInitialized();

  // This is where the magic happens and we handle background events from the
  // native portion of the plugin.
  backgroundChannel.setMethodCallHandler((MethodCall call) async {
    print(call.arguments);

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
  backgroundChannel.invokeMethod<void>('FcmDartService#initialized');
}

class WonderpushFlutterPlugin {
  factory WonderpushFlutterPlugin() => _instance;
  @visibleForTesting
  WonderpushFlutterPlugin.private(
      MethodChannel channel, Platform platform, EventChannel stream)
      : _channel = channel,
        _platform = platform,
        _stream = stream;

  static final WonderpushFlutterPlugin _instance =
      WonderpushFlutterPlugin.private(
          const MethodChannel('wonderpush_flutter_plugin'),
          const LocalPlatform(),
          const EventChannel('wonderpush_data_stream'));

  final MethodChannel _channel;
  final Platform _platform;
  final EventChannel _stream;
  MessageHandler _onMessage;
  MessageHandler _onBackgroundMessage;
  MessageHandler _onLaunch;
  MessageHandler _onResume;

  /// On iOS, prompts the user for notification permissions the first time
  /// it is called.
  ///
  /// Does nothing and returns null on Android.
  FutureOr<bool> requestNotificationPermissions([
    IosNotificationSettings iosSettings = const IosNotificationSettings(),
  ]) {
    if (!_platform.isIOS) {
      return null;
    }
    return _channel.invokeMethod<bool>(
      'requestNotificationPermissions',
      iosSettings.toMap(),
    );
  }

  final StreamController<IosNotificationSettings> _iosSettingsStreamController =
      StreamController<IosNotificationSettings>.broadcast();

  /// Stream that fires when the user changes their notification settings.
  ///
  /// Only fires on iOS.
  Stream<IosNotificationSettings> get onIosSettingsRegistered {
    return _iosSettingsStreamController.stream;
  }
  // static final CallbackHandle handle =
  //     PluginUtilities.getCallbackHandle(callbackDispatcher);

  String _clientId;
  String _clientSecret;

  Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  EventChannel get stream {
    return _stream;
  }

  Future<String> get name async {
    return Future.value("FlutterWonderPush");
  }

  // Future<bool> initBG() async {
  //   // final SharedPreferences prefs = await _prefs;
  //   // String clientId = prefs.getString('clientId');
  //   // String clientSecret = prefs.getString('clientSecret');
  //   // String senderId = prefs.getString('userId');

  //   const String clientId =
  //       "7b61b48bdaf2bc40da311b96812e3a833c9ee48d"; //set your client id here
  //   const String clientSecret =
  //       "08fd5728caa4df728e2deff50bf01466224326f7015c26c7df7ce917523eb305";

  //   const String senderId = "";
  //   await init(
  //       clientId: clientId, clientSecret: clientSecret, senderId: senderId);
  // }

  void configure({
    MessageHandler onMessage,
    MessageHandler onBackgroundMessage,
    MessageHandler onLaunch,
    MessageHandler onResume,
  }) {
    _onMessage = onMessage;
    _onLaunch = onLaunch;
    _onResume = onResume;
    _channel.setMethodCallHandler(_handleMethod);
    _channel.invokeMethod<void>('configure');

    print("onBackgroundMessage $onBackgroundMessage");
    if (onBackgroundMessage != null) {
      _onBackgroundMessage = onBackgroundMessage;
      final CallbackHandle backgroundSetupHandle =
          PluginUtilities.getCallbackHandle(_wpSetupBackgroundChannel);
      final CallbackHandle backgroundMessageHandle =
          PluginUtilities.getCallbackHandle(_onBackgroundMessage);

      if (backgroundMessageHandle == null) {
        throw ArgumentError(
          '''Failed to setup background message handler! `onBackgroundMessage`
          should be a TOP-LEVEL OR STATIC FUNCTION and should NOT be tied to a
          class or an anonymous function.''',
        );
      }

      _channel.invokeMethod<bool>(
        'FcmDartService#start',
        <String, dynamic>{
          'setupHandle': backgroundSetupHandle.toRawHandle(),
          'backgroundHandle': backgroundMessageHandle.toRawHandle()
        },
      );
    }
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

  /// Returns the FCM token.
  Future<String> getToken() async {
    return await _channel.invokeMethod<String>('getPushToken');
  }

  //  Future<String> get userId async {
  //   final String version = await _channel.invokeMethod('getUserId');
  //   return version;
  // }

  set logging(bool shouldLog) {
    _channel.invokeMethod('setLogging', {"enabled": shouldLog});

    // code to set logging for wonderpush
  }

  set userId(String userId) {
    // code to set wonderpush userid
  }

  Future<dynamic> trackEvent(String type) async {
    return await _channel.invokeMethod('trackEvent', {"eventType": type});
    // code to set wonderpush userid
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    print("Flutter : _handleMethod Start");
    print(call.arguments);
    print("Flutter : _handleMethod End");
    switch (call.method) {
      case "onToken":
        final String token = call.arguments;
        _tokenStreamController.add(token);
        return null;
      case "onIosSettingsRegistered":
        // _iosSettingsStreamController.add(IosNotificationSettings._fromMap(
        //     call.arguments.cast<String, bool>()));
        return null;
      case "onMessage":
        return _onMessage(call.arguments.cast<String, dynamic>());
      case "onLaunch":
        return _onLaunch(call.arguments.cast<String, dynamic>());
      case "onResume":
        return _onResume(call.arguments.cast<String, dynamic>());
      default:
        throw UnsupportedError("Unrecognized JSON message");
    }
  }
}

class IosNotificationSettings {
  const IosNotificationSettings({
    this.sound = true,
    this.alert = true,
    this.badge = true,
    this.provisional = false,
  });

  IosNotificationSettings._fromMap(Map<String, bool> settings)
      : sound = settings['sound'],
        alert = settings['alert'],
        badge = settings['badge'],
        provisional = settings['provisional'];

  final bool sound;
  final bool alert;
  final bool badge;
  final bool provisional;

  @visibleForTesting
  Map<String, dynamic> toMap() {
    return <String, bool>{
      'sound': sound,
      'alert': alert,
      'badge': badge,
      'provisional': provisional
    };
  }

  @override
  String toString() => 'PushNotificationSettings ${toMap()}';
}
