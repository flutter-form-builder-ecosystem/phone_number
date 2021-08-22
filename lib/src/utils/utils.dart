import 'package:flutter/widgets.dart';
import 'package:phone_number/src/utils/patterns.dart';

export 'package:phone_number/src/utils/patterns.dart';

/// Get index of character at oldText[oldIndex] in newText
int getNewIndex({
  required int oldIndex,
  required String oldText,
  required String newText,
}) {
  final c = oldText.codeUnitAt(oldIndex);

  final charCount = CodeUnitPattern(c).allMatches(oldText, 0, oldIndex).length;

  return CodeUnitPattern(c).allMatches(newText).nth(charCount)?.start ??
      (newText.length - 1);
}

extension IterableExt<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;

  E? nth(int i) {
    if (i == 0) {
      return firstOrNull;
    } else {
      return skip(i - 1).firstOrNull;
    }
  }
}

extension StringExt on String {
  /// Finds a conservative range such that if the substring at this
  /// range is removed, the result is a substring of [base].
  ///
  /// Example:
  ///
  /// ```
  /// 'abcdef'.findAdditionRange('adef') == TextRange(start: 1, end: 4);
  /// ```
  TextRange findAdditionRange(String base) {
    var from = 0;
    while (codeUnitAt(from) == base.codeUnitAt(from)) {
      from += 1;
      if (from == length) {
        return TextRange.empty;
      }
      if (from == base.length) {
        return TextRange(start: base.length, end: length);
      }
    }

    var to = length - 1;
    var bTo = base.length - 1;
    while (codeUnitAt(to) == base.codeUnitAt(bTo)) {
      bTo -= 1;
      if (bTo < 0) {
        return TextRange(start: 0, end: to + 1);
      }
      to -= 1;
      if (to < from) {
        return TextRange.empty;
      }
    }

    return TextRange(start: from, end: to + 1);
  }
}

int lowerBound(List<int> sortedList, int element) {
  var min = 0;
  var max = sortedList.length;
  while (min < max) {
    final mid = min + ((max - min) >> 1);
    final midElement = sortedList[mid];
    if (element > midElement) {
      min = mid + 1;
    } else {
      max = mid;
    }
  }
  return min;
}
