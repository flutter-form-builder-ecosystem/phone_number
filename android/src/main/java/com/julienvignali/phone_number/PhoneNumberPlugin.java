package com.julienvignali.phone_number;

import android.content.Context;
import android.telephony.TelephonyManager;

import androidx.annotation.NonNull;

import com.google.i18n.phonenumbers.AsYouTypeFormatter;
import com.google.i18n.phonenumbers.NumberParseException;
import com.google.i18n.phonenumbers.PhoneNumberUtil;
import com.google.i18n.phonenumbers.PhoneNumberUtil.PhoneNumberType;
import com.google.i18n.phonenumbers.Phonenumber.PhoneNumber;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class PhoneNumberPlugin implements FlutterPlugin, MethodCallHandler {

  private MethodChannel channel;
  private Context context;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    context = flutterPluginBinding.getApplicationContext();
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "com.julienvignali/phone_number");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "parse":
        parse(call, result);
        break;
      case "parse_list":
        parseList(call, result);
        break;
      case "format":
        format(call, result);
        break;
      case "validate":
        validate(call, result);
        break;
      case "get_all_supported_regions":
        getAllSupportedRegions(call, result);
        break;
      case "carrier_region_code":
        carrierRegionCode(result);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  private void getAllSupportedRegions(MethodCall call, Result result) {
    final List<Map<String, Object>> map = new ArrayList<>();

    Locale locale;
    final String identifier = call.argument("locale");
    if (identifier == null) {
      locale = Locale.getDefault();
    } else {
      locale = new Locale(identifier);
    }

    for (String region : PhoneNumberUtil.getInstance().getSupportedRegions()) {
      Map<String, Object> res = new HashMap<>();
      res.put("name", new Locale("", region).getDisplayCountry(locale));
      res.put("code", region);
      res.put("prefix", PhoneNumberUtil.getInstance().getCountryCodeForRegion(region));
      map.add(res);
    }

    result.success(map);
  }

  private void carrierRegionCode(Result result) {
    TelephonyManager tm = (TelephonyManager)context.getSystemService(Context.TELEPHONY_SERVICE);
    result.success(tm.getNetworkCountryIso());
  }

  private void validate(MethodCall call, Result result) {
    final String region = call.argument("region");
    final String number = call.argument("string");

    if (number == null) {
      result.error("InvalidParameters", "Invalid 'string' parameter.", null);
      return;
    }

    try {
      final PhoneNumberUtil util = PhoneNumberUtil.getInstance();
      final PhoneNumber phoneNumber = util.parse(number, region);
      boolean isValid = region == null
              ? util.isValidNumber(phoneNumber)
              : util.isValidNumberForRegion(phoneNumber, region);

      HashMap<String, Boolean> res = new HashMap<>();
      res.put("isValid", isValid);

      result.success(res);
    } catch (Exception exception) {
      result.error("InvalidNumber", "Number " + number + " is invalid", null);
    }
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
        int countryCode = phoneNumber.getCountryCode();
        put("type", numberTypeToString(type));
        put("e164", util.format(phoneNumber, PhoneNumberUtil.PhoneNumberFormat.E164));
        put("international",
                util.format(phoneNumber, PhoneNumberUtil.PhoneNumberFormat.INTERNATIONAL));
        put("national", util.format(phoneNumber, PhoneNumberUtil.PhoneNumberFormat.NATIONAL));
        put("country_code", String.valueOf(countryCode));
        put("region_code", String.valueOf(util.getRegionCodeForCountryCode(countryCode)));
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

        res.put(string, stringResult);
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
