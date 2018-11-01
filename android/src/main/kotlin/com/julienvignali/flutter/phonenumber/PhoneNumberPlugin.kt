package com.julienvignali.flutter.phonenumber

import com.google.i18n.phonenumbers.NumberParseException
import com.google.i18n.phonenumbers.PhoneNumberUtil
import com.google.i18n.phonenumbers.PhoneNumberUtil.PhoneNumberType
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class PhoneNumberPlugin: MethodCallHandler {
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "phone_number")
      channel.setMethodCallHandler(PhoneNumberPlugin())
    }

    private fun typeToString(type: PhoneNumberType): String {
      return when (type) {
        PhoneNumberType.MOBILE -> "mobile"
        PhoneNumberType.FIXED_LINE -> "fixedLine"
        PhoneNumberType.FIXED_LINE_OR_MOBILE -> "fixedOrMobile"
        PhoneNumberType.UNKNOWN -> "unknown"
        PhoneNumberType.PAGER -> "pager"
        PhoneNumberType.UAN -> "uan"
        PhoneNumberType.TOLL_FREE -> "tollFree"
        PhoneNumberType.VOICEMAIL -> "voicemail"
        PhoneNumberType.VOIP -> "voip"
        PhoneNumberType.PERSONAL_NUMBER -> "personalNumber"
        PhoneNumberType.SHARED_COST -> "sharedCost"
        PhoneNumberType.PREMIUM_RATE -> "premiumRate"
        else -> "notParsed"
      }
    }

    private val util:PhoneNumberUtil = PhoneNumberUtil.getInstance()
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "parse" -> parse(call, result)
      else -> result.notImplemented()
    }
  }

  private fun parse(call: MethodCall, result: Result) {
    val region = call.argument<String>("region")
    val string = call.argument<String>("string")

    // Check the arguments
    if (string.isNullOrEmpty()) {
      result.error("InvalidParameters", "Invalid 'string' argument.", null)
      return
    }

    try {
      // Try to parse the string to a phone number for a given region.

      // If the parsing is successful, we return a map containing :
      // - the number in the E164 format
      // - the number in the international format
      // - the number formatted as a national number and without the international prefix
      // - the type of number (might not be 100% accurate)

      // If it fails, we return a FlutterError to notify that the number is invalid.
      val phoneNumber = util.parse(string, region)

      if (util.isValidNumber(phoneNumber)) {
        val type = util.getNumberType(phoneNumber)
        val e164 = util.format(phoneNumber, PhoneNumberUtil.PhoneNumberFormat.E164)
        val national = util.format(phoneNumber, PhoneNumberUtil.PhoneNumberFormat.NATIONAL)
        val international = util.format(phoneNumber, PhoneNumberUtil.PhoneNumberFormat.INTERNATIONAL)
        result.success(mapOf(
                "type" to typeToString(type),
                "e164" to e164,
                "international" to international,
                "national" to national))
      }
      else {
        result.error("InvalidNumber", "Number '$string' is invalid", null)
      }
    }
    catch(e: ClassCastException) {
      result.error("InvalidArguments", "Missing 'string' argument.", call.arguments)
    }
    catch (e: NumberParseException) {
      result.error("InvalidNumber", "Could not parse the number", null)
    }
  }
}
