library libphonenumber;
@JS('libphonenumber')

import 'package:js/js.dart';

@JS('PhoneNumberUtil')
class PhoneNumberUtilJsImpl{


  @JS('getSupportedRegions')
  external List<String> getSupportedRegions();


}