import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PhoneNumber {
  static const _channel = MethodChannel('com.julienvignali/phone_number');

  factory PhoneNumber() {
    if (_instance == null) {
      _instance = PhoneNumber.private(_channel);
    }
    return _instance;
  }

  @visibleForTesting
  PhoneNumber.private(
    this._methodChannel,
  );

  static PhoneNumber _instance;

  final MethodChannel _methodChannel;

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

  /// Returns a dictionary of all supported regions & their country code.
  Future<Map<String, int>> allSupportedRegions() async {
    return await _methodChannel.invokeMapMethod<String, int>(
      "get_all_supported_regions",
    );
  }
}
