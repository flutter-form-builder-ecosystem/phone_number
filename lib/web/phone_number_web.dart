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
    // case 'carrier_region_code':
    //   return carrierRegionCode(call);
      default:
        throw PlatformException(
            code: 'Unimplemented',
            details: "The phone_number plugin for web doesn't implement "
                "the method '${call.method}'");
    }
  }

  Future<Map<String, String>> parse(MethodCall call) async {
    String? region = call.arguments["region"];
    String? string = call.arguments["string"];

    if (string == null) {
      throw(PlatformException(code:"InvalidParameters", details: "Invalid 'string' parameter."));
    } else {
      if (string.isEmpty) {
        throw(PlatformException(code: "InvalidParameters", details: "Invalid 'string' parameter."));
      }
      Map<String, String>? res = parseStringAndRegion(string, region);
      if (res != null) {
        return res;
      } else {
        throw(PlatformException(code:"InvalidNumber", details: "Number " + string + " is invalid"));
      }
    }
  }

  Future<Map<String, Map<String, String>?>> parse_list(MethodCall call) async {
    String? region = call.arguments["region"];
    List<String>? strings = call.arguments["strings"];

    if (strings == null || strings.isEmpty) {
      throw(PlatformException(code:"InvalidParameters", details: "Invalid 'string' parameter."));
    } else {

      Map<String, Map<String, String>?> res = Map<String, Map<String, String>>();

      strings.forEach((string) {
        Map<String, String>? stringResult = parseStringAndRegion(string, region);

        res.putIfAbsent(string, () => stringResult);

      });

      return res;
    }
  }

  Future<Map<String, String>> format(MethodCall call) async {
    final String region = call.arguments["region"];
    final String? number = call.arguments["string"];

    if (number == null) {
      throw(PlatformException(code:"InvalidParameters", details: "Invalid 'string' parameter."));
    }

    try {
      final AsYouTypeFormatterJsImpl formatter = AsYouTypeFormatterJsImpl(region);

      String formatted = "";
      formatter.clear();

      for (int i = 0; i < number.length; i++) {
        formatted = formatter.inputDigit(number[i]);
      }

      Map<String, String> res = Map<String, String>();
      res.putIfAbsent("formatted", () => formatted);

      return res;
    } catch (_) {
      throw(PlatformException(code:"InvalidNumber", details: "Number " + number + " is invalid"));
    }
  }

  Future<Map<String, bool>> validate(MethodCall call) async {
    final String region = call.arguments["region"];
    final String? number = call.arguments["string"];

    if (number == null) {
      throw(PlatformException(code:"InvalidParameters", details: "Invalid 'string' parameter."));
    }

    try {
      final PhoneNumberUtilJsImpl util = PhoneNumberUtilJsImpl.getInstance();
      final PhoneNumberJsImpl phoneNumber = util.parse(number, region);
      bool isValid = util.isValidNumberForRegion(phoneNumber, region);

      Map<String, bool> res = Map<String, bool>();
      res.putIfAbsent("isValid", () => isValid);

      return res;
    } catch(_) {
      throw(PlatformException(code:"InvalidNumber", details: "Number " + number + " is invalid"));
    }
  }

  //Can't use this on web
  Future<String> carrierRegionCode(MethodCall call) async {
    //TelephonyManager tm = (TelephonyManager)context.getSystemService(Context.TELEPHONY_SERVICE);
    //result.success(tm.getNetworkCountryIso());
    return "";
  }

  Future<List<Map<String, dynamic>>> getAllSupportedRegions(MethodCall call) async {
    final List<Map<String, dynamic>> map = <Map<String, dynamic>>[];

    // Locale locale;
    // final String? identifier = call.arguments["locale"];
    // if(identifier == null){
    //   locale = Locale("a");
    // }
    // else{
    //   locale = Locale(identifier);
    // }

    PhoneNumberUtilJsImpl util = PhoneNumberUtilJsImpl.getInstance();
    util.getSupportedRegions().forEach((region) {
      Map<String, dynamic> res = Map<String, dynamic>();
      res.putIfAbsent("name", () => Locale(region).toLanguageTag());//.getDisplayCountry(locale));
      res.putIfAbsent("code", () => region);
      res.putIfAbsent("prefix", () => util.getCountryCodeForRegion(region));
      map.add(res);
    });

    return map;
  }

  Map<String, String>? parseStringAndRegion(String string, String? region) {
    try {
      final PhoneNumberUtilJsImpl util = PhoneNumberUtilJsImpl.getInstance();
      final PhoneNumberJsImpl phoneNumber = util.parse(string, region);

      if (!util.isValidNumber(phoneNumber)) {
        return null;
      }

      // Try to parse the string to a phone number for a given region.

      // If the parsing is successful, we return a map containing :
      // - the number in the E164 format
      // - the number in the international format
      // - the number formatted as a national number and without the international prefix
      // - the type of number (might not be 100% accurate)

      /**
       * INTERNATIONAL and NATIONAL formats are consistent with the definition in ITU-T Recommendation
       * E.123. However we follow local conventions such as using '-' instead of whitespace as
       * separators. For example, the number of the Google Switzerland office will be written as
       * "+41 44 668 1800" in INTERNATIONAL format, and as "044 668 1800" in NATIONAL format. E164
       * format is as per INTERNATIONAL format but with no formatting applied, e.g. "+41446681800".
       * RFC3966 is as per INTERNATIONAL format, but with all spaces and other separating symbols
       * replaced with a hyphen, and with any phone number extension appended with ";ext=". It also
       * will have a prefix of "tel:" added, e.g. "tel:+41-44-668-1800".
       *
       *   i18n.phonenumbers.PhoneNumberFormat = {
       *   E164: 0,
       *   INTERNATIONAL: 1,
       *   NATIONAL: 2,
       *   RFC3966: 3
       *   };
       */

      int type = util.getNumberType(phoneNumber);
      return  {
        "type": numberTypeToString(type),
        "e164": util.format(phoneNumber, 0),
        "international":  util.format(phoneNumber, 1),
        "national": util.format(phoneNumber, 2),
        "country_code": phoneNumber.getCountryCode().toString(),
        "national_number": phoneNumber.getNationalNumber().toString()
      };
    } catch (e) {
      return null;
    }
  }



  ///
  ///   * Type of phone numbers.
  ///
  ///   * @enum {number}
  ///
  ///    i18n.phonenumbers.PhoneNumberType = {
  ///      FIXED_LINE: 0,
  ///      MOBILE: 1,
  ///      // In some regions (e.g. the USA), it is impossible to distinguish between
  ///      // fixed-line and mobile numbers by looking at the phone number itself.
  ///      FIXED_LINE_OR_MOBILE: 2,
  ///      // Freephone lines
  ///      TOLL_FREE: 3,
  ///      PREMIUM_RATE: 4,
  ///      // The cost of this call is shared between the caller and the recipient, and
  ///      // is hence typically less than PREMIUM_RATE calls. See
  ///      // http://en.wikipedia.org/wiki/Shared_Cost_Service for more information.
  ///      SHARED_COST: 5,
  ///      // Voice over IP numbers. This includes TSoIP (Telephony Service over IP).
  ///      VOIP: 6,
  ///      // A personal number is associated with a particular person, and may be routed
  ///      // to either a MOBILE or FIXED_LINE number. Some more information can be found
  ///      // here: http://en.wikipedia.org/wiki/Personal_Numbers
  ///      PERSONAL_NUMBER: 7,
  ///      PAGER: 8,
  ///      // Used for 'Universal Access Numbers' or 'Company Numbers'. They may be
  ///      // further routed to specific offices, but allow one number to be used for a
  ///      // company.
  ///      UAN: 9,
  ///      // Used for 'Voice Mail Access Numbers'.
  ///      VOICEMAIL: 10,
  ///      // A phone number is of type UNKNOWN when it does not fit any of the known
  ///      // patterns for a specific region.
  ///      UNKNOWN: -1
  ///    };

  String numberTypeToString(int type) {
    switch (type) {
      case 0:
        return "fixedLine";
      case 1:
        return "mobile";
      case 2:
        return "fixedOrMobile";
      case 3:
        return "tollFree";
      case 4:
        return "premiumRate";
      case 5:
        return "sharedCost";
      case 6:
        return "voip";
      case 7:
        return "personalNumber";
      case 8:
        return "pager";
      case 9:
        return "uan";
      case 10:
        return "voicemail";
      case -1:
        return "unknown";
      default:
        return "notParsed";
    }
  }
}

