import 'package:flutter/material.dart';
import 'package:masterg/utils/resource/colors.dart';

import 'Strings.dart';
import 'Styles.dart';

class CustomProgressIndicator extends StatelessWidget {
  final bool isLoading;
  final Color color;

  CustomProgressIndicator(this.isLoading, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 200,
      color: color,
      child: Center(
        child: Container(
          width: 100,
          height: 100,
          decoration: new BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                Strings.of(context)!.loading!,
                style: Styles.boldWhite(size: 16),
              ),
              CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(ColorConstants.PRIMARY_COLOR),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
