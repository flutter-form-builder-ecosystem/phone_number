class Region extends Comparable<Region> {
  final String code;
  final int prefix;
  final String name;

  Region(this.code, this.prefix, this.name);

  @override
  int compareTo(region) => code.compareTo(region.code);

  @override
  String toString() {
    return 'Region{name: $name, code: $code, prefix: $prefix}';
  }
}
