import 'package:flutter/material.dart';

class AppColors {
  final BuildContext context;

  AppColors(this.context);

  bool get isDarkMode {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Color get tdBlue => Colors.blue;

  Color get floatButtonBg {
    return isDarkMode ? Colors.white : Colors.black87;
  }
  Color get floatButtonText {
    return isDarkMode ? Colors.black87 : Colors.white;
  }
}
