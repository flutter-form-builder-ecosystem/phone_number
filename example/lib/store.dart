import 'package:flutter/services.dart';
import 'package:phone_number/phone_number.dart';
import 'package:phone_number_example/models/parse_result.dart';
import 'package:phone_number_example/models/region.dart';

class Store {
  final PhoneNumber plugin;

  Store(this.plugin);

  List<Region> _regions;

  Future<List<Region>> getRegions() async {
    if (_regions == null) {
      final data = await plugin.allSupportedRegions();

      // Filter out regions with more than 2 characters
      _regions = data.entries
          .where((e) => e.key.length <= 2)
          .map((e) => Region(e.key, e.value))
          .toList();

      _regions.sort();
    }
    return _regions;
  }

  Future<ParseResult> parse(String string, {Region region}) async {
    print("parse $string for region: ${region?.code}");
    try {
      final result = await plugin.parse(string, region: region?.code);
      return ParseResult(result);
    } on PlatformException catch (e) {
      return ParseResult.error(e.code);
    }
  }
}
