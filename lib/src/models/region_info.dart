import 'package:meta/meta.dart' show immutable;

/// Phone number region information
@immutable
class RegionInfo {
  /// ISO 3166-1 alpha-2 codes are two-letter country codes defined in ISO 3166-1,
  /// part of the ISO 3166 standard[1] published by the International Organization
  /// for Standardization (ISO), to represent countries, dependent territories, and
  /// special areas of geographical interest.
  final String code;

  /// By convention, international telephone numbers are represented by prefixing the country code
  /// with a plus sign (+), which also indicates to the subscriber that the local international
  /// call prefix must first be dialed. Example: (USA) +1
  final int prefix;

  RegionInfo({
    required this.code,
    required this.prefix,
  });

  @override
  int get hashCode => code.hashCode ^ prefix.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegionInfo && code == other.code && prefix == other.prefix;

  @override
  String toString() {
    return '''RegionInfo { code: $code, prefix: $prefix }''';
  }
}
