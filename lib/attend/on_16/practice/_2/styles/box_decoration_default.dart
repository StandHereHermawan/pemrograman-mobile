import 'package:flutter/material.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/styles/colors.dart';

class BoxDecorationDefault {
  static BoxDecoration? defaultYellowBoxDecoration(
      {double borderRadius = 30, Color? color}) {
    color ??= DefaultColors.secondaryColors;
    return BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(borderRadius),
      ),
      color: color,
    );
  }
}
