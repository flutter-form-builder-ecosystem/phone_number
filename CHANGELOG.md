## 0.9.0

- Migrate to null safety

## 0.8.1+1

- Bump to libphonenumber 8.12.18 and PhoneKit 3.3.3

## 0.8.1

- Fix parsing of nationalNumber property

## 0.8.0

- Pin PhoneNumberKit to 3.3.1 to align with libphonenumber 8.12.9 phone numbers metadata
- Refactor project according to latest stable Flutter plugin template
- Remove all tests

## 0.7.0+1

- Fix missing dependency to `meta`
- Formatting code according to `dartfmt`

## 0.7.0

- Introduce PhoneNumber and RegionInfo classes for parsed results
- Change plugin's entry point to `PhoneNumberUtil` to mirror usage found in Google's `libphonenumber` library
- Add the `PhoneNumberType` enum

## 0.6.3

- Adding validate method for both platforms

## 0.6.2+4

- Upgrade to libphonenumber 8.12.6

## 0.6.2+3

- Fix warnings in Swift code

## 0.6.2+2

- Rewrite of the example app

## 0.6.2+1

- Fix compatibility with Objective-C projects
- Fix iOS example compatibility issue with Xcode 11.4 (https://flutter.dev/docs/development/ios-project-migration)

## 0.6.2

- Upgrade to libphonenumber 8.12.1

## 0.6.1

- Compatibility with Flutters Android Embedding V2
- Activate E2E testing capabilities

## 0.6.0+2

- Upgrade to libphonenumber 8.11.3
- Upgrade to PhoneNumberKit 3.2.0

## 0.6.0+1

- Thanks to @ened for helping fixing 2 iOS issues
- Optimize factories for testing and normal usage
- Add analytics_options w/ pedantic
- Initial version of the README

## 0.6.0

- **Breaking Change**: all the plugin's API methods are now instance methods

## 0.5.0

- Add method to retrieve all supported regions & their country codes

## 0.4.1

- Change channel name (add FQDN)
- Reorganize the lib folder to Dart library standards
- Update to libphonenumber 8.10.23 / PhoneNumberKitCore 3.1.0
- Project cleanup

## 0.4.0

- Add support for parsing a list of phone numbers

## 0.3.1

- Add support for phone number's countryCode and nationalNumber

## 0.3.0

- Add partial number formatting

## 0.2.0

- Upgrade to libphonenumber 8.10.11 & PhoneNumberKit 2.6.0
- Refactor to AndroidX
- Remove Kotlin support and switched back to full Java implementation
- Added a very simple test in the example app

## 0.1.1

- Minimal implementation of the parse method. Example app still not functional.
