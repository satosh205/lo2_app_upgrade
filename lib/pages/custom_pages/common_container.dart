// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/notification_list_page.dart';
import 'package:masterg/pages/swayam_pages/login_screen.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/images.dart';

class CommonContainer extends StatelessWidget {
  Widget? child, drawerWidget;
  String? title;
  bool? isBackShow = false, isFloatIconVisible, isSkipEnable;
  bool? isLoading;
  // Function? onBackPressed, floatIconTap, onSkipClicked;
  Function? onBackPressed = () {};
  void Function()? floatIconTap;
  Function? onSkipClicked = () {};

  Color? bgChildColor;
  IconData? floatIcon;
  String? backImage;
  bool? isNotification;
  Widget? belowTitle;
  bool? isScrollable;
  bool? isContainerHeight;
  bool? scrollReverse;
  bool? isTopPadding;

  bool isDrawerEnable;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState>? scafKey;

  Color bgColor;

  CommonContainer(
      {this.child,
      this.title = "",
      this.isBackShow = false,
      this.isLoading = false,
      this.bgChildColor = ColorConstants.BG_GREY,
      this.bgColor = ColorConstants.PRIMARY_COLOR,
      this.onBackPressed,
      this.isFloatIconVisible = false,
      this.floatIcon,
      this.scafKey,
      this.isDrawerEnable = false,
      this.drawerWidget,
      this.belowTitle,
      this.isSkipEnable = false,
      this.isNotification = false,
      this.onSkipClicked,
      this.isScrollable = false,
      this.isContainerHeight = true,
      this.scrollReverse = false,
      this.isTopPadding = true,
      this.floatIconTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scafKey ?? _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: bgColor,
        drawer: isDrawerEnable ? drawerWidget : null,
        body: Builder(builder: (_context) {
          return isScrollable == true
              ? SingleChildScrollView(
                  reverse: scrollReverse!,
                  physics: !isScrollable!
                      ? NeverScrollableScrollPhysics()
                      : AlwaysScrollableScrollPhysics(),
                  child: isContainerHeight == true
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            color: ColorConstants.PRIMARY_COLOR,
                          ),
                          child: ScreenWithLoader(
                            body: Column(
                              children: [
                                Column(
                                  children: [
                                    _getTitleWidget(context),
                                    Container(
                                      child: belowTitle,
                                    )
                                  ],
                                ),
                                Expanded(child: _getMainBody())
                              ],
                            ),
                            isLoading: isLoading,
                          ),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: ColorConstants.PRIMARY_COLOR,
                          ),
                          child: ScreenWithLoader(
                            isContainerHeight: isContainerHeight!,
                            body: Column(
                              children: [
                                Column(
                                  children: [
                                    _getTitleWidget(context),
                                    Container(
                                      child: belowTitle,
                                    )
                                  ],
                                ),
                                _getMainBody()
                              ],
                            ),
                            isLoading: isLoading,
                          ),
                        ),
                )
              : Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    color: ColorConstants.PRIMARY_COLOR,
                  ),
                  child: ScreenWithLoader(
                    body: Column(
                      children: [
                        Column(
                          children: [
                            _getTitleWidget(context),
                            Container(
                              child: belowTitle,
                            )
                          ],
                        ),
                        Expanded(child: _getMainBody())
                      ],
                    ),
                    isLoading: isLoading,
                  ),
                );
        }),
        floatingActionButton: isFloatIconVisible!
            ? FloatingActionButton(
                onPressed: floatIconTap,
                child: Icon(floatIcon),
                backgroundColor: ColorConstants.PRIMARY_COLOR,
              )
            : null,
      ),
    );
  }

  _getTitleWidget(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: (){
              Navigator.pop(context);
            },
              // onTap: isDrawerEnable
              //     ? () {
              //         FirebaseAnalytics()
              //             .logEvent(name: "drawer_opened", parameters: null);
              //         _scaffoldKey.currentState.openDrawer();
              //       }
              //     : onBackPressed,
              child: isBackShow!
                  ? isDrawerEnable
                      ? Image(
                          image: AssetImage(Images.SWAYAM_SPLASH_LOGO),
                          width: 38,
                          height: 38,
                        )
                      : Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: ColorConstants.WHITE,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: ColorConstants.DARK_BLUE,
                          ),
                        )
                  : Container(
                      padding: EdgeInsets.all(10),
                    )),
          Expanded(
            child: Text(
              title!,
              textAlign: TextAlign.center,
              style: Styles.boldWhite(size: 20),
            ),
          ),
          isNotification == true
              ? InkWell(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (BuildContext context) =>
                    //             NotificationListPage()));

                    print("HeRE1");
            UserSession.clearSession();

            Preference.clearPref().then((value) {
              Navigator.pushAndRemoveUntil(
                  context, NextPageRoute(LoginScreen()), (route) => false);
            });
                    // if (onSkipClicked != null) onSkipClicked!();
                  },
                  child: Container(
                    padding: EdgeInsets.all(isNotification == true ? 0 : 0),
                    child: Visibility(
                      visible: isNotification == true,
                      child: Icon(
                        Icons.notifications,
                        color: ColorConstants.WHITE,
                      ),
                    ),
                  ),
                )
              : InkWell(
                  onTap: () {
                    if (onSkipClicked != null) onSkipClicked!();
                  },
                  child: Container(
                    padding: EdgeInsets.all(isSkipEnable == true ? 0 : 20),
                    child: Visibility(
                      visible: false,
                      child: Text(
                        "Skip",
                        style: Styles.lightWhite(size: 16),
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }

  _getMainBody() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          color: bgChildColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25), topLeft: Radius.circular(25))),
      child: Padding(
        padding: EdgeInsets.only(top: isTopPadding == true ? 20 : 0),
        child: isLoading == true ? Container() : child,
      ),
    );
  }

  _size({double height = 20, double width = 0}) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}
