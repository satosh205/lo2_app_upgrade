import 'package:flutter/material.dart';

enum WhatInRight { ICON, TEXT, IMAGE }

class CommonAppBar {
  static getAppBar(
      {required BuildContext context,
      Color bgColor = Colors.white,
      Color backColor = Colors.black,
      String title = '',
      bool isRightWidgetVisible = false,
      Function()? rightWidgetClick,
      Function()? onBackPress,
      IconData? rightIcon,
      String rightText = '',
      String? rightImage,
      bool isBackVisible = true,
      WhatInRight? type}) {
    return MyAppBar(
        bgColor: bgColor,
        backColor: backColor,
        title: title,
        isRightWidgetVisible: isRightWidgetVisible,
        rightWidgetClick: rightWidgetClick,
        rightIcon: rightIcon,
        rightText: rightText,
        rightImage: rightImage,
        onBackPress: onBackPress,
        isBackVisible: isBackVisible,
        type: type);
  }
}

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  Color bgColor = Colors.white;
  Color backColor = Colors.black;
  String title = '';
  bool isRightWidgetVisible = false;
  Function()? rightWidgetClick, onBackPress;
  IconData? rightIcon;
  String rightText = '';
  String? rightImage;
  bool isBackVisible = true;
  WhatInRight? type;

  MyAppBar(
      {this.bgColor = Colors.white,
      this.backColor = Colors.black,
      this.title = '',
      this.isRightWidgetVisible = false,
      this.rightWidgetClick,
      this.rightIcon,
      this.rightText = '',
      this.rightImage,
      this.onBackPress,
      this.isBackVisible = true,
      this.type});

  @override
  Size get preferredSize => Size.fromHeight(40);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: bgColor,
      leading: Visibility(
          visible: isBackVisible,
          child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: backColor,
              ),
              onPressed: () {
                if (onBackPress != null)
                  onBackPress!();
                else
                  Navigator.pop(context);
              })),
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),
      ),
      centerTitle: true,
      actions: <Widget>[
        Visibility(
            visible: isRightWidgetVisible,
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: rightWidgetClick,
              child: type == WhatInRight.TEXT
                  ? Text(rightText)
                  : type == WhatInRight.IMAGE
                      ? Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: CircleAvatar(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.network(
                                rightImage!,
                                fit: BoxFit.cover,
                                width: 40,
                                height: 40,
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            rightIcon,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
            ))
      ],
    );
  }
}
