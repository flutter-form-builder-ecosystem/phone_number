import 'package:flutter/services.dart';
import 'package:phone_number/phone_number.dart';
import 'package:phone_number_example/models/parse_result.dart';
import 'package:phone_number_example/models/region.dart';

class Store {
  final PhoneNumberUtil plugin;

  Store(this.plugin);

  List<Region> _regions;

  Future<List<Region>> getRegions() async {
    if (_regions == null) {
      final data = await plugin.allSupportedRegions();

      // Filter out regions with more than 2 characters
      _regions = data
          .where((e) => e.code.length <= 2)
          .map((e) => Region(e.code, e.prefix))
          .toList();

      _regions.sort();
    }
    return _regions;
  }

  Future<ParseResult> parse(String string, {Region region}) async {
    print("parse $string for region: ${region?.code}");
    try {
      final result1 =
          await plugin.parseList(['0334110404', '979006985'], regionCode: 'VN');
      print(result1);
      final result = await plugin.parse(string, regionCode: region?.code);
      return ParseResult(result);
    } on PlatformException catch (e) {
      return ParseResult.error(e.code);
    }
  }

  Future<String> format(String string, Region region) async {
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
      print(e.toString());
      return false;
    }
  }
}
