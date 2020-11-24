#import "WonderpushFcmFlutterPlugin.h"
#if __has_include(<wonderpush_fcm_flutter/wonderpush_fcm_flutter-Swift.h>)
#import <wonderpush_fcm_flutter/wonderpush_fcm_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "wonderpush_fcm_flutter-Swift.h"
#endif

@implementation WonderpushFcmFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftWonderpushFcmFlutterPlugin registerWithRegistrar:registrar];
}
@end
