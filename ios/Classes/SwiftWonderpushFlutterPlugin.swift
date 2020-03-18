import Flutter
import UIKit
import WonderPush

public class SwiftWonderpushFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "wonderpush_flutter_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftWonderpushFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
    switch call.method  {
        
    case "init":
       
        if let arguments = call.arguments as? [String:Any],let clientId = arguments["clientId"] as? String, let clientSecret = arguments["clientSecret"] as? String{
            WonderPush.setClientId(clientId, secret: clientSecret)
           
             WonderPush.setupDelegateForUserNotificationCenter()
            result("Wonderpush initalized successfully");
        }else{
            result("Wonderpush initalized failed due to data mismatch datatype");
        }
    case "trackEvent":
        if let arguments = call.arguments as? [String:Any],let eventType = arguments["eventType"] as? String{
            WonderPush.trackEvent(eventType)
            WonderPush.subscribeToNotifications()
            result("Subscribed to event "+eventType+"successfully")
        }

    default:
        result("iOS " + UIDevice.current.systemVersion)
        
    }
  }
    
    
    
}
