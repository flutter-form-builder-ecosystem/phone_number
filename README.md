# Phone Number for Flutter

PhoneNumber is a Flutter plugin that allows you to parse, validate and format international phone numbers.

The plugin uses the native libraries [libphonenumber](https://github.com/google/libphonenumber) for Android and [PhoneNumberKit](https://github.com/marmelroy/PhoneNumberKit) pod for iOS.

| Library        | Version   |
| -------------- | --------- |
| libphonenumber | `8.12.52` |
| PhoneNumberKit | `3.4.4`   |

## Usage

### Parsing

Parse a phone number with region prefix.

```dart
String springFieldUSASimple = '+14175555470';
PhoneNumber phoneNumber = await PhoneNumberUtil().parse(springFieldUSASimple);
```

Parse a phone number with region prefix and dashes.

```dart
String springFieldUSA = '+1-417-555-5470';
PhoneNumber phoneNumber = await PhoneNumberUtil().parse(springFieldUSA);
```

Parse a phone number string without the region prefix. **Region required**. Country calling codes can be found [here](https://en.wikipedia.org/wiki/List_of_country_calling_codes)

```dart
String springFieldUSASimpleNoRegion = '4175555470';
RegionInfo region = RegionInfo('US', 1);
PhoneNumber phoneNumber = await PhoneNumberUtil().parse(springFieldUSASimpleNoRegion, region: region);
```

Parsing a valid phone number results in a phone number object:

```dart
PhoneNumber{
  e164: +14175555470,
  type: PhoneNumberType.FIXED_LINE_OR_MOBILE,
  international: +1 417-555-5470,
  national: (417) 555-5470,
  countryCode: 1,
  nationalNumber: 4175555470,
  errorCode: null,
}
```

### Validating

Validating a phone number requires both the phone number string and the region country code.

```dart
PhoneNumberUtil plugin = PhoneNumberUtil();

String springFieldUSASimpleNoRegion = '4175555470';
RegionInfo region = RegionInfo('US', 1);
bool isValid = await plugin.validate(springFieldUSASimpleNoRegion, region.code);

String springFieldUSASimple = '+14175555470';
bool isValid = await plugin.validate(springFieldUSASimple, region.code);

String springFieldUSA = '+1-417-555-5470';
bool isValid = await plugin.validate(springFieldUSA, region.code);
```

### Formatting

Phone numbers can also be formatted for the UI to display the number.

```dart
String springFieldUSASimpleNoRegion = '4175555470';
RegionInfo region = RegionInfo('US', 1);
String formatted = await PhoneNumberUtil().format(springFieldUSASimpleNoRegion, region.code); // (417) 555-5470
```

PhoneNumber will not add the country prefix unless the phone number has the prefix

```dart
String springFieldUSASimpleNoRegion = '+14175555470';
RegionInfo region = RegionInfo('US', 1);
String formatted = await PhoneNumberUtil().format(springFieldUSASimpleNoRegion, region.code); // +1 (417) 555-5470
```

#### As-you-type formatting

Attach the provided `PhoneNumberEditingController` to a TextField to format its text as the user type.

There are 3 formatting behavior:

- `PhoneInputBehavior.strict`: always format, do not accept non dialable chars.
- `PhoneInputBehavior.cancellable`: stop formatting when a separator is removed, do not accept non dialable chars.
- `PhoneInputBehavior.lenient` _(default)_: stop formatting when either a non dialable char is inserted or a separator is removed.

Example video: https://www.youtube.com/watch?v=rlLGVXCi-2Y.

See `example/lib/autoformat_page.dart` for a detailed implementation.

### Regions

Fetching regions (country code and prefixes).

```dart
List<RegionInfo> regions = await plugin.allSupportedRegions();
// [ RegionInfo { code: IM, prefix: 44 }, RegionInfo { code: LU, prefix: 352 }, ... ]
```

If you want to display all the flags alongside the regions in your UI region picker, consider having a JSON file instead of using this function. [Example JSON file](https://gist.githubusercontent.com/DmytroLisitsyn/1c31186e5b66f1d6c52da6b5c70b12ad/raw/01b1af9b267471818f4f8367852bd4a2814cbae6/country_dial_info.json)

```dart
const List<Map<String, dynamic>> countries = [
  {"name":"Afghanistan","flag":"🇦🇫","code":"AF","dial_code":"+93"},
  {"name":"Åland Islands","flag":"🇦🇽","code":"AX","dial_code":"+358"},
  ...
]
```

### Device Region code

It is possible to fetch the region code from the device. This will give you the two letter country code. (e.g. US, UK, ...)

```dart
String code = await plugin.carrierRegionCode();
```

## Contributors

<a href="https://github.com/nashfive/phone_number/graphs/contributors">
  <img src="https://contributors-img.web.app/image?repo=nashfive/phone_number" />
</a>

Made with [contributors-img](https://contributors-img.web.app).
