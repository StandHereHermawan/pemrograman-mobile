import 'package:flutter/material.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/styles/colors.dart';

class TextStyleDefault {
  static TextStyle defaultBlack35SizeTextStyle(
      {double? fontSize = 35, Color? color}) {
    color ??= DefaultColors.primaryColors;
    return TextStyle(
        fontSize: fontSize, color: color, debugLabel: "Text Style Black");
  }

  static TextStyle defaultBlack16SizeTextStyle(
      {double? fontSize = 16, Color? color}) {
    color ??= DefaultColors.primaryColors;
    return TextStyle(
        fontSize: fontSize, color: color, debugLabel: "Text Style Black");
  }
}
