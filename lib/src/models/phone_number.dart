import 'package:meta/meta.dart' show immutable;
import 'package:phone_number/src/models/phone_number_type.dart';

/// Represents a successfully parsed phone number
@immutable
class PhoneNumber {
  /// Returns the country calling code for a specific region.
  ///
  /// Example: 1 for the US, 44 for the UK, 1 for Canada, 61 for Australia, etc.
  final String countryCode;

  /// ISO 3166-1 alpha-2 codes are two-letter country codes defined in ISO 3166-1,
  /// part of the ISO 3166 standard[1] published by the International Organization
  /// for Standardization (ISO), to represent countries, dependent territories, and
  /// special areas of geographical interest.
  ///
  /// Example: US
  final String regionCode;

  /// E.164 is an international standard (ITU-T Recommendation), titled The international
  /// public telecommunication numbering plan, that defines a numbering plan for the
  /// worldwide public switched telephone network (PSTN) and some other data networks.
  ///
  /// Example: +14175555470
  final String e164;

  /// Example: (417) 555-5470
  final String national;

  /// Example: PhoneNumberType.FIXED_LINE_OR_MOBILE
  final PhoneNumberType type;

  /// Example: +1 417-555-5470
  final String international;

  /// Example: 4175555470
  final String nationalNumber;

  const PhoneNumber({
    required this.countryCode,
    required this.regionCode,
    required this.e164,
    required this.national,
    required this.type,
    required this.international,
    required this.nationalNumber,
  });

  factory PhoneNumber.fromJson(Map<String, dynamic> json) {
    return PhoneNumber(
        countryCode: json['country_code'],
        regionCode: json['region_code'],
        e164: json['e164'],
        national: json['national'],
        type: _mapStringToPhoneNumberType(json['type'])!,
        international: json['international'],
        nationalNumber: json['national_number']);
  }

  static PhoneNumberType? _mapStringToPhoneNumberType(String? typeStr) {
    PhoneNumberType? type;
    switch (typeStr) {
      case 'fixedLine':
        type = PhoneNumberType.FIXED_LINE;
        break;
      case 'mobile':
        type = PhoneNumberType.MOBILE;
        break;
      case 'fixedOrMobile':
        type = PhoneNumberType.FIXED_LINE_OR_MOBILE;
        break;
      case 'tollFree':
        type = PhoneNumberType.TOLL_FREE;
        break;
      case 'premiumRate':
        type = PhoneNumberType.PREMIUM_RATE;
        break;
      case 'sharedCost':
        type = PhoneNumberType.SHARED_COST;
        break;
      case 'voip':
        type = PhoneNumberType.VOIP;
        break;
      case 'personalNumber':
        type = PhoneNumberType.PERSONAL_NUMBER;
        break;
      case 'pager':
        type = PhoneNumberType.PAGER;
        break;
      case 'uan':
        type = PhoneNumberType.UAN;
        break;
      case 'voicemail':
        type = PhoneNumberType.VOICEMAIL;
        break;
      case 'unknown':
        type = PhoneNumberType.UNKNOWN;
        break;
      case 'notParsed':
        type = PhoneNumberType.NOT_PARSED;
        break;
      default:
    }

    return type;
  }

  @override
  int get hashCode =>
      countryCode.hashCode ^
      regionCode.hashCode ^
      e164.hashCode ^
      national.hashCode ^
      type.hashCode ^
      international.hashCode ^
      nationalNumber.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhoneNumber &&
          runtimeType == other.runtimeType &&
          countryCode == other.countryCode &&
          regionCode == other.regionCode &&
          e164 == other.e164 &&
          national == other.national &&
          type == other.type &&
          international == other.international &&
          nationalNumber == other.nationalNumber;

  @override
  String toString() {
    return 'PhoneNumber { '
        'countryCode: $countryCode, '
        'regionCode: $regionCode, '
        'e164: $e164, '
        'national: $national, '
        'type: $type, '
        'international: $international, '
        'nationalNumber: $nationalNumber '
        '}';
  }
}
