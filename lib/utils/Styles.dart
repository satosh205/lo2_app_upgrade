import 'package:flutter/material.dart';
import 'package:masterg/utils/resource/colors.dart';

class Styles {
  static const _NunitoBold = "Nunito_Bold";
  static const _NunitoLight = "Nunito_Light";
  static const _NunitoRegular = "Nunito_Regular";
  static const _NunitoExtraBold = "Nunito_ExtraBold";
  static const _NunitoSemiBold = "Nunito_SemiBold";

  static const _OpenSansBold = "OpenSansBold";
  static const _OpenSansSemiBold = "OpenSans_SemiBold";
  static const _OpenSansRegular = "OpenSans_Regular";

  static const _DMSansBold = "DMSans_Bold";
  static const _DMSansRegular = "DMSans_Regular";

  static textBold({double? size = 14, Color color = ColorConstants.DARK_BLUE}) {
    return TextStyle(fontSize: size, fontFamily: _NunitoBold, color: color);
  }

  static textExtraBold(
      {double? size = 14, Color color = ColorConstants.DARK_BLUE}) {
    return TextStyle(
        fontSize: size, fontFamily: _NunitoExtraBold, color: color);
  }

  static textExtraBoldUnderline(
      {double size = 14, Color color = ColorConstants.DARK_BLUE}) {
    return TextStyle(
        fontSize: size,
        fontFamily: _NunitoExtraBold,
        color: color,
        decoration: TextDecoration.underline);
  }

  static textRegular(
      {double? size = 14, Color color = ColorConstants.DARK_BLUE}) {
    return TextStyle(fontSize: size, fontFamily: _NunitoRegular, color: color);
  }

  static textItalic(
      {double size = 14, Color color = ColorConstants.DARK_BLUE}) {
    return TextStyle(
        fontSize: size,
        fontFamily: _NunitoRegular,
        color: color,
        fontStyle: FontStyle.italic);
  }

  static textSemiBold(
      {double? size = 14, Color color = ColorConstants.DARK_BLUE}) {
    return TextStyle(fontSize: size, fontFamily: _NunitoSemiBold, color: color);
  }

  static textSemiBoldUndeline(
      {double size = 14, Color color = ColorConstants.DARK_BLUE}) {
    return TextStyle(
        fontSize: size,
        fontFamily: _NunitoSemiBold,
        color: color,
        decoration: TextDecoration.underline);
  }

  static textLight(
      {double? size = 14, Color color = ColorConstants.DARK_BLUE}) {
    return TextStyle(
      fontSize: size,
      fontFamily: _NunitoLight,
      color: color,
    );
  }

  static boldWhite({double? size}) {
    return textBold(size: size, color: ColorConstants.WHITE);
  }

  static regularWhite({double? size}) {
    return textRegular(size: size, color: ColorConstants.WHITE);
  }

  static semiBoldWhite({double? size}) {
    return textSemiBold(size: size, color: ColorConstants.WHITE);
  }

  static extraBoldWhite({double? size}) {
    return textExtraBold(size: size, color: ColorConstants.WHITE);
  }

  static lightWhite({double? size}) {
    return textLight(size: size, color: ColorConstants.WHITE);
  }

  static bold({double size = 16, Color color = ColorConstants.BLACK}) {
    return TextStyle(
        fontSize: size * 1.0,
        fontFamily: _OpenSansBold,
        color: color,
        fontWeight: FontWeight.w700);
  }

  static semibold({double size = 18, Color color = ColorConstants.BLACK}) {
    return TextStyle(
        fontSize: size * 1.0,
        fontFamily: _OpenSansSemiBold,
        color: color,
        fontWeight: FontWeight.w600);
  }

  static lineThrough({double size = 18, Color color = ColorConstants.BLACK}) {
    return TextStyle(
      fontSize: size * 1.0,
      fontFamily: _OpenSansSemiBold,
      decoration: TextDecoration.lineThrough,
    );
  }

  static regular({double size = 16, Color color = ColorConstants.GREY_2}) {
    return TextStyle(
        fontSize: size * 1.0,
        fontFamily: _OpenSansRegular,
        color: color,
        fontWeight: FontWeight.w400);
  }

  static DMSansbold({double size = 18, Color color = ColorConstants.BLACK}) {
    return TextStyle(
        fontSize: size,
        fontFamily: _DMSansBold,
        color: color,
        fontWeight: FontWeight.w700);
  }

  static DMSansregular(
      {double size = 16, Color color = ColorConstants.GREY_2}) {
    return TextStyle(
        fontSize: size,
        fontFamily: _DMSansRegular,
        color: color,
        fontWeight: FontWeight.w400);
  }
}
