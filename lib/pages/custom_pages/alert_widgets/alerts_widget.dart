import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';

class AlertsWidget {
  static Future alertWithOkCancelBtn(
      {required BuildContext context,
      String? title = "",
      String? text = "",
      String okText = "",
      String cancelText = "",
      Function? onOkClick,
      Function? onCancelClick}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text(title!),
            content: Text(text!),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              TextButton(
                child: new Text(Strings.of(context)!.no!),
                onPressed: () {
                  if (onCancelClick != null) onCancelClick();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: new Text(Strings.of(context)!.yes!),
                onPressed: () {
                  Navigator.pop(context);
                  if (onOkClick != null) onOkClick();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static Future alertWithYesNoBtn(
      {required BuildContext context,
      String title = "",
      String text = "",
      Function? onOkClick,
      Function? onCancelClick}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text(
              title,
              style: Styles.textBold(size: 18),
              textAlign: TextAlign.center,
            ),
            content: Text(
              text,
              style: Styles.textRegular(size: 14),
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 10),
                child: TextButton(
                  child: new Text(
                    Strings.of(context)!.no!,
                    style: Styles.textBold(size: 18),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (onCancelClick != null) onCancelClick();
                  },
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 30),
                child: TextButton(
                  child: new Text(
                    Strings.of(context)!.yes!,
                    style: Styles.textBold(size: 18),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    if (onOkClick != null) onOkClick();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future alertWithOkBtn(
      {required BuildContext context,
      String? text = "",
      Function? onOkClick,
      bool isBarrierDismissible = false}) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text(
              Strings.of(context)!.alert!,
              style: Styles.textBold(size: 20),
            ),
            content: Text(text!, style: Styles.textBold(size: 16)),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              TextButton(
                child: new Text(Strings.of(context)!.ok!,
                    style: Styles.textBold(size: 14)),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onOkClick != null) onOkClick();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static Future showCustomDialog(
      {required BuildContext context,
      bool? showCancel = true,
      String? title = "",
      String? text = "",
      String? icon = 'assets/images/circle_alert_fill.svg',
      String? oKText = "Yes",
      Function? onOkClick,
      Function? onCancelClick}) {
        
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 230,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      icon!,
                      allowDrawingOutsideViewBox: true,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          title!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        text!,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15.0,
                        top: 25.0,
                        right: 15.0,
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (showCancel == true)
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    print('Cancel flagColor');
                                    if (onCancelClick != null) onCancelClick();
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          '${Strings.of(context)?.cancel}',
                                        )),
                                  ),
                                ),
                              ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  if (onOkClick != null) onOkClick();
                                },
                                child: Container(
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: ColorConstants().primaryColor(),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '$oKText',
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
