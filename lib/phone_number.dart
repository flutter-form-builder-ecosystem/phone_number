import 'dart:async';

import 'package:flutter/services.dart';

class PhoneNumber {
  static const MethodChannel _channel =
      const MethodChannel('phone_number');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
