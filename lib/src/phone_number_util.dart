import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:phone_number/src/models/phone_number.dart';
import 'package:phone_number/src/models/region_info.dart';

const _phoneNumberChannel = MethodChannel('com.julienvignali/phone_number');

class PhoneNumberUtil {
  final MethodChannel _channel;

  PhoneNumberUtil._(this._channel);

  factory PhoneNumberUtil() => PhoneNumberUtil._(_phoneNumberChannel);

  @visibleForTesting
  factory PhoneNumberUtil.withChannel(channel) => PhoneNumberUtil._(channel);

  /// Parse a [phoneNumberString] to [PhoneNumber] object
  ///
  /// Returns [PhoneNumber] object corresponds to [phoneNumberString] if [phoneNumberString] is valid
  /// Throws [PlatformException] if [phoneNumberString] is invalid
  Future<PhoneNumber> parse(String phoneNumberString, {String regionCode}) async {
    final result = await _channel.invokeMapMethod<String, dynamic>('parse', {
      'string': phoneNumberString,
      'region': regionCode,
    });

    return PhoneNumber.fromJson(result);
  }

  /// Returns a [Map] with the keys set to each item in [phoneNumberStrings] and the value to
  /// the corresponding result of a parse operation for that item. See [parse] for details.
  Future<Map<String, PhoneNumber>> parseList(
    List<String> phoneNumberStrings, {
    String regionCode,
  }) async {
    final result =
        await _channel.invokeMapMethod<String, dynamic>('parse_list', {
      'strings': phoneNumberStrings,
      'region': regionCode,
    });

    return result.map(
      (key, value) => MapEntry(
        key,
        PhoneNumber.fromJson(Map<String, dynamic>.from(value)),
      ),
    );
  }

///Format [phoneNumberString] or [regionCode]
///
///Return formatted phone number
/// Throws [PlatformException] if [phoneNumberString] is invalid
  Future<String> format(String phoneNumberString, String regionCode) async {
    final result = await _channel.invokeMapMethod<String, dynamic>('format', {
      'string': phoneNumberString,
      'region': regionCode,
    });

    return result['formatted'];
  }

  /// Validate [phoneNumberString] for [regionCode]
  /// 
  /// Returns true if [phoneNumberString] is valid in region with code [regionCode]
  /// otherwise return false
  Future<bool> validate(String phoneNumberString, String regionCode) async {
    final result = await _channel.invokeMapMethod<String, dynamic>('validate', {
      'string': phoneNumberString,
      'region': regionCode,
    });

    return result['isValid'];
  }

  /// Returns a [List] of [RegionInfo] of all supported regions.
  Future<List<RegionInfo>> allSupportedRegions() async {
    final result = await _channel
        .invokeMapMethod<String, int>('get_all_supported_regions');

    return result
        .map(
          (key, value) => MapEntry(
            key,
            RegionInfo(code: key, prefix: value),
          ),
        )
        .values
        .toList(growable: false);
  }
}
