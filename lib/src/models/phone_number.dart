import 'package:meta/meta.dart';
import 'package:phone_number/src/models/phone_number_type.dart';

@immutable
class PhoneNumber {
  final String countryCode;
  final String e164;
  final String national;
  final PhoneNumberType type;
  final String international;
  final String nationalNumber;

  PhoneNumber({
    required this.countryCode,
    required this.e164,
    required this.national,
    required this.type,
    required this.international,
    required this.nationalNumber,
  });

  factory PhoneNumber.fromJson(Map<String, dynamic> json) {
    return PhoneNumber(
        countryCode: json['country_code'],
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
}
