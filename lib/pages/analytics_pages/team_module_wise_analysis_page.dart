import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/request/home_request/get_course_modules_request.dart';
import 'package:masterg/data/models/response/home_response/get_course_modules_resp.dart';
import 'package:masterg/data/models/response/home_response/get_courses_resp.dart'
    as courseResp;
import 'package:masterg/data/models/response/home_response/get_module_leaderboard_resp.dart'
    as moduleLeaderboard;
import 'package:masterg/pages/custom_pages/analytics_loader.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/courses_loader.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:masterg/utils/constant.dart';

class TeamModuleWiseAnalysisPage extends StatefulWidget {
  final List<courseResp.ListElement>? getCoursesResp;

  TeamModuleWiseAnalysisPage({this.getCoursesResp});

  @override
  _TeamModuleWiseAnalysisPageState createState() =>
      _TeamModuleWiseAnalysisPageState();
}

class _TeamModuleWiseAnalysisPageState
    extends State<TeamModuleWiseAnalysisPage> {
  ScrollController _moduleListScrollController = new ScrollController();
  List<Module> _getModulesResp = [];
  List<moduleLeaderboard.ListElement> _getLeaderboardResp = [];
  bool? _isModuleWiseLeaderboardLoading = true;
  bool? _isModuleLoading = true;
  int? _selectedCourse;
  int? _selectedCourseIndex = 0;
  int? _selectedModule;
  int? _selectedModuleIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        _selectedCourse = widget.getCoursesResp?.first.id;
        _selectedModule = Hive.box("analytics")
                .get(_selectedCourse.toString() + AnalyticsType.MODULE_TYPE_2)
                ?.map((e) => Module.fromJson(Map<String, dynamic>.from(e)))
                ?.cast<Module>()
                ?.toList()
                ?.first
                ?.id ??
            null;
      });
      _getCourseWiseModulesData(_selectedCourse.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocManager(
        initState: (BuildContext context) {},
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            Log.v("Loading....................GetCoursesState build");
            if (state is GetCourseModulesState)
              _handleCourseWiseModulesAnnouncmentData(state);

            if (state is GetModuleLeaderboardState)
              _handleModuleWiseLeaderboardAnnouncmentData(state);
          },
          child: _buildBody(),
        ));
  }

  _buildBody() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Module wise Analysis',
          style: Styles.textExtraBold(
            size: 18,
            color: Color.fromRGBO(255, 141, 41, 1),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Padding(
          padding: EdgeInsets.only(right: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
               '${ Strings.of(context)?.Course_name}',
                style: Styles.textSemiBold(
                  size: 14,
                  color: Color.fromRGBO(28, 28, 28, 0.6),
                ),
              ),
              Visibility(
                visible: false,
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: Color.fromRGBO(3, 169, 244, 1),
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Search courses',
                        style: Styles.textBold(
                          size: 12,
                          color: Color.fromRGBO(28, 37, 85, 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        _selectedCourse == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                margin: EdgeInsets.only(right: 20),
                padding: EdgeInsets.symmetric(horizontal: 17, vertical: 11),
                width: screenWidth,
                // height: 41,
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
                child: DropdownButton<String>(
                  underline: Center(),
                  isExpanded: true,
                  value: widget.getCoursesResp
                      ?.where((element) => element.id == _selectedCourse)
                      .first
                      .name,
                  items: widget.getCoursesResp?.map((value) {
                    return new DropdownMenuItem<String>(
                      onTap: () {
                        setState(() {
                          _selectedCourse = value.id;
                          _selectedModule = Hive.box("analytics")
                                  .get(_selectedCourse.toString() +
                                      AnalyticsType.MODULE_TYPE_2)
                                  ?.map((e) => Module.fromJson(
                                      Map<String, dynamic>.from(e)))
                                  ?.cast<Module>()
                                  ?.toList()
                                  ?.first
                                  ?.id ??
                              null;
                          // _selectedCourseIndex=widget.getCoursesResp.data.list.indexOf(value);
                        });
                        _getCourseWiseModulesData(_selectedCourse.toString());
                        _getModuleWiseLeaderboardData(
                            _selectedModule.toString());
                      },
                      value: value.name,
                      child: new Text('${value.name}'),
                    );
                  }).toList(),
                  onChanged: (_) {},
                ),
              ),
        SizedBox(
          height: 10,
        ),
        _selectedModule == null
            ? CoursesLoader(
                expanded: false,
              )
            : _moduleList(),
        SizedBox(
          height: 20,
        ),
        _moduleWiseLeaderboardList(),
        SizedBox(
          height: 100,
        ),
      ],
    );
  }

  _moduleList() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return ValueListenableBuilder(
      valueListenable: Hive.box("analytics").listenable(),
      builder: (bc, Box box, child) {
        if (box.get(_selectedCourse.toString() + AnalyticsType.MODULE_TYPE_2) ==
            null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        _getModulesResp = box
            .get(_selectedCourse.toString() + AnalyticsType.MODULE_TYPE_2)
            .map((e) => Module.fromJson(Map<String, dynamic>.from(e)))
            .cast<Module>()
            .toList();
        return SizedBox(
          height: 67,
          width: screenWidth,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: _getModulesResp.length,
            controller: _moduleListScrollController,
            itemBuilder: (ctx, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedModule = _getModulesResp[index].id;
                    // _selectedModuleIndex = index;
                  });
                  _getModuleWiseLeaderboardData(_selectedModule.toString());
                  if (index == 2) {
                    setState(() {
                      _moduleListScrollController.animateTo(
                          _moduleListScrollController.position.maxScrollExtent,
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
                      color: _selectedModule == _getModulesResp[index].id
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
                            '${_getModulesResp[index].image}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Flexible(
                        child: Text(
                         '${ _getModulesResp[index].name}',
                          style: _selectedModule == _getModulesResp[index].id
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
      },
    );
  }

  _moduleWiseLeaderboardList() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    DateTime startDateObj = DateTime.fromMicrosecondsSinceEpoch(
        widget.getCoursesResp![_selectedCourseIndex!].startDate!);
    String startDate = DateFormat('dd-MM-yyyy').format(startDateObj);
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
            height: 103,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Color.fromRGBO(235, 238, 255, 1),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                   '${   widget.getCoursesResp![_selectedCourseIndex!].name}',
                      style: Styles.textBold(
                        size: 16,
                        color: Color.fromRGBO(28, 37, 85, 1),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 22,
                ),
                Text(
                  'Start Date: $startDate',
                  style: Styles.textSemiBold(
                    size: 10,
                    color: Color.fromRGBO(28, 37, 85, 0.8),
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
                       '${ Strings.of(context)?.Score}',
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
          ValueListenableBuilder(
              valueListenable: Hive.box("analytics").listenable(),
              builder: (bc, Box box, child) {
                if (box.get(_selectedModule.toString() +
                        AnalyticsType.MODULE_LEADERBOARD_TYPE_2) ==
                    null) {
                  return AnalyticsLoader();
                }
                _getLeaderboardResp = box
                    .get(_selectedModule.toString() +
                        AnalyticsType.MODULE_LEADERBOARD_TYPE_2)
                    .map((e) => moduleLeaderboard.ListElement.fromJson(
                        Map<String, dynamic>.from(e)))
                    .cast<moduleLeaderboard.ListElement>()
                    .toList();
                return SizedBox(
                  width: screenWidth,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _getLeaderboardResp.length,
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
                                  // ClipRRect(
                                  //   borderRadius: BorderRadius.all(Radius.circular(15)),
                                  //   child: SizedBox(
                                  //     width: 30,
                                  //     height: 30,
                                  //     child: Image.network(
                                  //       '',
                                  //       fit: BoxFit.cover,
                                  //     ),
                                  //   ),
                                  // ),
                                  // SizedBox(width: 10,),
                                  SizedBox(
                                    width: screenWidth * 0.28,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${_getLeaderboardResp[index].name}',
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
                                    _getLeaderboardResp[index]
                                            .completion
                                            .toString() +
                                        "%",
                                    style: Styles.textExtraBold(
                                      size: 12,
                                      color: Color.fromRGBO(45, 117, 221, 1),
                                    ),
                                  ),
                                  Text(
                                   '${ _getLeaderboardResp[index].score}',
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
                );
              })
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
        _isModuleLoading = true;
        Log.v("Loading....................GetCourseModulesState");
        break;
      case ApiStatus.SUCCESS:
        Log.v("Success....................GetCourseModulesState");
        _isModuleLoading = false;
        // _getModulesResp = state.response.data.list.first.modules;
        if (_selectedModule == null) {
          setState(() {
            _selectedModule = state.response?.data?.list?.first.modules?.first.id;
          });
        }
        _getModuleWiseLeaderboardData(_selectedModule.toString());
        break;
      case ApiStatus.ERROR:
        _isModuleLoading = false;
        Log.v("Error..........................GetCourseModulesState");
        Log.v("Error..........................${loginState.error}");
        break;
      case ApiStatus.INITIAL:
        // TODO: Handle this case.
        break;
    }
    // });
  }

  void _getModuleWiseLeaderboardData(String courseId) {
    Log.v(
        "Loading....................GetCourseModulesState_getCourseModulesData");
    BlocProvider.of<HomeBloc>(context).add(GetModuleLeaderboardEvent(
        getCourseModulesReq: GetCourseModulesRequest(courseId), type: 1));
  }

  void _handleModuleWiseLeaderboardAnnouncmentData(
      GetModuleLeaderboardState state) {
    var loginState = state;

    /// setState(() {
    switch (loginState.apiState) {
      case ApiStatus.LOADING:
        _isModuleWiseLeaderboardLoading = true;
        Log.v("Loading....................GetCourseModulesState");
        break;
      case ApiStatus.SUCCESS:
        Log.v("Success....................GetCourseModulesState");
        _isModuleWiseLeaderboardLoading = false;
        //  _getLeaderboardResp = state.response.data.list;
        break;
      case ApiStatus.ERROR:
        _isModuleWiseLeaderboardLoading = false;
        Log.v("Error..........................GetCourseModulesState");
        Log.v("Error..........................${loginState.error}");
        break;
      case ApiStatus.INITIAL:
        // TODO: Handle this case.
        break;
    }
    //});
  }
}
