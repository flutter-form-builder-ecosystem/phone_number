import 'dart:async';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:phone_number/web/phone_number_util_js_impl.dart';



class PhoneNumberPlugin {


  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel('com.julienvignali/phone_number',
        StandardMethodCodec(),
        registrar.messenger
    );
    final PhoneNumberPlugin instance = PhoneNumberPlugin();
    channel.setMethodCallHandler(instance.handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call, ) async {
    switch (call.method) {
      case 'parse':
        return parse(call);
      case 'parse_list':
        return parse_list(call);
      case 'format':
        return format(call);
      case 'validate':
        return validate(call);
      case 'get_all_supported_regions':
        return getAllSupportedRegions(call);
      case 'carrier_region_code':
        return carrierRegionCode(call);
      default:
        throw PlatformException(
            code: 'Unimplemented',
            details: "The url_launcher plugin for web doesn't implement "
                "the method '${call.method}'");
    }
  }

  Future<Map<String, String>> parse(MethodCall call) async {
    String region = call.arguments["region"];
    String? string = call.arguments["string"];

    if (string == null || string.isEmpty) {
      throw(Exception("InvalidParameters, Invalid 'string' parameter."));
    } else {

      //Map<String, String>? res = parseStringAndRegion(string, region, PhoneNumberUtilJsImpl());

      // if (res != null) {
      //   return res;
      // } else {
      //   throw(Exception("InvalidNumber, Number " + string + " is invalid"));
      // }
      return {};
    }
  }

  Future<Map<String, Map<String, String>?>> parse_list(MethodCall call) async {
    String region = call.arguments["region"];
    List<String>? strings = call.arguments["strings"];

    if (strings == null || strings.isEmpty) {
      throw(Exception("InvalidParameters, Invalid 'string' parameter."));
    } else {

      Map<String, Map<String, String>?> res = Map<String, Map<String, String>>();

      // strings.forEach((string) {
      //   Map<String, String>? stringResult = parseStringAndRegion(string, region, PhoneNumberUtilJsImpl());
      //
      //   res.putIfAbsent(string, () => stringResult);
      //
      // });

          return res;
    }
  }

  Future<Map<String, String>> format(MethodCall call) async {
    final String region = call.arguments["region"];
    final String? number = call.arguments["string"];

    if (number == null) {
      throw(Exception("InvalidParameters, Invalid 'string' parameter."));
    }

    try {
      //final AsYouTypeFormatter formatter = PhoneNumberUtilJsImpl().getAsYouTypeFormatter(region);

      String formatted = "";
      //formatter.clear();

      // for (int i = 0; i < number.length; i++) {
      //   formatted = formatter.inputDigit(number[i]);
      // }

      Map<String, String> res = Map<String, String>();
      res.putIfAbsent("formatted", () => formatted);

      return res;
    } catch (_) {
      throw(Exception("InvalidNumber, Number " + number + " is invalid"));
    }
  }

  Future<Map<String, bool>> validate(MethodCall call) async {
    final String region = call.arguments["region"];
    final String? number = call.arguments["string"];

    if (number == null) {
      throw(Exception("InvalidParameters, Invalid 'string' parameter."));
    }

    try {
      // final PhoneNumberUtilJsImpl util = PhoneNumberUtilJsImpl();
      // final PhoneNumber phoneNumber = util.parse(number, region);
      // bool isValid = util.isValidNumberForRegion(phoneNumber, region);

      Map<String, bool> res = Map<String, bool>();
      //res.putIfAbsent("isValid", () => isValid);

      return res;
    } catch(_) {
      throw(Exception("InvalidNumber, Number " + number + " is invalid"));
    }
  }

  Future<String> carrierRegionCode(MethodCall call) async {
    //TelephonyManager tm = (TelephonyManager)context.getSystemService(Context.TELEPHONY_SERVICE);
    //result.success(tm.getNetworkCountryIso());
    return "";
  }

  Future<List<Map<String, dynamic>>> getAllSupportedRegions(MethodCall call) async {
    final List<Map<String, dynamic>> map = <Map<String, Object>>[];

    Locale locale;
    final String? identifier = call.arguments["locale"];
    if(identifier == null){
      locale = Locale("a");
    }
    else{
      locale = Locale(identifier);
    }

    PhoneNumberUtilJsImpl().getSupportedRegions().forEach((region) {
      Map<String, dynamic> res = Map<String, dynamic>();
      //res.putIfAbsent("name", () => Locale("", region).getDisplayCountry(locale));
      res.putIfAbsent("code", () => region);
      //res.putIfAbsent("prefix", () => PhoneNumberUtilJsImpl().getCountryCodeForregion(region));
      map.add(res);
    });

    return map;
  }

  // Map<String, String>? parseStringAndRegion(String string, String region, PhoneNumberUtilJsImpl util) {
  //   try {
  //     final PhoneNumber phoneNumber = util.parse(string, region);
  //
  //     if (!util.isValidNumber(phoneNumber)) {
  //       return null;
  //     }
  //
  //     // Try to parse the string to a phone number for a given region.
  //
  //     // If the parsing is successful, we return a map containing :
  //     // - the number in the E164 format
  //     // - the number in the international format
  //     // - the number formatted as a national number and without the international prefix
  //     // - the type of number (might not be 100% accurate)
  //     PhoneNumberType type = util.getNumberType(phoneNumber);
  //     return  {
  //       "type": numberTypeToString(type),
  //       "e164": util.format(phoneNumber, PhoneNumberUtil.PhoneNumberFormat.E164),
  //       "international":  util.format(phoneNumber, PhoneNumberUtil.PhoneNumberFormat.INTERNATIONAL),
  //       "national": util.format(phoneNumber, PhoneNumberUtil.PhoneNumberFormat.NATIONAL),
  //       "country_code": phoneNumber.getCountryCode(),
  //       "national_number": phoneNumber.getNationalNumber()
  //     };
  //   } catch (e) {
  //     return null;
  //   }
  // }


  // String numberTypeToString(PhoneNumberUtil.PhoneNumberType type) {
  //   switch (type) {
  //     case FIXED_LINE:
  //       return "fixedLine";
  //     case MOBILE:
  //       return "mobile";
  //     case FIXED_LINE_OR_MOBILE:
  //       return "fixedOrMobile";
  //     case TOLL_FREE:
  //       return "tollFree";
  //     case PREMIUM_RATE:
  //       return "premiumRate";
  //     case SHARED_COST:
  //       return "sharedCost";
  //     case VOIP:
  //       return "voip";
  //     case PERSONAL_NUMBER:
  //       return "personalNumber";
  //     case PAGER:
  //       return "pager";
  //     case UAN:
  //       return "uan";
  //     case VOICEMAIL:
  //       return "voicemail";
  //     case UNKNOWN:
  //       return "unknown";
  //     default:
  //       return "notParsed";
  //   }
  // }


}