import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:phone_number/phone_number.dart';
import 'package:phone_number/src/utils/utils.dart';

/// Behavior of [PhoneNumberEditingController].
enum PhoneInputBehavior {
  /// Accepts only phone numbers, with formatting always on.
  ///
  /// Considers all inputs are phone numbers, and ignores the input if
  /// formatting fails.
  /// Always tries to format.
  strict,

  /// Accepts only phone numbers, but may cancel formatting.
  ///
  /// Considers all inputs are phone numbers, and ignores the input if
  /// formatting fails.
  /// Stops formatting if a separator is removed by the user.
  /// Will continue formatting if the input is cleared.
  cancellable,

  /// Accepts any input.
  ///
  /// Stops formatting if a separator is removed by the user, if the formatting
  /// fails, or if a non-dialable is inserted.
  /// Will continue formatting if the input is cleared.
  lenient,
}

// Implementation details:
//
// Custom patterns are used in favor of RegExp for better performance.
//
// Formatting sets super.value after await, but does not check whether the
// current value is still oldValue.
// By testing, this is better than checking before setting, which causes
// inputs to be ignored if the user types too fast.
//
// The reason a TextEditingController is used instead of a TextInputFormatter
// is that we need to call async functions, so this allows us to call them
// without needing the user to provide a callback.
//
// The new offsets are calculated by counting characters instead of using
// getRememberedPosition() from AsYouTypeFormatter.
// The reasons for doing so are:
//
// - There is no such method for the iOS version, so this would have to be
//  used in iOS anyways.
// - This allows two positions to be remembered for the selection, though just
//  remembering the end of the selection is fine, as it only formats after
//  insertion or deletion.

/// A [TextEditingController] which applies phone number formatting.
///
/// The property [behavior] allows you to control how the controller handles
/// deleting separators or inserting non-dialable digits.
class PhoneNumberEditingController extends TextEditingController {
  /// Behavior of the controller.
  ///
  /// Defaults to [PhoneInputBehavior.lenient].
  final PhoneInputBehavior behavior;

  /// Region code to format the string.
  final String regionCode;

  final PhoneNumberUtil _phoneNumberUtil;

  /// Used for lenient mode, where we accept non-phonenumber inputs.
  bool _stopFormatting = false;

  /// Creates a controller for an editable text field.
  PhoneNumberEditingController(
    this._phoneNumberUtil, {
    required this.regionCode,
    super.text,
    this.behavior = PhoneInputBehavior.lenient,
  });

  /// Creates a controller for an editable text field from an initial [TextEditingValue].
  PhoneNumberEditingController.fromValue(
    this._phoneNumberUtil,
    super.value, {
    required this.regionCode,
    this.behavior = PhoneInputBehavior.lenient,
  }) : super.fromValue();

  @override
  set value(TextEditingValue newValue) => _formatAndSet(value, newValue);

  Future<void> _formatAndSet(
      TextEditingValue oldValue, TextEditingValue newValue) async {
    // Ignore invalid selections
    if (!newValue.selection.isValid) {
      return;
    }

    // Do not format if unchanged or composing
    if (newValue.text == oldValue.text || !newValue.composing.isCollapsed) {
      super.value = newValue;
      return;
    }

    if (newValue.text.isEmpty) {
      // Start formatting again if input is clear
      _stopFormatting = false;
      super.value = newValue;
      return;
    }

    // Do not format
    if (_stopFormatting) {
      if (behavior == PhoneInputBehavior.cancellable &&
          newValue.text.contains(const NonDialable())) {
        // Remove non dialable
        final text = newValue.text.replaceAll(const NonDialable(), '');
        super.value = TextEditingValue(
          text: text,
          selection: _updateOffsets(newValue, text),
        );
        return;
      }

      super.value = newValue;
      return;
    }

    if (behavior != PhoneInputBehavior.strict) {
      final newNonDialableCount =
          (const NonDialable()).allMatches(newValue.text).length;
      final oldNonDialableCount =
          (const NonDialable()).allMatches(oldValue.text).length;

      switch (behavior) {
        case PhoneInputBehavior.cancellable:
          // Check if a non-dialable was removed. If so, stop formatting.
          if (newNonDialableCount < oldNonDialableCount) {
            _onStopFormatting(oldValue, newValue);
            return;
          }
          break;
        case PhoneInputBehavior.lenient:
          // Check if a non-dialable was removed or inserted. If so, stop formatting.
          if (newNonDialableCount != oldNonDialableCount) {
            _onStopFormatting(oldValue, newValue);
            return;
          }
          break;
        default:
      }
    }

    String formatted;

    try {
      formatted = await _phoneNumberUtil.format(
        newValue.text.replaceAll(const NonDialable(), ''),
        regionCode,
      );
    } on PlatformException {
      switch (behavior) {
        case PhoneInputBehavior.strict:
        case PhoneInputBehavior.cancellable:
          super.value = oldValue;
          return;
        default:
          _onStopFormatting(oldValue, newValue);
          return;
      }
    }

    super.value = TextEditingValue(
      text: formatted,
      selection: _updateOffsets(newValue, formatted),
    );
  }

  void _onStopFormatting(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    _stopFormatting = true;

    // Do not remove anything in the range that contains new characters
    final additionRange = newValue.text.findAdditionRange(oldValue.text);
    final start = additionRange.start != -1 ? additionRange.start : 0;
    final end = additionRange.end != -1 ? additionRange.end : 0;

    final pattern = (const NonDialable()).excludeRange(start, end);

    final keptIndices = pattern
        .not()
        .allMatches(newValue.text)
        .map((match) => match.start)
        .toList();
    var baseOffset = 0;
    if (newValue.selection.baseOffset > 0) {
      final i = newValue.selection.baseOffset - 1;
      final j = lowerBound(keptIndices, i);
      if (keptIndices[j] == i) {
        baseOffset = j + 1;
      } else {
        baseOffset = j;
      }
    }
    var extentOffset = 0;
    if (newValue.selection.extentOffset > 0) {
      final i = newValue.selection.extentOffset - 1;
      final j = lowerBound(keptIndices, i);
      if (keptIndices[j] == i) {
        extentOffset = j + 1;
      } else {
        extentOffset = j;
      }
    }

    super.value = TextEditingValue(
      text: newValue.text.replaceAll(pattern, ''),
      selection: newValue.selection.copyWith(
        baseOffset: baseOffset,
        extentOffset: extentOffset,
      ),
    );
  }

  static TextSelection _updateOffsets(
    TextEditingValue value,
    String formatted,
  ) {
    var newBaseOffset = 0;
    if (value.selection.baseOffset > 0) {
      var index = value.text.lastIndexOf(
        const Dialable(),
        value.selection.baseOffset - 1,
      );
      if (index != -1) {
        final newIndex = getNewIndex(
            oldIndex: index, oldText: value.text, newText: formatted);
        newBaseOffset = newIndex + 1;
      }
    }
    var newExtentOffset = 0;
    if (value.selection.extentOffset == value.selection.baseOffset) {
      newExtentOffset = newBaseOffset;
    } else if (value.selection.extentOffset > 0) {
      final index = value.text.lastIndexOf(
        const Dialable(),
        value.selection.extentOffset - 1,
      );
      if (index != -1) {
        final newIndex = getNewIndex(
            oldIndex: index, oldText: value.text, newText: formatted);
        newExtentOffset = newIndex + 1;
      }
    }
    return value.selection.copyWith(
      baseOffset: newBaseOffset,
      extentOffset: newExtentOffset,
    );
  }
}
