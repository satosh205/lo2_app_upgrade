import 'package:flutter/material.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';

// Custom App Button
class AppOutlineButton extends StatelessWidget {
  final Function onTap;
  final bool? isEnabled;
  final String? title;
  Color? bgColor, outLineColor, textColor;
  double? radius;

  bool isCheckVisible;

  AppOutlineButton(
      {this.isEnabled = true,
     required this.onTap,
      this.title,
      this.isCheckVisible = false,
      this.bgColor = ColorConstants.WHITE,
      this.outLineColor = ColorConstants.PRIMARY_COLOR,
      this.textColor = ColorConstants.PRIMARY_COLOR,
      this.radius = 5});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap(),
      height: appButtonHeight,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius!),
          side: BorderSide(
            color: outLineColor!,
            width: 1,
          )),
      color: bgColor,
      elevation: 0,
      disabledColor: bgColor,
      enableFeedback: isEnabled!,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            title.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Visibility(
                visible: isCheckVisible,
                child: Icon(
                  Icons.check_circle,
                  size: 20,
                  color: ColorConstants.PRIMARY_COLOR,
                )),
          )
        ],
      ),
    );
  }
}
