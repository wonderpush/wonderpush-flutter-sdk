#import "WonderPushPlugin.h"
#import "WonderPush.h"

@implementation WonderPushPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [WonderPush setIntegrator:@"wonderpush_flutter-1.0.0"];
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"wonderpushflutter"
            binaryMessenger:[registrar messenger]];
  WonderPushPlugin* instance = [[WonderPushPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
 @try {
         if ([@"setLogging" isEqualToString:call.method]) {
            BOOL enable = [[call.arguments valueForKey:@"enable"] boolValue];
            [self setLogging:enable];
            result(nil);
         }else if ([@"subscribeToNotifications" isEqualToString:call.method]) {
             [self subscribeToNotifications];
             result(nil);
         }else if ([@"unsubscribeFromNotifications" isEqualToString:call.method]) {
             [self unsubscribeFromNotifications];
             result(nil);
         }else if ([@"isSubscribedToNotifications" isEqualToString:call.method]) {
             [self isSubscribedToNotifications];
             result(nil);
         }else if ([@"setUserId" isEqualToString:call.method]) {
             NSString *userId = [call.arguments valueForKey:@"userId"];
             [self setUserId:userId];
             result(nil);
        }else if ([@"getUserId" isEqualToString:call.method]) {
            result([self getUserId]);
        } else {
            result(FlutterMethodNotImplemented);
        }
  } @catch (NSError *e) {
      result([FlutterError errorWithCode:@""
                                 message:nil
                                 details:e]);
  }
}

-(void)setLogging:(BOOL) enable{
    [WonderPush setLogging:enable];
}

-(void)subscribeToNotifications{
   [WonderPush subscribeToNotifications];
}

-(void)unsubscribeFromNotifications{
    [WonderPush unsubscribeFromNotifications];
}

-(BOOL)isSubscribedToNotifications{
   BOOL status =  [WonderPush isSubscribedToNotifications];
   return [NSNumber numberWithBool:status];
}

-(void)setUserId:(NSString *)userId{
   [WonderPush setUserId:userId];
}

-(NSString *)getUserId{
   NSString *userId = [WonderPush userId];
   return userId;
}

@end
