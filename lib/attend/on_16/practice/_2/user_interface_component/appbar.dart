import 'package:flutter/material.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/styles/colors.dart';
import 'package:pemprograman_mobile/attend/on_16/practice/_2/styles/text_style_default.dart';

class CustomAppBar {
  static dynamic appBarDefault(
      {key,
      context,
      titleAppbar = "DefaultAppbarTitle.",
      TextStyle? style,
      primaryColor = DefaultColors.primaryColors,
      backgroundColor = DefaultColors.secondaryColors,
      onPressed}) {
    style ??= TextStyleDefault.defaultBlack35SizeTextStyle();

    return AppBar(
      backgroundColor: backgroundColor,
      key: key,
      title: Text(titleAppbar, style: style),
      centerTitle: true,
      leading: MaterialButton(
        onPressed: onPressed,
        child: Center(
            child: Icon(Icons.arrow_circle_left_outlined,
                color: primaryColor, size: 35)),
      ),
    );
  }
}
