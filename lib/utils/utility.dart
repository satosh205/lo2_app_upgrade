import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/data/models/response/home_response/category_response.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/resource/colors.dart';

import 'Styles.dart';

class Utility {
  bool isConnected = true;
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

  //  Future<bool> loop() async {
  //   while (true) {
  //     await Future.delayed(const Duration(seconds: 6));

  //     return checkConnection();

  //   }
  // }


    String calculateTimeDifferenceBetween(
        DateTime startDate, DateTime endDate, context) {
      int seconds = endDate.difference(startDate).inSeconds;
      if (seconds < 60) {
        if (seconds.abs() < 4) return '${Strings.of(context)?.justNow}';
        return '${seconds.abs()} ${Strings.of(context)?.s}';
      } else if (seconds >= 60 && seconds < 3600)
        return '${startDate.difference(endDate).inMinutes.abs()} ${Strings.of(context)?.m}';
      else if (seconds >= 3600 && seconds < 86400)
        return '${startDate.difference(endDate).inHours.abs()} ${Strings.of(context)?.h}';
      else {
        // convert day to month
        int days = startDate.difference(endDate).inDays.abs();
        if (days < 30 && days > 7) {
          return '${(startDate.difference(endDate).inDays ~/ 7).abs()} ${Strings.of(context)?.w}';
        }
        if (days > 30) {
          int month = (startDate.difference(endDate).inDays ~/ 30).abs();
          return '$month ${Strings.of(context)?.mos}';
        } else
          return '${startDate.difference(endDate).inDays.abs()} ${Strings.of(context)?.d}';
      }
    }
  Future<bool> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // setState(() {
        //   isConnected = true;
        // });
        return true;
      }
    } on SocketException catch (_) {
      // setState(() {
      //   isConnected = false;
      // });
      return false;
    }
    return false;
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
    return DateFormat(newFormat).format(DateTime.fromMillisecondsSinceEpoch(
      timeInMillis * 1000,
      isUtc: isUTC,
    ));
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

  //check status of class
  static int classStatus(int startTime, int endTime) {
    // 0-> live
    // 1-> upcoming
    // 2-> completed
    double currentTime = DateTime.now().millisecondsSinceEpoch / 1000;
    if (currentTime > startTime && currentTime < endTime)
      return 0;
    else if (currentTime < startTime)
      return 1;
    else
      return 2;
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

  static List<dynamic> getReportList() {
    List<dynamic> reportList = [
      {"title": 'It\'s Spam', 'value': 'spam'},
      {"title": 'False information', 'value': 'False information'},
      {"title": 'Bullying or harassment', 'value': 'Bullying or harassment'},
      {
        "title": 'Violence or dangerous organizations',
        'value': 'Violence or dangerous organizations'
      },
      {"title": 'Hate speech of symbols', 'value': 'Hate speech of symbols'},
      {
        "title": 'Nudity or sexual activity',
        'value': 'Nudity or sexual activity'
      },
      {"title": 'Scam and Fraud', 'value': 'Scam and Fraud'},
    ];
    return reportList;
  }

  // void checkInternet(context) {
  //   InternetConnectionChecker().onStatusChange.listen((status) {
  //     switch (status) {
  //       case InternetConnectionStatus.connected:

  //         print('====>Data connection is available now.');
  //    if(isConnected == false)ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //                           elevation: 0,
  //                           backgroundColor: Colors.transparent,
  //                           duration: Duration(seconds: 4),
  //                           content: Container(
  //                               margin: EdgeInsets.only(
  //                                   bottom: 100, left: 4, right: 4),
  //                               padding: EdgeInsets.symmetric(
  //                                   vertical: 10, horizontal: 4),
  //                               decoration: BoxDecoration(
  //                                   borderRadius: BorderRadius.circular(8),
  //                                   color: ColorConstants.GREY_2),
  //                               child: Row(
  //                                 crossAxisAlignment: CrossAxisAlignment.center,
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 children: [
  //                                   Icon(Icons.wifi, color: ColorConstants.WHITE,),
  //                                   SizedBox(width: 8),
  //                                   Text(
  //                                     "Connected to Internet!",
  //                                     style: Styles.bold(
  //                                         color: ColorConstants.WHITE),
  //                                   )
  //                                 ],
  //                               )),
  //                         ));
  //                         isConnected = true;

  //         break;
  //       case InternetConnectionStatus.disconnected:
  //         isConnected = false;
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //                           elevation: 0,
  //                           backgroundColor: Colors.transparent,
  //                           duration: Duration(seconds: 8),
  //                           content: Container(
  //                               margin: EdgeInsets.only(
  //                                   bottom: 100, left: 4, right: 4),
  //                               padding: EdgeInsets.symmetric(
  //                                   vertical: 10, horizontal: 4),
  //                               decoration: BoxDecoration(
  //                                   borderRadius: BorderRadius.circular(8),
  //                                   color: ColorConstants.GREY_2),
  //                               child: Row(
  //                                 crossAxisAlignment: CrossAxisAlignment.center,
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 children: [
  //                                   Icon(Icons.wifi_off, color: ColorConstants.WHITE,),
  //                                   SizedBox(width: 8),
  //                                   Text(
  //                                     "No Internet Connection!",
  //                                     style: Styles.bold(
  //                                         color: ColorConstants.WHITE),
  //                                   )
  //                                 ],
  //                               )),
  //                         ));

  //         break;
  //     }
  // });
  // }

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
