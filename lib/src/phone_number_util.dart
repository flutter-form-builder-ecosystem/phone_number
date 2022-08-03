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
  Future<PhoneNumber> parse(
    String phoneNumberString, {
    String? regionCode,
  }) async {
    final result = await _channel.invokeMapMethod<String, dynamic>(
      'parse',
      {
        'string': phoneNumberString,
        'region': regionCode,
      },
    );

    if (result == null) {
      throw PlatformException(
        code: 'PARSE_FAILED',
        message: 'Parsing the phone number returned null',
      );
    }

    return PhoneNumber.fromJson(result);
  }

  /// Returns a [Map] with the keys set to each item in [phoneNumberStrings] and the value to
  /// the corresponding result of a parse operation for that item. See [parse] for details.
  Future<Map<String, PhoneNumber>> parseList(
    List<String> phoneNumberStrings, {
    String? regionCode,
  }) async {
    final result = await _channel.invokeMapMethod<String, dynamic>(
      'parse_list',
      {
        'strings': phoneNumberStrings,
        'region': regionCode,
      },
    );

    if (result == null) {
      throw PlatformException(
        code: 'PARSE_FAILED',
        message: 'Parsing the phone numbers returned null',
      );
    }

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
  Future<String> format(
    String phoneNumberString,
    String regionCode,
  ) async {
    final result = await _channel.invokeMapMethod<String, dynamic>(
      'format',
      {
        'string': phoneNumberString,
        'region': regionCode,
      },
    );

    if (result == null) {
      throw PlatformException(
        code: 'FORMAT_FAILED',
        message: 'Formatting the phone number returned null',
      );
    }

    return result['formatted'];
  }

  /// Validate [phoneNumberString]
  ///
  /// Returns true if [phoneNumberString] is valid otherwise return false
  ///
  /// Optional [regionCode] to validate number in specific region
  Future<bool> validate(
    String phoneNumberString, {
    String? regionCode,
  }) async {
    final result = await _channel.invokeMapMethod<String, dynamic>(
      'validate',
      {
        'string': phoneNumberString,
        'region': regionCode,
      },
    );

    return result?['isValid'] ?? false;
  }

  /// Returns a [List] of [RegionInfo] of all supported regions.
  /// Optionally pass the [locale] identifier for translating the names.
  Future<List<RegionInfo>> allSupportedRegions({String? locale}) async {
    final result =
        await _channel.invokeListMethod<Map>('get_all_supported_regions', {
      'locale': locale,
    });

    return result
            ?.map((value) => RegionInfo.fromJson(value.cast()))
            .toList(growable: false) ??
        [];
  }

  /// Return the region code for the device's phone number.
  Future<String> carrierRegionCode() async =>
      await _channel.invokeMethod('carrier_region_code') ?? '';
}
