import 'package:flutter/material.dart';

class AppColors {
  final BuildContext context;

  AppColors(this.context);

  bool get isDarkMode {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Color get appBlue => Colors.blue;

  Color get dropdownButtonBg {
    return isDarkMode ? Colors.white : Colors.black87;
  }

  Color get appDefaultBgColor {
    return isDarkMode ? Colors.white : Colors.black87;
  }

  Color get appDefaultTextColor {
    return isDarkMode ? Colors.black87 : Colors.white;
  }

  Color get timerBg {
    return isDarkMode ? const Color.fromARGB(255, 49, 49, 49) : Colors.white;
  }

  Color get timerButtonBg => const Color(0xFF415b6e); //Colors.blueGrey;
  Color get white => Colors.white;
}
