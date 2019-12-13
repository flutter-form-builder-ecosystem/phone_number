import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

const _phoneNumberChannel = MethodChannel('com.julienvignali/phone_number');

class PhoneNumber {
  final MethodChannel _channel;

  PhoneNumber._(this._channel);

  factory PhoneNumber() => PhoneNumber._(_phoneNumberChannel);

  @visibleForTesting
  factory PhoneNumber.withChannel(channel) => PhoneNumber._(channel);

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
