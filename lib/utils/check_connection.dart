import 'dart:io';

import 'package:flutter/material.dart';
import 'package:masterg/utils/Styles.dart';

class CheckInternet extends StatefulWidget {
  final Widget body;

  const CheckInternet(
      {super.key, required this.body});

  @override
  State<CheckInternet> createState() => _CheckInternetState();
}

class _CheckInternetState extends State<CheckInternet> {
  bool isConnected= true;

  @override
  void initState() {
    super.initState();
    // loop();
  }

    void loop() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 6));
     
       checkConnection();
    
    }
  }

  void checkConnection() async {
    try {

      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isConnected = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isConnected = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          widget.body,
          if (isConnected == false)
            Positioned.fill(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 100),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 6,
                              blurRadius: 10,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 50,
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                              (IconData(0xf018a, fontFamily: 'MaterialIcons'))),
                          SizedBox(width: 10),
                          Text(
                            'No Internet Connection!',
                            style: Styles.semibold(),
                          )
                        ],
                      )),
                    ))),
        ],
      ),
    );
  }
}
