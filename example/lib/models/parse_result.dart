import 'package:phone_number/phone_number.dart';

class ParseResult {
  final PhoneNumber? phoneNumber;
  final String? errorCode;

  ParseResult._({
    this.phoneNumber,
    this.errorCode,
  });

  bool get hasError => errorCode != null;

  factory ParseResult(PhoneNumber phoneNumber) => ParseResult._(
        phoneNumber: phoneNumber,
      );

  factory ParseResult.error(code) => ParseResult._(errorCode: code);

  @override
  String toString() {
    return 'ParseResult{'
        'e164: ${phoneNumber?.e164}, '
        'type: ${phoneNumber?.type}, '
        'international: ${phoneNumber?.international}, '
        'national: ${phoneNumber?.national}, '
        'countryCode: ${phoneNumber?.countryCode}, '
        'nationalNumber: ${phoneNumber?.nationalNumber}, '
        'errorCode: $errorCode}';
  }
}
