class Region extends Comparable<Region> {
  final String code;
  final int prefix;

  Region(this.code, this.prefix);

  @override
  int compareTo(region) => code.compareTo(region.code);

  @override
  String toString() {
    return 'Region{code: $code, prefix: $prefix}';
  }
}
