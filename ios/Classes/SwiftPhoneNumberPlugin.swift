import Flutter
import PhoneNumberKit

public class SwiftPhoneNumberPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.julienvignali/phone_number", binaryMessenger: registrar.messenger())
        let instance = SwiftPhoneNumberPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch(call.method) {
        case "parse": parse(call, result: result)
        case "validate": validate(call, result: result)
        case "parse_list": parseList(call, result: result)
        case "format": format(call, result: result)
        case "get_all_supported_regions": getAllSupportedRegions(call, result: result)
        case "carrier_region_code": carrierRegionCode(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private let kit = PhoneNumberKit()
    
    private func validate(_ call: FlutterMethodCall, result: FlutterResult){
        guard
            let arguments = call.arguments as? [String : Any],
            let number = arguments["string"] as? String

            else {
                result(FlutterError(code: "InvalidArgument",
                                    message: "The 'string' argument is missing.",
                                    details: nil))
                return
        }

        let region = arguments["region"] as? String?

        let isValid = region != nil ? kit.isValidPhoneNumber(number, withRegion: region!!) : kit.isValidPhoneNumber(number);
          let res:[String: Bool] = [
                    "isValid": isValid
                ]
        result(res)
    }
    
    private func getAllSupportedRegions(_ call: FlutterMethodCall, result: FlutterResult) {
        let locale: Locale
        if let arguments = call.arguments as? [String : Any],
            let identifier = arguments["locale"] as? String {
            locale = Locale(identifier: identifier)
        } else {
            locale = Locale.current
        }

        let regions = kit
            .allCountries()
            .compactMap { code -> [String: Any]? in
                guard let name = locale.localizedString(forRegionCode: code),
                      let prefix = kit.countryCode(for: code) else {
                    return nil
                }
                return ["name": name,
                        "code": code,
                        "prefix": prefix]
            }
        result(regions)
    }

    private func carrierRegionCode(result: FlutterResult) {
        result(PhoneNumberKit.defaultRegionCode())
    }

    private func format(_ call: FlutterMethodCall, result: FlutterResult) {
        guard
            let arguments = call.arguments as? [String : Any],
            let number = arguments["string"] as? String,
            let region = arguments["region"] as? String
            else {
                result(FlutterError(code: "InvalidArgument",
                                    message: "The 'string' argument is missing.",
                                    details: nil))
                return
        }
        
        let formatted = PartialFormatter(defaultRegion: region).formatPartial(number)
        let res:[String: String] = [
            "formatted": formatted
        ]

        result(res)
    }

    private func parse(string: String, region: String?) -> [String: String]? {
        do {
            var phoneNumber: PhoneNumber

            if let region = region {
                phoneNumber = try kit.parse(string, withRegion: region)
            }
            else {
                phoneNumber = try kit.parse(string)
            }

            // Try to parse the string to a phone number for a given region.

            // If the parsing is successful, we return a dictionary containing :
            // - the number in the E164 format
            // - the number in the international format
            // - the number formatted as a national number and without the international prefix
            // - the number type (might not be 100% auccurate)

            let regionCode = kit.getRegionCode(of: phoneNumber)

            return [
                "type": phoneNumber.type.toString(),
                "e164": kit.format(phoneNumber, toType: .e164),
                "international": kit.format(phoneNumber, toType: .international, withPrefix: true),
                "national": kit.format(phoneNumber, toType: .national),
                "country_code": String(phoneNumber.countryCode),
                "region_code": String(regionCode ?? ""),
                "national_number": String(phoneNumber.nationalNumber)
            ]
        } catch {
            return nil;
        }
    }

    private func parse(_ call: FlutterMethodCall, result: FlutterResult) {
        guard
            let arguments = call.arguments as? [String : Any],
            let string = arguments["string"] as? String
            else {
                result(FlutterError(code: "InvalidArgument",
                                    message: "The 'string' argument is missing.",
                                    details: nil))
                return
        }

        let region = arguments["region"] as? String

        if let res = parse(string: string, region: region) {
            result(res)
        } else {
            result(FlutterError(code: "InvalidNumber",
                                message:"Failed to parse phone number string '\(string)'.",
                                details: nil))
        }
    }

    private func parseList(_ call: FlutterMethodCall, result: FlutterResult) {
        guard
            let arguments = call.arguments as? [String : Any],
            let strings = arguments["strings"] as? [String]
            else {
                result(FlutterError(code: "InvalidArgument",
                                    message: "The 'strings' argument is missing.",
                                    details: nil))
                return
        }

        let region = arguments["region"] as? String

        var res = [String: [String: String]]()

        strings.forEach {
            res[$0] = parse(string: $0, region: region)
        }

        result(res)
    }
}

extension PhoneNumberType {
    func toString() -> String {
        switch self {
        case .fixedLine: return "fixedLine"
        case .mobile: return "mobile"
        case .fixedOrMobile: return "fixedOrMobile"
        case .notParsed: return "notParsed"
        case .pager: return "pager"
        case .personalNumber: return "personalNumber"
        case .premiumRate: return "premiumRate"
        case .sharedCost: return "sharedCost"
        case .tollFree: return "tollFree"
        case .uan: return "uan"
        case .unknown: return "unknown"
        case .voicemail: return "voicemail"
        case .voip: return "voip"
        }
    }
}
