import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/request/home_request/get_course_modules_request.dart';
import 'package:masterg/data/models/response/home_response/get_course_leaderboard_resp.dart'
    as leaderResp;
import 'package:masterg/data/models/response/home_response/get_course_modules_resp.dart'
    as moduleResp;
import 'package:masterg/data/models/response/home_response/get_courses_resp.dart'
    as courseResp;
import 'package:masterg/pages/custom_pages/analytics_loader.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masterg/utils/constant.dart';
import 'team_module_wise_analysis_page.dart';

class TeamAnalysisPage extends StatefulWidget {
  ValueChanged<String>? onMemberChanged;

  // String selectedMemberId;
  final List<courseResp.ListElement>? getCoursesResp;
  final bool? isLoading;

  TeamAnalysisPage({this.onMemberChanged, this.getCoursesResp, this.isLoading
      // @required this.selectedMemberId
      });

  @override
  _TeamAnalysisPageState createState() => _TeamAnalysisPageState();
}

class _TeamAnalysisPageState extends State<TeamAnalysisPage> {
  ScrollController _courseListScrollController = new ScrollController();
  List<moduleResp.Module> _getCourseModulesResp = [];
  List<leaderResp.ListElement> _getCourseLeaderboardResp = [];

  bool _isCourseWiseLeaderboardLoading = true;
  bool _isCourseWiseModuleLoading = true;

  int? _selectedCourse = 0;

  int _selectedCourseIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 200), () {
      if (widget.isLoading == true) {
        setState(() {
          _selectedCourse = widget.getCoursesResp?.first.id;
          _selectedCourseIndex = 0;
        });
        _getCourseWiseLeaderboardData(_selectedCourse.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return BlocManager(
        initState: (BuildContext context) {},
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            Log.v("Loading....................GetCoursesState build");
            if (state is GetCourseModulesState)
              _handleCourseWiseModulesAnnouncmentData(state);
            if (state is GetCourseLeaderboardState)
              _handleCourseWiseLeaderboardAnnouncmentData(state);
          },
          child: _teamAnalysisMainPage(),
        ));
  }

  _courseList() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: 67,
      width: screenWidth,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: widget.getCoursesResp?.length ?? 0,
        controller: _courseListScrollController,
        itemBuilder: (ctx, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCourse = widget.getCoursesResp?[index].id;
                _selectedCourseIndex = index;
              });
              //_getCourseWiseModulesData(_selectedCourse.toString());
              _getCourseWiseLeaderboardData(_selectedCourse.toString());
              if (index == 2) {
                setState(() {
                  _courseListScrollController.animateTo(
                      _courseListScrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeOut);
                });
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              margin: EdgeInsets.only(right: 16),
              width: 172,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: _selectedCourse == widget.getCoursesResp?[index].id
                      ? Colors.white
                      : Color.fromRGBO(28, 28, 28, 0.12),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                      color: Color.fromRGBO(28, 28, 28, 0.12), width: 1),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 16,
                      color: Color.fromRGBO(0, 0, 0, 0.05),
                    ),
                  ]),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: Image.network(
                        widget.getCoursesResp![index].image!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Flexible(
                    child: Text(
                      widget.getCoursesResp![index].name!,
                      style: _selectedCourse == widget.getCoursesResp![index].id
                          ? Styles.textExtraBold(
                              size: 12,
                              color: Color.fromRGBO(28, 37, 85, 0.8),
                            )
                          : Styles.textSemiBold(
                              size: 12,
                              color: Color.fromRGBO(28, 37, 85, 0.6),
                            ),
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // _teamAnalysisSelectMemberPage() {
  //   double screenWidth = MediaQuery.of(context).size.width;
  //   double screenHeight = MediaQuery.of(context).size.height;
  //
  //   return Container(
  //     width: screenWidth,
  //     padding: EdgeInsets.only(left: 20, top: 20),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Text(
  //               'Your team',
  //               style: Styles.textExtraBold(
  //                 size: 18,
  //                 color: Color.fromRGBO(255, 141, 41, 1),
  //               ),
  //             ),
  //             SizedBox(
  //               width: 2,
  //             ),
  //             Text(
  //               "•",
  //               style: Styles.textItalic(
  //                 size: 10,
  //                 color: Color.fromRGBO(28, 28, 28, 0.6),
  //               ),
  //             ),
  //             SizedBox(
  //               width: 2,
  //             ),
  //             Text(
  //               "43 people",
  //               style: Styles.textItalic(
  //                 size: 12,
  //                 color: Color.fromRGBO(28, 28, 28, 0.6),
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(
  //           height: 19,
  //         ),
  //         Container(
  //           margin: EdgeInsets.only(right: 20),
  //           padding: EdgeInsets.symmetric(horizontal: 17, vertical: 11),
  //           width: screenWidth,
  //           height: 41,
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.all(Radius.circular(10)),
  //             boxShadow: [
  //               BoxShadow(
  //                 blurRadius: 16,
  //                 color: Color.fromRGBO(0, 0, 0, 0.15),
  //               ),
  //             ],
  //           ),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: [
  //               Icon(
  //                 Icons.search,
  //                 color: Color.fromRGBO(28, 37, 85, 1),
  //                 size: 20,
  //               ),
  //               SizedBox(
  //                 width: 10,
  //               ),
  //               SizedBox(
  //                 width: screenWidth * 0.6,
  //                 child: TextField(
  //                   decoration: InputDecoration(
  //                     contentPadding: EdgeInsets.symmetric(vertical: 10),
  //                     hintText: 'Search name',
  //                     hintStyle: Styles.textSemiBold(
  //                       size: 12,
  //                       color: Color.fromRGBO(28, 37, 85, 0.6),
  //                     ),
  //                     border: InputBorder.none,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         SizedBox(
  //           height: 10,
  //         ),
  //         Container(
  //           margin: EdgeInsets.only(right: 20),
  //           padding: EdgeInsets.symmetric(horizontal: 17, vertical: 11),
  //           width: screenWidth,
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.all(Radius.circular(10)),
  //             boxShadow: [
  //               BoxShadow(
  //                 blurRadius: 16,
  //                 color: Color.fromRGBO(0, 0, 0, 0.15),
  //               ),
  //             ],
  //           ),
  //           child: Column(
  //             children: [
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text(
  //                     "Select a member",
  //                     style: Styles.textBold(
  //                       size: 16,
  //                       color: Color.fromRGBO(28, 37, 85, 1),
  //                     ),
  //                     maxLines: 2,
  //                   ),
  //                   Row(
  //                     children: [
  //                       Text(
  //                         "Filter",
  //                         style: Styles.textSemiBold(
  //                           size: 12,
  //                           color: Color.fromRGBO(45, 117, 221, 1),
  //                         ),
  //                         maxLines: 2,
  //                       ),
  //                       Icon(
  //                         Icons.keyboard_arrow_down_outlined,
  //                         color: Color.fromRGBO(17, 20, 45, 1),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //               SizedBox(
  //                 height: 16,
  //               ),
  //               SizedBox(
  //                 width: screenWidth,
  //                 child: GridView.builder(
  //                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //                       crossAxisCount: 4,
  //                       mainAxisSpacing: 20,
  //                       childAspectRatio: 1,
  //                     ),
  //                     physics: NeverScrollableScrollPhysics(),
  //                     itemCount: 10,
  //                     shrinkWrap: true,
  //                     itemBuilder: (ctx, index) {
  //                       return GestureDetector(
  //                         onTap: () {
  //                           setState(() {
  //                             widget.selectedMemberId = index.toString();
  //                           });
  //                           widget.onMemberChanged(widget.selectedMemberId);
  //                         },
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: [
  //                             ClipRRect(
  //                               borderRadius:
  //                               BorderRadius.all(Radius.circular(24)),
  //                               child: SizedBox(
  //                                 width: 48,
  //                                 height: 48,
  //                                 child: Image.network(
  //                                   "https://images.pexels.com/photos/6662764/pexels-photo-6662764.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
  //                                   fit: BoxFit.cover,
  //                                 ),
  //                               ),
  //                             ),
  //                             SizedBox(
  //                               height: 7,
  //                             ),
  //                             Text(
  //                               "Nishant Jain",
  //                               style: Styles.textSemiBold(
  //                                 size: 10,
  //                                 color: Color.fromRGBO(28, 37, 85, 1),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       );
  //                     }),
  //               )
  //             ],
  //           ),
  //         ),
  //         SizedBox(
  //           height: 100,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  _teamAnalysisMainPage() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        width: screenWidth,
        padding: EdgeInsets.only(left: 20, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${Strings.of(context)?.Course_level_Analysis}',
              style: Styles.textExtraBold(
                size: 18,
                color: Color.fromRGBO(255, 141, 41, 1),
              ),
            ),
            SizedBox(
              height: 11,
            ),
            _courseList(),
            SizedBox(
              height: 11,
            ),
            _courseWiseLeaderboardList(),
            SizedBox(
              height: 50,
            ),
            TeamModuleWiseAnalysisPage(
              getCoursesResp: widget.getCoursesResp,
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  _courseWiseLeaderboardList() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.only(right: 20),
      padding: EdgeInsets.all(9),
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            color: Color.fromRGBO(0, 0, 0, 0.15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: screenWidth,
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Color.fromRGBO(235, 238, 255, 1),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${Strings.of(context)?.Leaderboard}',
                  style: Styles.textBold(
                    size: 16,
                    color: Color.fromRGBO(28, 37, 85, 1),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.all(9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: screenWidth * 0.07,
                  child: Text(
                    'S.no',
                    style: Styles.textSemiBold(
                      size: 12,
                      color: Color.fromRGBO(45, 117, 221, 1),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.36,
                  child: Text(
                    'Name',
                    style: Styles.textSemiBold(
                      size: 12,
                      color: Color.fromRGBO(45, 117, 221, 1),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.32,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '% completed',
                        style: Styles.textSemiBold(
                          size: 12,
                          color: Color.fromRGBO(45, 117, 221, 1),
                        ),
                      ),
                      Text(
                        '${Strings.of(context)?.Score}',
                        style: Styles.textSemiBold(
                          size: 12,
                          color: Color.fromRGBO(45, 117, 221, 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: screenWidth,
            child: ValueListenableBuilder(
                valueListenable: Hive.box("analytics").listenable(),
                builder: (bc, Box box, child) {
                  if (box.get(_selectedCourse.toString() +
                          AnalyticsType.COURSE_LEADERBOARD_TYPE_2) ==
                      null) {
                    return AnalyticsLoader();
                  }
                  _getCourseLeaderboardResp = box
                      .get(_selectedCourse.toString() +
                          AnalyticsType.COURSE_LEADERBOARD_TYPE_2)
                      .map((e) => leaderResp.ListElement.fromJson(
                          Map<String, dynamic>.from(e)))
                      .cast<leaderResp.ListElement>()
                      .toList();
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: _getCourseLeaderboardResp.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, index) {
                      return Padding(
                        padding: EdgeInsets.all(9),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: screenWidth * 0.07,
                              alignment: Alignment.center,
                              child: Text(
                                (index + 1).toString(),
                                style: Styles.textSemiBold(
                                  size: 12,
                                  color: Color.fromRGBO(52, 50, 58, 1),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.43,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: screenWidth * 0.28,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${_getCourseLeaderboardResp[index].name}',
                                          style: Styles.textExtraBold(
                                            size: 14,
                                            color:
                                                Color.fromRGBO(28, 37, 85, 0.9),
                                          ),
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.23,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _getCourseLeaderboardResp[index]
                                            .completion
                                            .toString() +
                                        "%",
                                    style: Styles.textExtraBold(
                                      size: 12,
                                      color: Color.fromRGBO(45, 117, 221, 1),
                                    ),
                                  ),
                                  Text(
                                    "0.0",
                                    style: Styles.textExtraBold(
                                      size: 12,
                                      color: Color.fromRGBO(34, 34, 34, 0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (ctx, index) {
                      return Divider(
                        thickness: 1,
                        color: Color.fromRGBO(127, 137, 197, 0.16),
                        height: 1,
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }

  void _getCourseWiseModulesData(String courseId) {
    Log.v(
        "Loading....................GetCourseModulesState_getCourseModulesData");
    BlocProvider.of<HomeBloc>(context).add(GetCourseModulesEvent(
        getCourseModulesReq: GetCourseModulesRequest(courseId), type: 1));
  }

  void _handleCourseWiseModulesAnnouncmentData(GetCourseModulesState state) {
    var loginState = state;
    //setState(() {
    switch (loginState.apiState) {
      case ApiStatus.LOADING:
        _isCourseWiseModuleLoading = true;
        Log.v("Loading....................GetCourseModulesState");
        break;
      case ApiStatus.SUCCESS:
        Log.v("Success....................GetCourseModulesState");
        // _isCourseWiseModuleLoading = false;
        // _getCourseModulesResp = state.response;
        break;
      case ApiStatus.ERROR:
        _isCourseWiseModuleLoading = false;
        Log.v("Error..........................GetCourseModulesState");
        Log.v("Error..........................${loginState.error}");
        break;
      case ApiStatus.INITIAL:
        // TODO: Handle this case.
        break;
    }
    //});
  }

  void _getCourseWiseLeaderboardData(String courseId) {
    Log.v(
        "Loading....................GetCourseModulesState_getCourseModulesData");
    BlocProvider.of<HomeBloc>(context).add(GetCourseLeaderboardEvent(
        getCourseModulesReq: GetCourseModulesRequest(courseId), type: 1));
  }

  void _handleCourseWiseLeaderboardAnnouncmentData(
      GetCourseLeaderboardState state) {
    var loginState = state;
    // setState(() {
    switch (loginState.apiState) {
      case ApiStatus.LOADING:
        _isCourseWiseLeaderboardLoading = true;
        Log.v("Loading....................GetCourseModulesState");
        break;
      case ApiStatus.SUCCESS:
        Log.v("Success....................GetCourseModulesState");
        _isCourseWiseLeaderboardLoading = false;
        // _getCourseLeaderboardResp = state.response;
        break;
      case ApiStatus.ERROR:
        _isCourseWiseLeaderboardLoading = false;
        Log.v("Error..........................GetCourseModulesState");
        Log.v("Error..........................${loginState.error}");
        break;
      case ApiStatus.INITIAL:
        // TODO: Handle this case.
        break;
    }
    // });
  }

  _moduleAnalysisListByCourse() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.only(right: 20),
      padding: EdgeInsets.all(9),
      width: screenWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            color: Color.fromRGBO(0, 0, 0, 0.15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: screenWidth,
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Color.fromRGBO(235, 238, 255, 1),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${Strings.of(context)?.Leaderboard}',
                  style: Styles.textBold(
                    size: 16,
                    color: Color.fromRGBO(28, 37, 85, 1),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.all(9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: screenWidth * 0.07,
                  child: Text(
                    'S.no',
                    style: Styles.textSemiBold(
                      size: 12,
                      color: Color.fromRGBO(45, 117, 221, 1),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.36,
                  child: Text(
                    'Name',
                    style: Styles.textSemiBold(
                      size: 12,
                      color: Color.fromRGBO(45, 117, 221, 1),
                    ),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.32,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '% completed',
                        style: Styles.textSemiBold(
                          size: 12,
                          color: Color.fromRGBO(45, 117, 221, 1),
                        ),
                      ),
                      Text(
                        '${Strings.of(context)?.Score}',
                        style: Styles.textSemiBold(
                          size: 12,
                          color: Color.fromRGBO(45, 117, 221, 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: screenWidth,
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: 3,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (ctx, index) {
                return Padding(
                  padding: EdgeInsets.all(9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: screenWidth * 0.07,
                        alignment: Alignment.center,
                        child: Text(
                          (index + 1).toString(),
                          style: Styles.textSemiBold(
                            size: 12,
                            color: Color.fromRGBO(52, 50, 58, 1),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * 0.43,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              child: SizedBox(
                                width: 30,
                                height: 30,
                                child: Image.network(
                                  "https://images.pexels.com/photos/6805871/pexels-photo-6805871.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: screenWidth * 0.28,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Rashi Juneja",
                                    style: Styles.textExtraBold(
                                      size: 14,
                                      color: Color.fromRGBO(28, 37, 85, 0.9),
                                    ),
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: screenWidth * 0.23,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "0%",
                              style: Styles.textExtraBold(
                                size: 12,
                                color: Color.fromRGBO(45, 117, 221, 1),
                              ),
                            ),
                            Text(
                              "0.0",
                              style: Styles.textExtraBold(
                                size: 12,
                                color: Color.fromRGBO(34, 34, 34, 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (ctx, index) {
                return Divider(
                  thickness: 1,
                  color: Color.fromRGBO(127, 137, 197, 0.16),
                  height: 1,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
