#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <WonderPush/WonderPush.h>
#import <WonderPushPlugin.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    [WonderPush setLogging:YES];
    // See https://docs.wonderpush.com/docs/flutter-push-notifications#step-2-prepare-your-xcode-project-for-push-notifications
    [WonderPush setClientId:@"REPLACE_WITH_CLIENT_ID" secret:@"REPLACE_WITH_CLIENT_SECRET"];
    [WonderPush setupDelegateForApplication:application];
    [WonderPush setupDelegateForUserNotificationCenter];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}



@end
