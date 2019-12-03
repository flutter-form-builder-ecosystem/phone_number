import 'dart:async';

import 'package:flutter/services.dart';

class PhoneNumber {
  static const _channel = MethodChannel('com.julienvignali/phone_number');

  static Future<dynamic> parse(String string, {String region}) async {
    final args = {"string": string, "region": region};
    final result = await _channel.invokeMethod("parse", args);
    return result;
  }

  static Future<dynamic> parseList(List<String> strings,
      {String region}) async {
    final args = {"strings": strings, "region": region};
    final result = await _channel.invokeMethod("parse_list", args);
    return result;
  }

  static Future<dynamic> format(String string, String region) async {
    final args = {"string": string, "region": region};
    final result = await _channel.invokeMethod("format", args);
    return result;
  }
}
