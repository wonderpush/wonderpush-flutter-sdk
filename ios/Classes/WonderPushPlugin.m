#import "WonderPushPlugin.h"
#import "WonderPush.h"
@interface WonderPushPlugin()<WonderPushDelegate>


@end
static FlutterMethodChannel *methodChannel = nil;
static WonderPushPlugin *plugInInstace = nil;

@implementation WonderPushPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [WonderPush setIntegrator:@"wonderpush_flutter-1.0.0"];
    plugInInstace = [[WonderPushPlugin alloc] init];
    methodChannel = [FlutterMethodChannel
        methodChannelWithName:@"wonderpush_flutter"
              binaryMessenger:[registrar messenger]];
    [registrar addMethodCallDelegate:plugInInstace channel:methodChannel];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:WP_NOTIFICATION_OPENED_BROADCAST object:nil queue:nil usingBlock:^(NSNotification *note) {
        NSDictionary *pushNotification = note.userInfo;
        dispatch_async(dispatch_get_main_queue(), ^{
              [methodChannel invokeMethod:@"wonderPushReceivedPushNotification" arguments:pushNotification];
         });
    }];
}

+(void)setupWonderPushDelegate{
    [WonderPush setDelegate:plugInInstace];
}

- (void) wonderPushWillOpenURL:(NSURL *)URL withCompletionHandler:(void (^)(NSURL *))completionHandler {
  dispatch_async(dispatch_get_main_queue(), ^{
       [methodChannel invokeMethod:@"wonderPushWillOpenURL" arguments:[URL absoluteString]];
      completionHandler(URL);
  });
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
         }else if ([@"trackEvent" isEqualToString:call.method]) {
             NSString *type = [call.arguments valueForKey:@"type"];
             id attributes = [call.arguments valueForKey:@"attributes"];
             [self trackEvent:type attributes:attributes];
             result(nil);
         }else if ([@"addTag" isEqualToString:call.method]) {
             NSArray *tags = [call.arguments valueForKey:@"tags"];
             [self addTag:tags];
             result(nil);
         }else if ([@"removeTag" isEqualToString:call.method]) {
             NSArray *tags = [call.arguments valueForKey:@"tags"];
             [self removeTag:tags];
             result(nil);
         }else if ([@"removeAllTags" isEqualToString:call.method]) {
             [self removeAllTags];
             result(nil);
         }else if ([@"hasTag" isEqualToString:call.method]) {
             NSString *tag = [call.arguments valueForKey:@"tag"];
             result([self hasTag:tag]);
         }else if ([@"getTags" isEqualToString:call.method]) {
             result([self getTags]);
         }else if ([@"addProperty" isEqualToString:call.method]) {
            NSString *property = [call.arguments valueForKey:@"property"];
            id properties = [call.arguments valueForKey:@"properties"];
             [self addProperty:property properties:properties];
             result(nil);
         }else if ([@"removeProperty" isEqualToString:call.method]) {
            NSString *property = [call.arguments valueForKey:@"property"];
            id properties = [call.arguments valueForKey:@"properties"];
             [self removeProperty:property properties:properties];
             result(nil);
         }else if ([@"setProperty" isEqualToString:call.method]) {
            NSString *property = [call.arguments valueForKey:@"property"];
            id properties = [call.arguments valueForKey:@"properties"];
             [self setProperty:property properties:properties];
             result(nil);
         }else if ([@"putProperties" isEqualToString:call.method]) {
            id properties = [call.arguments valueForKey:@"properties"];
             [self putProperties:properties];
             result(nil);
         }else if ([@"getProperties" isEqualToString:call.method]) {
             result([self getProperties]);
         }else if ([@"getPropertyValue" isEqualToString:call.method]) {
             NSString *property = [call.arguments valueForKey:@"property"];
             result([self getPropertyValue:property]);
         }else if ([@"getPropertyValues" isEqualToString:call.method]) {
             NSString *property = [call.arguments valueForKey:@"property"];
             result([self getPropertyValues:property]);
         }else if ([@"unsetProperty" isEqualToString:call.method]) {
             NSString *property = [call.arguments valueForKey:@"property"];
             [self unsetProperty:property];
             result(nil);
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
        }else if ([@"setRequiresUserConsent" isEqualToString:call.method]) {
            BOOL isConsent = [[call.arguments valueForKey:@"isConsent"] boolValue];
            [self setRequiresUserConsent:isConsent];
            result(nil);
        }else if ([@"setUserConsent" isEqualToString:call.method]) {
            BOOL isConsent = [[call.arguments valueForKey:@"isConsent"] boolValue];
            [self setUserConsent:isConsent];
            result(nil);
        }else if ([@"disableGeolocation" isEqualToString:call.method]) {
            [self disableGeolocation];
            result(nil);
        }else if ([@"enableGeolocation" isEqualToString:call.method]) {
            [self enableGeolocation];
            result(nil);
        }else if ([@"setGeolocation" isEqualToString:call.method]) {
            double lat = [[call.arguments valueForKey:@"lat"] doubleValue];
            double lon = [[call.arguments valueForKey:@"lon"] doubleValue];
            [self setGeolocation:lat lon:lon];
            result(nil);
        }else if ([@"clearEventsHistory" isEqualToString:call.method]) {
            [self clearEventsHistory];
            result(nil);
        }else if ([@"clearPreferences" isEqualToString:call.method]) {
            [self clearPreferences];
            result(nil);
        }else if ([@"clearAllData" isEqualToString:call.method]) {
            [self clearAllData];
            result(nil);
        }else if ([@"downloadAllData" isEqualToString:call.method]) {
            [self downloadAllData:result];
        }else if ([@"setLogging" isEqualToString:call.method]) {
            BOOL enable = [[call.arguments valueForKey:@"enable"] boolValue];
            [self setLogging:enable];
            result(nil);
        } else {
            result(FlutterMethodNotImplemented);
        }
  } @catch (NSError *e) {
      NSString *code = [NSString stringWithFormat:@"%ld", e.code];
      result([FlutterError errorWithCode:code
                                 message:e.localizedDescription
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

-(void)trackEvent:(NSString *)type attributes:(NSDictionary *)attributes{
   [WonderPush trackEvent:type attributes:attributes];
}

-(void)addTag:(NSArray *)tags{
    [WonderPush addTags:tags];
}

-(void)removeTag:(NSArray *)tags{
    [WonderPush removeTags:tags];
}

-(void)removeAllTags{
    [WonderPush removeAllTags];
}

-(id)hasTag:(NSString *)tag{
   BOOL status =  [WonderPush hasTag:tag];
   return [NSNumber numberWithBool:status];
}

- (id)getTags{
    NSOrderedSet<NSString*> *tags = [WonderPush getTags];
    NSArray *arrTags = [NSArray arrayWithArray:[tags array]];
    return arrTags;
}
//
-(id)getPropertyValue:(NSString *)property{
    id value = [WonderPush getPropertyValue:property];
    return value;
}

-(NSArray *)getPropertyValues:(NSString *)property{
    NSArray *values  = [WonderPush getPropertyValues:property];
    return values;
}

-(void)addProperty:(NSString *)property properties:(id)properties{
    [WonderPush addProperty:property value:properties];
}

-(void)removeProperty:(NSString *)property properties:(id)properties{
    [WonderPush removeProperty:property value:properties];
}

-(void)setProperty:(NSString *)property properties:(id)properties{
    [WonderPush setProperty:property value:properties];
}

-(void)unsetProperty:(NSString *)property{
   [WonderPush unsetProperty:property];
}

-(void)putProperties:(NSDictionary *)properties{
   [WonderPush putProperties:properties];
}

-(NSDictionary *)getProperties{
   NSDictionary *properties = [WonderPush getProperties];
   return properties;
}
//
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

#pragma mark - Privacy

-(void)setRequiresUserConsent:(BOOL)isConsent{
    [WonderPush setRequiresUserConsent:isConsent];
}

-(void)setUserConsent:(BOOL)isConsent{
    [WonderPush setUserConsent:isConsent];
}

-(void)disableGeolocation{
    [WonderPush disableGeolocation];
}

-(void)enableGeolocation{
    [WonderPush enableGeolocation];
}

-(void)setGeolocation:(double)lat lon:(double)lon{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    [WonderPush setGeolocation:location];
}

-(void)clearEventsHistory{
    [WonderPush clearEventsHistory];
}

-(void)clearPreferences{
    [WonderPush clearPreferences];
}

-(void)clearAllData{
    [WonderPush clearAllData];
}

-(void)downloadAllData:(FlutterResult)result{
     [WonderPush downloadAllData:^(NSData *data, NSError *error) {
         if (error) {
             @throw error;
         }
         result(data);
     }];
}

#pragma mark - Debug

-(void)setLogging:(BOOL) enable{
    [WonderPush setLogging:enable];
}




@end
