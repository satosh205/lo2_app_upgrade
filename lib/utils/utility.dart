import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/data/models/response/home_response/category_response.dart';
import 'package:masterg/utils/resource/colors.dart';

import 'Styles.dart';

class Utility {
  static Future<bool> checkNetwork() async {
    bool isConnected = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
    }
    return isConnected;
  }

  static void hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  var currentLocation;

  static void showSnackBar(
      {String? message,
      required BuildContext? scaffoldContext,
      int miliSec = 1500}) {
    if (scaffoldContext != null)
      ScaffoldMessenger.of(scaffoldContext).showSnackBar(SnackBar(
          duration: Duration(milliseconds: miliSec),
          content: Text(
            message ?? "",
            style: Styles.textBold(color: ColorConstants.WHITE),
          ),
          backgroundColor: ColorConstants.BLACK));
  }

  static String convertDateFromMillis(int timeInMillis, String newFormat,
      {bool isUTC = false}) {
    return DateFormat(newFormat).format(
        DateTime.fromMillisecondsSinceEpoch(timeInMillis * 1000, isUtc: isUTC));
  }

  //check if date is expired or not
  static bool isExpired(int timeInMillis) {
    return DateTime.now().millisecondsSinceEpoch / 1000 > timeInMillis;
  }

  //check if current time is lies between start and end time
  static bool isBetween(int startTime, int endTime) {
    return DateTime.now().millisecondsSinceEpoch / 1000 > startTime &&
        DateTime.now().millisecondsSinceEpoch / 1000 < endTime;
  }

  static String convertCourseTime(int? timeInMillis, String newFormat,
      {bool isUTC = false}) {
    return DateFormat(newFormat).format(DateTime.fromMillisecondsSinceEpoch(
        timeInMillis! * 1000,
        isUtc: isUTC));
  }

  static String getDiffInMin(int start, int end) {
    var diff = end - start;
    DateTime time = DateTime.fromMillisecondsSinceEpoch(diff * 1000).toUtc();
    //convert time to minutes
    int minutes = time.minute;
    return minutes.toString();
  }

  static String convertDateFormat(DateTime date,
      {String format = 'MM/dd/yyyy'}) {
    var formatter = new DateFormat(format);
    String formatted = formatter.format(date);
    return formatted;
  }

  static int getDeviceType() {
    if (Platform.isAndroid)
      return 1;
    else
      return 2;
  }

  static Future waitFor(int seconds) async {
    await Future.delayed(Duration(seconds: seconds));
  }

  static Future waitForMili(int mili) async {
    await Future.delayed(Duration(milliseconds: mili));
  }

  static int? getCategoryValue(String type) {
    if (UserSession.categoryData == null) return 0;
    int? contentType = 0;
    CategoryResp respone =
        CategoryResp.fromJson(json.decode(UserSession.categoryData!));

    for (var element in respone.data!.listData!) {
      if (element.title!.toLowerCase().contains(type.toLowerCase())) {
        contentType = element.id;
        break;
      }
    }
    return contentType;
  }
}
