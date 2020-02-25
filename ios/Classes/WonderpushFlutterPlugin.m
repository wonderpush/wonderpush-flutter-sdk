#import "WonderpushFlutterPlugin.h"
#if __has_include(<wonderpush_flutter_plugin/wonderpush_flutter_plugin-Swift.h>)
#import <wonderpush_flutter_plugin/wonderpush_flutter_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "wonderpush_flutter_plugin-Swift.h"
#endif

@implementation WonderpushFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftWonderpushFlutterPlugin registerWithRegistrar:registrar];
}
@end
