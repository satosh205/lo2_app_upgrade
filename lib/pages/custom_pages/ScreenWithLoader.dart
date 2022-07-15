import 'package:flutter/material.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';

class ScreenWithLoader extends StatefulWidget {
  final bool? isLoading;
  Color color;
  final Widget? body;
  bool isContainerHeight;

  ScreenWithLoader(
      {this.isLoading,
      this.body,
      this.color = Colors.white38,
      this.isContainerHeight = true});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ScreenWithLoader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          widget.isContainerHeight
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: widget.body,
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  child: widget.body,
                ),
          Visibility(
            visible: widget.isLoading!,
            child: widget.isContainerHeight
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: widget.color,
                    child: Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: new BoxDecoration(
                            color: Colors.black45,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              '${Strings.of(context)?.loading}',
                              style: Styles.boldWhite(size: 16),
                            ),
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  ColorConstants.WHITE),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    color: widget.color,
                    child: Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: new BoxDecoration(
                            color: Colors.black45,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              Strings.of(context)!.loading!,
                              style: Styles.boldWhite(size: 16),
                            ),
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  ColorConstants.WHITE),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
