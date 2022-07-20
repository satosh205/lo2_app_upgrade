import 'package:flutter/material.dart';
import 'package:masterg/utils/config.dart';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

class ColorConstants {
  static const PRIMARY_COLOR_LIGHT = MaterialColor(
    0xff1A1A1D,
    <int, Color>{
      50: Color(0xff1A1A1D),
      100: Color(0xff1A1A1D),
      200: Color(0xff1A1A1D),
      300: Color(0xff1A1A1D),
      400: Color(0xff1A1A1D),
      500: Color(0xff1A1A1D),
      600: Color(0xff1A1A1D),
      700: Color(0xff1A1A1D),
      800: Color(0xff1A1A1D),
      900: Color(0xff1A1A1D),
    },
  );

  //static dynamic PRIMARY_COLOR =Color(int.parse(Preference.getString(Preference.THEMECOLOR)));

  static const PRIMARY_COLOR = Color(0xff2c73d9);
  //static const PRIMARY_COLOR = Color(0xFFFFB606);
  static const PRIMARY_COLOR_DARK = Color(0xff2e78e4);
  static const ACCENT_COLOR = Color(0xffffffff);
  static const TEXT_FIELD_BG = Color(0xffF2F2F2);
  static const WHITE = Color(0xffffffff);
  static const BLACK = Color(0xff000000);
  static const PENDING_GREY = Color(0xffA7A7A7);
  static const GREY = Color(0xffF0F0F0);
  static const DAR_GREY = Color(0xff252525);
  static const GREEN = Color(0xff258d00);
  static const RED_BG = Color(0xFFff3d3d);
  static const BOTTOM_GREY = Color(0xffF8F8F8);
  static const HINT_GREY = Color(0xffACACAC);
  static const INACTIVE_TAB = Color(0xFFBFBFBF);
  static const ACTIVE_TAB = Color(0xFFffd500);
  static const YELLOW_ACTIVE_BUTTON = Color(0xFFffd500);
  static const YELLOW = Color(0xFFFDB515);
  static const START_GREY_BG = Color(0xFFE0E0E0);
  static const ACTIVE_TAB_UNDERLINE = Color(0xFF12AAEB);
  static const TEXT_DARK_BLACK = Color(0xff1c2555);
  static const BG_COLOR = Color(0xffFAFAFA);
  static const SEARCH_FILLED = Color(0xff194250);
  static const SELECTED_PAGE = Color(0xffF6BA17);
  static const UNSELECTED_PAGE = Color(0xff11576F);
  static const GREY_2 = Color(0xff4F4F4F);
  static const GREY_3 = Color(0xff828282);
  static const GREY_4 = Color(0xffBDBDBD);
  static const COURSE_BG = Color(0xff333333);
  static const SECTION_DIVIDER = Color(0xffF5F5F5);
  static const DIVIDER = Color(0xffEFEFEF);
  static const NOTIFICATION_DATE_GREY = Color(0xff9D9A9A);
  static const ORANGE = Color(0xffff8d29);
  static const DARK_BLUE = Color(0xff1c2555);
  static const GREY_OUTLINE = Color(0xff757575);
  static const PURPLE = Color(0xff2c2738);
  static const STARCOLOUR = Color(0xfff9414d);

  //Continue button color
  static const CONTINUE_COLOR = Color(0xff043140);
  static const DARK_GREY = Color(0xff444444);
  static const BG_GREY = Color(0xffF2F2F2);
  static const ICON_BG_GREY = Color(0xffE5E5E5);
  static const BG_LIGHT_GREY = Color(0xffebeeff);

  static const TEXT_DARK_BLUE = Color(0xff043140);
  static const BG_BLUE_SCREEN = Color(0xff043140);
  static const BG_BLUE_BTN = Color(0xff12AAEB);
  static const BG_DARK_BLUE_BTN = Color(0xff104152);
  static const BG_DARK_BLUE_BTN_2 = Color(0xff043140);
  static const SHADOW_COLOR = Color(0xff0000002B);
  static const DOCUMENT_QUOTE_BG = Color(0xffFDF1D0);
  static const OTP_TEXT = Color(0xff101a5c);

  static const DISABLE_COLOR = Color(0xffe2e7ff);
  static const Color_E5E5E5 = Color(0xffe5e5e5);
  static const Color_444444 = Color(0xff444444);
  static const Color_291e53 = Color(0xff291e53);
  static const Color_GREEN = Color(0xff0ebdab);

  static const Color_5f6687 = Color(0xff5f6687);

  //ASSESSMENT COLORS
  static const ANSWERED = Color.fromRGBO(255, 157, 92, 1);
  static const NOT_ANSWERED = Color.fromRGBO(255, 235, 59, 1);
  static const REVIEWED = Color.fromRGBO(14, 189, 171, 1);
  static const ANSWERED_REVIEWS = Color.fromRGBO(45, 117, 221, 1);
  static const SELECTED_GREEN = Color.fromRGBO(14, 189, 171, 1);

/************ */
  static const APPBAR_COLOR = Color(0xff2c73d9);
  static const BUTTON_COLOR = Color(0xff2c73d9);
  /********** */
  Color primaryColor(){
    return HexColor.fromHex(APK_DETAILS['theme_color']!);
  }

  Color buttonColor(){
    return HexColor.fromHex(APK_DETAILS['theme_color']!);
  }






}
