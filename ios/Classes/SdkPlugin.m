#import "SdkPlugin.h"
#import "WonderPush.h"
@implementation SdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"sdk"
            binaryMessenger:[registrar messenger]];
  SdkPlugin* instance = [[SdkPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
  [WonderPush setIntegrator:@"flutter-wonderpush-1.0.0"];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([self getPlatformVersion]);
  } else if ([@"setLogging" isEqualToString:call.method]) {
      BOOL enable = [[call.arguments valueForKey:@"enable"] boolValue];
      result([self setLogging:enable]);
  }else if ([@"subscribeToNotifications" isEqualToString:call.method]) {
      result([self subscribeToNotifications]);
  }else if ([@"unsubscribeFromNotifications" isEqualToString:call.method]) {
      result([self unsubscribeFromNotifications]);
  }else if ([@"isSubscribedToNotifications" isEqualToString:call.method]) {
      result([self isSubscribedToNotifications]);
  }else if ([@"setUserId" isEqualToString:call.method]) {
      NSString *userId = [call.arguments valueForKey:@"userId"];
      result([self setUserId:userId]);
  }else if ([@"getUserId" isEqualToString:call.method]) {
      result([self getUserId]);
  } else {
      result(FlutterMethodNotImplemented);
  }
}

-(NSString *)getPlatformVersion{
  return [@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]];
}

-(id)setLogging:(BOOL) enable{
  @try {
        [WonderPush setLogging:enable];
        return nil;
    } @catch (NSError *e) {
        return e;
    }
}

-(id)subscribeToNotifications{
   @try {
        [WonderPush subscribeToNotifications];
        return nil;
    } @catch (NSError *e) {
        return e;
    }
}

-(id)unsubscribeFromNotifications{
    @try {
        [WonderPush unsubscribeFromNotifications];
        return nil;
    } @catch (NSError *e) {
        return e;
    }
}

-(id)isSubscribedToNotifications{
   @try {
        BOOL status =  [WonderPush isSubscribedToNotifications];
        return [NSNumber numberWithBool:status];
    } @catch (NSError *e) {
        return false;
    }
}

-(id)setUserId:(NSString *)userId{
   @try {
        [WonderPush setUserId:userId];
        return nil;
    } @catch (NSError *e) {
        return false;
    }
}

-(id)getUserId{
   @try {
        NSString *userId = [WonderPush userId];
        return userId;
    } @catch (NSError *e) {
        return false;
    }
}

@end
