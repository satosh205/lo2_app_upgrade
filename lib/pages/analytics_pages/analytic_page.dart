// import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/get_courses_resp.dart';
import 'package:masterg/pages/analytics_pages/asking_rate_calculator_page.dart';
import 'package:masterg/pages/custom_pages/common_container.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/courses_loader.dart';
import 'package:masterg/pages/notification_list_page.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../analytics_pages/my_certificates_page.dart';
import 'kpi_wise_analysis_page.dart';
import 'my_analitics_page.dart';
import 'team_analysis_page.dart';

class AnalyticPage extends StatefulWidget {
  bool? isViewAll;
  Widget? drawerWidget;

  AnalyticPage({this.isViewAll, this.drawerWidget});

  @override
  _AnalyticPageState createState() => _AnalyticPageState();
}

class _AnalyticPageState extends State<AnalyticPage> {
  ScrollController _pageListScrollController = new ScrollController();
  List<ListElement> _getCoursesResp = [];

  bool _isLoading = true;

  int _selectedPage = 0;
  List<String?> _pageList = [];

  String? _selectedMemberId;

  @override
  void initState() {
    // TODO: implement initState
    // FirebaseAnalytics().logEvent(name: "analytics_screen", parameters: null);
    super.initState();
    _getCoursesListData(0);
  }

  @override
  void didChangeDependencies() {
    _pageList = [
      Strings.of(context)?.My_Analytics,
      Strings.of(context)?.Team_Analytics,
      Strings.of(context)?.KPI_Analytics,
    ];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocManager(
          initState: (BuildContext context) {},
          child: BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              Log.v("Loading....................GetCoursesState build");
              if (state is GetCoursesState) _handleAnnouncmentData(state);
            },
            child: widget.isViewAll == true
                ? _verticalList()
                : MyAnalyticsPage(
                    getCoursesResp: _getCoursesResp,
                    // getCourseModulesResp: _getCourseModulesResp,
                    isLoading: _isLoading),
          )),
    );
  }

  _verticalList() {
    return CommonContainer(
      isBackShow: false,
      isDrawerEnable: widget.drawerWidget != null,
      drawerWidget: widget.drawerWidget,
      child: _mainBody(),
      isContainerHeight: !_isLoading ? false : true,
      isScrollable: true,
      // scrollReverse: true,
      bgChildColor: Color.fromRGBO(238, 238, 243, 1),
      belowTitle: _menuItems(),
      title: Strings.of(context)?.analytics,
      onBackPressed: () {
        Navigator.pop(context);
      },
      isNotification: true,
      onSkipClicked: () {
        Navigator.push(context, NextPageRoute(NotificationListPage()));
      },
      isLoading: false,
    );
  }

  _mainBody() {
    if (_selectedPage == 0) {
      print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");

      return ValueListenableBuilder(
        valueListenable: Hive.box("analytics").listenable(),
        builder: (bc, Box box, child) {
          if (box.get("myAnalytics") == null) {
            return CoursesLoader();
          } else if (box.get("myAnalytics").isEmpty) {
            return Container(
              height: MediaQuery.of(context).size.height / 1.8,
              child: Center(
                child: Text(
                  "No data",
                  style: Styles.textBold(),
                ),
              ),
            );
          }
          print("##MYANALYTICS");
          _getCoursesResp = box
              .get("myAnalytics")
              .map((e) => ListElement.fromJson(Map<String, dynamic>.from(e)))
              .cast<ListElement>()
              .toList();
          return MyAnalyticsPage(
            getCoursesResp: _getCoursesResp,
            isLoading: false,
          );
        },
      );
    }
    if (_selectedPage == 1) {
      // FirebaseAnalytics()
      //     .logEvent(name: "team_analytics_opened", parameters: null);
      return ValueListenableBuilder(
        valueListenable: Hive.box("analytics").listenable(),
        builder: (bc, Box box, child) {
          if (box.get("teamAnalytics") == null) {
            return CoursesLoader();
          } else if (box.get("teamAnalytics").isEmpty) {
            return Container(
              height: MediaQuery.of(context).size.height / 1.8,
              child: Center(
                child: Text(
                  "No data",
                  style: Styles.textBold(),
                ),
              ),
            );
          }
          print("##TEAMANALYTICS");
          _getCoursesResp = box
              .get("teamAnalytics")
              .map((e) => ListElement.fromJson(Map<String, dynamic>.from(e)))
              .cast<ListElement>()
              .toList();
          return TeamAnalysisPage(
            // selectedMemberId: _selectedMemberId,
            isLoading: false,
            getCoursesResp: _getCoursesResp,
            onMemberChanged: (_selectedMemberId) {
              // setState(() {
              //   this._selectedMemberId = _selectedMemberId;
              // });
            },
          );
        },
      );
    }
    if (_selectedPage == 2) {
      // FirebaseAnalytics()
      //     .logEvent(name: "kpi_analytics_opened", parameters: null);
      return KPIWiseAnalysisPage();
    }
  }

  _menuItems() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: _selectedPage == 1
          ? _selectedMemberId != null
              ? 300
              : 200
          : 200,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 19),
            child: SizedBox(
              height: 120,
              width: screenWidth,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  GestureDetector(
                    onTap: () {
                      // FirebaseAnalytics().logEvent(
                      //     name: "asking_rate_calculator_opened",
                      //     parameters: null);
                      Navigator.push(
                          context,
                          NextPageRoute(AskingRateCalculatorPage(
                            isViewAll: true,
                          )));
                    },
                    child: Container(
                      height: 120,
                      width: 200,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color.fromRGBO(157, 234, 251, 1),
                          Color.fromRGBO(198, 223, 245, 1),
                        ]),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Asking Rate Calculator',
                            style: Styles.textBold(
                              size: 16,
                              color: Color.fromRGBO(28, 37, 85, 1),
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20.0),
                            child: Text(
                              '${Strings.of(context)?.Define_your_self}',
                              style: Styles.textBold(
                                size: 12,
                                color: Color.fromRGBO(0, 0, 0, 0.8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // FirebaseAnalytics().logEvent(
                      //     name: "my_certificates_opened", parameters: null);
                      Navigator.push(
                          context,
                          NextPageRoute(MyCertificatesPage(
                            isViewAll: true,
                          )));
                    },
                    child: Container(
                      height: 120,
                      width: 160,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color.fromRGBO(255, 235, 59, 1),
                          Color.fromRGBO(255, 213, 0, 1),
                        ]),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${Strings.of(context)?.Certification}',
                            style: Styles.textBold(
                              size: 16,
                              color: Color.fromRGBO(28, 37, 85, 1),
                            ),
                          ),
                          Spacer(),
                          Text(
                            '${Strings.of(context)?.viewAll}',
                            style: Styles.textBold(
                              size: 16,
                              color: Color.fromRGBO(46, 120, 228, 1),
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(left: 19),
            child: SizedBox(
              height: 40,
              width: screenWidth,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: _pageList.length,
                controller: _pageListScrollController,
                itemBuilder: (ctx, index) {
                  return GestureDetector(
                    onTap: () {
                      if (index == 0) {
                        setState(() {
                          _selectedPage = 0;
                          // _isLoading=true;
                          _getCoursesListData(0);
                        });
                      }
                      if (index == 1) {
                        setState(() {
                          _selectedPage = 1;
                          // _isLoading=true;
                          _getCoursesListData(1);
                        });
                      }
                      if (index == 2) {
                        setState(() {
                          _selectedPage = 2;
                          _pageListScrollController.animateTo(
                              _pageListScrollController
                                  .position.maxScrollExtent,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeOut);
                        });
                      }
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      margin: EdgeInsets.only(right: 16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: _selectedPage == index
                              ? Colors.white
                              : Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: _selectedPage == index ? 16 : 0,
                              color: Color.fromRGBO(0, 0, 0, 0.05),
                            ),
                          ]),
                      child: Text(
                        '${_pageList[index]}',
                        style: _selectedPage == index
                            ? Styles.textExtraBold(
                                size: 12,
                                color: Color.fromRGBO(46, 120, 228, 1),
                              )
                            : Styles.textSemiBold(
                                size: 12,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: 7,
          ),
          Visibility(
            visible: _selectedMemberId != null && _selectedPage == 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 7,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMemberId = null;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.symmetric(horizontal: 17, vertical: 11),
                    width: screenWidth,
                    height: 57,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: screenWidth * 0.7,
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Image.network(
                                    "https://images.pexels.com/photos/4462782/pexels-photo-4462782.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: screenWidth * 0.5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Tanmay G Bansal",
                                      style: Styles.textExtraBold(
                                        size: 14,
                                        color: Color.fromRGBO(28, 37, 85, 0.9),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "Lead UI/UX designer",
                                      style: Styles.textSemiBold(
                                        size: 10,
                                        color: Color.fromRGBO(28, 37, 85, 0.6),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: Color.fromRGBO(28, 37, 85, 0.8),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _getCoursesListData(int type) {
    Log.v("Loading....................GetCoursesState_getHomeData");
    BlocProvider.of<HomeBloc>(context).add(GetCoursesEvent(type: type));
  }

  void _handleAnnouncmentData(GetCoursesState state) {
    var loginState = state;
    //setState(() {
    switch (loginState.apiState) {
      case ApiStatus.LOADING:
        _isLoading = true;
        Log.v("Loading....................GetCoursesState");
        break;
      case ApiStatus.SUCCESS:
        Log.v("Success....................GetCoursesState");
        _isLoading = false;
        //   _getCoursesResp = state.response;
        break;
      case ApiStatus.ERROR:
        _isLoading = false;
        Log.v("Error..........................GetCoursesState");
        Log.v("Error..........................${loginState.error}");
        break;
      case ApiStatus.INITIAL:
        // TODO: Handle this case.
        break;
    }
    //  });
  }
}
