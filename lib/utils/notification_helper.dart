import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:masterg/data/api/api_response.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/data/models/response/home_response/get_content_resp.dart';
import 'package:masterg/data/providers/home_provider.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/main.dart';
// import 'package:masterg/pages/announecment_pages/announcemnt_details_page.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/walk_through_page/splash_screen.dart';
import 'package:masterg/utils/Log.dart';
// import 'package:masterg/pages/library_pages/library_details_page.dart';
// import 'package:masterg/pages/session_pages/scheduled_sessions_page.dart';
// import 'package:masterg/pages/walk_through_page/splash_page.dart';

// import 'Log.dart';
// import 'Strings.dart';

class NotificationHelper {
  static NotificationHelper? _notificationHelper;
  static FirebaseMessaging? _firebaseMessaging;
  static BuildContext? buildContext;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  static getInstance(BuildContext context) {
    if (_notificationHelper == null) {
      _firebaseMessaging = FirebaseMessaging.instance;
      _notificationHelper = new NotificationHelper._();
    }
    return _notificationHelper;
  }

  NotificationHelper._();

  void getFcmToken() async {
    var token = await FirebaseMessaging.instance.getToken();
    Log.v("Firebase Token : $token");

    UserSession.firebaseToken = token;
    Preference.setString(Preference.FIREBASE_TOKEN, token!);
  }

  void setFcm() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher_masterg');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin?.initialize(initSettings,
        onSelectNotification: (value){
          _onSelectNotification(value!);
        });

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    

    FirebaseMessaging.instance.getInitialMessage().then((value) {
      print("INIT MESSAGE");
      if (value != null) {
        _shownotification(value);
      }
    });

    FirebaseMessaging.onMessage.listen((message) {
      Log.v('onMessage called --> ${message.data}');
      _shownotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Log.v('onMessageOpened called --> $message');
      notificationClickAction(message.data);
    });
    // _firebaseMessaging.onIosSettingsRegistered.listen((setting) {
    //   Log.v("Data --> ${setting.toMap()}");
    // });
    // _firebaseMessaging.configure(
    //   onLaunch: _onLaunch,
    //   onResume: _onResume,
    //   onMessage: _onMessage,
    // );
  }

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    print("onBackgroundMessage: $message");
    //_showBigPictureNotification(message);
    return Future<void>.value();
  }

  // Future<dynamic> _onLaunch(Map<String, dynamic> message) {
  //   Log.v('onLaunch called --> $message');
  //   UserSession.notificationData = message;
  //   return null;
  // }

  // Future<dynamic> _onResume(Map<String, dynamic> message) {
  //   Log.v('onResume --> $message');
  //   notificationClickAction(message);
  //   return null;
  // }

  // Future<dynamic> _onMessage(Map<String, dynamic> message) {
  //   Log.v('onMessage called --> $message');
  //   _shownotification(message);
  //   return null;
  // }

  Future<dynamic> _shownotification(RemoteMessage message) async {
    print("object");
    final android = AndroidNotificationDetails(
        'com.perfetti', 'perfetti', 
         largeIcon: const DrawableResourceAndroidBitmap('ic_launcher_masterg'),
        priority: Priority.high, importance: Importance.max);
    final iOS = IOSNotificationDetails();
    final platform = NotificationDetails(android: android, iOS: iOS);
    final json = jsonEncode(message.data);
    var id = DateTime.now().millisecondsSinceEpoch.toString();
    await flutterLocalNotificationsPlugin?.show(
      
        int.parse(id.substring(id.length - 6)), // notification id
        message.notification?.title,
        message.notification?.body,
        platform,
        payload: json);
  }

  notificationClickAction(Map<String, dynamic> message) {
    Navigator.push(
        Application.getContext()!,
        NextPageRoute(EntryAnimationPage(
          // notificationData: message,
        )));
  }

  Future<void> _onSelectNotification(String json) async {
    print("Amit45678");
    print("######");
    print(json);
    final data = jsonDecode(json);
    _handleNotification(data);
  }

  void _handleNotification(Map<String, dynamic> json) async {
    Map<String, dynamic> payload = json;
    ApiResponse? res =
        await HomeProvider.getContentDetails(id: int.parse(payload['id']));
    if (res!.success) {
      var context = Application.getContext();
      if (payload['content_type'] == 'content') {
        GetContentResp resp = GetContentResp.fromJson(res.body);
        ListData data = resp.data!.list!.first;
        if (resp.data!.list!.first.categoryId == 8) {
          // Navigator.push(
          //   Application.getContext()!,
          //   MaterialPageRoute(
          //       builder: (c) => AnnouncementDetailsPage(
          //             announmentData: data,
          //             title: Strings.of(context).announcements,
          //           )),
          // );
        }
        if (resp.data?.list?.first.categoryId == 9) {
          // Navigator.push(
          //     context,
          //     NextPageRoute(LibraryDetailPage(
          //       libraryData: data,
          //     )));
        }
        if (resp.data?.list?.first.categoryId == 10) {
          // await Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (c) => AnnouncementDetailsPage(
          //             announmentData: data,
          //             title: Strings.of(context).benefits,
          //           )),
          // );
        }
      }
      if (payload['content_type'] == 'meeting') {
        // Navigator.push(context, NextPageRoute(ScheduledSessionsPage()));
      }
      if (payload['content_type'] == 'training') {
        // Navigator.push(context, NextPageRoute(ScheduledSessionsPage()));
      }
    }
  }
}
