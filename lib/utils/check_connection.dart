import 'package:flutter/material.dart';
import 'package:masterg/utils/Styles.dart';

class CheckInternet extends StatefulWidget {
  final Widget body;
  final bool isConnected;
  const CheckInternet(
      {super.key, required this.body, required this.isConnected});

  @override
  State<CheckInternet> createState() => _CheckInternetState();
}

class _CheckInternetState extends State<CheckInternet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          widget.body,
          if (widget.isConnected == false)
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
