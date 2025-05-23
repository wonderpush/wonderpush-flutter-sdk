#import "WonderPushPlugin.h"
#import "WonderPush.h"

@interface WPFlutterCallback : NSObject
@property (nonatomic, strong) NSString *method;
@property (nonatomic, strong) id arguments;
- (instancetype) initWithMethod:(NSString *)method arguments:(id)arguments;
@end


@interface WonderPushPlugin() <WonderPushDelegate>
@property (nonatomic, strong) NSMutableArray<WPFlutterCallback *> *pendingFlutterCallbacks;
@property (nonatomic, assign) BOOL flutterDelegateRegistered;
- (void) savePendingCallbackWithMethod:(NSString *)method arguments:(id)arguments;
- (void) drainPendingFlutterCallbacks;
@end

@implementation WPFlutterCallback

- (instancetype)initWithMethod:(NSString *)method arguments:(id)arguments {
    if (self = [super init]) {
        self.method = method;
        self.arguments = arguments;
    }
    return self;
}

@end

static FlutterMethodChannel *methodChannel = nil;
static WonderPushPlugin *pluginInstance = nil;

@implementation WonderPushPlugin

+ (void) prepare {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pluginInstance = [[WonderPushPlugin alloc] init];
        [WonderPush setDelegate:pluginInstance];
#if DEBUG
        NSLog(@"[WonderPushPlugin] Delegate registered");
#endif
    });
}

+ (void)initialize {
    [self prepare];
}

+ (void) registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
#if DEBUG
    NSLog(@"[WonderPushPlugin] registerWithRegistrar");
#endif
    [WonderPush setIntegrator:@"wonderpush_flutter-2.4.0"];
    methodChannel = [FlutterMethodChannel
                     methodChannelWithName:@"wonderpush_flutter"
                     binaryMessenger:[registrar messenger]];
    [registrar addMethodCallDelegate:pluginInstance channel:methodChannel];
}

- (instancetype)init {
    if (self = [super init]) {
        self.pendingFlutterCallbacks = [NSMutableArray new];
    }
    return self;
}

- (void)drainPendingFlutterCallbacks {
#if DEBUG
    NSLog(@"[WonderPushPlugin] drainPendingFlutterCallbacks");
#endif
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized (self) {
            for (WPFlutterCallback *callback in self.pendingFlutterCallbacks) {
                [methodChannel invokeMethod:callback.method arguments:callback.arguments];
            }
            [self.pendingFlutterCallbacks removeAllObjects];
        }
    });
}

- (void)savePendingCallbackWithMethod:(NSString *)method arguments:(id)arguments {
    WPFlutterCallback *callback = [[WPFlutterCallback alloc] initWithMethod:method arguments:arguments];
    @synchronized (self) {
        [self.pendingFlutterCallbacks addObject:callback];
    }
}

- (void) onNotificationReceived:(NSDictionary *)notification {
#if DEBUG
    NSLog(@"[WonderPushPlugin] onNotificationReceived: %@", notification);
#endif
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:notification options:NSJSONWritingPrettyPrinted error:&error];
    if (jsonData) {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *method = @"onNotificationReceived";
        id arguments = jsonString;
        if (self.flutterDelegateRegistered && methodChannel) {
            dispatch_async(dispatch_get_main_queue(), ^{
#if DEBUG
                NSLog(@"[WonderPushPlugin] onNotificationReceived: calling back flutter layer");
#endif
                [methodChannel invokeMethod:method arguments:arguments];
            });
        } else {
#if DEBUG
            NSLog(@"[WonderPushPlugin] onNotificationReceived: delegate is not ready, saving for later");
#endif
            [self savePendingCallbackWithMethod:method arguments:arguments];
        }
    } else {
        NSLog(@"[WonderPushPlugin] Error converting dictionary to JSON: %@", error);
    }
}

- (void) onNotificationOpened:(NSDictionary *)notification withButton:(NSInteger)buttonIndex {
#if DEBUG
    NSLog(@"[WonderPushPlugin] onNotificationOpened: %@", notification);
#endif
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:notification options:NSJSONWritingPrettyPrinted error:&error];
    if (jsonData) {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *method = @"onNotificationOpened";
        id arguments = @[jsonString, @(buttonIndex)];
        if (self.flutterDelegateRegistered && methodChannel) {
            dispatch_async(dispatch_get_main_queue(), ^{
#if DEBUG
                NSLog(@"[WonderPushPlugin] onNotificationOpened: calling back flutter layer");
#endif
                [methodChannel invokeMethod:method arguments:arguments];
            });
        } else {
#if DEBUG
            NSLog(@"[WonderPushPlugin] onNotificationOpened: delegate is not ready, saving for later");
#endif
            [self savePendingCallbackWithMethod:method arguments:arguments];
        }
    } else {
        NSLog(@"[WonderPushPlugin] Error converting dictionary to JSON: %@", error);
    }
}

- (void) handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
#if DEBUG
            NSLog(@"[WonderPushPlugin] handleMethodCall: %@", call.method);
#endif
    @try {
        if ([@"subscribeToNotifications" isEqualToString:call.method]) {
            [self subscribeToNotifications];
            result(nil);
        } else if ([@"setFlutterDelegate" isEqualToString:call.method]) {
            self.flutterDelegateRegistered = YES;
            [self drainPendingFlutterCallbacks];
            result(nil);
        } else if ([@"unsubscribeFromNotifications" isEqualToString:call.method]) {
            [self unsubscribeFromNotifications];
            result(nil);
        } else if ([@"isSubscribedToNotifications" isEqualToString:call.method]) {
            result([self isSubscribedToNotifications]);
        } else if ([@"trackEvent" isEqualToString:call.method]) {
            NSString *type = [call.arguments valueForKey:@"type"];
            id attributes = [call.arguments valueForKey:@"attributes"];
            [self trackEvent:type attributes:attributes];
            result(nil);
        } else if ([@"addTag" isEqualToString:call.method]) {
            NSArray *tags = [call.arguments valueForKey:@"tags"];
            [self addTag:tags];
            result(nil);
        } else if ([@"removeTag" isEqualToString:call.method]) {
            NSArray *tags = [call.arguments valueForKey:@"tags"];
            [self removeTag:tags];
            result(nil);
        } else if ([@"removeAllTags" isEqualToString:call.method]) {
            [self removeAllTags];
            result(nil);
        } else if ([@"hasTag" isEqualToString:call.method]) {
            NSString *tag = [call.arguments valueForKey:@"tag"];
            result([self hasTag:tag]);
        } else if ([@"getTags" isEqualToString:call.method]) {
            result([self getTags]);
        } else if ([@"addProperty" isEqualToString:call.method]) {
            NSString *property = [call.arguments valueForKey:@"property"];
            id properties = [call.arguments valueForKey:@"properties"];
            [self addProperty:property properties:properties];
            result(nil);
        } else if ([@"removeProperty" isEqualToString:call.method]) {
            NSString *property = [call.arguments valueForKey:@"property"];
            id properties = [call.arguments valueForKey:@"properties"];
            [self removeProperty:property properties:properties];
            result(nil);
        } else if ([@"setProperty" isEqualToString:call.method]) {
            NSString *property = [call.arguments valueForKey:@"property"];
            id properties = [call.arguments valueForKey:@"properties"];
            [self setProperty:property properties:properties];
            result(nil);
        } else if ([@"putProperties" isEqualToString:call.method]) {
            id properties = [call.arguments valueForKey:@"properties"];
            [self putProperties:properties];
            result(nil);
        } else if ([@"getProperties" isEqualToString:call.method]) {
            result([self getProperties]);
        } else if ([@"getPropertyValue" isEqualToString:call.method]) {
            NSString *property = [call.arguments valueForKey:@"property"];
            result([self getPropertyValue:property]);
        } else if ([@"getPropertyValues" isEqualToString:call.method]) {
            NSString *property = [call.arguments valueForKey:@"property"];
            result([self getPropertyValues:property]);
        } else if ([@"unsetProperty" isEqualToString:call.method]) {
            NSString *property = [call.arguments valueForKey:@"property"];
            [self unsetProperty:property];
            result(nil);
        } else if ([@"setCountry" isEqualToString:call.method]) {
            NSString *country = [call.arguments valueForKey:@"country"];
            [self setCountry:country];
            result(nil);
        } else if ([@"getCountry" isEqualToString:call.method]) {
            result([self getCountry]);
        } else if ([@"setCurrency" isEqualToString:call.method]) {
            NSString *currency = [call.arguments valueForKey:@"currency"];
            [self setCurrency:currency];
            result(nil);
        } else if ([@"getCurrency" isEqualToString:call.method]) {
            result([self getCurrency]);
        } else if ([@"setLocale" isEqualToString:call.method]) {
            NSString *locale = [call.arguments valueForKey:@"locale"];
            [self setLocale:locale];
            result(nil);
        } else if ([@"getLocale" isEqualToString:call.method]) {
            result([self getLocale]);
        } else if ([@"setTimeZone" isEqualToString:call.method]) {
            NSString *timeZone = [call.arguments valueForKey:@"timeZone"];
            [self setTimeZone:timeZone];
            result(nil);
        } else if ([@"getTimeZone" isEqualToString:call.method]) {
            result([self getTimeZone]);
        } else if ([@"setUserId" isEqualToString:call.method]) {
            NSString *userId = [call.arguments valueForKey:@"userId"];
            [self setUserId:userId];
            result(nil);
        } else if ([@"getUserId" isEqualToString:call.method]) {
            result([self getUserId]);
        } else if ([@"getInstallationId" isEqualToString:call.method]) {
            result([self getInstallationId]);
        } else if ([@"getDeviceId" isEqualToString:call.method]) {
            result([self getDeviceId]);
        } else if ([@"getAccessToken" isEqualToString:call.method]) {
            result([self getAccessToken]);
        } else if ([@"getUserConsent" isEqualToString:call.method]) {
            result([self getUserConsent]);
        } else if ([@"getPushToken" isEqualToString:call.method]) {
            result([self getPushToken]);
        } else if ([@"setRequiresUserConsent" isEqualToString:call.method]) {
            BOOL isConsent = [[call.arguments valueForKey:@"isConsent"] boolValue];
            [self setRequiresUserConsent:isConsent];
            result(nil);
        } else if ([@"setUserConsent" isEqualToString:call.method]) {
            BOOL isConsent = [[call.arguments valueForKey:@"isConsent"] boolValue];
            [self setUserConsent:isConsent];
            result(nil);
        } else if ([@"disableGeolocation" isEqualToString:call.method]) {
            [self disableGeolocation];
            result(nil);
        } else if ([@"enableGeolocation" isEqualToString:call.method]) {
            [self enableGeolocation];
            result(nil);
        } else if ([@"setGeolocation" isEqualToString:call.method]) {
            double lat = [[call.arguments valueForKey:@"lat"] doubleValue];
            double lon = [[call.arguments valueForKey:@"lon"] doubleValue];
            [self setGeolocation:lat lon:lon];
            result(nil);
        } else if ([@"clearEventsHistory" isEqualToString:call.method]) {
            [self clearEventsHistory];
            result(nil);
        } else if ([@"clearPreferences" isEqualToString:call.method]) {
            [self clearPreferences];
            result(nil);
        } else if ([@"clearAllData" isEqualToString:call.method]) {
            [self clearAllData];
            result(nil);
        } else if ([@"downloadAllData" isEqualToString:call.method]) {
            [self downloadAllData];
            result(nil);
        } else if ([@"setLogging" isEqualToString:call.method]) {
            BOOL enable = [[call.arguments valueForKey:@"enable"] boolValue];
            [self setLogging:enable];
            result(nil);
        } else if ([@"isInitialized" isEqualToString:call.method]) {
            result([self isInitialized]);
        } else {
            result(FlutterMethodNotImplemented);
        }
    } @catch (NSError *e) {
        NSString *code = [NSString stringWithFormat:@"%ld", e.code];
        result([FlutterError errorWithCode:code
                                   message:e.localizedDescription
                                   details:e.userInfo]);
    }
}

-(id) isInitialized {
    BOOL initialized =  [WonderPush isInitialized];
    return [NSNumber numberWithBool:initialized];
}

#pragma mark - Subscribing users

-(void) subscribeToNotifications {
    [WonderPush subscribeToNotifications];
}

-(void) unsubscribeFromNotifications {
    [WonderPush unsubscribeFromNotifications];
}

-(id) isSubscribedToNotifications {
    BOOL status =  [WonderPush isSubscribedToNotifications];
    return [NSNumber numberWithBool:status];
}

#pragma mark - Segmentation

-(void) trackEvent:(NSString *)type attributes:(NSDictionary *)attributes {
    [WonderPush trackEvent:type attributes:attributes];
}

-(void) addTag:(NSArray *)tags {
    [WonderPush addTags:tags];
}

-(void) removeTag:(NSArray *)tags {
    [WonderPush removeTags:tags];
}

-(void) removeAllTags {
    [WonderPush removeAllTags];
}

-(id) hasTag:(NSString *)tag {
    BOOL status =  [WonderPush hasTag:tag];
    return [NSNumber numberWithBool:status];
}

- (id) getTags {
    NSOrderedSet<NSString*> *tags = [WonderPush getTags];
    NSArray *arrTags = [NSArray arrayWithArray:[tags array]];
    return arrTags;
}

-(id) getPropertyValue:(NSString *)property {
    id value = [WonderPush getPropertyValue:property];
    return value;
}

-(NSArray *) getPropertyValues:(NSString *)property {
    NSArray *values  = [WonderPush getPropertyValues:property];
    return values;
}

-(void) addProperty:(NSString *)property properties:(id)properties {
    [WonderPush addProperty:property value:properties];
}

-(void) removeProperty:(NSString *)property properties:(id)properties {
    [WonderPush removeProperty:property value:properties];
}

-(void) setProperty:(NSString *)property properties:(id)properties {
    [WonderPush setProperty:property value:properties];
}

-(void) unsetProperty:(NSString *)property {
    [WonderPush unsetProperty:property];
}

-(void) putProperties:(NSDictionary *)properties {
    [WonderPush putProperties:properties];
}

-(NSDictionary *) getProperties {
    NSDictionary *properties = [WonderPush getProperties];
    return properties;
}

-(id) getCountry {
    NSString *country = [WonderPush country];
    return country;
}

-(void) setCountry:(NSString *)country {
    [WonderPush setCountry:country];
}

-(id) getCurrency {
    NSString *currency = [WonderPush currency];
    return currency;
}

-(void) setCurrency:(NSString *)currency {
    [WonderPush setCurrency:currency];
}

-(id) getLocale {
    NSString *locale = [WonderPush locale];
    return locale;
}

-(void) setLocale:(NSString *)locale {
    [WonderPush setLocale:locale];
}

-(id) getTimeZone {
    NSString *timeZone = [WonderPush timeZone];
    return timeZone;
}

-(void) setTimeZone:(NSString *)timeZone {
    [WonderPush setTimeZone:timeZone];
}


#pragma mark - User IDs

-(void) setUserId:(NSString *)userId {
    [WonderPush setUserId:userId];
}

-(NSString *) getUserId {
    NSString *userId = [WonderPush userId];
    return userId;
}

#pragma mark - Installation info

-(NSString *) getInstallationId {
    NSString *installationId = [WonderPush installationId];
    return installationId;
}

-(NSString *) getDeviceId {
    NSString *deviceId = [WonderPush deviceId];
    return deviceId;
}

-(NSString *) getAccessToken {
    NSString *accessToken = [WonderPush accessToken];
    return accessToken;
}

-(id) getUserConsent {
    BOOL userConsent =  [WonderPush getUserConsent];
    return [NSNumber numberWithBool:userConsent];
}

-(NSString *) getPushToken {
    NSString *pushToken = [WonderPush pushToken];
    return pushToken;
}

#pragma mark - Privacy

-(void) setRequiresUserConsent:(BOOL)isConsent {
    [WonderPush setRequiresUserConsent:isConsent];
}

-(void) setUserConsent:(BOOL)isConsent {
    [WonderPush setUserConsent:isConsent];
}

-(void) disableGeolocation {
    [WonderPush disableGeolocation];
}

-(void) enableGeolocation {
    [WonderPush enableGeolocation];
}

-(void) setGeolocation:(double)lat lon:(double)lon {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    [WonderPush setGeolocation:location];
}

-(void) clearEventsHistory {
    [WonderPush clearEventsHistory];
}

-(void) clearPreferences {
    [WonderPush clearPreferences];
}

-(void) clearAllData {
    [WonderPush clearAllData];
}

-(void) downloadAllData {
    [WonderPush downloadAllData:^(NSData *data, NSError *error) {
        if (error) {
            return;
        }

        // Upon success, present a UIActivityViewController

        // Find the topmost view controller
        UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (topController.presentedViewController) {
            topController = topController.presentedViewController;
        }

        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[string] applicationActivities:nil];
        [topController presentViewController:controller animated:YES completion:nil];
    }];
}

#pragma mark - Debug

-(void) setLogging:(BOOL) enable {
    [WonderPush setLogging:enable];
}

@end
