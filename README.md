# Phone Number

Phone Number is a Flutter plugin that allows you to parse, validate, format and other utilities for to international phone numbers.

[![Pub Version](https://img.shields.io/pub/v/phone_number?logo=flutter&style=for-the-badge)](https://pub.dev/packages/phone_number)
[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/flutter-form-builder-ecosystem/phone_number/Base?logo=github&style=for-the-badge)](https://github.com/flutter-form-builder-ecosystem/phone_number/actions/workflows/base.yaml)
[![Codecov](https://img.shields.io/codecov/c/github/flutter-form-builder-ecosystem/phone_number?logo=codecov&style=for-the-badge)](https://codecov.io/gh/flutter-form-builder-ecosystem/phone_number/)
[![CodeFactor Grade](https://img.shields.io/codefactor/grade/github/flutter-form-builder-ecosystem/phone_number?logo=codefactor&style=for-the-badge)](https://www.codefactor.io/repository/github/flutter-form-builder-ecosystem/phone_number)
[![Discord](https://img.shields.io/discord/985922433578053673?logo=discord&style=for-the-badge)](https://discord.com/invite/25KNPMJQf2)
___


- [Features](#features)
    - [Dependencies](#dependencies)
- [Usage](#usage)
    - [Setup](#setup)
    - [Basic use](#basic-use)
    - [Specific use](#specific-use)
- [Support](#support)
    - [Contribute](#contribute)
    - [Questions and answers](#questions-and-answers)
    - [Donations](#donations)
- [Roadmap](#roadmap)
- [Ecosystem](#ecosystem)
- [Thanks to](#thanks-to)
    - [Contributors](#contributors)

## Features

- Parsing phone number
- Validate phone number
- Format phone number
- Get region from phone number
- Get region from device

### Dependencies

The plugin uses the native libraries [libphonenumber](https://github.com/google/libphonenumber) for Android and [PhoneNumberKit](https://github.com/marmelroy/PhoneNumberKit) pod for iOS.

| Library        | Version   |
| -------------- | --------- |
| libphonenumber | `8.12.52` |
| PhoneNumberKit | `3.4.4`   |

## Usage

### Setup

No especific setup required: only install the dependency and use :)

### Basic use

```dart
String springFieldUSASimple = '+14175555470';

// Parsing
PhoneNumber phoneNumber = await PhoneNumberUtil().parse(springFieldUSASimpleNoRegion, regionCode: region.code);

// Validate
bool isValid = await PhoneNumberUtil().validate(springFieldUSASimpleNoRegion, regionCode: region.code);

// Format
RegionInfo region = RegionInfo('US', 1);
String formatted = await PhoneNumberUtil().format(springFieldUSASimple, region.code); // +1 (417) 555-5470
```

See [pud.dev example tab](https://pub.dev/packages/phone_number/example) or [github code](example/lib/main.dart) for more details

### Specific use

#### Phone number with dashes

Parse a phone number with region prefix and dashes.

```dart
// Parsing
String springFieldUSA = '+1-417-555-5470';
PhoneNumber phoneNumber = await PhoneNumberUtil().parse(springFieldUSA);

// Validate
bool isValid = await PhoneNumberUtil().validate(springFieldUSA);

// Format
String formatted = await PhoneNumberUtil().format(springFieldUSASimpleNoRegion, region.code); // +1 (417) 555-5470
```

#### Phone number without region (national number)

Parse a phone number string without the region prefix. **Region required**. Country calling codes can be found [here](https://en.wikipedia.org/wiki/List_of_country_calling_codes)

```dart
String springFieldUSASimpleNoRegion = '4175555470';
RegionInfo region = RegionInfo('US', 1);

// Parsing
PhoneNumber phoneNumber = await PhoneNumberUtil().parse(springFieldUSASimpleNoRegion, region: region);

// Validate
bool isValid = await PhoneNumberUtil().validate(springFieldUSASimpleNoRegion, region: region.code);

// Format
String formatted = await PhoneNumberUtil().format(springFieldUSASimpleNoRegion, region.code); // (417) 555-5470
```

#### Parsing model result

Parsing a valid phone number results in a phone number object:

```dart
PhoneNumber{
  e164: +14175555470,
  type: PhoneNumberType.FIXED_LINE_OR_MOBILE,
  international: +1 417-555-5470,
  national: (417) 555-5470,
  countryCode: 1,
  regionCode: "US",
  nationalNumber: 4175555470,
  errorCode: null,
}
```

#### As-you-type formatting

Attach the provided `PhoneNumberEditingController` to a TextField to format its text as the user type.

There are 3 formatting behavior:

- `PhoneInputBehavior.strict`: always format, do not accept non dialable chars.
- `PhoneInputBehavior.cancellable`: stop formatting when a separator is removed, do not accept non dialable chars.
- `PhoneInputBehavior.lenient` _(default)_: stop formatting when either a non dialable char is inserted or a separator is removed.

Example video: [Phone number editing controller demo](http://www.youtube.com/watch?v=rlLGVXCi-2Y)

#### Regions

Fetching regions (country code and prefixes).

```dart
List<RegionInfo> regions = await plugin.allSupportedRegions();
// [ RegionInfo { code: IM, prefix: 44 }, RegionInfo { code: LU, prefix: 352 }, ... ]
```

A parsed phone number will give region code as well.

```dart
String springFieldUSASimple = '+14175555470';
PhoneNumber phoneNumber = await PhoneNumberUtil().parse(springFieldUSASimple);
phoneNumber.regionCode; // US
```

If you want to display all the flags alongside the regions in your UI region picker, consider having a JSON file instead of using this function. [Example JSON file](https://gist.githubusercontent.com/DmytroLisitsyn/1c31186e5b66f1d6c52da6b5c70b12ad/raw/01b1af9b267471818f4f8367852bd4a2814cbae6/country_dial_info.json)

```dart
const List<Map<String, dynamic>> countries = [
  {"name":"Afghanistan","flag":"🇦🇫","code":"AF","dial_code":"+93"},
  {"name":"Åland Islands","flag":"🇦🇽","code":"AX","dial_code":"+358"},
  ...
]
```

#### Device Region code

It is possible to fetch the region code from the device. This will give you the two letter country code. (e.g. US, UK, etc.)

```dart
String code = await plugin.carrierRegionCode();
```

## Support

### Contribute

You have some ways to contribute to this packages

 - Beginner: Reporting bugs or request new features
 - Intermediate: Implement new features (from issues or not) and created pull requests
 - Advanced: Join the [organization](#ecosystem) like a member and help coding, manage issues, dicuss new features and other things

 See [contribution guide](https://github.com/flutter-form-builder-ecosystem/.github/blob/main/CONTRIBUTING.md) for more details

### Questions and answers

You can join to [our Discord server](https://discord.gg/25KNPMJQf2)

### Donations

Donate or become a sponsor of Flutter Form Builder Ecosystem

[![Become a Sponsor](https://opencollective.com/flutter-form-builder-ecosystem/tiers/sponsor.svg?avatarHeight=56)](https://opencollective.com/flutter-form-builder-ecosystem)

## Roadmap

- [Web support](https://github.com/flutter-form-builder-ecosystem/phone_number/issues/44)
- [Simplify example code](https://github.com/flutter-form-builder-ecosystem/phone_number/issues/79)
- [Implement integration tests](https://github.com/flutter-form-builder-ecosystem/phone_number/issues/74)
- [Solve open issues](https://github.com/flutter-form-builder-ecosystem/phone_number/issues), [prioritizing bugs](https://github.com/flutter-form-builder-ecosystem/phone_number/labels/bug)

## Ecosystem

Take a look to [our awesome ecosystem](https://github.com/flutter-form-builder-ecosystem) and all packages in there

## Thanks to

### Contributors

<a href="https://github.com/flutter-form-builder-ecosystem/phone_number/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=flutter-form-builder-ecosystem/phone_number" />
</a>

Made with [contrib.rocks](https://contrib.rocks).
