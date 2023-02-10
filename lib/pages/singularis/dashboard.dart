import 'dart:math';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
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
import 'package:masterg/pages/ghome/my_courses.dart';
import 'package:masterg/pages/ghome/widget/read_more.dart';
import 'package:masterg/pages/ghome/widget/view_widget_details_page.dart';
import 'package:masterg/pages/singularis/competition/competition_detail.dart';
import 'package:masterg/pages/singularis/job/job_details_page.dart';

import 'package:masterg/pages/training_pages/new_screen/courses_details_page.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/portfolio_page.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/coustom_outline_button.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../data/models/response/auth_response/bottombar_response.dart';
import '../../data/models/response/home_response/competition_response.dart';
import '../../data/models/response/home_response/domain_list_response.dart';
import '../../data/providers/training_detail_provider.dart';
import '../../data/providers/video_player_provider.dart';
import '../../utils/resource/size_constants.dart';
import '../custom_pages/alert_widgets/alerts_widget.dart';
import '../custom_pages/custom_widgets/CommonWebView.dart';
import '../gcarvaan/comment/comment_view_page.dart';
import '../reels/reels_dashboard_page.dart';
import '../training_pages/training_detail_page.dart';
import '../training_pages/training_service.dart';
import 'app_drawer_page.dart';

class DashboardPage extends StatefulWidget {
  final fromDashboard;

  const DashboardPage({Key? key, this.fromDashboard}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<MProgram>? courseList1;
  Box? box;
  bool? dashboardIsVisibleLoading = true;
  bool? dasboardListLoading = true;
  bool? domainLoading = true;
  bool? featuredInternshipsLoading = true;
  bool? jobApplyLoading = true;

  DashboardContentResponse? dashboardContentResponse;
  List<DashboardFeaturedContentLimit>? featuredContentList;
  List<DashboardRecommendedCoursesLimit>? recommendedCourseList;

  //List<DashboardLimit>? reelsList;
  List<DashboardReelsLimit>? reelsList;
  List<DashboardCarvanLimit>? carvaanList;
  List<DashboardSessionsLimit>? sessionList;
  List<DashboardMyCoursesLimit>? myCoursesList;
  DashboardViewResponse? dashboardViewResponse;
  bool showAllFeatured = false;
  MenuListProvider? menuProvider;
  late int selectedPage;
  late final PageController _pageController;
  CompetitionResponse? competitionResponse, featuredInternshipsResponse;
  DomainListResponse? domainList;


  @override
  void initState() {
    selectedPage = 0;
    _pageController = PageController(initialPage: selectedPage);
    getDomainList();
    getMyJobList();
    getCompetitionList();
    getDashboardIsVisible();
    getDasboardList();
    super.initState();
  }


  ///TODO: get Featured Jobs & Internships
  void getMyJobList() {
    BlocProvider.of<HomeBloc>(context).add(
        JobCompListEvent(isPopular: true, isFilter: false, isJob: 1, myJob: 0));
  }

  ///TODO: get Competition List
  void getCompetitionList() {
    BlocProvider.of<HomeBloc>(context)
        .add(CompetitionListEvent(isPopular: false));
  }

  void getDomainList() {
    BlocProvider.of<HomeBloc>(context).add(DomainListEvent());
  }

  //TODO: Job Apply API Call
  ///TODO: Job get progress and competition instructions Or Job Apply for same API call
  ///pass key for job apply case is_applied=1
  void jobApply(int jobId, int? isApplied) {
    BlocProvider.of<HomeBloc>(context).add(
        CompetitionContentListEvent(competitionId: jobId, isApplied: isApplied));
  }



  void _handlecompetitionListResponse(CompetitionListState state) {
    print('_handlecompetitionListResponse');
    var competitionState = state;
    setState(() {
      switch (competitionState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          break;
        case ApiStatus.SUCCESS:
          Log.v("CompetitionState....................");
          competitionResponse = state.competitonResponse;
          break;
        case ApiStatus.ERROR:
          Log.v(
              "Error CompetitionListIDState ..........................${competitionState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void handleDomainListResponse(DomainListState state) {
    var popularCompetitionState = state;
    setState(() {
      switch (popularCompetitionState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          domainLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("popularCompetitionState....................");
          domainList = state.response;
          print('domainList =======');
          print('UserID ======= ${Preference.getInt(Preference.USER_ID)}');
          print(domainList!.data!.list.length);
          print(domainList!.data!.list[0].name);

          domainLoading = false;
          break;
        case ApiStatus.ERROR:
          Log.v("Error Popular CompetitionListIDState ..........................${popularCompetitionState.error}");
          domainLoading = false;
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void _handleFeaturedInternshipsListResponse(JobCompListState state) {
    print('_handleFeaturedInternshipsListResponse singh');
    var jobCompState = state;
    setState(() {
      switch (jobCompState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          featuredInternshipsLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("CompetitionState....................");
          featuredInternshipsResponse = state.myJobListResponse;
          featuredInternshipsLoading = false;
          break;
        case ApiStatus.ERROR:
          Log.v("Error CompetitionListIDState .....................${jobCompState.error}");
          featuredInternshipsLoading = false;
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  //TODO: Job Apply
  void handleJobApplyState(CompetitionContentListState state) {
    var competitionState = state;
    setState(() {
      switch (competitionState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          jobApplyLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("Competition Content List State....................");
          //contentList = competitionState.response;
          jobApplyLoading = false;
          getMyJobList();
          /*AlertsWidget.showCustomDialog(
              context: context,
              title: '${'Job Apply'}',
              text: '${'Your application is successfully submitted'}',
              icon: 'assets/images/circle_alert_fill.svg',
              showCancel: false,
              oKText: 'OK',
              onOkClick: () async {
              });*/
          Utility.showSnackBar(
              scaffoldContext: context, message: 'Your application is successfully submitted.');
          break;
        case ApiStatus.ERROR:
          Log.v(
              "Error Competition Content ..........................${competitionState.response?.error}");
          jobApplyLoading = false;
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var pages = {
      "dashboard_featured_content_limit": renderFeaturedContentLimit(),
      "dashboard_sessions_limit": renderSession(),
      "dashboard_my_courses_limit": renderMyCourses(),
      "dashboard_reels_limit": renderReels(),
      "dashboard_recommended_courses_limit": renderRecommandedCourses(),
      //"dashboard_carvan_limit": renderCarvaan()
      "dashboard_carvan_limit": renderCarvaanPageView()
    };

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: new AppDrawer(),
      body: Consumer2<VideoPlayerProvider, MenuListProvider>(
          builder: (context, value, mp, child) => BlocManager(
            initState: (context) {},
            child: BlocListener<HomeBloc, HomeState>(
              listener: (context, state) async {
                if (state is CompetitionListState) {
                  _handlecompetitionListResponse(state);
                }
                if (state is DomainListState) {
                  handleDomainListResponse(state);
                }
                if (state is JobCompListState) {
                  _handleFeaturedInternshipsListResponse(state);
                }
                if (state is CompetitionContentListState)
                  handleJobApplyState(state);

                setState(() {
                  menuProvider = mp;
                });
              },
              child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                                    SizedBox(height: 5.0,),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                NextPageRoute(NewPortfolioPage()));
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(200),
                                            child: SizedBox(
                                              width: 50,
                                              child: Image.network(
                                                '${Preference.getString(Preference.PROFILE_IMAGE)}',
                                                errorBuilder:
                                                    (context, error, stackTrace) =>
                                                    SvgPicture.asset(
                                                      'assets/images/default_user.svg',
                                                      width: 50,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text('Welcome',
                                                style: Styles.regular(
                                                    color: ColorConstants.WHITE, size: 14)),
                                            Text(
                                              '${Preference.getString(Preference.FIRST_NAME)}',
                                              style: Styles.bold(
                                                  color: ColorConstants.WHITE, size: 22),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: InkWell(
                                          onTap: () {
                                            _scaffoldKey.currentState?.openEndDrawer();
                                          },
                                          child: SizedBox(
                                              width: 50,
                                              child: Icon(Icons.settings_sharp, color: Colors.white,)
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Container(
                                  height: 5,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color:
                                      ColorConstants.WHITE.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 10,
                                        width: MediaQuery.of(context).size.width *
                                            0.6 *
                                            (30 / 100),
                                        decoration: BoxDecoration(
                                            color: Color(0xffFFB72F),
                                            borderRadius:
                                            BorderRadius.circular(10)),
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

                      SizedBox(
                        height: 10,
                      ),
                      domainLoading == false ? futureTrendsList(): SizedBox(),

                      SizedBox(
                        height: 10,
                      ),
                      featuredInternshipsLoading == false ? featuredJobsInternships(): SizedBox(),

                      /*SizedBox(
                        height: 10,
                      ),
                      skillGapAnalysisWidgets(),*/

                      SizedBox(
                        height: 20,
                      ),
                      competitionsWidgets(),

                      SizedBox(
                        height: 20,
                      ),
                      _buildYourPortfolioCard(
                          ColorConstants.ORANGE,
                          'Build Your Portfolio',
                          'Creating a Portfolio helps the recruiters to understand better about your profile and your skills.',
                          'build_portfolio'),

                      SizedBox(
                        height: 10,
                      ),

                      ///API Data
                      renderWidgets(pages),
                    ],
                  )),
            ),
          )),
    );
  }

  ///Santosh
  futureTrendsList() {
    return Container(
      decoration: BoxDecoration(color: ColorConstants.WHITE),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: SvgPicture.asset(
                  'assets/images/grf_job.svg',
                  height: 30.0,
                  width: 30.0,
                  allowDrawingOutsideViewBox: true,
                  color: ColorConstants.GRADIENT_ORANGE,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 10,
                  ),
                  child: Text(
                    'Future Trends',
                    style: Styles.bold(color: Color(0xff0E1638)),
                  )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              height: 90,
              child: ListView.builder(
                  itemCount: domainList!.data!.list.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: (){
                        futureTrendsButtonSheet(
                            domainList!.data!.list[index].growthType,
                            domainList!.data!.list[index].growth);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                            color: ColorConstants.List_Color,
                            borderRadius: BorderRadius.circular(10),
                            border:
                            Border.all(color: ColorConstants.List_Color)),
                        margin: EdgeInsets.all(8),
                        // color: Colors.red,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            // mainAxisAlignment: MainAxisAlignment,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0,
                                    right: 8.0,
                                    top: 8.0,
                                    bottom: 8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      '${domainList!.data!.list[index].name}',
                                      style: Styles.bold(
                                          color: Color(0xff0E1638), size: 13),
                                      softWrap: true,
                                      maxLines: 1,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${domainList!.data!.list[index].jobCount} Jobs',
                                          style: Styles.regular(
                                              color: ColorConstants.GREY_3,
                                              size: 11),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            '+${domainList!.data!.list[index].growth}%',
                                            style: Styles.regular(
                                                color: domainList!.data!.list[index].growthType == 'up' ?
                                                ColorConstants.GREEN : ColorConstants.RED,
                                                size: 11),
                                          ),
                                        ),
                                        domainList!.data!.list[index].growthType == 'up' ? Icon(
                                          Icons.arrow_drop_up_outlined,
                                          color: Colors.green,
                                          size: 20,
                                        ):
                                        Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                    );
                  }),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  futureTrendsButtonSheet(String growthType, String growth) {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        backgroundColor: Colors.white,
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height - 60,
            child: Column(
              children: [
                Container(
                  height: 35,
                  padding: EdgeInsets.only(right: 20.0, top: 10.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.close,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                      color: ColorConstants.List_Color,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: ColorConstants.List_Color)),
                  //margin: EdgeInsets.all(8),
                  // color: Colors.red,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      '+${growth}%',
                                      style: Styles.regular(
                                          color: growthType == 'up' ?
                                          ColorConstants.GREEN:
                                          ColorConstants.RED,
                                          size: 11),
                                    ),
                                  ),
                                  growthType == 'up' ? Icon(
                                    Icons.arrow_drop_up_outlined,
                                    color: Colors.green,
                                    size: 20,
                                  ):
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Projected Growth',
                                style: Styles.regular(
                                    color: Color(0xff0E1638), size: 12),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30.0),
                  child: Image.asset('assets/images/graf_img.png'),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                                color: ColorConstants.List_Color,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                Border.all(color: ColorConstants.List_Color)),
                            margin: EdgeInsets.all(8),
                            // color: Colors.red,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0,
                                        right: 8.0,
                                        top: 8.0,
                                        bottom: 8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Art & Design',
                                          style: Styles.bold(
                                              color: Color(0xff0E1638), size: 12),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "\$59k",
                                              style: Styles.regular(
                                                  color: ColorConstants.GREY_3,
                                                  size: 11),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(left: 8.0),
                                              child: Text(
                                                '+30.6%',
                                                style: Styles.regular(
                                                    color: ColorConstants.GREEN,
                                                    size: 11),
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_drop_up_outlined,
                                              color: Colors.green,
                                              size: 20,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          )),
                      Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                                color: ColorConstants.List_Color,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                Border.all(color: ColorConstants.List_Color)),
                            margin: EdgeInsets.all(0),
                            // color: Colors.red,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0,
                                        right: 8.0,
                                        top: 8.0,
                                        bottom: 8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Art & Design',
                                          style: Styles.bold(
                                              color: Color(0xff0E1638), size: 12),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "\$59k",
                                              style: Styles.regular(
                                                  color: ColorConstants.GREY_3,
                                                  size: 12),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(left: 8.0),
                                              child: Text(
                                                '+30.6%',
                                                style: Styles.regular(
                                                    color: ColorConstants.GREEN,
                                                    size: 11),
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_drop_up_outlined,
                                              color: Colors.green,
                                              size: 20,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          )),
                      Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                                color: ColorConstants.List_Color,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                Border.all(color: ColorConstants.List_Color)),
                            margin: EdgeInsets.all(8),
                            // color: Colors.red,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0,
                                        right: 8.0,
                                        top: 8.0,
                                        bottom: 8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Art & Design',
                                          style: Styles.bold(
                                              color: Color(0xff0E1638), size: 12),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "\$59k",
                                              style: Styles.regular(
                                                  color: ColorConstants.GREY_3,
                                                  size: 11),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(left: 8.0),
                                              child: Text(
                                                '+30.6%',
                                                style: Styles.regular(
                                                    color: ColorConstants.GREEN,
                                                    size: 11),
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_drop_up_outlined,
                                              color: Colors.green,
                                              size: 20,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                    children: [
                      Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                                color: ColorConstants.List_Color,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                Border.all(color: ColorConstants.List_Color)),
                            margin: EdgeInsets.all(8),
                            // color: Colors.red,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0,
                                        right: 8.0,
                                        top: 8.0,
                                        bottom: 8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Art & Design',
                                          style: Styles.bold(
                                              color: Color(0xff0E1638), size: 12),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "\$59k",
                                              style: Styles.regular(
                                                  color: ColorConstants.GREY_3,
                                                  size: 11),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(left: 8.0),
                                              child: Text(
                                                '+30.6%',
                                                style: Styles.regular(
                                                    color: ColorConstants.GREEN,
                                                    size: 11),
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_drop_up_outlined,
                                              color: Colors.green,
                                              size: 20,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          )),
                      Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                                color: ColorConstants.List_Color,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                Border.all(color: ColorConstants.List_Color)),
                            margin: EdgeInsets.all(0),
                            // color: Colors.red,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0,
                                        right: 8.0,
                                        top: 8.0,
                                        bottom: 8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Art & Design',
                                          style: Styles.bold(
                                              color: Color(0xff0E1638), size: 12),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "\$59k",
                                              style: Styles.regular(
                                                  color: ColorConstants.GREY_3,
                                                  size: 12),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(left: 8.0),
                                              child: Text(
                                                '+30.6%',
                                                style: Styles.regular(
                                                    color: ColorConstants.GREEN,
                                                    size: 11),
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_drop_up_outlined,
                                              color: Colors.green,
                                              size: 20,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          )),
                      Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                                color: ColorConstants.List_Color,
                                borderRadius: BorderRadius.circular(10),
                                border:
                                Border.all(color: ColorConstants.List_Color)),
                            margin: EdgeInsets.all(8),
                            // color: Colors.red,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0,
                                        right: 8.0,
                                        top: 8.0,
                                        bottom: 8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Art & Design',
                                          style: Styles.bold(
                                              color: Color(0xff0E1638), size: 12),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "\$59k",
                                              style: Styles.regular(
                                                  color: ColorConstants.GREY_3,
                                                  size: 11),
                                            ),
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(left: 8.0),
                                              child: Text(
                                                '+30.6%',
                                                style: Styles.regular(
                                                    color: ColorConstants.GREEN,
                                                    size: 11),
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_drop_up_outlined,
                                              color: Colors.green,
                                              size: 20,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          )),
                    ],
                  ),
                ),

                /*Container(
                  height: 50,
                  margin: EdgeInsets.only(left: 50.0, right: 50.0, top: 20.0, bottom: 10.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
                    gradient:
                    LinearGradient(colors: [
                      ColorConstants.WHITE,
                      ColorConstants.WHITE,]),
                    border: Border.all(color: ColorConstants.GRADIENT_ORANGE),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('View Skill Assessments', style: TextStyle(color: ColorConstants.GRADIENT_ORANGE, fontSize: 14,
                          fontWeight: FontWeight.bold),),

                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(Icons.arrow_forward_ios_rounded,
                          color: ColorConstants.GRADIENT_ORANGE,),
                      )
                    ],
                  ),
                ),*/

                SizedBox(
                  height: 30,
                ),
                CustomOutlineButton(
                  strokeWidth: 2,
                  radius: 50,
                  gradient: LinearGradient(
                    colors: [
                      ColorConstants.GRADIENT_ORANGE,
                      ColorConstants.GRADIENT_RED
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.topRight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                    child: GradientText(
                      'View Skill Assessments',
                      style: Styles.textRegular(size: 14),
                      colors: [
                        ColorConstants.GRADIENT_ORANGE,
                        ColorConstants.GRADIENT_RED,
                      ],
                    ),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          );
        });
  }

  featuredJobsInternships() {
    return Container(
      //decoration: BoxDecoration(color: ColorConstants.WHITE),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Icon(CupertinoIcons.star_fill,
                    color: ColorConstants.YELLOW),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 10,
                  ),
                  child: Text(
                    'Featured Jobs & Internships',
                    style: Styles.bold(color: Color(0xff0E1638)),
                  )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              height: 360,
              child: featuredInternshipsResponse?.data!.length != 0 ?
              ListView.builder(
                  itemCount: featuredInternshipsResponse?.data!.length ,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            NextPageRoute(JobDetailsPage(
                              title: featuredInternshipsResponse?.data![index]!.name,
                              description: featuredInternshipsResponse?.data![index]!.description,
                              location: featuredInternshipsResponse?.data![index]!.location,
                              skillNames: featuredInternshipsResponse?.data![index]!.skillNames,
                              companyName: featuredInternshipsResponse?.data![index]!.organizedBy,
                              domain: featuredInternshipsResponse?.data![index]!.domainName,
                              companyThumbnail: featuredInternshipsResponse?.data![index]!.image,
                              experience: featuredInternshipsResponse?.data![index]!.experience,
                              //jobListDetails: jobList,
                              id: featuredInternshipsResponse?.data![index]!.id,
                              jobStatus: featuredInternshipsResponse?.data![index]!.jobStatus,
                            )));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                            color: ColorConstants.WHITE,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: ColorConstants.List_Color)),
                        margin: EdgeInsets.all(8),
                        // color: Colors.red,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0,
                                    right: 8.0,
                                    top: 15.0,
                                    bottom: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: '${featuredInternshipsResponse?.data![index]!.image}',
                                      width: 100,
                                      height: 50,
                                      errorWidget: (context, url, error) => SvgPicture.asset(
                                        'assets/images/gscore_postnow_bg.svg',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text(
                                        '${featuredInternshipsResponse?.data![index]!.name}',
                                        style: Styles.bold(
                                            color: Color(0xff0E1638), size: 13),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          color: Colors.orange,
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            '${featuredInternshipsResponse?.data![index]!.location}',
                                            style: Styles.regular(
                                                color: ColorConstants.GREY_3,
                                                size: 11),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    /*Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.currency_exchange_outlined,
                                        color: Colors.orange,
                                        size: 18,
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          '100K - 150K LPA',
                                          style: Styles.regular(
                                              color: ColorConstants.GREY_3,
                                              size: 11),
                                        ),
                                      ),
                                    ],
                                  ),*/
                                    Container(
                                      width:
                                      MediaQuery.of(context).size.width * 0.7,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          color: ColorConstants.List_Color,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                              color: ColorConstants.List_Color)),
                                      margin: EdgeInsets.all(8),
                                      // color: Colors.red,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0,
                                            right: 8.0,
                                            top: 10.0,
                                            bottom: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Skills Required',
                                              style: Styles.bold(
                                                  color: ColorConstants.GREY_3,
                                                  size: 13),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    '${featuredInternshipsResponse?.data![index]!.skillNames}',
                                                    maxLines: 2,
                                                    softWrap: true,
                                                    style: Styles.bold(
                                                        color: ColorConstants.BLACK,
                                                        size: 13),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    featuredInternshipsResponse?.data![index]!.jobStatus == null || featuredInternshipsResponse?.data![index]!.jobStatus == "" ? InkWell(
                                      onTap: (){
                                       jobApply(int.parse('${featuredInternshipsResponse?.data![index]!.id}'), 1);
                                       _onLoadingForJob();
                                      },
                                      child: Container(
                                        height: 50,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          gradient: LinearGradient(colors: [
                                            ColorConstants.DASHBOARD_APPLY_COLOR,
                                            ColorConstants.DASHBOARD_APPLY_COLOR,
                                          ]),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text('Apply',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ): Padding(
                                      padding: const EdgeInsets.only(bottom: 20.0),
                                      child: Text('${featuredInternshipsResponse?.data![index]!.jobStatus}', style: Styles.bold(color: Colors.green, size: 14),),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                      ),
                    );
                  }): SizedBox(),
            ),
          )
        ],
      ),
    );
  }

  void _onLoadingForJob() {
     showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 10),
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                new CircularProgressIndicator(
                  color: Colors.blue,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: new Text("Job Apply..."),
                ),
              ],
            ),
          ),
        );
      },
    );
    new Future.delayed(new Duration(seconds: 2), () {
      Navigator.pop(context); //pop dialog
    });
  }

  Widget _buildYourPortfolioCard(Color colorBg, String strTitle, String strDes, String clickType) {
    return Container(
      height: 120,
      margin: const EdgeInsets.only(
          left: SizeConstants.JOB_LEFT_SCREEN_MGN,
          right: SizeConstants.JOB_RIGHT_SCREEN_MGN),
      width: double.infinity,
      child: InkWell(
        onTap: () {
          Navigator.push(context, NextPageRoute(NewPortfolioPage()));
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 9,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$strTitle',
                          style: Styles.bold(
                              size: 16, color: ColorConstants.WHITE)),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text('$strDes', style: Styles.regularWhite()),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(colors: [
          ColorConstants.GRADIENT_ORANGE,
          ColorConstants.GRADIENT_RED,
        ]),
        color: colorBg,
        boxShadow: [
          //  BoxShadow(color: Colors.white, spreadRadius: 3),
        ],
      ),
    );
  }

  skillGapAnalysisWidgets() {
    return Container(
      decoration: BoxDecoration(color: ColorConstants.WHITE),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Image.asset(
                  'assets/images/skill_gap_analysis.png',
                  height: 30.0,
                  width: 30.0,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 10,
                  ),
                  child: Text(
                    'Skill Gap Analysis',
                    style: Styles.bold(color: Color(0xff0E1638)),
                  )),
            ],
          ),
          Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 10,
              ),
              child: Text(
                'Take assessments and analyze your skill-gap to be eligible for jobs',
                style: Styles.regular(color: ColorConstants.GREY_3),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              child: Column(
                children: [
                  Card(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: ColorConstants.GREY,
                          ),
                        ),
                        height: height(context) * 0.15,
                        width: width(context),
                        child: Column(
                          children: [
                            // Image.asset('assets/images/temp/UX_SKILL.png',
                            //     height: 20, width: 20),
                            Row(
                              children: [
                                SvgPicture.asset(
                                    'assets/images/temp/ux_skill.svg'),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, bottom: 8),
                                      child: Text(
                                        "UX Research",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4.0, bottom: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "10/200 ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Assessments Completed",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300),
                                          ),
                                          // SizedBox(
                                          //   width: 4,
                                          // ),
                                          Icon(Icons.arrow_forward_ios_outlined)
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 40.0),
                              child: Row(
                                children: [
                                  ShaderMask(
                                    blendMode: BlendMode.srcIn,
                                    shaderCallback: (Rect bounds) {
                                      return LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: <Color>[
                                            Color(0xfffc7804),
                                            ColorConstants.GRADIENT_RED
                                          ]).createShader(bounds);
                                    },
                                    child: Text(
                                      "Learner",
                                      style: Styles.bold(size: 12),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    height: 10,
                                    width:
                                    MediaQuery.of(context).size.width * 0.4,
                                    decoration: BoxDecoration(
                                        color: ColorConstants.GREY,
                                        borderRadius:
                                        BorderRadius.circular(10)),
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 10,
                                          width: width(context) * 0.15,
                                          // width: MediaQuery.of(context).size.width *
                                          //     0.9 *
                                          //     (
                                          //         //.completion! /
                                          //         100),
                                          decoration: BoxDecoration(
                                              color: Color(
                                                0xfffc7804,
                                              ),
                                              borderRadius:
                                              BorderRadius.circular(10)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  ShaderMask(
                                    blendMode: BlendMode.srcIn,
                                    shaderCallback: (Rect bounds) {
                                      return LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: <Color>[
                                            Color(0xfffc7804),
                                            ColorConstants.GRADIENT_RED
                                          ]).createShader(bounds);
                                    },
                                    child: Text(
                                      "Master",
                                      style: Styles.bold(size: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: ColorConstants.GREY,
                          ),
                        ),
                        //margin: EdgeInsets.only(left: 8, right: 8),
                        height: height(context) * 0.15,
                        // width: width(context) * 2,
                        child: Column(
                          children: [
                            // Image.asset('assets/images/temp/UX_SKILL.png',
                            //     height: 20, width: 20),
                            Row(
                              children: [
                                SvgPicture.asset(
                                    'assets/images/temp/graphic_skill.svg'),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, bottom: 8),
                                      child: Text(
                                        "Graphic Design",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, bottom: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "0/100 ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Assessments Completed",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300),
                                          ),
                                          // SizedBox(
                                          //   width: 10,
                                          // ),
                                          Icon(Icons.arrow_forward_ios_outlined)
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 40.0),
                              child: Row(
                                children: [
                                  ShaderMask(
                                    blendMode: BlendMode.srcIn,
                                    shaderCallback: (Rect bounds) {
                                      return LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: <Color>[
                                            Color(0xfffc7804),
                                            ColorConstants.GRADIENT_RED
                                          ]).createShader(bounds);
                                    },
                                    child: Text(
                                      "Learner",
                                      style: Styles.bold(size: 12),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    height: 10,
                                    width:
                                    MediaQuery.of(context).size.width * 0.4,
                                    decoration: BoxDecoration(
                                        color: ColorConstants.GREY,
                                        borderRadius:
                                        BorderRadius.circular(10)),
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 10,
                                          width: width(context) * 0.0,
                                          // width: MediaQuery.of(context).size.width *
                                          //     0.9 *
                                          //     (
                                          //         //.completion! /
                                          //         100),
                                          decoration: BoxDecoration(
                                              color: Color(
                                                0xfffc7804,
                                              ),
                                              borderRadius:
                                              BorderRadius.circular(10)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  ShaderMask(
                                    blendMode: BlendMode.srcIn,
                                    shaderCallback: (Rect bounds) {
                                      return LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: <Color>[
                                            Color(0xfffc7804),
                                            ColorConstants.GRADIENT_RED
                                          ]).createShader(bounds);
                                    },
                                    child: Text(
                                      "Master",
                                      style: Styles.bold(size: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: ColorConstants.GREY,
                          ),
                        ),
                        //margin: EdgeInsets.only(left: 8, right: 8),
                        height: height(context) * 0.15,
                        // width: width(context) * 2,
                        child: Column(
                          children: [
                            // Image.asset('assets/images/temp/UX_SKILL.png',
                            //     height: 20, width: 20),
                            Row(
                              children: [
                                SvgPicture.asset(
                                    'assets/images/temp/animation_skill.svg'),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, bottom: 8),
                                      child: Text(
                                        "Animation",
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4.0, bottom: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "4/200 ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            "Assessments Completed",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300),
                                          ),
                                          // SizedBox(
                                          //   width: 10,
                                          // ),
                                          Icon(Icons.arrow_forward_ios_outlined)
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left: 40.0),
                              child: Row(
                                children: [
                                  ShaderMask(
                                    blendMode: BlendMode.srcIn,
                                    shaderCallback: (Rect bounds) {
                                      return LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: <Color>[
                                            Color(0xfffc7804),
                                            ColorConstants.GRADIENT_RED
                                          ]).createShader(bounds);
                                    },
                                    child: Text(
                                      "Learner",
                                      style: Styles.bold(size: 12),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    height: 10,
                                    width:
                                    MediaQuery.of(context).size.width * 0.4,
                                    decoration: BoxDecoration(
                                        color: ColorConstants.GREY,
                                        borderRadius:
                                        BorderRadius.circular(10)),
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 10,
                                          width: width(context) * 0.05,
                                          // width: MediaQuery.of(context).size.width *
                                          //     0.9 *
                                          //     (
                                          //         //.completion! /
                                          //         100),
                                          decoration: BoxDecoration(
                                              color: Color(
                                                0xfffc7804,
                                              ),
                                              borderRadius:
                                              BorderRadius.circular(10)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  ShaderMask(
                                    blendMode: BlendMode.srcIn,
                                    shaderCallback: (Rect bounds) {
                                      return LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: <Color>[
                                            Color(0xfffc7804),
                                            ColorConstants.GRADIENT_RED
                                          ]).createShader(bounds);
                                    },
                                    child: Text(
                                      "Master",
                                      style: Styles.bold(size: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          CustomOutlineButton(
            strokeWidth: 2,
            radius: 50,
            gradient: LinearGradient(
              colors: [
                ColorConstants.GRADIENT_ORANGE,
                ColorConstants.GRADIENT_RED
              ],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 50.0),
              child: GradientText(
                'View all Skill',
                style: Styles.textRegular(size: 14),
                colors: [
                  ColorConstants.GRADIENT_ORANGE,
                  ColorConstants.GRADIENT_RED,
                ],
              ),
            ),
            onPressed: () {},
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  competitionsWidgets() {
    return Container(
      decoration: BoxDecoration(color: ColorConstants.WHITE),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: SvgPicture.asset(
                  'assets/images/selected_competition.svg',
                  height: 30.0,
                  width: 30.0,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 10,
                  ),
                  child: Text(
                    'Competitions',
                    style: Styles.bold(color: Color(0xff0E1638)),
                  )),
            ],
          ),
          Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 10,
              ),
              child: Text(
                'Participate and add to your portfolio Participate and add to your portfolio',
                style: Styles.regular(color: ColorConstants.GREY_3),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: competitionResponse?.data?.length != null
                ? ListView.builder(
                itemCount: (competitionResponse?.data?.length)! < 4
                    ? competitionResponse?.data?.length
                    : 4,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    CompetitionDetail(
                                        competition: competitionResponse
                                            ?.data?[index])));
                      },
                      child: renderCompetitionCard(
                          '${competitionResponse?.data![index]?.image}',
                          '${competitionResponse?.data![index]?.name}',
                          '',
                          '${competitionResponse?.data![index]?.competitionLevel ?? "Easy"}',
                          '${competitionResponse?.data![index]?.gScore}',
                          '${Utility.ordinalDate(dateVal: "${competitionResponse?.data![index]?.endDate}")}'));
                })
                : CompetitionBlankPage(),
          ),
          SizedBox(
            height: 10,
          ),
          competitionResponse?.data?.length != null
              ? CustomOutlineButton(
            strokeWidth: 2,
            radius: 50,
            gradient: LinearGradient(
              colors: [
                ColorConstants.GRADIENT_ORANGE,
                ColorConstants.GRADIENT_RED
              ],
              begin: Alignment.topLeft,
              end: Alignment.topRight,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 50.0),
              child: GradientText(
                'View all Skill',
                style: Styles.textRegular(size: 14),
                colors: [
                  ColorConstants.GRADIENT_ORANGE,
                  ColorConstants.GRADIENT_RED,
                ],
              ),
            ),
            onPressed: () {
              menuProvider?.updateCurrentIndex('/g-competitions');
            },
          )
              : SizedBox(),
          competitionResponse?.data?.length != null
              ? SizedBox(
            height: 20,
          )
              : SizedBox(),
        ],
      ),
    );
  }

  //TODO:Competition Widgets
  renderCompetitionCard(String competitionImg, String name, String companyName,
      String difficulty, String gScore, String date) {
    return Container(
      height: 90,
      width: double.infinity,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: ColorConstants.WHITE,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: Row(children: [
        SizedBox(
          width: 70,
          height: 90,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: competitionImg,
              width: 100,
              height: 120,
              errorWidget: (context, url, error) => SvgPicture.asset(
                'assets/images/gscore_postnow_bg.svg',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: width(context) * 0.6,
              child: Text(
                name,
                style: Styles.bold(size: 14),
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              height: 2,
            ),
            Row(
              children: [
                Text('Conducted by ',
                    style: Styles.regular(size: 10, color: Color(0xff929BA3))),
                Text(
                  companyName,
                  style: Styles.semibold(size: 12),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xff0E1638),
                ),
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Text('Easy',
                    style: Styles.regular(
                        color: ColorConstants.GREEN_1, size: 12)),
                SizedBox(
                  width: 4,
                ),
                Text('•',
                    style:
                    Styles.regular(color: ColorConstants.GREY_2, size: 12)),
                SizedBox(
                  width: 4,
                ),
                SizedBox(
                    height: 15, child: Image.asset('assets/images/coin.png')),
                SizedBox(
                  width: 4,
                ),
                Text('$gScore Points',
                    style: Styles.regular(
                        color: ColorConstants.ORANGE_4, size: 12)),
                SizedBox(
                  width: 4,
                ),
                Text('•',
                    style:
                    Styles.regular(color: ColorConstants.GREY_2, size: 12)),
                SizedBox(
                  width: 4,
                ),
                Icon(
                  Icons.calendar_month,
                  size: 20,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  date,
                  style: Styles.regular(size: 12, color: Color(0xff5A5F73)),
                )
              ],
            )
          ],
        ),
      ]),
    );
  }

  //skill_gap_analysis.png
  renderWidgets(pages) {
    return ValueListenableBuilder(
        valueListenable: Hive.box(DB.CONTENT).listenable(),
        builder: (bc, Box box, child) {
          if (box.get("getDashboardIsVisible") == null) {
            // return CustomProgressIndicator(true, Colors.white);
            //return Text('lading');
            return BlankPage();
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
            //return Text('Loading singh');
            return BlankPage();
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
            //return Text('lading');
            return BlankPage();
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
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Resume Learning',
                          style: Styles.bold(
                            color: Color(0xff0E1638),
                          ),
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
                                    width:
                                    MediaQuery.of(context).size.width * 0.8,
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    decoration: BoxDecoration(
                                        color: ColorConstants.GREY
                                            .withOpacity(0.6),
                                        borderRadius:
                                        BorderRadius.circular(15)),
                                    child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        // mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 60,
                                                height: 60,
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                    '${courseList1?[index].image}',
                                                    width: 60,
                                                    height: 60,
                                                    errorWidget:
                                                        (context, url, error) =>
                                                        SvgPicture.asset(
                                                          'assets/images/gscore_postnow_bg.svg',
                                                        ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Flexible(
                                                child: Text(
                                                    '${myCoursesList![index].name}',
                                                    maxLines: 2,
                                                    overflow:
                                                    TextOverflow.ellipsis,
                                                    softWrap: true,
                                                    style:
                                                    Styles.bold(size: 14)),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '${myCoursesList![index].completion.toString().split('.').first}% ${Strings.of(context)?.Completed}',
                                                  style:
                                                  Styles.regular(size: 12)),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Container(
                                                height: 10,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    0.57,
                                                decoration: BoxDecoration(
                                                    color: ColorConstants.GREY,
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10)),
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      height: 10,
                                                      width: MediaQuery.of(
                                                          context)
                                                          .size
                                                          .width *
                                                          0.8 *
                                                          (myCoursesList![index]
                                                              .completion! /
                                                              100),
                                                      decoration: BoxDecoration(
                                                          color: ColorConstants
                                                              .PROGESSBAR_TEAL,
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              10)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          //         SizedBox(height: 10),
                                          //         Row(
                                          //           mainAxisAlignment:
                                          //               MainAxisAlignment.end,
                                          //           children: [
                                          //             Container(
                                          //               height: 10,
                                          //               width: MediaQuery.of(context)
                                          //                       .size
                                          //                       .width *
                                          //                   0.5,
                                          //               decoration: BoxDecoration(
                                          //                   color: ColorConstants.GREY,
                                          //                   borderRadius:
                                          //                       BorderRadius.circular(10)),
                                          //               child: Stack(
                                          //                 children: [
                                          //                   Container(
                                          //                     height: 10,
                                          //                     width: MediaQuery.of(context)
                                          //                             .size
                                          //                             .width *
                                          //                         0.8 *
                                          //                         (myCoursesList![index]
                                          //                                 .completion! /
                                          //                             100),
                                          //                     decoration: BoxDecoration(
                                          //                         color: ColorConstants
                                          //                             .PROGESSBAR_TEAL,
                                          //                         borderRadius:
                                          //                             BorderRadius.circular(
                                          //                                 10)),
                                          //                   ),
                                          //                 ],
                                          //               ),
                                          //             ),
                                          //           ],
                                          //         ),
                                          //       ]),
                                          //      )
                                          //     ),
                                          // ],
                                        ])))
                          ]);
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
            //return Text('lading');
            return BlankPage();
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
              .map((e) =>
              DashboardReelsLimit.fromJson(Map<String, dynamic>.from(e)))
              .cast<DashboardReelsLimit>()
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
            //return Text('lading');
            return BlankPage();
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
            //return Text('lading');
            return BlankPage();
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
              .map((e) =>
              DashboardCarvanLimit.fromJson(Map<String, dynamic>.from(e)))
              .cast<DashboardCarvanLimit>()
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

  //TODO: Now used for recent community post------
  renderCarvaanPageView() {
    return ValueListenableBuilder(
        valueListenable: Hive.box(DB.CONTENT).listenable(),
        builder: (bc, Box box, child) {
          if (box.get("dashboard_carvan_limit") == null) {
            //return Text('lading');
            return BlankPage();
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
              .map((e) =>
              DashboardCarvanLimit.fromJson(Map<String, dynamic>.from(e)))
              .cast<DashboardCarvanLimit>()
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
                    height: 480,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: carvaanList?.length,
                      onPageChanged: (page) {
                        setState(() {
                          selectedPage = page;
                        });
                      },
                      itemBuilder: (BuildContext context, int index) {
                        final now = DateTime.now();

                        var millis =
                        int.parse(carvaanList![index].createdAt.toString());
                        DateTime date = DateTime.fromMillisecondsSinceEpoch(
                          millis * 1000,
                        );

                        return Container(
                          width: MediaQuery.of(context).size.width * 0.8,

                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: ColorConstants.GREY_4)),
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
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                              errorBuilder: (context, url, error) {
                                                return SvgPicture.asset(
                                                  'assets/images/default_user.svg',
                                                  height: 30,
                                                  width: 30,
                                                  allowDrawingOutsideViewBox: true,
                                                );
                                              },
                                              loadingBuilder: (BuildContext context,
                                                  Widget child,
                                                  ImageChunkEvent?
                                                  loadingProgress) {
                                                if (loadingProgress == null)
                                                  return child;
                                                return Shimmer.fromColors(
                                                  baseColor: Color(0xffe6e4e6),
                                                  highlightColor: Color(0xffeaf0f3),
                                                  child: Container(
                                                      height: 50,
                                                      margin:
                                                      EdgeInsets.only(left: 2),
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
                                                carvaanList?[index].name ?? '',
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
                                                        .substring(0, 19)),
                                                    now,
                                                    context),
                                                style: Styles.regular(size: 12),
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
                                    carvaanList?[index].description != null
                                        ? const EdgeInsets.only(
                                        bottom: 7, left: 10, top: 13)
                                        : const EdgeInsets.only(
                                        bottom: 0, left: 10, top: 0),
                                    child: ReadMoreText(
                                        text:
                                        '${carvaanList?[index].description ?? ''}')),

                                carvaanList?[index]
                                    .resourcePath
                                    ?.contains('.mp4') ==
                                    true ||
                                    carvaanList?[index]
                                        .resourcePath
                                        ?.contains('.mov') ==
                                        true
                                // ? CustomBetterPlayer(
                                //     url: widget.fileList[index])
                                    ? Container(
                                    height: 300,
                                    child: FlickVideoPlayer(
                                        flickManager: FlickManager(
                                          videoPlayerController:
                                          VideoPlayerController.network(
                                            '${carvaanList?[index].resourcePath}',),
                                        )))

                                    : Image.network(
                                    '${carvaanList?[index].resourcePath}',
                                    height: 300,
                                    width: double.infinity,
                                    fit: BoxFit.fitWidth),

                                //TODO: Like Dislike
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 10.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          setState(() {});
                                        },
                                        child: Container(
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 4.0,
                                                ),
                                                child: SvgPicture.asset(
                                                  'assets/images/like_icon.svg',
                                                  height: 18.8,
                                                  width: 17.86,
                                                  color: ColorConstants.BLACK,
                                                ),
                                              ),
                                              Text(
                                                carvaanList?[index].likeCount !=
                                                    0
                                                    ? '${carvaanList?[index].likeCount} ${Strings.of(context)?.Like}'
                                                    : ' ${Strings.of(context)?.Like}',
                                                style: Styles.regular(
                                                    size: 12,
                                                    color:
                                                    ColorConstants.BLACK),
                                              ),
                                              /*if (widget.value?.getLikeCount(widget.index) != 0 &&
                                                widget.value?.getLikeCount(widget.index) != 1 &&
                                                Preference.getInt(Preference.APP_LANGUAGE) == 1)
                                              Text(
                                                Preference.getInt(Preference.APP_LANGUAGE) == 1
                                                    ? 's'
                                                    : '',
                                                style: Styles.regular(
                                                    size: 12, color: ColorConstants.BLACK),
                                              )*/
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              backgroundColor:
                                              ColorConstants.WHITE,
                                              isScrollControlled: true,
                                              builder: (context) {
                                                return FractionallySizedBox(
                                                  heightFactor: 0.7,
                                                  child: CommentViewPage(
                                                    postId:
                                                    carvaanList?[index].id,
                                                    //value: widget.value,
                                                  ),
                                                );
                                              });
                                        },
                                        child: Container(
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 4.0,
                                                ),
                                                child: SvgPicture.asset(
                                                  'assets/images/comment_icon.svg',
                                                  height: 18.8,
                                                  width: 17.86,
                                                  allowDrawingOutsideViewBox:
                                                  true,
                                                ),
                                              ),
                                              Text(
                                                carvaanList?[index]
                                                    .commentCount !=
                                                    0
                                                    ? '${carvaanList?[index].commentCount} ${Strings.of(context)?.Comment}'
                                                    : ' ${Strings.of(context)?.Comment}',
                                                style: Styles.regular(
                                                    size: 12,
                                                    color:
                                                    ColorConstants.BLACK),
                                              ),
                                              /*if (carvaanList?[index].commentCount! > 1 &&
                                                Preference.getInt(Preference.APP_LANGUAGE) == 1)
                                              Text(
                                                Preference.getInt(Preference.APP_LANGUAGE) == 1
                                                    ? 's'
                                                    : '',
                                                style: Styles.regular(
                                                    size: 12, color: ColorConstants.BLACK),
                                              )*/
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          //Share.share('${widget.image_path}');
                                        },
                                        child: Container(
                                          child: Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 4.0,
                                                ),
                                                child: SvgPicture.asset(
                                                  'assets/images/share_icon.svg',
                                                  height: 18.8,
                                                  width: 17.86,
                                                  allowDrawingOutsideViewBox:
                                                  true,
                                                ),
                                              ),
                                              Text(
                                                '${Strings.of(context)?.Share}',
                                                style: Styles.regular(
                                                    size: 12,
                                                    color:
                                                    ColorConstants.BLACK),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ]),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                _dots(selectedPage, carvaanList?.length as int),
                SizedBox(
                  height: 20.0,
                )
              ],
            ),
          );
        });
  }

  _dots(int index, int postCount) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DotsIndicator(
          dotsCount: postCount,
          position: index.toDouble(),
          decorator: DotsDecorator(
            size: const Size.square(8.0),
            color: Color(0xffCCCACA),
            spacing: const EdgeInsets.only(left: 5.0),
            activeColor: ColorConstants.GRADIENT_ORANGE,
            activeSize: const Size(22.0, 8.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
      ],
    );
  }

  renderFeaturedContentLimit() {
    return ValueListenableBuilder(
      valueListenable: Hive.box(DB.CONTENT).listenable(),
      builder: (bc, Box box, child) {
        if (box.get("dashboard_featured_content_limit") == null) {
          // return CustomProgressIndicator(true, Colors.white);
          //return Text('lading');
          return BlankPage();
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
                      //menuProvider?.updateCurrentIndex('1'); //Gcarva page
                      showModalBottomSheet(
                          context: context,
                          backgroundColor: ColorConstants.WHITE,
                          isScrollControlled: true,
                          builder: (context) {
                            return FractionallySizedBox(
                              heightFactor: 1.0,
                              child: ViewWidgetDetailsPage(
                                root: 'dashboard',
                              ),
                            );
                          });
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
                          showModalBottomSheet(
                              context: context,
                              backgroundColor: ColorConstants.WHITE,
                              isScrollControlled: true,
                              builder: (context) {
                                return FractionallySizedBox(
                                  heightFactor: 1.0,
                                  /*child: ViewWidgetDetailsPage(
                                      joyContentList: featuredContentList
                                          as List<JoyContentListElement>,
                                      currentIndex: index,
                                    ),*/
                                  child: ViewWidgetDetailsPage(
                                    currentID: featuredContentList![index].id,
                                    root: 'dashboard',
                                  ),
                                );
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
                                            imageUrl:
                                            '${featuredContentList![index].resourcePathThumbnail}',
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

class BlankPage extends StatelessWidget {
  const BlankPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 10.0, top: 15.0, right: 10.0, bottom: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 9,
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 5.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Color(0xffe6e4e6),
                          highlightColor: Color(0xffeaf0f3),
                          child: Container(
                              height: 150,
                              margin: EdgeInsets.only(left: 2),
                              width: 190,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 5.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Color(0xffe6e4e6),
                          highlightColor: Color(0xffeaf0f3),
                          child: Container(
                              height: 150,
                              margin: EdgeInsets.only(left: 2),
                              width: 190,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 10.0, top: 15.0, right: 10.0, bottom: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.only(
                      right: 10.0,
                    ),
                    child: Image.asset('assets/images/blank.png'),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 5.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Color(0xffe6e4e6),
                          highlightColor: Color(0xffeaf0f3),
                          child: Container(
                              height: 13,
                              margin: EdgeInsets.only(left: 2),
                              width: 190,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Shimmer.fromColors(
                            baseColor: Color(0xffe6e4e6),
                            highlightColor: Color(0xffeaf0f3),
                            child: Container(
                                height: 13,
                                margin: EdgeInsets.only(left: 2),
                                width: 160,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: [
                              Shimmer.fromColors(
                                baseColor: Color(0xffe6e4e6),
                                highlightColor: Color(0xffeaf0f3),
                                child: Container(
                                    height: 13,
                                    margin: EdgeInsets.only(left: 2),
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Shimmer.fromColors(
                                  baseColor: Color(0xffe6e4e6),
                                  highlightColor: Color(0xffeaf0f3),
                                  child: Container(
                                      height: 13,
                                      margin: EdgeInsets.only(left: 2),
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 1,
          color: ColorConstants.GREY_3,
        ),
        Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 10.0, top: 15.0, right: 10.0, bottom: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.only(
                      right: 10.0,
                    ),
                    child: Image.asset('assets/images/blank.png'),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 5.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Color(0xffe6e4e6),
                          highlightColor: Color(0xffeaf0f3),
                          child: Container(
                              height: 13,
                              margin: EdgeInsets.only(left: 2),
                              width: 190,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Shimmer.fromColors(
                            baseColor: Color(0xffe6e4e6),
                            highlightColor: Color(0xffeaf0f3),
                            child: Container(
                                height: 13,
                                margin: EdgeInsets.only(left: 2),
                                width: 160,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: [
                              Shimmer.fromColors(
                                baseColor: Color(0xffe6e4e6),
                                highlightColor: Color(0xffeaf0f3),
                                child: Container(
                                    height: 13,
                                    margin: EdgeInsets.only(left: 2),
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Shimmer.fromColors(
                                  baseColor: Color(0xffe6e4e6),
                                  highlightColor: Color(0xffeaf0f3),
                                  child: Container(
                                      height: 13,
                                      margin: EdgeInsets.only(left: 2),
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 10.0, top: 30.0, right: 10.0, bottom: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 9,
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 5.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Color(0xffe6e4e6),
                          highlightColor: Color(0xffeaf0f3),
                          child: Container(
                              height: 150,
                              margin: EdgeInsets.only(left: 2),
                              width: 190,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 5.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Color(0xffe6e4e6),
                          highlightColor: Color(0xffeaf0f3),
                          child: Container(
                              height: 150,
                              margin: EdgeInsets.only(left: 2),
                              width: 190,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 10.0, top: 15.0, right: 10.0, bottom: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.only(
                      right: 10.0,
                    ),
                    child: Image.asset('assets/images/blank.png'),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 5.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Color(0xffe6e4e6),
                          highlightColor: Color(0xffeaf0f3),
                          child: Container(
                              height: 13,
                              margin: EdgeInsets.only(left: 2),
                              width: 190,
                              decoration: BoxDecoration(
                                color: Colors.white,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Shimmer.fromColors(
                            baseColor: Color(0xffe6e4e6),
                            highlightColor: Color(0xffeaf0f3),
                            child: Container(
                                height: 13,
                                margin: EdgeInsets.only(left: 2),
                                width: 160,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Row(
                            children: [
                              Shimmer.fromColors(
                                baseColor: Color(0xffe6e4e6),
                                highlightColor: Color(0xffeaf0f3),
                                child: Container(
                                    height: 13,
                                    margin: EdgeInsets.only(left: 2),
                                    width: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    )),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Shimmer.fromColors(
                                  baseColor: Color(0xffe6e4e6),
                                  highlightColor: Color(0xffeaf0f3),
                                  child: Container(
                                      height: 13,
                                      margin: EdgeInsets.only(left: 2),
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CompetitionBlankPage extends StatelessWidget {
  const CompetitionBlankPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 90,
          width: double.infinity,
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: ColorConstants.WHITE,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: const Offset(5, 5),
              ),
            ],
          ),
          child: Row(children: [
            Shimmer.fromColors(
              baseColor: Color(0xffe6e4e6),
              highlightColor: Color(0xffeaf0f3),
              child: Container(
                  height: 80,
                  margin: EdgeInsets.only(left: 2),
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  )),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Color(0xffe6e4e6),
                  highlightColor: Color(0xffeaf0f3),
                  child: Container(
                      height: 12,
                      margin: EdgeInsets.only(left: 2),
                      width: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      )),
                ),
                SizedBox(
                  height: 7,
                ),
                Row(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Color(0xffe6e4e6),
                      highlightColor: Color(0xffeaf0f3),
                      child: Container(
                          height: 12,
                          margin: EdgeInsets.only(left: 2),
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          )),
                    ),
                    Shimmer.fromColors(
                      baseColor: Color(0xffe6e4e6),
                      highlightColor: Color(0xffeaf0f3),
                      child: Container(
                          height: 12,
                          margin: EdgeInsets.only(left: 2),
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 7,
                ),
                Row(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Color(0xffe6e4e6),
                      highlightColor: Color(0xffeaf0f3),
                      child: Container(
                          height: 12,
                          margin: EdgeInsets.only(left: 2),
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          )),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Shimmer.fromColors(
                      baseColor: Color(0xffe6e4e6),
                      highlightColor: Color(0xffeaf0f3),
                      child: Container(
                          height: 12,
                          margin: EdgeInsets.only(left: 2),
                          width: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          )),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Shimmer.fromColors(
                      baseColor: Color(0xffe6e4e6),
                      highlightColor: Color(0xffeaf0f3),
                      child: Container(
                          height: 12,
                          margin: EdgeInsets.only(left: 2),
                          width: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                          )),
                    ),
                  ],
                )
              ],
            ),
          ]),
        ),
      ],
    );
  }
}
