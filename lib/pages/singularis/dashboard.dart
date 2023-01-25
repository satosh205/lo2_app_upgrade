import 'dart:math';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/auth_response/dashboard_content_resp.dart';
import 'package:masterg/data/models/response/auth_response/dashboard_view_resp.dart';
import 'package:masterg/data/models/response/home_response/course_category_list_id_response.dart';
import 'package:masterg/data/models/response/home_response/joy_contentList_response.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/rounded_appbar.dart';
import 'package:masterg/pages/gcarvaan/components/gcarvaan_card_post.dart';
import 'package:masterg/pages/ghome/my_courses.dart';
import 'package:masterg/pages/ghome/video_player_screen.dart';
import 'package:masterg/pages/ghome/widget/read_more.dart';
import 'package:masterg/pages/ghome/widget/view_widget_details_page.dart';

import 'package:masterg/pages/training_pages/new_screen/courses_details_page.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/portfolio_page.dart';
import 'package:masterg/pages/user_profile_page/portfolio_page.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/custom_progress_indicator.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../data/models/response/auth_response/bottombar_response.dart';
import '../../data/providers/training_detail_provider.dart';
import '../../data/providers/video_player_provider.dart';
import '../reels/reels_dashboard_page.dart';
import '../training_pages/training_detail_page.dart';
import '../training_pages/training_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Box? box;
  bool? dashboardIsVisibleLoading = true;
  bool? dasboardListLoading = true;

  DashboardContentResponse? dashboardContentResponse;
  List<DashboardFeaturedContentLimit>? featuredContentList;
  List<DashboardRecommendedCoursesLimit>? recommendedCourseList;
  List<DashboardLimit>? reelsList;
  List<DashboardLimit>? carvaanList;
  List<DashboardSessionsLimit>? sessionList;
  List<DashboardMyCoursesLimit>? myCoursesList;

  DashboardViewResponse? dashboardViewResponse;

  bool showAllFeatured = false;

  MenuListProvider? menuProvider;

  @override
  void initState() {
    getDashboardIsVisible();
    getDasboardList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var pages = {
      "dashboard_featured_content_limit": renderFeaturedContentLimit(),
      "dashboard_sessions_limit": renderSession(),
      "dashboard_my_courses_limit": renderMyCourses(),
      "dashboard_reels_limit": renderReels(),
      "dashboard_recommended_courses_limit": renderRecommandedCourses(),

      // "dashboard_carvan_limit": renderReels()
      "dashboard_carvan_limit": renderCarvaan()
    };
    return Consumer2<VideoPlayerProvider, MenuListProvider>(
        builder: (context, value, mp, child) => BlocManager(
            initState: (context) {},
            child: BlocListener<HomeBloc, HomeState>(
              listener: (context, state) async {
                setState(() {
                  menuProvider = mp;
                });
              },
              child: FutureBuilder(
                future: Future.delayed(Duration(seconds: 2)),
                builder: (context, snapshot) => SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RoundedAppBar(
                        appBarHeight: height(context) * 0.16,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=> NewPortfolioPage()));
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(200),
                                      child: SizedBox(
                                        width: 40,
                                        child: Image.network(
                                            '${Preference.getString(Preference.PROFILE_IMAGE)}'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Welcome',
                                          style: Styles.regular(
                                              color: ColorConstants.WHITE)),
                                      Text('Prince Vishwkarma', style: Styles.bold(color: ColorConstants.WHITE),),
                                    ],
                                  ),
                                ],
                              ),
SizedBox(height: 10),
                              Container(
                                          height: 8,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                          decoration: BoxDecoration(
                                              color: ColorConstants.WHITE.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Stack(
                                            children: [
                                              Container(
                                                height: 10,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6 *
                                                    (30/
                                                        100),
                                                decoration: BoxDecoration(
                                                    color: Color(0xffFFB72F),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                              ),
                                            ],
                                          ),
                                        ),
SizedBox(height: 10),

                              Text('Profile completed: 30% ',
                                  style: Styles.semiBoldWhite())
                            ],
                          ),
                        )),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 8, vertical: 8),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Text(
                    //         'Welcome',
                    //         style: Styles.semibold(size: 14),
                    //       ),
                    //       Text(
                    //         '${Preference.getString(Preference.FIRST_NAME)}',
                    //         style: Styles.bold(size: 28),
                    //       ),
                    //       Text(
                    //         'Begin your learning journey',
                    //         style: Styles.regular(),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    renderWidgets(pages),
                  ],
                )),
              ),
            )));
  }

  renderWidgets(pages) {
    return ValueListenableBuilder(
        valueListenable: Hive.box(DB.CONTENT).listenable(),
        builder: (bc, Box box, child) {
          if (box.get("getDashboardIsVisible") == null) {
            // return CustomProgressIndicator(true, Colors.white);
            return Text('lading');
          } else if (box.get("getDashboardIsVisible").isEmpty) {
            return Container(
              height: 290,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  "There are no getDashboardIsVisible available",
                  style: Styles.textBold(),
                ),
              ),
            );
          }

          dynamic content = box.get("getDashboardIsVisible") as Map;
          List<Widget> list = <Widget>[];
          content.forEach((key, value) {
            if (value != null) list.add(pages[key] as Widget);
          });

          return Column(
            children: list,
          );
        });
  }

  renderSession() {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return ValueListenableBuilder(
        valueListenable: Hive.box(DB.CONTENT).listenable(),
        builder: (bc, Box box, child) {
          if (box.get("dashboard_sessions_limit") == null) {
            return Text('Loading');
          } else if (box.get("dashboard_sessions_limit").isEmpty) {
            return Container(
              // height: 290,
              padding: EdgeInsets.only(bottom: 12),
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  "Today\'s classes not found",
                  style: Styles.textBold(),
                ),
              ),
            );
          }

          sessionList = box
              .get("dashboard_sessions_limit")
              .map((e) =>
                  DashboardSessionsLimit.fromJson(Map<String, dynamic>.from(e)))
              .cast<DashboardSessionsLimit>()
              .toList();

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      child: Text(
                        'Today\'s classes',
                        style: Styles.bold(color: Color(0xff0E1638)),
                      )),
                  Expanded(child: SizedBox()),
                ],
              ),

              //show Today's classes list

              Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(color: ColorConstants.GREY),
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return sessionList!.length > 0
                          ? Container(
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  color: ColorConstants.WHITE,
                                  border: Border.all(
                                      color: Colors.grey[350]!, width: 1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    sessionList![index]
                                                .liveclassStatus!
                                                .toLowerCase() ==
                                            'live'
                                        ? Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              sessionList![index]
                                                          .contentType!
                                                          .toLowerCase() !=
                                                      'offlineclass'
                                                  ? SvgPicture.asset(
                                                      'assets/images/live_icon.svg',
                                                      width: 25,
                                                      height: 25,
                                                      allowDrawingOutsideViewBox:
                                                          true,
                                                    )
                                                  : SvgPicture.asset(
                                                      'assets/images/offline_live.svg',
                                                      allowDrawingOutsideViewBox:
                                                          true,
                                                    ),
                                              SizedBox(width: 5),
                                              Text(
                                                  sessionList![index]
                                                              .contentType!
                                                              .toLowerCase() ==
                                                          'offlineclass'
                                                      ? 'Ongoing'
                                                      : "${Strings.of(context)?.liveNow}",
                                                  style: Styles.regular(
                                                      size: 12,
                                                      color: ColorConstants()
                                                          .primaryColor())),
                                              Expanded(child: SizedBox()),
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color:
                                                        ColorConstants.BG_GREY),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 18),
                                                child: Text(
                                                    sessionList![index]
                                                                    .contentType!
                                                                    .toLowerCase() ==
                                                                'liveclass' ||
                                                            sessionList![index]
                                                                    .contentType!
                                                                    .toLowerCase() ==
                                                                'zoomclass'
                                                        ? "Live"
                                                        : 'Classroom',
                                                    style: Styles.regular(
                                                        size: 10,
                                                        color: ColorConstants
                                                            .BLACK)),
                                              ),
                                            ],
                                          )
                                        : sessionList![index]
                                                    .liveclassStatus!
                                                    .toLowerCase() ==
                                                'upcoming'
                                            ? Row(children: [
                                                SvgPicture.asset(
                                                  'assets/images/upcoming_live.svg',
                                                  allowDrawingOutsideViewBox:
                                                      true,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                    '${sessionList![index].startTime} - ${sessionList![index].endTime} |${DateFormat('d').format(DateTime.fromMillisecondsSinceEpoch(sessionList![index].fromDate! * 1000))} ${months[int.parse(DateFormat('M').format(DateTime.fromMillisecondsSinceEpoch(sessionList![index].fromDate! * 1000))) - 1]}',
                                                    style: Styles.regular(
                                                        size: 12)),
                                                Expanded(child: SizedBox()),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: ColorConstants
                                                          .BG_GREY),
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 18),
                                                  child: Text(
                                                      sessionList![index]
                                                                  .contentType!
                                                                  .toLowerCase() ==
                                                              'offlineclass'
                                                          ? "Classroom"
                                                          : "Live",
                                                      style: Styles.regular(
                                                          size: 10,
                                                          color: ColorConstants
                                                              .BLACK)),
                                                ),
                                              ])
                                            : SizedBox(),
                                    SizedBox(height: 10),
                                    Text('${sessionList![index].name}',
                                        style: Styles.semibold(size: 16)),
                                    SizedBox(height: 9),
                                    Text(
                                      '${sessionList![index].description}',
                                      style: Styles.regular(size: 14),
                                    ),
                                    SizedBox(height: 15),
                                    Row(
                                      children: [
                                        sessionList![index].trainerName !=
                                                    null &&
                                                sessionList![index]
                                                        .trainerName !=
                                                    ''
                                            ? Text(
                                                'by ${sessionList![index].trainerName} ',
                                                style: Styles.regular(size: 12))
                                            : Text(''),
                                        Expanded(child: SizedBox()),
                                        if (sessionList![index]
                                                .liveclassStatus!
                                                .toLowerCase() ==
                                            'live')
                                          InkWell(
                                              onTap: () {
                                                launch(
                                                    sessionList![index].url!);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: ColorConstants()
                                                      .primaryColor(),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Padding(
                                                    child: Text(
                                                        sessionList![index]
                                                                        .contentType!
                                                                        .toLowerCase() ==
                                                                    "liveclass" ||
                                                                sessionList![
                                                                            index]
                                                                        .contentType!
                                                                        .toLowerCase() ==
                                                                    "zoomclass"
                                                            ? "Join Now"
                                                            : "Mark your attendance",
                                                        style: Styles.regular(
                                                            size: 12,
                                                            color: ColorConstants()
                                                                .primaryForgroundColor())),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 18,
                                                            vertical: 8)),
                                              )),
                                        if (sessionList![index]
                                                .liveclassStatus!
                                                .toLowerCase() ==
                                            'upcoming')
                                          Text('Upcoming',
                                              style: Styles.regular(size: 12)),
                                        Visibility(
                                            child: Padding(
                                                child: Text(
                                                  "Concluded",
                                                  style: Styles.regular(
                                                      size: 12,
                                                      color:
                                                          ColorConstants.BLACK),
                                                ),
                                                padding: EdgeInsets.all(10)),
                                            visible: sessionList![index]
                                                    .liveclassStatus!
                                                    .toLowerCase() ==
                                                'completed')
                                      ],
                                    )
                                  ]))
                          : Container(child: Text(""));
                    },
                    itemCount: sessionList?.length != 0
                        ? sessionList!.length >= 2
                            ? 2
                            : sessionList?.length
                        : 0,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                  ))
            ],
          );
        });
  }

  renderMyCourses() {
    return ValueListenableBuilder(
        valueListenable: Hive.box(DB.CONTENT).listenable(),
        builder: (bc, Box box, child) {
          if (box.get("dashboard_my_courses_limit") == null) {
            return Text('lading');
          } else if (box.get("dashboard_my_courses_limit").isEmpty) {
            return Container(
              height: 290,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  "There are no dashboard_my_courses_limit available",
                  style: Styles.textBold(),
                ),
              ),
            );
          }

          myCoursesList = box
              .get("dashboard_my_courses_limit")
              .map((e) => DashboardMyCoursesLimit.fromJson(
                  Map<String, dynamic>.from(e)))
              .cast<DashboardMyCoursesLimit>()
              .toList();

          return Container(
            decoration: BoxDecoration(color: ColorConstants.WHITE),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'My Courses',
                        style: Styles.bold(color: Color(0xff0E1638)),
                      ),
                      Expanded(child: SizedBox()),
                      InkWell(
                        onTap: () {
                          menuProvider?.updateCurrentIndex('/g-school');
                        },
                        child: Text('View all',
                            style: Styles.regular(
                              size: 12,
                              color: ColorConstants.ORANGE_3,
                            )),
                      ),
                    ],
                  ),
                ),

                //show courses list
                Container(
                  height: 140,
                  decoration: BoxDecoration(color: ColorConstants.WHITE),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    NextPageRoute(
                                        ChangeNotifierProvider<
                                                TrainingDetailProvider>(
                                            create: (context) =>
                                                TrainingDetailProvider(
                                                    TrainingService(
                                                        ApiService()),
                                                    MProgram(
                                                        id: myCoursesList![
                                                                index]
                                                            .id)),
                                            child: TrainingDetailPage()),
                                        isMaintainState: true));
                              },
                              child: Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(top: 12, right: 10),
                                width: MediaQuery.of(context).size.width * 0.8,
                                //height: MediaQuery.of(context).size.height * 0.13,
                                decoration: BoxDecoration(
                                    color: ColorConstants.GREY.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(15)),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('${myCoursesList![index].name}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: Styles.bold(size: 16)),
                                      // SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Expanded(child: SizedBox()),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: ColorConstants.GREY_2,
                                            size: 20,
                                          )
                                        ],
                                      ),
                                      // SizedBox(height: 15),
                                      Text(
                                          '${myCoursesList![index].completion.toString().split('.').first}% ${Strings.of(context)?.Completed}',
                                          style: Styles.regular(size: 12)),
                                      SizedBox(height: 10),
                                      Container(
                                        height: 10,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        decoration: BoxDecoration(
                                            color: ColorConstants.GREY,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 10,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8 *
                                                  (myCoursesList![index]
                                                          .completion! /
                                                      100),
                                              decoration: BoxDecoration(
                                                  color: ColorConstants.YELLOW,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ]),
                              )),
                        ],
                      );
                    },
                    itemCount: myCoursesList?.length,
                    scrollDirection: Axis.horizontal,
                  ),
                )
              ],
            ),
          );
        });
  }

  renderReels() {
    return ValueListenableBuilder(
        valueListenable: Hive.box(DB.CONTENT).listenable(),
        builder: (bc, Box box, child) {
          if (box.get("dashboard_reels_limit") == null) {
            return Text('lading');
          } else if (box.get("dashboard_reels_limit").isEmpty) {
            return Container(
              height: 290,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  "There are no dashboard_reels_limit available",
                  style: Styles.textBold(),
                ),
              ),
            );
          }

          reelsList = box
              .get("dashboard_reels_limit")
              .map((e) => DashboardLimit.fromJson(Map<String, dynamic>.from(e)))
              .cast<DashboardLimit>()
              .toList();

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      child: Text(
                        'Latest Trends',
                        style: Styles.bold(color: Color(0xff0E1638)),
                      )),
                  Expanded(child: SizedBox()),
                  IconButton(
                      onPressed: () {
                        menuProvider?.updateCurrentIndex('/g-reels');
                      },
                      icon: Icon(Icons.arrow_forward_ios))
                ],
              ),

              //show courses list

              Container(
                  height: 250,
                  child: ListView.builder(
                      itemCount: reelsList?.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.2,
                          margin: EdgeInsets.only(
                              right: 10, left: 10, top: 4, bottom: 4),
                          child: SizedBox(
                              height: 280,
                              width: 180,
                              child: InkWell(
                                  onTap: () {
                                    menuProvider
                                        ?.updateCurrentIndex('/g-reels');
                                    menuProvider?.updateItemIndex(index);
                                  },
                                  child: CreateThumnail(
                                      path: reelsList?[index].resourcePath))),
                        );
                      }))
            ],
          );
        });
  }

  renderRecommandedCourses() {
    return ValueListenableBuilder(
        valueListenable: Hive.box(DB.CONTENT).listenable(),
        builder: (bc, Box box, child) {
          if (box.get("dashboard_recommended_courses_limit") == null) {
            // return CustomProgressIndicator(true, Colors.white);
            return Text('lading');
          } else if (box.get("dashboard_recommended_courses_limit").isEmpty) {
            return Container(
              height: 290,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  "There are no dashboard_recommended_courses_limit available",
                  style: Styles.textBold(),
                ),
              ),
            );
          }

          recommendedCourseList = box
              .get("dashboard_recommended_courses_limit")
              .map((e) => DashboardRecommendedCoursesLimit.fromJson(
                  Map<String, dynamic>.from(e)))
              .cast<DashboardRecommendedCoursesLimit>()
              .toList();

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      child: Text(
                        'Recommended Courses',
                        style: Styles.bold(color: Color(0xff0E1638)),
                      )),
                  Expanded(child: SizedBox()),
                  IconButton(
                      onPressed: () {
                        menuProvider?.updateCurrentIndex('/g-school');
                      },
                      icon: Icon(Icons.arrow_forward_ios))
                ],
              ),

              //show courses list

              Container(
                  padding: EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(color: ColorConstants.WHITE),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return _getCourseTemplate(
                          context,
                          recommendedCourseList,
                          recommendedCourseList![index],
                          index,
                          'TagReco',
                          MediaQuery.of(context).size.height * 0.35);
                    },
                    itemCount: recommendedCourseList?.length ?? 0,
                    shrinkWrap: true,
                  ))
            ],
          );
        });
  }

  renderCarvaan() {
    return ValueListenableBuilder(
        valueListenable: Hive.box(DB.CONTENT).listenable(),
        builder: (bc, Box box, child) {
          if (box.get("dashboard_carvan_limit") == null) {
            return Text('lading');
          } else if (box.get("dashboard_carvan_limit").isEmpty) {
            return Container(
              height: 290,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Text(
                  "There are no dashboard_carvan_limit available",
                  style: Styles.textBold(),
                ),
              ),
            );
          }

          carvaanList = box
              .get("dashboard_carvan_limit")
              .map((e) => DashboardLimit.fromJson(Map<String, dynamic>.from(e)))
              .cast<DashboardLimit>()
              .toList();

          return Container(
            decoration: BoxDecoration(color: ColorConstants.WHITE),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 10,
                        ),
                        child: Text(
                          'Recent Community Posts',
                          style: Styles.bold(color: Color(0xff0E1638)),
                        )),
                    Expanded(child: SizedBox()),
                    IconButton(
                        onPressed: () {
                          menuProvider?.updateCurrentIndex('/g-carvaan');
                        },
                        icon: Icon(Icons.arrow_forward_ios))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    height: 400,
                    child: ListView.builder(
                        itemCount: carvaanList?.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          final now = DateTime.now();

                          var millis = int.parse(
                              carvaanList![index].createdAt.toString());
                          DateTime date = DateTime.fromMillisecondsSinceEpoch(
                            millis * 1000,
                          );
                          //  VideoPlayerController? _controller;
                          //   if(   carvaanList?[index].resourcePath
                          //                                                 ?.contains('.mp4')  == true||
                          //                                               carvaanList?[index].resourcePath
                          //                                                 ?.contains('.mov') == true) {
                          //                                                    _controller = VideoPlayerController.network(carvaanList![index].resourcePath!);
                          //                                                     _controller.addListener(() {
                          //      if(kDebugMode) setState(() {});
                          //     });
                          //     _controller.setLooping(true);
                          //     // _controller.initialize().then((_) => setState(() {}));
                          //     _controller.play();
                          //                                                 }

                          return Container(
                            width: MediaQuery.of(context).size.width * 0.8,

                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: ColorConstants.GREY_4)),
                            margin: EdgeInsets.all(8),
                            // color: Colors.red,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0,
                                        right: 8.0,
                                        top: 15.0,
                                        bottom: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Center(
                                          child: ClipOval(
                                              child: Image.network(
                                            '${carvaanList?[index].profileImage}',
                                            height: 30,
                                            width: 30,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, url, error) {
                                              return SvgPicture.asset(
                                                'assets/images/default_user.svg',
                                                height: 30,
                                                width: 30,
                                                allowDrawingOutsideViewBox:
                                                    true,
                                              );
                                            },
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Shimmer.fromColors(
                                                baseColor: Color(0xffe6e4e6),
                                                highlightColor:
                                                    Color(0xffeaf0f3),
                                                child: Container(
                                                    height: 50,
                                                    margin: EdgeInsets.only(
                                                        left: 2),
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle,
                                                    )),
                                              );
                                            },
                                          )),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0,
                                                    right: 8.0,
                                                    top: 2.0),
                                                child: Text(
                                                  carvaanList?[index].name ??
                                                      '',
                                                  style: Styles.textRegular(
                                                      size: 14),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Text(
                                                  Utility()
                                                      .calculateTimeDifferenceBetween(
                                                          DateTime.parse(date
                                                              .toString()
                                                              .substring(
                                                                  0, 19)),
                                                          now,
                                                          context),
                                                  style:
                                                      Styles.regular(size: 12),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Padding(
                                      padding:
                                          carvaanList?[index].description !=
                                                  null
                                              ? const EdgeInsets.only(
                                                  bottom: 7, left: 10, top: 13)
                                              : const EdgeInsets.only(
                                                  bottom: 0, left: 10, top: 0),
                                      child: ReadMoreText(
                                          text:
                                              '${carvaanList?[index].description ?? ''}')),

                                  //                                    carvaanList?[index].resourcePath
                                  //                                               ?.contains('.mp4')  == true||
                                  //                                             carvaanList?[index].resourcePath
                                  //                                               ?.contains('.mov') == true
                                  //                                       // ? CustomBetterPlayer(
                                  //                                       //     url: widget.fileList[index])
                                  //                                       ? Container
                                  //                                       (
                                  //                                         height: 30,
                                  //                                         child: FlickVideoPlayer(
                                  //     flickManager: FlickManager(
                                  //   videoPlayerController:
                                  //       VideoPlayerController.network('${carvaanList?[index].resourcePath}'),
                                  // )
                                  //   )

                                  //                                         ):
                                  Image.network(
                                      '${carvaanList?[index].resourcePath}')
                                ]),
                          );
                        }),
                  ),
                )
              ],
            ),
          );
        });
  }

  renderFeaturedContentLimit() {
    return ValueListenableBuilder(
      valueListenable: Hive.box(DB.CONTENT).listenable(),
      builder: (bc, Box box, child) {
        if (box.get("dashboard_featured_content_limit") == null) {
          // return CustomProgressIndicator(true, Colors.white);
          return Text('lading');
        } else if (box.get("dashboard_featured_content_limit").isEmpty) {
          return Container(
            height: 290,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                "There are no getDashboardIsVisible available",
                style: Styles.textBold(),
              ),
            ),
          );
        }

        featuredContentList = box
            .get("dashboard_featured_content_limit")
            .map((e) => DashboardFeaturedContentLimit.fromJson(
                Map<String, dynamic>.from(e)))
            .cast<DashboardFeaturedContentLimit>()
            .toList();

        return Container(
          margin: EdgeInsets.only(left: 17, right: 17, top: 4),
          child: Column(
            children: [
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(CupertinoIcons.star_fill, color: ColorConstants.YELLOW),
                  SizedBox(width: 8),
                  Text('Featured Updates',
                      style: Styles.bold(color: Color(0xff0E1638))),
                  Expanded(child: SizedBox()),
                  InkWell(
                    onTap: () {
                      // menuProvider
                      //     .updateCurrentIndex(1);
                    },
                    child: Text('View all',
                        style: Styles.regular(
                          size: 12,
                          color: ColorConstants.ORANGE_3,
                        )),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Visibility(
                  visible: featuredContentList!.length > 0,
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: showAllFeatured
                        ? featuredContentList!.length
                        : min(2, featuredContentList!.length),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 20,
                        childAspectRatio: 2 / 3,
                        mainAxisExtent:
                            MediaQuery.of(context).size.height * 0.34,
                        crossAxisCount: 2),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () async {
                          // value
                          //     .enableProviderControl();
                          // value.mute();
                          // value.pause().then((data) =>
                          showModalBottomSheet(
                              context: context,
                              backgroundColor: ColorConstants.WHITE,
                              isScrollControlled: true,
                              builder: (context) {
                                return FractionallySizedBox(
                                    heightFactor: 1.0,
                                    child: ViewWidgetDetailsPage(
                                      joyContentList: featuredContentList
                                          as List<JoyContentListElement>,
                                      currentIndex: index,
                                    ));
                              });
                        },
                        child: Column(
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.25,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          foregroundDecoration: BoxDecoration(
                                              gradient: LinearGradient(
                                            end: const Alignment(0.0, -1),
                                            begin: const Alignment(0.0, 0.8),
                                            colors: [
                                              const Color(0x8A000000)
                                                  .withOpacity(0.4),
                                              Colors.black12.withOpacity(0.0)
                                            ],
                                          )),
                                          child: CachedNetworkImage(
                                            imageUrl: '',
                                            // '${featuredContentList![index].thumbnailUrl}',
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.fill,
                                              )),
                                            ),
                                            placeholder: (context, url) =>
                                                Image.asset(
                                              'assets/images/placeholder.png',
                                              fit: BoxFit.fill,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.asset(
                                              'assets/images/placeholder.png',
                                              fit: BoxFit.fill,
                                            ),
                                          )),
                                    ),
                                    if (featuredContentList![index]
                                        .resourcePath!
                                        .contains('.mp4'))
                                      Positioned.fill(
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: SvgPicture.asset(
                                            'assets/images/play_video_icon.svg',
                                            height: 30.0,
                                            width: 30.0,
                                            allowDrawingOutsideViewBox: true,
                                          ),
                                        ),
                                      ),
                                  ],
                                )),
                            Container(
                              height: 60,
                              margin: EdgeInsets.only(top: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // featuredContentList![
                                  //                 index]
                                  //             .viewCount !=
                                  //         null
                                  //     ? Row(
                                  //         children: [
                                  //           Text(
                                  //               '${featuredContentList![index].viewCount}  ${Strings.of(context)?.Views}',
                                  //               style: Styles.regular(
                                  //                   size: 10,
                                  //                   color: ColorConstants.GREY_3)),
                                  //           if (featuredContentList![index]
                                  //                   .viewCount! >
                                  //               1)
                                  //             Text(
                                  //                 Preference.getInt(Preference.APP_LANGUAGE) == 1
                                  //                     ? 's'
                                  //                     : '',
                                  //                 style:
                                  //                     Styles.regular(size: 10, color: ColorConstants.GREY_3)),
                                  //         ],
                                  //       )
                                  //     : Text(
                                  //         '${0}  ${Strings.of(context)?.Views}',
                                  //         style: Styles.regular(
                                  //             size:
                                  //                 10,
                                  //             color: ColorConstants
                                  //                 .GREY_3)),
                                  // SizedBox(
                                  //   width: 10,
                                  //   height: 4,
                                  // ),
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                        featuredContentList![index].title ?? '',
                                        maxLines: 2,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        style: Styles.semibold(
                                            size: 14,
                                            color: ColorConstants.GREY_1)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void getDashboardIsVisible() {
    box = Hive.box(DB.CONTENT);
    BlocProvider.of<HomeBloc>(context).add(DashboardIsVisibleEvent());
  }

  void getDasboardList() {
    box = Hive.box(DB.CONTENT);
    BlocProvider.of<HomeBloc>(context).add(DashboardContentEvent());
  }

  void handleDashboardIsVisible(DashboardIsVisibleState state) {
    var dashboardIsVisibleState = state;
    setState(() {
      switch (dashboardIsVisibleState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          dashboardIsVisibleLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("DashboardIsVisibleState....................");
          Log.v(state.response!.data);
          dashboardViewResponse = state.response;

          dashboardIsVisibleLoading = false;
          break;
        case ApiStatus.ERROR:
          dashboardIsVisibleLoading = false;
          Log.v("Error..........................");
          Log.v(
              "Error..........................${dashboardIsVisibleState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void handleDasboardList(DashboardContentState state) {
    var dashboardContentState = state;
    setState(() {
      switch (dashboardContentState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          dasboardListLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("DashboardContentState....................");
          Log.v(state.response!.data);
          dashboardContentResponse = state.response;

          dasboardListLoading = false;
          break;
        case ApiStatus.ERROR:
          dasboardListLoading = false;
          Log.v("Error..........................");
          Log.v(
              "Error..........................${dashboardContentState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  Widget _getCourseTemplate(
      context, recommendedcourses, yourCourses, int index, String tag, size) {
    List<String> duration = yourCourses.duration.toString().split(' ');
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CoursesDetailsPage(
                  imgUrl: recommendedcourses![index].image,
                  indexc: index,
                  tagName: 'TagReco',
                  name: recommendedcourses![index].name,
                  description: recommendedcourses![index].description ?? '',
                  regularPrice: recommendedcourses![index].regularPrice,
                  salePrice: recommendedcourses![index].salePrice,
                  trainer: recommendedcourses![index].trainer,
                  enrolmentCount: recommendedcourses![index].enrolmentCount,
                  type: recommendedcourses![index].subscriptionType,
                  id: recommendedcourses![index].id,
                  shortCode: recommendedcourses![index].shortCode)),
        ).then((isSuccess) {
          if (isSuccess == true) {
            print('sucess enrolled');
            // _getPopularCourses();
            // _getFilteredPopularCourses();

            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyCourses()));
          }
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        margin: EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
            border: Border.all(color: ColorConstants.GREY_4),
            borderRadius: BorderRadius.circular(8)),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size * 0.5,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    '${yourCourses.image}',
                    errorBuilder: (context, error, stackTrace) {
                      return SvgPicture.asset(
                        'assets/images/gscore_postnow_bg.svg',
                      );
                    },
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.55,
                          child: Text('${yourCourses.name}',
                              overflow: TextOverflow.ellipsis,
                              style: Styles.bold(size: 16))),
                      Icon(CupertinoIcons.clock,
                          size: 15, color: Color(0xFFFDB515)),
                      SizedBox(width: 2),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: Text('${duration[0]} ${duration[1]}',
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              style: Styles.regular(
                                  size: 10, color: Colors.black)))
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text('by ${yourCourses.trainer}',
                    style: Styles.regular(size: 12)),
              ),
              SizedBox(
                height: 2,
              ),
              Center(
                  child: Text(
                      '${yourCourses.enrolmentCount} Students already enrolled in this course',
                      style: Styles.regular(size: 12))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Start now',
                    style: Styles.semibold(),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  // Text(
                  //     '${yourCourses.enrolmentCount} ${Strings.of(context)?.enrollments}',
                  //     style: Styles.regular(size: 12)),
                  Row(
                    children: [
                      if (yourCourses.regularPrice != null)
                        Text('₹${yourCourses.regularPrice}',
                            style: TextStyle(
                              decoration: TextDecoration.lineThrough,
                            )),
                      SizedBox(
                        width: 8,
                      ),
                      if (yourCourses.salePrice != null)
                        Text(
                          '₹${yourCourses.salePrice}',
                          style: Styles.semibold(
                              size: 22, color: ColorConstants.GREEN),
                        ),
                    ],
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}

class CreateThumnail extends StatelessWidget {
  final String? path;

  const CreateThumnail({super.key, this.path});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
        future: getFile(),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    snapshot.data!,
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                Center(
                  child: SvgPicture.asset(
                    'assets/images/play.svg',
                    height: 40.0,
                    width: 40.0,
                    allowDrawingOutsideViewBox: true,
                  ),
                ),
              ],
            );
          return Shimmer.fromColors(
            baseColor: Color(0xffe6e4e6),
            highlightColor: Color(0xffeaf0f3),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(6)),
            ),
          );
        });
  }

  Future<Uint8List?> getFile() async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: path!,
      imageFormat: ImageFormat.PNG,
      timeMs: Duration(seconds: 1).inMilliseconds,
    );
    // if (this.mounted)
    //   setState(() {
    //     imageFile = uint8list;
    //   });
    return uint8list;
  }
}

class ShowImage extends StatefulWidget {
  final String? path;
  ShowImage({Key? key, this.path}) : super(key: key);

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  Uint8List? imageFile;
  @override
  void initState() {
    print('creating file ${widget.path}');
    super.initState();
    getFile();
  }

  Future<Uint8List?> getFile() async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: widget.path!,
      imageFormat: ImageFormat.PNG,
      timeMs: Duration(seconds: 1).inMilliseconds,
    );
    if (this.mounted)
      setState(() {
        imageFile = uint8list;
      });
    return uint8list;
  }

  @override
  Widget build(BuildContext context) {
    return imageFile != null
        ? Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  imageFile!,
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Center(
                child: SvgPicture.asset(
                  'assets/images/play.svg',
                  height: 40.0,
                  width: 40.0,
                  allowDrawingOutsideViewBox: true,
                ),
              ),
            ],
          )
        : Shimmer.fromColors(
            baseColor: Color(0xffe6e4e6),
            highlightColor: Color(0xffeaf0f3),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(6)),
            ),
          );
  }
}
