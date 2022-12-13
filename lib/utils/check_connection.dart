import 'dart:io';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';

class CheckInternet extends StatefulWidget {
  final Widget body;
  final Function refresh;

  const CheckInternet({super.key, required this.body, required this.refresh});

  @override
  State<CheckInternet> createState() => _CheckInternetState();
}

class _CheckInternetState extends State<CheckInternet> {
  bool isConnected = true;
  bool isSnackBarShowing = false;

  @override
  void initState() {
    super.initState();
    // loop();
  }

  void loop() async {
    while (true) {
      print('checking internet $isConnected');
      await Future.delayed(const Duration(seconds: 6));

      isConnected = await InternetConnectionChecker().hasConnection;

      if (isConnected) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        widget.refresh();
      } else if (isSnackBarShowing == false) {
        isSnackBarShowing = true;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          duration: Duration(seconds: 50),
          content: Container(
              margin: EdgeInsets.only(bottom: 100, left: 4, right: 4),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ColorConstants.GREY_2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off,
                    color: ColorConstants.WHITE,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "No Internet Connection!",
                    style: Styles.bold(color: ColorConstants.WHITE),
                  )
                ],
              )),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          widget.body,
          // if (isConnected == false)
          //   Positioned.fill(
          //       child: Align(
          //           alignment: Alignment.bottomCenter,
          //           child: Container(
          //             margin: const EdgeInsets.only(bottom: 100),
          //             decoration: BoxDecoration(
          //                 boxShadow: [
          //                   BoxShadow(
          //                     color: Colors.grey.withOpacity(0.5),
          //                     spreadRadius: 6,
          //                     blurRadius: 10,
          //                     offset: const Offset(
          //                         0, 3), // changes position of shadow
          //                   ),
          //                 ],
          //                 color: Colors.white,
          //                 borderRadius: BorderRadius.circular(8)),
          //             width: MediaQuery.of(context).size.width * 0.9,
          //             height: 50,
          //             child: Center(
          //                 child: Row(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               crossAxisAlignment: CrossAxisAlignment.center,
          //               children: [
          //             // const     Icon(
          //             //         (IconData(0xf018a, fontFamily: 'MaterialIcons'))),
          //                 SizedBox(width: 10),
          //                 Text(
          //                   'No Internet Connection!',
          //                   style: Styles.semibold(),
          //                 )
          //               ],
          //             )),
          //           ))),
        ],
      ),
    );
  }
}
