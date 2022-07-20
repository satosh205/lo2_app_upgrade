import 'package:flutter/material.dart';

class TapWidget extends StatelessWidget {
  final Function() onTap;
  final Widget child;

  TapWidget({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: child,
      onTap: onTap,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
    );
  }
}
