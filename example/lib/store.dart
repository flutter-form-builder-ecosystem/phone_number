import 'package:flutter/services.dart';
import 'package:phone_number/phone_number.dart';
import 'package:phone_number_example/models/parse_result.dart';
import 'package:phone_number_example/models/region.dart';

class Store {
  final PhoneNumberUtil plugin;

  Store(this.plugin);

  List<Region>? _regions;

  Future<List<Region>> getRegions() async {
    if (_regions == null) {
      final regions = await plugin.allSupportedRegions();

      // Filter out regions with more than 2 characters
      _regions = regions
          .where((e) => e.code.length <= 2)
          .map((e) => Region(e.code, e.prefix, e.name))
          .toList(growable: false);

      _regions!.sort((a, b) => a.name.compareTo(b.name));
    }
    return _regions ?? [];
  }

  Future<ParseResult> parse(String string, {Region? region}) async {
    print("parse $string for region: ${region?.code}");
    try {
      final result = await plugin.parse(string, regionCode: region?.code);
      return ParseResult(result);
    } on PlatformException catch (e) {
      return ParseResult.error(e.code);
    }
  }

  Future<String?> format(String string, Region region) async {
    print("format $string for region: ${region.code}");
    try {
      final result = await plugin.format(string, region.code);
      return result;
    } on PlatformException catch (e) {
      return e.code;
    }
  }

  Future<bool> validate(String string, Region region) async {
    print("validate $string for region: ${region.code}");
    try {
      final result = await plugin.validate(string, region.code);
      return result;
    } on PlatformException catch (e) {
      return false;
    }
  }

  Future<String?> carrierRegionCode() async {
    print("fetching carrierRegionCode");
    try {
      final result = await plugin.carrierRegionCode();
      return result;
    } on PlatformException catch (e) {
      print(e.toString());
      return null;
    }
  }
}
