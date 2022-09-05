import 'package:flutter/material.dart';
import 'package:masterg/pages/custom_pages/ScreenWithLoader.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/resource/images.dart';

class CommonBgContainer extends StatelessWidget {
  Widget? child;
  String? title;
  bool isBackShow = false;
  bool? isLoading;
  Function onBackPressed;
  Color? bgChildColor;
  String? backImage;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String bgImage;

  CommonBgContainer(
      {this.child,
      this.title = "",
      this.isBackShow = false,
      this.isLoading = false,
      this.bgChildColor = ColorConstants.BG_GREY,
      required this.onBackPressed,
      this.bgImage = Images.LOGIN_BANNER});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorConstants.PRIMARY_COLOR,
        body: Builder(builder: (_context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: ColorConstants.PRIMARY_COLOR,
            ),
            child: ScreenWithLoader(
              body: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Image(
                    image: AssetImage(bgImage),
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  ),
                  _getTitleWidget(context),
                  _getMainBody(context)
                ],
              ),
              isLoading: isLoading,
            ),
          );
        }),
      ),
    );
  }

  _getTitleWidget(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
                onTap: () {
                  onBackPressed();
                },
                child: isBackShow
                    ? Container(
                        margin: EdgeInsets.all(20),
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
                    : Container()),
            Text(
              '$title',
              style: Styles.boldWhite(size: 20),
            ),
            Container(
              padding: EdgeInsets.all(20),
            )
          ],
        ));
  }

  _getMainBody(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3.5),
      decoration: BoxDecoration(
          color: bgChildColor,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25), topLeft: Radius.circular(25))),
      child: Padding(
        padding: EdgeInsets.only(top: 20),
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
