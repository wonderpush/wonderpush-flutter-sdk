import Flutter
import UIKit
import WonderPush

public class SwiftWonderpushFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "wonderpush_flutter_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftWonderpushFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    
     NotificationCenter.default.addObserver(self, selector: #selector(registerApns), name: NSNotification.Name(rawValue: "RegisterNotification"), object: nil)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
    switch call.method  {
        
    case "init":
       
        if let arguments = call.arguments as? [String:Any],let clientId = arguments["clientId"] as? String, let clientSecret = arguments["clientSecret"] as? String{
            WonderPush.setClientId(clientId, secret: clientSecret)
            WonderPush.setupDelegate(for: UIApplication.shared)
             WonderPush.setupDelegateForUserNotificationCenter()
            result("Wonderpush initalized successfully");
        }else{
            result("Wonderpush initalized failed due to data mismatch datatype");
        }
    case "trackEvent":
        if let arguments = call.arguments as? [String:Any],let eventType = arguments["eventType"] as? String{
            WonderPush.trackEvent(eventType, attributes:nil)
            WonderPush.subscribeToNotifications()
            result("Subscribed to event "+eventType+"successfully")
        }

    default:
        result("iOS " + UIDevice.current.systemVersion)
        
    }
  }
    
    
    //MARK:- registerApns
    @objc func registerApns()
    {
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.

        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound, .badge]) {
            [weak self] granted, error in
            
            print("Permission granted: \(granted)")
            guard granted else {
                return
            }
           // WonderPushHandler.subscribe()
            self?.getNotificationSettings()
        }

    }
    
    func getNotificationSettings() {
           UNUserNotificationCenter.current().getNotificationSettings { settings in
               guard settings.authorizationStatus == .authorized else { return }
               DispatchQueue.main.async {
                   UIApplication.shared.registerForRemoteNotifications()
               }
           }
       }
    

    //MARK:- AppDelegate

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {

        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.

        // Print full message.
        print(userInfo)

    }
    
    //MARK: Notification Methods-
    public func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        let token =  deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("Device Token: \(token)")//print device token in debugger console
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        NSLog("User Info : %@",notification.request.content.userInfo)

        if UIApplication.shared.applicationState == .active {
            completionHandler([.alert, .badge, .sound])
        }
    }

    // Receive displayed notifications for iOS 10 devices.
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive resRPUsernse: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        let userInfo = resRPUsernse.notification.request.content.userInfo
        NSLog("User Info : %@",userInfo)

        completionHandler()
    }
}
