import Flutter
import PhoneNumberKit

public class SwiftPhoneNumberPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "phone_number", binaryMessenger: registrar.messenger())
        let instance = SwiftPhoneNumberPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch(call.method) {
        case "parse": parse(call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private let kit = PhoneNumberKit()

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

        // Try to parse the string to a phone number for a given region.

        // If the parsing is successful, we return a dictionary containing :
        // - the number in the E164 format
        // - the number in the international format
        // - the number formatted as a national number and without the international prefix
        // - the number type (might not be 100% auccurate)

        // If it fails, we return a FlutterError to notify that the number is invalid.
        do {
            var phoneNumber: PhoneNumber
            if let region = arguments["region"] as? String {
                phoneNumber = try kit.parse(string, withRegion: region)
            }
            else {
                phoneNumber = try kit.parse(string)
            }

            let res:[String: String] = [
                "type": phoneNumber.type.toString(),
                "e164": kit.format(phoneNumber, toType: .e164),
                "international": kit.format(phoneNumber, toType: .international, withPrefix: true),
                "national": kit.format(phoneNumber, toType: .national)
            ]

            result(res)
        } catch {
            result(FlutterError(code: "InvalidNumber",
                                message:"Failed to parse phone number string '\(string)'.",
                                details: nil))
        }
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
