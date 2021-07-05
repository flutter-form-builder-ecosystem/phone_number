@JS('libphonenumber')
library libphonenumber;


import 'package:js/js.dart';

@JS('PhoneNumberUtil')
class PhoneNumberUtilJsImpl{

  @JS('getInstance')
  external static PhoneNumberUtilJsImpl getInstance();

  @JS('getSupportedRegions')
  external List<String> getSupportedRegions();

  @JS('getCountryCodeForRegion')
  external int getCountryCodeForRegion(String regionCode);

  @JS('parse')
  external PhoneNumberJsImpl parse(String numberToParse, String? defaultRegion);

  @JS('isValidNumberForRegion')
  external bool isValidNumberForRegion(PhoneNumberJsImpl number, String regionCode);

  @JS('isValidNumber')
  external bool isValidNumber(PhoneNumberJsImpl number);

  @JS('getNumberType')
  external int getNumberType(PhoneNumberJsImpl number);

  @JS('format')
  external String format(PhoneNumberJsImpl number, int numberFormat);
}


@JS('PhoneNumber')
class PhoneNumberJsImpl{

  @JS('getCountryCode')
  external int getCountryCode();

  @JS('getNationalNumber')
  external int getNationalNumber();

}

@JS('AsYouTypeFormatter')
class AsYouTypeFormatterJsImpl {

  external AsYouTypeFormatterJsImpl(String regionCode);

  @JS('clear')
  external void clear();

  @JS('inputDigit')
  external String inputDigit(String nextChar);

}


