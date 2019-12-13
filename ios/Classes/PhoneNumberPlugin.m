#import "PhoneNumberPlugin.h"

#if __has_include(<phone_number/phone_number-Swift.h>)
#import <phone_number/phone_number-Swift.h>
#else
#import "phone_number-Swift.h"
#endif

@implementation PhoneNumberPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPhoneNumberPlugin registerWithRegistrar:registrar];
}
@end
