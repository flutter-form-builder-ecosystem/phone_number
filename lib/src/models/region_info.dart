import 'package:meta/meta.dart' show immutable;

/// Phone number region information
@immutable
class RegionInfo {
  /// Localized name for the country.
  final String name;

  /// ISO 3166-1 alpha-2 codes are two-letter country codes defined in ISO 3166-1,
  /// part of the ISO 3166 standard[1] published by the International Organization
  /// for Standardization (ISO), to represent countries, dependent territories, and
  /// special areas of geographical interest.
  final String code;

  /// By convention, international telephone numbers are represented by prefixing the country code
  /// with a plus sign (+), which also indicates to the subscriber that the local international
  /// call prefix must first be dialed. Example: (USA) +1
  final int prefix;

  const RegionInfo({
    required this.name,
    required this.code,
    required this.prefix,
  });

  factory RegionInfo.fromJson(Map<String, dynamic> json) => RegionInfo(
        name: json['name'],
        code: json['code'],
        prefix: json['prefix'],
      );

  @override
  int get hashCode => name.hashCode ^ code.hashCode ^ prefix.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegionInfo &&
          name == other.name &&
          code == other.code &&
          prefix == other.prefix;

  @override
  String toString() {
    return 'RegionInfo { name: $name, code: $code, prefix: $prefix }';
  }
}
