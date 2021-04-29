import 'package:meta/meta.dart';

class RegionInfo {
  final String name;
  final String code;
  final int prefix;

  const RegionInfo({
    @required this.name,
    @required this.code,
    @required this.prefix,
  });
}
