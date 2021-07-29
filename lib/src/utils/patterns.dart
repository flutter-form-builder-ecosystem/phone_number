import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

abstract class BaseCodeUnitPattern implements Pattern {
  const BaseCodeUnitPattern();

  @protected
  bool matches(int ch, int position);

  @override
  Match? matchAsPrefix(String string, [int start = 0]) {
    if (start < string.length && matches(string.codeUnitAt(start), start)) {
      return _SingleCharacterMatch(
        input: string,
        pattern: this,
        offset: start,
      );
    }
  }

  @override
  Iterable<Match> allMatches(String string, [int start = 0, int? end]) sync* {
    final length;
    if (end != null) {
      length = min(end + 1, string.length);
    } else {
      length = string.length;
    }

    for (var i = start; i < length; i++) {
      if (matches(string.codeUnitAt(i), i)) {
        yield _SingleCharacterMatch(
          input: string,
          pattern: this,
          offset: i,
        );
      }
    }
  }

  BaseCodeUnitPattern excludeRange(int start, int end) =>
      _ExcludeRangePattern(start, end, this);

  BaseCodeUnitPattern not() => _NotPattern(this);
}

class _NotPattern extends BaseCodeUnitPattern {
  final BaseCodeUnitPattern inner;

  _NotPattern(this.inner);

  @override
  bool matches(int ch, int position) => !inner.matches(ch, position);
}

class _ExcludeRangePattern extends BaseCodeUnitPattern {
  final BaseCodeUnitPattern inner;
  final int start;
  final int end;

  _ExcludeRangePattern(this.start, this.end, this.inner);

  @override
  bool matches(int ch, int position) =>
      (position < start || position >= end) && inner.matches(ch, position);
}

/// Pattern which matches a single code unit.
class CodeUnitPattern extends BaseCodeUnitPattern {
  final int codeUnit;

  const CodeUnitPattern(this.codeUnit);

  @override
  bool matches(int ch, int position) => ch == codeUnit;
}

/// Matches single non dialable characters.
@immutable
class NonDialable extends BaseCodeUnitPattern {
  const NonDialable();

  @override
  bool matches(int ch, int position) {
    switch (String.fromCharCode(ch)) {
      case '0':
      case '1':
      case '2':
      case '3':
      case '4':
      case '5':
      case '6':
      case '7':
      case '8':
      case '9':
      case '#':
      case '*':
      case '+':
      case 'N':
      // Not really dialable but these are non separators
      case ',':
      case '.':
        return false;
      default:
        return true;
    }
  }
}

/// Matches single dialable characters.
@immutable
class Dialable extends BaseCodeUnitPattern {
  const Dialable();

  @override
  bool matches(int ch, int position) =>
      !(const NonDialable()).matches(ch, position);
}

class _SingleCharacterMatch implements Match {
  final int offset;
  @override
  final Pattern pattern;
  @override
  final String input;

  @override
  final int groupCount = 0;

  _SingleCharacterMatch({
    required this.input,
    required this.pattern,
    required this.offset,
  });

  @override
  String? operator [](int group) => null;

  @override
  int get end => offset + 1;

  @override
  String? group(int group) => null;

  @override
  List<String?> groups(List<int> groupIndices) => const [];

  @override
  int get start => offset;
}
