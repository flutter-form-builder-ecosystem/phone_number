package com.julienvignali.phone_number;

import android.telephony.PhoneNumberUtils;

import com.google.i18n.phonenumbers.AsYouTypeFormatter;
import com.google.i18n.phonenumbers.NumberParseException;
import com.google.i18n.phonenumbers.PhoneNumberUtil;
import com.google.i18n.phonenumbers.PhoneNumberUtil.PhoneNumberType;
import com.google.i18n.phonenumbers.Phonenumber.PhoneNumber;

import java.util.HashMap;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class PhoneNumberPlugin implements MethodCallHandler {

    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "phone_number");
        channel.setMethodCallHandler(new PhoneNumberPlugin());
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        if (call.method.equals("parse")) {
            parse(call, result);
        } else if(call.method.equals("format")) {
            format(call, result);
        } else {
            result.notImplemented();
        }
    }

    private void format(MethodCall call, Result result) {
        final String region = call.argument("region");
        final String number = call.argument("string");

        if(number == null) {
            result.error("InvalidParameters", "Invalid 'string' parameter.", null);
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

    private void parse(MethodCall call, Result result) {
        String region = call.argument("region");
        String string = call.argument("string");

        if (string == null || string.isEmpty()) {
            result.error("InvalidParameters", "Invalid 'string' parameter.", null);
        } else {
            // Try to parse the string to a phone number for a given region.

            // If the parsing is successful, we return a map containing :
            // - the number in the E164 format
            // - the number in the international format
            // - the number formatted as a national number and without the international prefix
            // - the type of number (might not be 100% accurate)
            final PhoneNumberUtil util = PhoneNumberUtil.getInstance();
            try {
                final PhoneNumber phoneNumber = util.parse(string, region);
                if (util.isValidNumber(phoneNumber)) {
                    HashMap<String, String> res = new HashMap<String, String>() {{
                        PhoneNumberType type = util.getNumberType(phoneNumber);
                        put("type", numberTypeToString(type));
                        put("e164", util.format(phoneNumber, PhoneNumberUtil.PhoneNumberFormat.E164));
                        put("international", util.format(phoneNumber, PhoneNumberUtil.PhoneNumberFormat.INTERNATIONAL));
                        put("national", util.format(phoneNumber, PhoneNumberUtil.PhoneNumberFormat.NATIONAL));
                    }};
                    result.success(res);
                } else {
                    result.error("InvalidNumber", "Number " + string + " is invalid", null);
                }

            } catch (NumberParseException e) {
                result.error("InvalidNumber", "Number " + string + " is invalid", null);
            }
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
