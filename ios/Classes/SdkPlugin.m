#import "SdkPlugin.h"
#import "WonderPush.h"
@implementation SdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"sdk"
            binaryMessenger:[registrar messenger]];
  SdkPlugin* instance = [[SdkPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([self getPlatformVersion]);
  } else if ([@"setLogging" isEqualToString:call.method]) {
      BOOL enable = [[call.arguments valueForKey:@"enable"] boolValue];
      result([self setLogging:enable]);
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
@end
