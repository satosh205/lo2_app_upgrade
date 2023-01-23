import 'package:flutter/material.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';

class RoundedAppBar extends StatelessWidget {
  final Widget child;
  final double? appBarHeight; 
  const RoundedAppBar({super.key, required this.child, this.appBarHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: appBarHeight ?? height(context) * 0.07,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft:  Radius.circular(14), bottomRight:  Radius.circular(14)),
        gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [
          ColorConstants.GRADIENT_ORANGE,
          ColorConstants.GRADIENT_RED,

        ])
      ),
      child: child,
    );
  }
}