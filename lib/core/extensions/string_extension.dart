import 'package:flutter/cupertino.dart';
import 'package:qchat/core/constants/app/app_colors.dart';

extension ImagePathExtension on String {
  String get toSVG => 'assets/svg/$this.svg';
  String get toPng => 'assets/images/$this.png';
}

extension TextStyleExtension on TextStyle {
  TextStyle get minStyle => TextStyle(
        color: color ?? AppColors.black,
        decoration: decoration ?? TextDecoration.none,
        fontSize: 10,
        height: 1.4,
        letterSpacing: 1,
        fontWeight: fontWeight ?? FontWeight.w400,
        fontFamily: "futura",
      );

  TextStyle get smallStyle => TextStyle(
        color: color ?? AppColors.black,
        decoration: decoration ?? TextDecoration.none,
        fontSize: 14,
        height: 1.4,
        letterSpacing: 1,
        fontWeight: fontWeight ?? FontWeight.w400,
        fontFamily: "futura",
      );

  TextStyle get normalStyle => TextStyle(
        color: color ?? AppColors.black,
        decoration: decoration ?? TextDecoration.none,
        fontSize: 17,
        height: 1.4,
        letterSpacing: 1,
        fontWeight: fontWeight ?? FontWeight.w400,
        fontFamily: "futura",
      );

  TextStyle get mediumStyle => TextStyle(
        color: color ?? AppColors.black,
        decoration: decoration ?? TextDecoration.none,
        fontSize: 20,
        height: 1.4,
        letterSpacing: 1,
        fontWeight: fontWeight ?? FontWeight.w400,
        fontFamily: "futura",
      );
  TextStyle get largeStyle => TextStyle(
        color: color ?? AppColors.black,
        decoration: decoration ?? TextDecoration.none,
        fontSize: 23,
        height: 1.4,
        letterSpacing: 1,
        fontWeight: fontWeight ?? FontWeight.w400,
        fontFamily: "futura",
      );

  TextStyle get extraStyle => TextStyle(
        color: color ?? AppColors.black,
        decoration: decoration ?? TextDecoration.none,
        fontSize: 40,
        height: 1.4,
        letterSpacing: 0.36,
        fontWeight: fontWeight ?? FontWeight.w400,
        fontFamily: "futura",
      );
}
