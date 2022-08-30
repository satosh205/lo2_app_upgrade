import 'package:flutter/material.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';

// Custom App Button
class AppButton extends StatelessWidget {
  final Function? onTap;
  final bool isEnabled;
  final String? title;
  Color color;

  AppButton(
      {this.isEnabled = true,
      this.onTap,
      this.title,
      this.color = ColorConstants.PRIMARY_COLOR});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: isEnabled == true
          ? () {
              onTap;
            }
          : null,
      height: appButtonHeight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      color: color,
      disabledColor: ColorConstants.PRIMARY_COLOR.withOpacity(0.5),
      enableFeedback: isEnabled,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title!,
            style: TextStyle(
              color: ColorConstants.WHITE,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
