import 'package:flutter/material.dart';
import 'package:masterg/utils/resource/colors.dart';

class RoundedAppBar extends StatelessWidget {
  final Widget child;
  const RoundedAppBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [
          ColorConstants.GRADIENT_ORANGE,
          ColorConstants.GRADIENT_RED,

        ])
      ),
      child: child,
    );
  }
}