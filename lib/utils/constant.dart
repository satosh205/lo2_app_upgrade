import 'package:flutter/material.dart';
import 'package:masterg/utils/resource/colors.dart';

const forbiddenRolesList = [
  "",
  "psr",
  "ssr",
  "ws",
  "dbsm",
  "merchandiser",
  "promoter",
  "dbsm neo",
  "dbsm gotm",
  "ws dbsm gotm",
  "ws dbsm neo"
];

class DB {
  static const String CONTENT = 'content';
  static const String ANALYTICS = 'analytics';
  static const String TRAININGS = 'trainings';
}

class AnalyticsType {
  static const String COURSE_LEADERBOARD_TYPE_1 = 'CL1';
  static const String COURSE_LEADERBOARD_TYPE_2 = 'CL2';
  static const String MODULE_TYPE_1 = 'MOD1';
  static const String MODULE_TYPE_2 = 'MOD2';
  static const String MODULE_LEADERBOARD_TYPE_1 = 'ML1';
  static const String MODULE_LEADERBOARD_TYPE_2 = 'ML2';
}

const textInputDecoration = InputDecoration(
  fillColor: Color(0xFFFFFF),
  hintStyle: TextStyle(
    color: ColorConstants.GREY_OUTLINE,
    fontSize: 16,
  ),
  filled: false,
  labelStyle: TextStyle(
    color: ColorConstants.TEXT_DARK_BLACK,
    fontSize: 16,
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: ColorConstants.GREY_OUTLINE,
      width: 1,
    ),
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(4),
      topRight: Radius.circular(4),
      bottomLeft: Radius.circular(4),
      bottomRight: Radius.circular(4),
    ),
  ),
  focusColor: ColorConstants.GREY_OUTLINE,
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: ColorConstants.GREY_OUTLINE,
      width: 1,
    ),
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(4),
      topRight: Radius.circular(4),
    ),
  ),
);

const textRoundInputDecoration = InputDecoration(
  fillColor: Color(0xFFFFFF),
  hintStyle: TextStyle(
    color: ColorConstants.GREY_OUTLINE,
    fontSize: 16,
  ),
  filled: false,
  labelStyle: TextStyle(
    color: ColorConstants.TEXT_DARK_BLACK,
    fontSize: 16,
  ),
  contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: ColorConstants.GREY_OUTLINE,
      width: 1,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(8),
    ),
  ),
  focusColor: ColorConstants.GREY_OUTLINE,
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: ColorConstants.GREY_OUTLINE,
      width: 1,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(8),
    ),
  ),
);

const double appButtonHeight = 40.0;

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
