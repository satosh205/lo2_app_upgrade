import 'package:flutter/material.dart';

class NextPageRoute extends MaterialPageRoute {
  Widget _whichScreen;
  bool isMaintainState;

  NextPageRoute(this._whichScreen, {this.isMaintainState = false})
      : super(
            builder: (BuildContext context) => _whichScreen,
            maintainState: isMaintainState);

  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: _whichScreen);
  }
}
