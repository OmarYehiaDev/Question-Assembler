import 'package:flutter/material.dart';
import 'constants.dart';
import 'hex_colors.dart';

class AppColors {
  static Color primary = HexColor("FFCF31");
  static Color secondary = HexColor("331E6D");
  static Color classIconColor = Colors.blueGrey[700]!;
  static Color navBarActiveColor = const Color.fromRGBO(255, 164, 0, 1);
}

class AppTextStyles {
  static TextStyle appBarTitle = TextStyle(
    color: AppColors.primary,
    fontSize: 30,
    fontWeight: FontWeight.bold,
    fontFamily: Constants.primaryFontFamily,
  );
  static TextStyle body = TextStyle(
    color: AppColors.primary,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: Constants.primaryFontFamily,
  );
}
