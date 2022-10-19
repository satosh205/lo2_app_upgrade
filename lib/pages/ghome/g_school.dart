// ignore_for_file: unused_field, unused_local_variable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/request/home_request/user_program_subscribe.dart';
import 'package:masterg/data/models/response/home_response/course_category_list_id_response.dart';
import 'package:masterg/data/models/response/home_response/learning_space_response.dart';
import 'package:masterg/data/models/response/home_response/my_assignment_response.dart';
import 'package:masterg/data/models/response/home_response/onboard_sessions.dart';
import 'package:masterg/data/models/response/home_response/popular_courses_response.dart';
import 'package:masterg/data/models/response/home_response/user_analytics_response.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/ghome/my_assessments.dart';
import 'package:masterg/pages/ghome/my_assignments.dart';
import 'package:masterg/pages/ghome/my_courses.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/config.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../training_pages/new_screen/courses_details_page.dart';
import 'my_classes.dart';

class GSchool extends StatefulWidget {
  const GSchool({Key? key}) : super(key: key);

  @override
  _GSchoolState createState() => _GSchoolState();
}

class _GSchoolState extends State<GSchool> with TickerProviderStateMixin {
  List<AssignmentList>? assignmentList = [];
  List<UserAnalyticsData>? userAnalytics = [];
  List<LearningSpace>? learningSpace = [];
  bool _isJoyCategoryLoading = true;
  bool _isJoyContentListLoading = true;
  bool _isCourseList1Loading = true;
  bool _isCourseList2Loading = true;
  bool _isFeaturedVideoLoading = true;
  bool isProgramListLoading = true;
  bool isNotLiveclass = false;
  Timer? timer;
  int nocourseAssigned = 0;
  List<MProgram>? courseList1;
  List<Liveclass>? liveclassList;
  List<PopularCourses>? popularcoursess = [];
  List<Recommended>? recommendedcourses = [];
  List<OtherLearners>? otherLearners = [];
  List<ShortTerm>? shortTerm = [];
  List<HighlyRated>? highlyRated = [];
  List<MostViewed>? mostViewed = [];
  AnimationController? controller;

  Box? box;

  @override
  void initState() {
    super.initState();
    _getLiveClass();
    _getLearningSpace();
    _getUserAnalytics();
    _getPopularCourses();
    _getFilteredPopularCourses();

    timer = Timer.periodic(Duration(seconds: 60), (Timer t) => _getLiveClass());
    //timer =Timer.periodic(Duration(seconds: 20), (Timer t) => _getUserAnalytics());
    //timer = Timer.periodic(Duration(seconds: 20), (Timer t) => _getPopularCourses());
  }

  Widget build(BuildContext context) {
    return BlocManager(
      initState: (context) {},
      child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) async {
            if (state is getLiveClassState) _handleLiveClassResponse(state);
            if (state is PopularCoursesState)
              _handlePopularCoursesStateResponse(state);
            if (state is FilteredPopularCoursesState)
              _handlePopularFilteredCourses(state);
            if (state is CourseCategoryListIDState) {
              _handleCourseList1Response(state);
            }
            if (state is MyAssignmentState) _handleAnnouncmentData(state);
            if (state is UserAnalyticsState) _handleUserAnalyticsData(state);
            if (state is LearningSpaceState) _handleLearningSpaceData(state);
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                liveclassList != null && liveclassList!.length > 0
                    ? _getTodayClass()
                    : isNotLiveclass == true
                        ? Container()
                        : Container(),
                //_getRecentActivities(),
                //_getResumeLerarning(),
                //_getCourses(),
                _getDashboard(context),
                //_getCategories(context),
                //_getLearnNewEveryday(context),
                _getRecommendedCourses(context),
                _getOtherLearnerTopics(context),
                // _getTopPicksCourses(context),
                //_getShortCourses(context),
                // _getHighlyRatedCourses(context),
                // _getMostViewedCourses(context),
              ],
            ),
          )),
    );
  }

  void _handleAnnouncmentData(MyAssignmentState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          break;
        case ApiStatus.SUCCESS:
          //_isLoading = false;
          //_userTrack();
          //assignmentList.clear();
          assignmentList = box!
              .get("myassignment")
              .map((e) => AssignmentList.fromJson(Map<String, dynamic>.from(e)))
              .cast<AssignmentList>()
              .toList();
          print("45678456784567845678456789");
          /*if (state.contentType == categoryId) {
          announcementList.addAll(state.response.data.list.where((element) {
            return element.categoryId == categoryId;
          }).toList());
        }*/
          break;
        case ApiStatus.ERROR:
          //_isLoading = false;
          Log.v("Error..........................");
          Log.v(
              "ErrorAnnoucement..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void _handleUserAnalyticsData(UserAnalyticsState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          break;
        case ApiStatus.SUCCESS:
          //_isLoading = false;
          //_userTrack();
          //assignmentList.clear();
          userAnalytics = loginState.response!.data;
          /*if (state.contentType == categoryId) {
          announcementList.addAll(state.response.data.list.where((element) {
            return element.categoryId == categoryId;
          }).toList());
        }*/
          break;
        case ApiStatus.ERROR:
          //_isLoading = false;
          Log.v("Error..........................");
          Log.v(
              "ErrorAnnoucement..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void _handleLearningSpaceData(LearningSpaceState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          break;
        case ApiStatus.SUCCESS:
          print(loginState.response!.data!.learningSpace);
          break;
        case ApiStatus.ERROR:
          //_isLoading = false;
          Log.v("Error..........................");
          Log.v(
              "ErrorAnnoucement..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void _handleCourseList1Response(CourseCategoryListIDState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          _isCourseList1Loading = true;

          break;
        case ApiStatus.SUCCESS:
          Log.v("CourseCategoryState....................");
          // courseCategoryList.add(state.response.data.);

          courseList1 = state.response!.data!.programs;
          print('===========${courseList1}');

          if (courseList1!.length <= 0) nocourseAssigned = 1;
          _isCourseList1Loading = false;

          break;
        case ApiStatus.ERROR:
          Log.v("Error..........................");
          Log.v("ErrorHome..........................${loginState.error}");
          print('========test');
          courseList1 = state.response!.data!.programs;

          if (courseList1 == null || courseList1!.length <= 0)
            nocourseAssigned = 1;

          _isCourseList1Loading = false;

          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void _getUserAnalytics() {
    BlocProvider.of<HomeBloc>(context).add(UserAnalyticsEvent());
  }

  void _handlePopularCoursesStateResponse(PopularCoursesState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          _isJoyCategoryLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("PopularCourses....................");
          Log.v(state.response!.data);
          //liveclassList = state.response.data;
          Log.v("PopularCourses Done ....................${liveclassList}");
          _isJoyCategoryLoading = false;
          break;
        case ApiStatus.ERROR:
          _isJoyCategoryLoading = false;
          Log.v("Error..........................");
          Log.v("ErrorHome..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void _handlePopularFilteredCourses(FilteredPopularCoursesState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          _isJoyCategoryLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("JoyCategoryState....................");
          Log.v(state.response!.data);


          Log.v("LiveClassState Done ....................${liveclassList}");

          _isJoyCategoryLoading = false;
          break;
        case ApiStatus.ERROR:
          _isJoyCategoryLoading = false;
          Log.v("Error..........................");
          Log.v("ErrorHome..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void _handleLiveClassResponse(getLiveClassState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");

          // _isJoyCategoryLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("LiveClassState....................");
          Log.v(state.response!.data!.modules!.liveclass.toString());

          liveclassList = state.response!.data!.modules!.liveclass;

          liveclassList = liveclassList
              ?.where((element) =>
                  element.liveclassStatus?.toLowerCase() == 'upcoming')
              .toList();

          Log.v("LiveClassState Done ....................${liveclassList}");

          _isJoyCategoryLoading = false;
          break;
        case ApiStatus.ERROR:
          isNotLiveclass = true;
          _isJoyCategoryLoading = false;
          Log.v("Error..........................");
          Log.v("ErrorHome..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void _getLiveClass() {
    BlocProvider.of<HomeBloc>(context).add(getLiveClassEvent());
  }

  void _getLearningSpace() {
    box = Hive.box(DB.CONTENT);
    BlocProvider.of<HomeBloc>(context).add(LearningSpaceEvent(box: box));
  }

  void _getPopularCourses() {
    box = Hive.box(DB.CONTENT);
    BlocProvider.of<HomeBloc>(context).add(PopularCoursesEvent());
  }

  void _getFilteredPopularCourses() {
    box = Hive.box(DB.CONTENT);
    BlocProvider.of<HomeBloc>(context).add(FilteredPopularCoursesEvent());
  }

  Widget _getTodayClass() {
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
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: ColorConstants.GREY),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: EdgeInsets.only(left: 10, top: 10),
              child:
                  Text('Upcoming Classes', style: Styles.semibold(size: 18))),
          ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return liveclassList!.length > 0
                  ? Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          color: ColorConstants.WHITE,
                          border:
                              Border.all(color: Colors.grey[350]!, width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            liveclassList![index]
                                        .liveclassStatus!
                                        .toLowerCase() ==
                                    'live'
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      liveclassList![index]
                                                  .contentType!
                                                  .toLowerCase() !=
                                              'offlineclass'
                                          ? SvgPicture.asset(
                                              'assets/images/live_icon.svg',
                                              width: 25,
                                              height: 25,
                                              allowDrawingOutsideViewBox: true,
                                            )
                                          : SvgPicture.asset(
                                              'assets/images/offline_live.svg',
                                              allowDrawingOutsideViewBox: true,
                                            ),
                                      SizedBox(width: 5),
                                      Text(
                                          liveclassList![index]
                                                      .contentType!
                                                      .toLowerCase() ==
                                                  'offlineclass'
                                              ? 'Ongoing'
                                              : "Live Now",
                                          style: Styles.regular(
                                              size: 12,
                                              color: ColorConstants()
                                                  .primaryColor())),
                                      Expanded(child: SizedBox()),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: ColorConstants.BG_GREY),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 18),
                                        child: Text(
                                            liveclassList![index]
                                                            .contentType!
                                                            .toLowerCase() ==
                                                        'liveclass' ||
                                                    liveclassList![index]
                                                            .contentType!
                                                            .toLowerCase() ==
                                                        'zoomclass'
                                                ? "Live"
                                                : 'Classroom',
                                            style: Styles.regular(
                                                size: 10,
                                                color: ColorConstants.BLACK)),
                                      ),
                                    ],
                                  )
                                : liveclassList![index]
                                            .liveclassStatus!
                                            .toLowerCase() ==
                                        'upcoming'
                                    ? Row(children: [
                                        SvgPicture.asset(
                                          'assets/images/upcoming_live.svg',
                                          allowDrawingOutsideViewBox: true,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                            '${liveclassList![index].startTime} - ${liveclassList![index].endTime} |${DateFormat('d').format(DateTime.fromMillisecondsSinceEpoch(liveclassList![index].fromDate! * 1000))} ${months[int.parse(DateFormat('M').format(DateTime.fromMillisecondsSinceEpoch(liveclassList![index].fromDate! * 1000))) - 1]}',
                                            style: Styles.regular(size: 14)),
                                        Expanded(child: SizedBox()),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: ColorConstants.BG_GREY),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 18),
                                          child: Text(
                                              liveclassList![index]
                                                          .contentType!
                                                          .toLowerCase() ==
                                                      'offlineclass'
                                                  ? "Classroom"
                                                  : "Live",
                                              style: Styles.regular(
                                                  size: 10,
                                                  color: ColorConstants.BLACK)),
                                        ),
                                      ])
                                    : SizedBox(),
                            SizedBox(height: 10),
                            Text('${liveclassList![index].name}',
                                style: Styles.semibold(size: 16)),
                            SizedBox(height: 9),
                            Text(
                              '${liveclassList![index].description}',
                              style: Styles.regular(size: 14),
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                liveclassList![index].trainerName != null &&
                                        liveclassList![index].trainerName != ''
                                    ? Text(
                                        'by ${liveclassList![index].trainerName} ',
                                        style: Styles.regular(size: 12))
                                    : Text(''),
                                Expanded(child: SizedBox()),
                                if (liveclassList![index]
                                        .liveclassStatus!
                                        .toLowerCase() ==
                                    'live')
                                  InkWell(
                                      onTap: () {
                                        launch(liveclassList![index].url!);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color:
                                              ColorConstants().primaryColor(),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Padding(
                                            child: Text(
                                                liveclassList![index]
                                                                .contentType!
                                                                .toLowerCase() ==
                                                            "liveclass" ||
                                                        liveclassList![index]
                                                                .contentType!
                                                                .toLowerCase() ==
                                                            "zoomclass"
                                                    ? "Join Now"
                                                    : "Mark your attendance",
                                                style:
                                                    Styles.regular(size: 12)),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 18, vertical: 8)),
                                      )),
                                if (liveclassList![index]
                                        .liveclassStatus!
                                        .toLowerCase() ==
                                    'upcoming')
                                  Text('Upcoming',
                                      style: Styles.regular(size: 12)),
                                Visibility(
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.white),
                                            backgroundColor:
                                                MaterialStateProperty.all<Color>(
                                                    ColorConstants()
                                                        .primaryColor()),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                    side: BorderSide(color: ColorConstants().primaryColor())))),
                                        onPressed: () {
                                          //launch(liveclassList[index].url);
                                        },
                                        child: Padding(
                                            child: Text(
                                              "View Recording",
                                              style: Styles.regular(size: 12),
                                            ),
                                            padding: EdgeInsets.all(10))),
                                    visible: liveclassList![index].liveclassStatus!.toLowerCase() == 'completed')
                              ],
                            )
                          ]))
                  : Container(child: Text("No Acive LiveClass Now!!"));
            },
            itemCount: liveclassList?.length != 0
                ? liveclassList!.length >= 2
                    ? 2
                    : liveclassList?.length
                : 0,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
          ),
        ]));
  }

  Widget _getDashboard(context) {
    return Container(
        padding: EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 10),
        decoration: BoxDecoration(color: ColorConstants.GREY),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text('${Strings.of(context)?.ApniPadhaiJaariRakein}',
                    style: Styles.semibold(size: 18))),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                dashboardClassCard(),
                dashboardAssignmentCard(),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                dashboardQuizCard(),
                dashboardCoursesCard(),
              ],
            )
          ],
        ));
  }

  Widget dashboardQuizCard() {
    int index;
    index = userAnalytics!.length > 0
        ? userAnalytics!.indexWhere((element) => element.order == 3)
        : 0;
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyAssessmentPage(isViewAll: true)));
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.45,
          height: MediaQuery.of(context).size.width * 0.45,
          decoration: BoxDecoration(
              color: Colors.white,
              // gradient: LinearGradient(
              //     begin: Alignment.topLeft,
              //     end: Alignment.bottomRight,
              //     stops: [
              //       0.1,
              //       0.4,
              //     ],
              //     colors: [
              //       Colors.pink[200],
              //       Colors.orange[200]
              //     ]),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.09,
                  child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Color(0xFFFFF6DE),
                      child: CircleAvatar(
                          backgroundColor: Color(0xFFFFF6DE),
                          radius: 30,
                          child: SvgPicture.asset(
                            'assets/images/Quiz.svg',
                            allowDrawingOutsideViewBox: true,
                          )))),
              SizedBox(
                height: 15,
              ),
              Text('${Strings.of(context)?.MyQuiz}',
                  style: Styles.semibold(size: 16)),
              SizedBox(height: 4),
              // userAnalytics != null && userAnalytics.length > 0
              //     ? Text('${userAnalytics[index].value}',
              //         style: Styles.regular(size: 12))
              //     : Text("null"),
            ],
          ),
        ));
  }

  Widget dashboardCoursesCard() {
    int index;
    index = userAnalytics!.length > 0
        ? userAnalytics!.indexWhere((element) => element.order == 4)
        : 0;
    return InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyCourses()));
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.45,
          height: MediaQuery.of(context).size.width * 0.45,
          decoration: BoxDecoration(
              color: Colors.white,
              // gradient: LinearGradient(
              //     begin: Alignment.topLeft,
              //     end: Alignment.bottomRight,
              //     stops: [
              //       0.1,
              //       0.4,
              //     ],
              //     colors: [
              //       Colors.indigo[300],
              //       Colors.pink[600]
              //     ]),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.09,
                  child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Color(0xFFFFF6DE),
                      child: CircleAvatar(
                          backgroundColor: Color(0xFFFFF6DE),
                          radius: 30,
                          child: SvgPicture.asset(
                            'assets/images/Courses.svg',
                            allowDrawingOutsideViewBox: true,
                          )))),
              SizedBox(
                height: 15,
              ),
              Text('${Strings.of(context)?.MyCourses}',
                  style: Styles.semibold(size: 16)),
              SizedBox(height: 4),
              // userAnalytics != null && userAnalytics.length > 0
              //     ? Text('${userAnalytics[index].value}',
              //         style: Styles.regular(size: 12))
              //     : Text("null"),
            ],
          ),
        ));
  }

  Widget dashboardAssignmentCard() {
    int index;
    index = userAnalytics!.length > 0
        ? userAnalytics!.indexWhere((element) => element.order == 2)
        : 0;
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyAssignmentPage(isViewAll: true)));
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.45,
          height: MediaQuery.of(context).size.width * 0.45,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.09,
                  child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Color(0xFFFFF6DE),
                      child: SvgPicture.asset(
                        'assets/images/Assignment.svg',
                        allowDrawingOutsideViewBox: true,
                      ))),
              SizedBox(
                height: 15,
              ),
              Text('${Strings.of(context)?.MyAssignments}',
                  style: Styles.semibold(size: 16),
                  textAlign: TextAlign.center),
              SizedBox(height: 4),
              // userAnalytics != null && userAnalytics.length > 0
              //     ? Text('${userAnalytics[index].value}',
              //         style: Styles.regular(size: 12),
              //         textAlign: TextAlign.center)
              //     : Text("null"),
            ],
          ),
        ));
  }

  Widget dashboardClassCard() {
    int index;
    index = userAnalytics!.length > 0
        ? userAnalytics!.indexWhere((element) => element.order == 1)
        : 0;

    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MyClasses()));
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.45,
          height: MediaQuery.of(context).size.width * 0.45,
          decoration: BoxDecoration(
              color: Colors.white,
              // gradient: LinearGradient(
              //     begin: Alignment.topLeft,
              //     end: Alignment.bottomRight,
              //     stops: [
              //       0.1,
              //       0.4,
              //     ],
              //     colors: [
              //       Colors.indigo[300],
              //       Colors.indigo[600]
              //     ]),
              borderRadius: BorderRadius.circular(11)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.09,
                  child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Color(0xFFFFF6DE),
                      child: CircleAvatar(
                          backgroundColor: Color(0xFFFFF6DE),
                          radius: 30,
                          child: SvgPicture.asset(
                            'assets/images/MyClasses.svg',
                            allowDrawingOutsideViewBox: true,
                          )))),
              SizedBox(
                height: 15,
              ),
              Text('${Strings.of(context)?.MyClasses}',
                  style: Styles.semibold(size: 16)),
              SizedBox(height: 4),
              // userAnalytics != null && userAnalytics.length > 0
              //     ? Text('${userAnalytics[index].value}',
              //         style: Styles.regular(size: 12))
              //     : Text("null"),
            ],
          ),
        ));
  }

  Widget _getOtherLearnerTopics(context) {
    var title = APK_DETAILS['package_name'] == 'com.at.masterg' ?  Strings.of(context)!.otherLearnerCoursesMasterG :Strings.of(context)!.otherLearnerCourses;

    print('the title is $title');
    return box != null
        ? ValueListenableBuilder(
            valueListenable: box!.listenable(),
            builder: (bc, Box box, child) {
              if (box.get("other_learners") == null || _isJoyCategoryLoading == true) {
               return Column(children: [
          Shimmer.fromColors(
            baseColor: Color(0xffe6e4e6),
            highlightColor: Color(0xffeaf0f3),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.02,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(6)),
            ),
          
          ),

            ListView.builder(
              itemCount: 4,
              shrinkWrap: true,
              itemBuilder: (context, index)=>  Shimmer.fromColors(
            baseColor: Color(0xffe6e4e6),
            highlightColor: Color(0xffeaf0f3),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.12,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(6)),
            ),
          
          )),
         ],);
              } else if (box.get("other_learners").isEmpty) {
                return Container(
                    /*height: 290,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(
                      "There are no courses available",
                      style: Styles.textBold(),
                    ),
                  ),*/
                    );
              }

              otherLearners = box
                  .get("other_learners")
                  .map((e) =>
                      OtherLearners.fromJson(Map<String, dynamic>.from(e)))
                  .cast<OtherLearners>()
                  .toList();
              //var list = _getFilterList();
              return Container(
                  padding:
                      EdgeInsets.only(left: 10, bottom: 10, top: 10, right: 10),
                  decoration: BoxDecoration(color: ColorConstants.GREY),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(left: 10),
                            child:
                                Text(title!, style: Styles.DMSansbold(size: 18))),
                        ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            return otherLearners!.length > 0
                                ? InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CoursesDetailsPage(
                                                  imgUrl: otherLearners![index]
                                                      .image,
                                                  indexc: index,
                                                  tagName: 'TagOther',
                                                  name: otherLearners![index]
                                                      .name,
                                                  description:
                                                      otherLearners![index]
                                                          .description,
                                                  regularPrice:
                                                      otherLearners![index]
                                                          .regularPrice,
                                                  salePrice:
                                                      otherLearners![index]
                                                          .salePrice,
                                                  trainer: otherLearners![index]
                                                      .trainer,
                                                  enrolmentCount:
                                                      otherLearners![index]
                                                          .enrolmentCount,
                                                  type: otherLearners![index]
                                                      .subscriptionType,
                                                  id: otherLearners![index].id,
                                                  shortCode:
                                                      otherLearners![index]
                                                          .shortCode,
                                                )),
                                      ).then((isSuccess) {
                                        if (isSuccess == true) {

                            print('sucess enrolled');
                                          _getPopularCourses();
                                          _getFilteredPopularCourses();
                                             Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyCourses()));
                                        }
                                      });
                                      /*_subscribeRequest(
                                          otherLearners![index]
                                              .subscriptionType,
                                          otherLearners![index].id);*/
                                      // Navigator.push(
                                      //     context,
                                      //     NextPageRoute(ChangeNotifierProvider<
                                      //             OtherLearnersCourseProvider>(
                                      //         create: (context) =>
                                      //             OtherLearnersCourseProvider(
                                      //                 TrainingService(
                                      //                     ApiService()),
                                      //                 otherLearners[index]),
                                      //         child: OLCourseDetailPage())));
                                    },
                                    child: _getCourseTemplate(
                                        context,
                                        otherLearners![index],
                                        index,
                                        'TagOther'))
                                : Container(
                                    child: Text("No Acive LiveClass Now!!"));
                          },
                          itemCount: otherLearners?.length ?? 0,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                        ),
                      ]));
            },
          )
        : Shimmer.fromColors(
            baseColor: Color(0xffe6e4e6),
            highlightColor: Color(0xffeaf0f3),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.07,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(6)),
            ),
          );
  }

  sectionLoader() {
    return Shimmer.fromColors(
      baseColor: Color(0xffe6e4e6),
      highlightColor: Color(0xffeaf0f3),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.07,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(6)),
      ),
    );
  }

  Widget _getRecommendedCourses(context) {
    var title = Strings.of(context)!.recommendedCourses;
    return ValueListenableBuilder(
      valueListenable: box!.listenable(),
      builder: (bc, Box box, child) {
        if (box.get("recommended") == null || _isJoyCategoryLoading == true) {
          // return Container();
         return Column(children: [
          Shimmer.fromColors(
            baseColor: Color(0xffe6e4e6),
            highlightColor: Color(0xffeaf0f3),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.02,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(6)),
            ),
          
          ),

            ListView.builder(
              itemCount: 4,
              shrinkWrap: true,
              itemBuilder: (context, index)=>  Shimmer.fromColors(
            baseColor: Color(0xffe6e4e6),
            highlightColor: Color(0xffeaf0f3),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.12,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(6)),
            ),
          
          )),
         ],);
       
        } else if (box.get("recommended").isEmpty) {
          return Container();
        }

        recommendedcourses = box
            .get("recommended")
            .map((e) => Recommended.fromJson(Map<String, dynamic>.from(e)))
            .cast<Recommended>()
            .toList();

            // recommendedcourse.sor 
         if(APK_DETAILS['package_name'] == 'com.learn_build')   recommendedcourses?.sort((a,b) => a.categoryName!.compareTo(b.categoryName!));
        //var list = _getFilterList();
        return Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: ColorConstants.GREY),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [


              Padding(
                  padding: EdgeInsets.only(left: 10, top: 10),
                  child: Text(title!, style: Styles.DMSansbold(size: 18))),
              ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
if(APK_DETAILS['package_name'] == 'com.learn_build')...[

   if(index == 0) Container(
    margin: EdgeInsets.only(left: 9, top: 6),
    child: Text('${recommendedcourses![index].categoryName}',  maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: Styles.semibold(size: 16))),
                      if(index > 0 && recommendedcourses![index].categoryName != recommendedcourses![index-1].categoryName) Container(
                            margin: EdgeInsets.only(left: 9, top: 6),

                        child: Text('${recommendedcourses![index].categoryName}',  maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: Styles.semibold(size: 16))),
],
                      InkWell(
                          onTap: () {
                            /*_subscribeRequest(
                                recommendedcourses![index].subscriptionType,
                                recommendedcourses![index].id);*/

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CoursesDetailsPage(
                                      imgUrl: recommendedcourses![index].image,
                                      indexc: index,
                                      tagName: 'TagReco',
                                      name: recommendedcourses![index].name,
                                      description:
                                          recommendedcourses![index].description ??
                                              '',
                                      regularPrice:
                                          recommendedcourses![index].regularPrice,
                                      salePrice:
                                          recommendedcourses![index].salePrice,
                                      trainer: recommendedcourses![index].trainer,
                                      enrolmentCount:
                                          recommendedcourses![index].enrolmentCount,
                                      type: recommendedcourses![index]
                                          .subscriptionType,
                                      id: recommendedcourses![index].id,
                                      shortCode:
                                          recommendedcourses![index].shortCode)),
                            ).then((isSuccess) {
                              if (isSuccess == true) {
                                print('sucess enrolled');
                                _getPopularCourses();
                                _getFilteredPopularCourses();

                               Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyCourses()));
                              }
                            });

                            /*Navigator.push(
                                              context,
                                              NextPageRoute(ChangeNotifierProvider<
                                                      RecommendedCourseProvider>(
                                                  create: (context) =>
                                                      RecommendedCourseProvider(
                                                          TrainingService(
                                                              ApiService()),
                                                          recommendedcourses[
                                                              index]),
                                                  child:
                                                      PopularCourseDetailPage())));*/
                          },
                          child: _getCourseTemplate(context,
                              recommendedcourses![index], index, 'TagReco')),
                    ],
                  );
                },
                itemCount: recommendedcourses?.length ?? 0,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              ),
            ]));
      },
    );
  }

  Widget _getCourseTemplate(context, yourCourses, int index, String tag) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.14,
      //decoration: BoxDecoration(color: ColorConstants.GREY),
      //padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(7),
      //borderRadius
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorConstants.WHITE,
      ),

      child: Row(children: [
        Padding(
            child: SizedBox(
              width: MediaQuery.of(context).size.height * 0.08,
              height: MediaQuery.of(context).size.height * 0.12,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Hero(
                  tag: tag + "$index",
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
            ),
            padding: EdgeInsets.all(10)),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${yourCourses.name}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: Styles.semibold(size: 16)),
            if( APK_DETAILS['package_name'] == 'com.learn_build') Text('${yourCourses.approvalStatus ?? ''}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: Styles.semibold(size: 12, color: ColorConstants.YELLOW)),
                Row(
                  children: [
                    Text('${yourCourses.enrolmentCount} Enrollments',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                        style: Styles.regular(size: 14)),
                    Spacer(),
                    if (yourCourses.regularPrice != yourCourses.salePrice)
                      Text('₹${yourCourses.regularPrice}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                          )),
                    if (yourCourses.salePrice != null)
                      Text('₹${yourCourses.salePrice}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: Styles.bold(
                              size: 18, color: ColorConstants.GREEN)),
                  ],
                )
              ],
            ),
          ),
        )

        // Padding(
        //     padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
        //     child: Column(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           SizedBox(height: 1),
        //           Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               children: [
        //                 SizedBox(
        //                     width: 180,
        //                     child: Text('${yourCourses.name}',
        //                         style: Styles.bold(size: 16))),
        //                 // Container(
        //                 //     child: _getCoinCardWidget(
        //                 //         '${yourCourses.totalCoins ?? 0}', 'G Score'))
        //               ]),
        //           SizedBox(height: 7),
        //           // Row(
        //           //   children: [
        //           //     Icon(CupertinoIcons.clock,
        //           //         size: 15, color: Color(0xFFFDB515)),
        //           //     Text('${yourCourses.duration}',
        //           //         style: Styles.regular(size: 10))
        //           //   ],
        //           // ),
        //           SizedBox(height: 10),
        //           // Row(
        //           //   children: [
        //           //     Text('4.5',
        //           //         style: Styles.textRegular(
        //           //             color: ColorConstants.ACTIVE_TAB, size: 20)),
        //           //     Icon(Icons.star, color: ColorConstants.ACTIVE_TAB, size: 20),
        //           //     Icon(Icons.star, color: ColorConstants.ACTIVE_TAB, size: 20),
        //           //     Icon(Icons.star, color: ColorConstants.ACTIVE_TAB, size: 20),
        //           //     Icon(Icons.star, color: ColorConstants.ACTIVE_TAB, size: 20),
        //           //     Icon(Icons.star, color: ColorConstants.ACTIVE_TAB, size: 20),
        //           //   ],
        //           // ),
        //           Row(
        //             mainAxisAlignment: MainAxisAlignment.start,
        //             children: [
        //               Text('${yourCourses.enrolmentCount} Enrollments',
        //                   style: Styles.regular(size: 12)),
        //               Row(
        //                 children: [
        //                   Text('₹${yourCourses.regularPrice}',
        //                       style: TextStyle(
        //                         decoration: TextDecoration.lineThrough,
        //                       )),
        //                   Text(
        //                     '₹${yourCourses.salePrice}',
        //                     style: Styles.textExtraBold(
        //                         size: 22, color: ColorConstants.GREEN),
        //                   ),
        //                 ],
        //               ),
        //             ],
        //           ),
        //         ]))
      ]),
    );
  }

  _subscribeRequest(type, id) {
    print(type);
    print(id);
    if (type == "paid") {
      AlertsWidget.showCustomDialog(
          context: context,
          title: "Contact Administrator to get access to this program!!",
          text: "",
          icon: 'assets/images/circle_alert_fill.svg',
          showCancel: false,
          // okText:
          oKText: "Ok",
          onOkClick: () async {
            // Navigator.pop(context);
          });
    }

    if (type == "approve") {
      BlocProvider.of<HomeBloc>(context).add(UserProgramSubscribeEvent(
          subrReq: UserProgramSubscribeReq(programId: id)));

      AlertsWidget.showCustomDialog(
          context: context,
          title: "Approval Request has been sent,",
          text: "You will be assigned to this course soon!!",
          icon: 'assets/images/circle_alert_fill.svg',
          showCancel: false,
          oKText: '${Strings.of(context)?.ok}',
          onOkClick: () async {
            // Navigator.pop(context);
          });
    }

    if (type == "open") {
      BlocProvider.of<HomeBloc>(context).add(UserProgramSubscribeEvent(
          subrReq: UserProgramSubscribeReq(programId: id)));

      AlertsWidget.showCustomDialog(
          context: context,
          title: "Subscribed Sucessfully!!",
          text: "",
          icon: 'assets/images/circle_alert_fill.svg',
          showCancel: false,
          onOkClick: () async {
            // Navigator.pop(context);
          });
    }
  }
}
