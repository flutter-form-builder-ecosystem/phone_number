#import "PhoneNumberPlugin.h"
#import <phone_number/phone_number-Swift.h>

@implementation PhoneNumberPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPhoneNumberPlugin registerWithRegistrar:registrar];
}
@end
