#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import <WonderPush/WonderPush.h>
#import <WonderPushPlugin.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  [WonderPush setLogging:YES];
    [WonderPush setClientId:@"fd49eef17401e6b2916e9101fa48c9c2f15ec330" secret:@"fd9b63c4c77c9a66d00aa64e5aed8d25e8ccb510e96baff8b08a8a980777e1c6"];
    [WonderPush setupDelegateForApplication:application];
    [WonderPush setupDelegateForUserNotificationCenter];
  // Override point for customization after application launch.
    
    [NSTimer scheduledTimerWithTimeInterval:30.0
    target:self
    selector:@selector(testEventExpose)
    userInfo:nil
    repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:60.0
     target:self
     selector:@selector(testDelegetExpose)
     userInfo:nil
     repeats:NO];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}


-(void)testEventExpose{
    NSLog(@"testEventExpose");
}
-(void)testDelegetExpose{
    NSLog(@"testDelegetExpose");
}
@end
