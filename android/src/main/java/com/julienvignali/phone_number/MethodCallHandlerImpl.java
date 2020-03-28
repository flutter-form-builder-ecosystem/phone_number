package com.julienvignali.phone_number;

import androidx.annotation.NonNull;
import com.google.i18n.phonenumbers.AsYouTypeFormatter;
import com.google.i18n.phonenumbers.NumberParseException;
import com.google.i18n.phonenumbers.PhoneNumberUtil;
import com.google.i18n.phonenumbers.PhoneNumberUtil.PhoneNumberType;
import com.google.i18n.phonenumbers.Phonenumber.PhoneNumber;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class MethodCallHandlerImpl implements MethodChannel.MethodCallHandler {

  @Override
  public void onMethodCall(MethodCall call, @NonNull Result result) {
    if (call.method.equals("parse")) {
      parse(call, result);
    } else if (call.method.equals("parse_list")) {
      parseList(call, result);
    } else if (call.method.equals("format")) {
      format(call, result);
    } else if (call.method.equals("get_all_supported_regions")) {
      getAllSupportedRegions(result);
    } else {
      result.notImplemented();
    }
  }

  private void getAllSupportedRegions(Result result) {
    final Map<String, Integer> map = new HashMap<>();

    for (String region : PhoneNumberUtil.getInstance().getSupportedRegions()) {
      map.put(region, PhoneNumberUtil.getInstance().getCountryCodeForRegion(region));
    }

    result.success(map);
  }

  private void format(MethodCall call, Result result) {
    final String region = call.argument("region");
    final String number = call.argument("string");

    if (number == null) {
      result.error("InvalidParameters", "Invalid 'string' parameter.", null);
      return;
    }

    try {
      final PhoneNumberUtil util = PhoneNumberUtil.getInstance();
      final AsYouTypeFormatter formatter = util.getAsYouTypeFormatter(region);

      String formatted = "";
      formatter.clear();
      for (char character : number.toCharArray()) {
        formatted = formatter.inputDigit(character);
      }

      HashMap<String, String> res = new HashMap<>();
      res.put("formatted", formatted);

      result.success(res);
    } catch (Exception exception) {
      result.error("InvalidNumber", "Number " + number + " is invalid", null);
    }
  }

  private HashMap<String, String> parseStringAndRegion(String string, String region,
      final PhoneNumberUtil util) {
    try {
      final PhoneNumber phoneNumber = util.parse(string, region);

      if (!util.isValidNumber(phoneNumber)) {
        return null;
      }

      // Try to parse the string to a phone number for a given region.

      // If the parsing is successful, we return a map containing :
      // - the number in the E164 format
      // - the number in the international format
      // - the number formatted as a national number and without the international prefix
      // - the type of number (might not be 100% accurate)

      return new HashMap<String, String>() {{
        PhoneNumberType type = util.getNumberType(phoneNumber);
        put("type", numberTypeToString(type));
        put("e164", util.format(phoneNumber, PhoneNumberUtil.PhoneNumberFormat.E164));
        put("international",
            util.format(phoneNumber, PhoneNumberUtil.PhoneNumberFormat.INTERNATIONAL));
        put("national", util.format(phoneNumber, PhoneNumberUtil.PhoneNumberFormat.NATIONAL));
        put("country_code", String.valueOf(phoneNumber.getCountryCode()));
        put("national_number", String.valueOf(phoneNumber.getNationalNumber()));
      }};
    } catch (NumberParseException e) {
      return null;
    }
  }

  private void parse(MethodCall call, Result result) {
    String region = call.argument("region");
    String string = call.argument("string");

    if (string == null || string.isEmpty()) {
      result.error("InvalidParameters", "Invalid 'string' parameter.", null);
    } else {
      final PhoneNumberUtil util = PhoneNumberUtil.getInstance();

      HashMap<String, String> res = parseStringAndRegion(string, region, util);

      if (res != null) {
        result.success(res);
      } else {
        result.error("InvalidNumber", "Number " + string + " is invalid", null);
      }
    }
  }

  private void parseList(MethodCall call, Result result) {
    String region = call.argument("region");
    List<String> strings = call.argument("strings");

    if (strings == null || strings.isEmpty()) {
      result.error("InvalidParameters", "Invalid 'strings' parameter.", null);
    } else {
      final PhoneNumberUtil util = PhoneNumberUtil.getInstance();

      HashMap<String, HashMap<String, String>> res = new HashMap<>(strings.size());

      for (String string : strings) {
        HashMap<String, String> stringResult = parseStringAndRegion(string, region, util);

        if (stringResult != null) {
          res.put(string, stringResult);
        } else {
          res.put(string, null);
        }
      }

      result.success(res);
    }
  }

  private String numberTypeToString(PhoneNumberUtil.PhoneNumberType type) {
    switch (type) {
      case FIXED_LINE:
        return "fixedLine";
      case MOBILE:
        return "mobile";
      case FIXED_LINE_OR_MOBILE:
        return "fixedOrMobile";
      case TOLL_FREE:
        return "tollFree";
      case PREMIUM_RATE:
        return "premiumRate";
      case SHARED_COST:
        return "sharedCost";
      case VOIP:
        return "voip";
      case PERSONAL_NUMBER:
        return "personalNumber";
      case PAGER:
        return "pager";
      case UAN:
        return "uan";
      case VOICEMAIL:
        return "voicemail";
      case UNKNOWN:
        return "unknown";
      default:
        return "notParsed";
    }
  }
}
