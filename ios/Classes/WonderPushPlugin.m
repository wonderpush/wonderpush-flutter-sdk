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
        if ([@"isReady" isEqualToString:call.method]) {
             result([self isReady]);
         }else if ([@"subscribeToNotifications" isEqualToString:call.method]) {
             [self subscribeToNotifications];
             result(nil);
         }else if ([@"unsubscribeFromNotifications" isEqualToString:call.method]) {
             [self unsubscribeFromNotifications];
             result(nil);
         }else if ([@"isSubscribedToNotifications" isEqualToString:call.method]) {
             result([self isSubscribedToNotifications]);
         }else if ([@"removeAllTags" isEqualToString:call.method]) {
             [self removeAllTags];
             result(nil);
         }else if ([@"hasTag" isEqualToString:call.method]) {
             NSString *tag = [call.arguments valueForKey:@"tag"];
             result([self hasTag:tag]);
         }else if ([@"setCountry" isEqualToString:call.method]) {
              NSString *country = [call.arguments valueForKey:@"country"];
              [self setCountry:country];
              result(nil);
         }else if ([@"getCountry" isEqualToString:call.method]) {
             result([self getCountry]);
         }else if ([@"setCurrency" isEqualToString:call.method]) {
              NSString *currency = [call.arguments valueForKey:@"currency"];
              [self setCurrency:currency];
              result(nil);
         }else if ([@"getCurrency" isEqualToString:call.method]) {
             result([self getCurrency]);
         }else if ([@"setLocale" isEqualToString:call.method]) {
              NSString *locale = [call.arguments valueForKey:@"locale"];
              [self setLocale:locale];
              result(nil);
         }else if ([@"getLocale" isEqualToString:call.method]) {
             result([self getLocale]);
         }else if ([@"setTimeZone" isEqualToString:call.method]) {
              NSString *timeZone = [call.arguments valueForKey:@"timeZone"];
              [self setTimeZone:timeZone];
              result(nil);
         }else if ([@"getTimeZone" isEqualToString:call.method]) {
             result([self getTimeZone]);
         }else if ([@"setUserId" isEqualToString:call.method]) {
             NSString *userId = [call.arguments valueForKey:@"userId"];
             [self setUserId:userId];
             result(nil);
        }else if ([@"getUserId" isEqualToString:call.method]) {
            result([self getUserId]);
        }else if ([@"getInstallationId" isEqualToString:call.method]) {
            result([self getInstallationId]);
        }else if ([@"getPushToken" isEqualToString:call.method]) {
            result([self getPushToken]);
        }else if ([@"setLogging" isEqualToString:call.method]) {
            BOOL enable = [[call.arguments valueForKey:@"enable"] boolValue];
            [self setLogging:enable];
            result(nil);
        } else {
            result(FlutterMethodNotImplemented);
        }
  } @catch (NSError *e) {
      result([FlutterError errorWithCode:@""
                                 message:nil
                                 details:e]);
  }
}

#pragma mark - Initialization	

-(id)isReady{
    BOOL status = [WonderPush isReady];
    return [NSNumber numberWithBool:status];
}

#pragma mark - Subscribing users

-(void)subscribeToNotifications{
   [WonderPush subscribeToNotifications];
}

-(void)unsubscribeFromNotifications{
    [WonderPush unsubscribeFromNotifications];
}

-(id)isSubscribedToNotifications{
   BOOL status =  [WonderPush isSubscribedToNotifications];
   return [NSNumber numberWithBool:status];
}

#pragma mark - Segmentation	

-(void)removeAllTags{
    [WonderPush removeAllTags];
}

-(id)hasTag:(NSString *)tag{
   BOOL status =  [WonderPush hasTag:tag];
   return [NSNumber numberWithBool:status];
}

-(id)getCountry{
   NSString *country = [WonderPush country];
   return country;
}

-(void)setCountry:(NSString *)country{
   [WonderPush setCountry:country];
}

-(id)getCurrency{
   NSString *currency = [WonderPush currency];
   return currency;
}

-(void)setCurrency:(NSString *)currency{
   [WonderPush setCurrency:currency];
}

-(id)getLocale{
   NSString *locale = [WonderPush locale];
   return locale;
}

-(void)setLocale:(NSString *)locale{
   [WonderPush setLocale:locale];
}

-(id)getTimeZone{
   NSString *timeZone = [WonderPush timeZone];
   return timeZone;
}

-(void)setTimeZone:(NSString *)timeZone{
   [WonderPush setTimeZone:timeZone];
}


#pragma mark - User IDs	

-(void)setUserId:(NSString *)userId{
   [WonderPush setUserId:userId];
}

-(NSString *)getUserId{
   NSString *userId = [WonderPush userId];
   return userId;
}

#pragma mark - Installation info

-(NSString *)getInstallationId{
   NSString *installationId = [WonderPush installationId];
   return installationId;
}

-(NSString *)getPushToken{
   NSString *pushToken = [WonderPush pushToken];
   return pushToken;
}

#pragma mark - Debug

-(void)setLogging:(BOOL) enable{
    [WonderPush setLogging:enable];
}

@end
