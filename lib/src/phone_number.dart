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

  Future<dynamic> parse(String string, {String region}) {
    final args = {"string": string, "region": region};
    return _channel.invokeMethod("parse", args);
  }

  Future<dynamic> parseList(List<String> strings, {String region}) {
    final args = {"strings": strings, "region": region};
    return _channel.invokeMethod("parse_list", args);
  }

  Future<dynamic> format(String string, String region) {
    final args = {"string": string, "region": region};
    return _channel.invokeMethod("format", args);
  }

  /// Returns a dictionary of all supported regions & their country code.
  Future<Map<String, int>> allSupportedRegions() {
    return _channel.invokeMapMethod<String, int>("get_all_supported_regions");
  }
}
