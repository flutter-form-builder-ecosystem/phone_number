#import "PhoneNumberPlugin.h"
#if __has_include(<phone_number/phone_number-Swift.h>)
#import <phone_number/phone_number-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "phone_number-Swift.h"
#endif

@implementation PhoneNumberPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPhoneNumberPlugin registerWithRegistrar:registrar];
}
@end
