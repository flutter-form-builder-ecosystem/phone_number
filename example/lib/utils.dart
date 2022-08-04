import 'package:flutter/material.dart';

class Utils {
  static void showSnackBar(BuildContext context, String message,
      {Duration? duration, Color? color, Widget? prefix}) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Row(
          children: [
            if (prefix != null) ...[prefix, const SizedBox(width: 8)],
            Text(
              message,
              style: TextStyle(
                color: (color?.computeLuminance() ?? 0) < 0.5
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ],
        ),
        backgroundColor: color,
        margin: const EdgeInsets.all(20),
        behavior: SnackBarBehavior.floating,
        duration: duration ?? const Duration(seconds: 4),
      ));
  }
}
