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

  /// Parse a single string and return a map in the format below.
  ///
  /// Given a passed [string] or '+4930123123123', the response will be:
  /// ```
  /// {
  ///   country_code: 49,
  ///   e164: '+4930123123123',
  ///   national: '030 123 123 123',
  ///   type: 'mobile',
  ///   international: '+49 30 123 123 123',
  ///   national_number: '030123123123',
  /// }
  /// ```
  Future<Map<String, dynamic>> parse(String string, {String region}) {
    return _channel.invokeMapMethod<String, dynamic>("parse", {
      "string": string,
      "region": region,
    });
  }

  /// Returns a map with the keys set to each item in [strings] and the value to
  /// the corresponding result of a parse operation. See [parse] for details.
  Future<Map<String, dynamic>> parseList(
    List<String> strings, {
    String region,
  }) {
    return _channel.invokeMapMethod<String, dynamic>("parse_list", {
      "strings": strings,
      "region": region,
    });
  }

  Future<Map<String, dynamic>> format(String string, String region) {
    return _channel.invokeMapMethod<String, dynamic>("format", {
      "string": string,
      "region": region,
    });
  }

  /// Returns a dictionary of all supported regions & their country code.
  Future<Map<String, int>> allSupportedRegions() {
    return _channel.invokeMapMethod<String, int>("get_all_supported_regions");
  }
}
