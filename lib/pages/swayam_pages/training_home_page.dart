import 'dart:convert';

// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/auth_response/user_session.dart';
import 'package:masterg/data/models/response/home_response/category_response.dart';
import 'package:masterg/data/models/response/home_response/get_content_resp.dart';
import 'package:masterg/data/models/response/home_response/training_programs_response.dart';
import 'package:masterg/pages/custom_pages/card_loader.dart';
import 'package:masterg/pages/custom_pages/common_container.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/notification_list_page.dart';
import 'package:masterg/pages/swayam_pages/training_course.dart';
import 'package:masterg/pages/swayam_pages/training_provider.dart';
// import 'package:masterg/pages/home_pages/notification_list_page.dart';
// import 'package:masterg/pages/session_pages/scheduled_sessions_page.dart';
// import 'package:masterg/pages/training_pages/training_course.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/custom_progress_indicator.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/resource/images.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import '../session_pages/create_session_page.dart';

class TrainingHomePage extends StatefulWidget {
  Widget? drawerWidget;

  TrainingHomePage({this.drawerWidget});

  @override
  _TrainingHomePageState createState() => _TrainingHomePageState();
}

class _TrainingHomePageState extends State<TrainingHomePage> {
  var _isLoading = false;
  var myAnnouncmentList = <ListData>[];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // FirebaseAnalytics().logEvent(name: "trainings_screen", parameters: null);
    // FirebaseAnalytics().setCurrentScreen(screenName: "trainings_screen");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final trainingProvider = Provider.of<TrainingProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;

    /* CommonContainer(
      child: _mainBody(),
      isDrawerEnable: true,
      isBackShow: true,
      drawerWidget: widget.drawerWidget,
      bgChildColor: ColorConstants.WHITE,
      title: Strings.of(context).accountSettings,
    );*/
    return CommonContainer(
      bgColor: ColorConstants.BG_GREY,
      child: Selector<TrainingProvider, ApiStatus>(
          builder: (context, data, child) {
            return _getAnnounecment(trainingProvider);
          },
          selector: (buildContext, provider) => provider.apiStatus),
      isNotification: true,
      onSkipClicked: () {
        Navigator.push(context, NextPageRoute(NotificationListPage()));
      },
      isScrollable: true,
      belowTitle: Container(
        height: 120,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: GestureDetector(
          onTap: () {
            // Navigator.of(context).push(new MaterialPageRoute(
            //     builder: (context) => ScheduledSessionsPage()));
          },
          child: Container(
            width: screenWidth,
            height: 80,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color.fromRGBO(165, 232, 251, 1),
                  Color.fromRGBO(26, 202, 255, 1),
                ]),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  topLeft: Radius.circular(40),
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(10),
                )),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  height: 80,
                  width: 80,
                  child: ClipRRect(
                    child: Image.asset(
                      "assets/images/swayam_splash_logo.png",
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${Strings.of(context)?.Live_sessions}',
                      style: Styles.textExtraBold(
                        size: 16,
                        color: Color.fromRGBO(0, 0, 0, 1),
                      ),
                    ),
                    Visibility(
                      visible: UserSession.userType == 1,
                      child: GestureDetector(
                        onTap: () {
                          // Navigator.of(context).push(new MaterialPageRoute(
                          //     builder: (context) => CreateSessionPage()));
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            '${Strings.of(context)?.Create_Live_Class}',
                            style: Styles.textSemiBoldUndeline(
                              size: 12,
                              color: Color.fromRGBO(28, 37, 85, 0.6),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      isDrawerEnable: true,
      isContainerHeight: false,
      isBackShow: true,
      drawerWidget: widget.drawerWidget,
      bgChildColor: ColorConstants.GREY,
      title: Strings.of(context)?.training,
    );
  }

  _size({double height = 20}) {
    return SizedBox(
      height: height,
    );
  }

  Widget trainingDetailWidget(TrainingProvider trainingProvider) {
    Widget trainingDetailWidget;
    switch (trainingProvider.apiStatus) {
      case ApiStatus.INITIAL:
        trainingDetailWidget = Center(
          child: CustomProgressIndicator(true, ColorConstants.GREY),
        );
        break;
      case ApiStatus.LOADING:
        trainingDetailWidget = CardLoader();
        break;
      case ApiStatus.SUCCESS:
        trainingDetailWidget = _getAnnounecment(trainingProvider);
        break;
      case ApiStatus.ERROR:
        trainingDetailWidget = Center(
          child: Text(
            '${trainingProvider.error}',
            style: Styles.textExtraBold(size: 14, color: ColorConstants.WHITE),
          ),
        );
        break;
    }
    return trainingDetailWidget;
  }

  _getAnnounecment(TrainingProvider trainingProvider) {
    return Selector<TrainingProvider, List<Program?>?>(
        builder: (context, data, child) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _getTitle('${Strings.of(context)?.mandatoryCourses}', () {
                trainingProvider.getTraningData();
                /*Navigator.push(
                context,
                NextPageRoute(AnnouncementPage(
              isViewAll: true,
                )));*/
              }),
              _size(height: 16),
              ValueListenableBuilder(
                valueListenable: Hive.box(DB.TRAININGS).listenable(),
                builder: (bc, Box? box, child) {
                  if (box?.get("courses") == null) {
                    return CardLoader();
                  
                  } else if (box?.get("courses").isEmpty) {
                    return Container(
                      height: 290,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Text(
                          "There are no trainings available",
                          style: Styles.textBold(),
                        ),
                      ),
                    );
                  }
                  print("##TRAINIGNS");
                  List<Program> data = box
                      ?.get("courses")
                      .map(
                          (e) => Program.fromJson(Map<String, dynamic>.from(e)))
                      .cast<Program>()
                      .toList();
                  return TrainingCourses(
                    isViewAll: false,
                    programs: data,
                  );
                },
              )
            ],
          );
        },
        selector: (buildContext, provider) => provider.trainingPrograms);
  }

  _getTitle(String title, Function onViewAllTap) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          Row(
            children: [
              Text(
                title,
                style: Styles.textExtraBold(
                    size: 21, color: ColorConstants.ORANGE),
              ),
              const SizedBox(
                width: 2,
              ),
              Column(
                children: [
                  Icon(
                    Icons.star,
                    size: 8,
                    color: ColorConstants.STARCOLOUR,
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              )
            ],
          ),
          Spacer(),
          // InkWell(
          //   onTap: onViewAllTap,
          //   child: Text(
          //     Strings.of(context).viewAll,
          //     style: Styles.textSemiBold(
          //       size: 14,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  _getTitleWidget(TrainingProvider trainingProvider) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
              onTap: () {
                debugPrint('on click of menu icons');
                trainingProvider.scaffoldKey.currentState?.openDrawer();
              },
              child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: ColorConstants.WHITE,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Image(image: AssetImage(Images.IC_MENU)))),
          Expanded(
              child: Center(
            child: Text('${Strings.of(context)?.training}',
                style: Styles.boldWhite(
                  size: 20,
                )),
          )),
          InkWell(
              onTap: () {},
              child: Container(
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Icon(
                    Icons.notifications,
                    color: ColorConstants.WHITE,
                  ))),
        ],
      ),
    );
  }

  /*_content() {
    return Column(
      children: [
        _getTitleWidget(),
        // _getAnnounecment(),
        _size(),
        Container(
          decoration: BoxDecoration(
              color: ColorConstants.BG_GREY,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25), topLeft: Radius.circular(25))),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Based on your previous activity',
                    style: Styles.textExtraBold(
                        size: 20, color: ColorConstants.ORANGE)),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Container(
                    decoration: BoxDecoration(
                        color: ColorConstants.WHITE,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    height: 300,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          child: FadeInImage.assetNetwork(
                            placeholder: Images.PLACE_HOLDER,
                            image: "https://picsum.photos/200/300",
                            height: 140,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                          ),
                        ),
                        _size(
                          height: 10,
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'Advanced CSS',
                                textAlign: TextAlign.center,
                                style: Styles.textBold(
                                    size: 18,
                                    color: ColorConstants.TEXT_DARK_BLACK),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'By Harsit Agrawal',
                                textAlign: TextAlign.center,
                                style: Styles.textBold(
                                    size: 12, color: ColorConstants.DARK_GREY),
                              ),
                            ),
                            _size(
                              height: 12,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  '40%',
                                  style: Styles.textRegular(size: 12),
                                ),
                                LinearPercentIndicator(
                                  width: 120.0,
                                  lineHeight: 2.0,
                                  percent: 0.5,
                                  backgroundColor: ColorConstants.PENDING_GREY,
                                  progressColor: ColorConstants.ACTIVE_TAB,
                                ),
                                Spacer(),
                                Image(
                                  image: AssetImage(Images.CLOCK),
                                ),
                                Text(
                                  Utility.convertDateFromMillis(10000000,
                                      Strings.REQUIRED_DATE_DD_MMM_YYYY),
                                  style: Styles.textRegular(size: 12),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                _size(height: 40)
              ],
            ),
          ),
        ),
      ],
    );
  }*/

  int getCategoryValue(String type) {
    if (UserSession.categoryData == null) return 0;
    int contentType = 0;
    CategoryResp respone =
        CategoryResp.fromJson(json.decode('${UserSession.categoryData}'));

    // for (var element in respone.data.listData) {
    //   if (element.title.toLowerCase().contains(type.toLowerCase())) {
    //     contentType = element.id;
    //     break;
    //   }
    // }

    for(int i = 0; i  < respone.data!.listData!.length; i++){
      if(respone.data!.listData![i].title!.toLowerCase().contains(type.toLowerCase())){
        contentType = respone.data!.listData![i].id!;
      }
    }
    return contentType;
  }
}
