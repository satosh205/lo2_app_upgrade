import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/user_jobs_list_response.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/rounded_appbar.dart';
import 'package:masterg/pages/singularis/app_drawer_page.dart';
import 'package:masterg/pages/singularis/job/job_search_view_page.dart';
import 'package:masterg/pages/singularis/job/my_job_all_view_list_page.dart';
import 'package:masterg/pages/user_profile_page/portfolio_create_form/portfolio_page.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/resource/size_constants.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../../../blocs/bloc_manager.dart';
import '../../../blocs/home_bloc.dart';
import '../../../data/models/response/home_response/competition_response.dart';
import '../../../data/models/response/home_response/domain_filter_list.dart';
import '../../../data/models/response/home_response/domain_list_response.dart';
import '../../../data/models/response/home_response/training_module_response.dart';
import '../../../local/pref/Preference.dart';
import '../../../utils/Styles.dart';
import '../../../utils/utility.dart';
import '../../custom_pages/custom_widgets/NextPageRouting.dart';
import 'job_details_page.dart';
import 'package:masterg/pages/user_profile_page/portfolio_page.dart';


class JobDashboardPage extends StatefulWidget {
  const JobDashboardPage({Key? key}) : super(key: key);

  @override
  State<JobDashboardPage> createState() => _JobDashboardPageState();
}

class _JobDashboardPageState extends State<JobDashboardPage> {
  bool? isJobLoading;
  bool? myJobLoading = true;
  bool? competitionDetailLoading = true;
  bool? domainListLoading = true;
  bool? jobApplyLoading = true;
  //List<ListElement>? jobList;
  CompetitionResponse? myJobResponse, allJobListResponse, recommendedJobOpportunities;
  TrainingModuleResponse? competitionDetail;
  DomainListResponse? domainList;
  DomainFilterListResponse? domainFilterList;
  int? programId;
  int selectedIndex = 0;
  String seletedIds = '';
  List<int> selectedIdList = <int>[];
  int? applied;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool myJobRecall = false;

  @override
  void initState() {
    super.initState();
    //getJobList();
    getMyJobList(false);
    getDomainList();
  }

//OLD API
  /*void getJobList() {
    BlocProvider.of<HomeBloc>(context).add(UserJobsListEvent());
  }*/

  void getMyJobList(bool jobType) {
    BlocProvider.of<HomeBloc>(context).add(
        JobCompListEvent(isPopular: false, isFilter: false, isJob: 1, myJob: 1, jobTypeMyJob: jobType));
  }


  //TODO: Job Apply API Call
  ///TODO: Job get progress and competition instructions Or Job Apply for same API call
  ///pass key for job apply case is_applied=1
  void jobApply(int jobId, int? isApplied) {
    BlocProvider.of<HomeBloc>(context).add(
        CompetitionContentListEvent(competitionId: jobId, isApplied: isApplied));
  }

  ///TODO: Get Job domain
  void getDomainList() {
    BlocProvider.of<HomeBloc>(context).add(DomainListEvent());
  }

 ///TODO:Job Search
  void getFilterList(String ids) {
    BlocProvider.of<HomeBloc>(context).add(DomainFilterListEvent(ids: ids));
  }


  void _handlecompetitionListResponse(JobCompListState state) {
    print('_handlecompetitionListResponse singh');
    var jobCompState = state;
    setState(() {
      switch (jobCompState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          myJobLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("CompetitionState....................");
          if(myJobRecall == false){
            myJobResponse = state.myJobListResponse;
            allJobListResponse = state.jobListResponse;
            recommendedJobOpportunities = state.recommendedJobOpportunities;
          }else{
            myJobResponse = state.myJobListResponse;
          }

          myJobLoading = false;
          break;
        case ApiStatus.ERROR:
          Log.v("Error CompetitionListIDState .....................${jobCompState.error}");
          myJobLoading = false;
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  void handlecompetitionDetailResponse(CompetitionDetailState state) {
    var competitionState = state;
    setState(() {
      switch (competitionState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          competitionDetailLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("Competition Detail State....................");
          competitionDetail = state.response;
          competitionDetailLoading = false;
          break;
        case ApiStatus.ERROR:
          Log.v(
              "Error Competition Detail IDState ..........................${competitionState.error}");
          competitionDetailLoading = false;
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
          domainListLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("popularCompetitionState....................");
          domainList = state.response;
          domainListLoading = false;

          break;
        case ApiStatus.ERROR:
          Log.v(
              "Error Popular CompetitionListIDState ..........................${popularCompetitionState.error}");
          domainListLoading = false;
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }

  ///TODO: Job Apply
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
          myJobRecall = true;
          getMyJobList(true);

          //contentList = competitionState.response;
          /*if(jobApplyLoading == true){
            Utility.showSnackBar(
                scaffoldContext: context, message: 'Your application is successfully submitted.');
          }*/
          jobApplyLoading = false;
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
    return BlocManager(
      initState: (context) {},
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is JobCompListState) {
            _handlecompetitionListResponse(state);
          }
          if (state is CompetitionDetailState) {
            handlecompetitionDetailResponse(state);
          }
          if (state is DomainListState) {
            handleDomainListResponse(state);
          }
          if (state is CompetitionContentListState)
            handleJobApplyState(state);
        },
        child: Scaffold(
          key:  _scaffoldKey,
      endDrawer: new AppDrawer(),

          backgroundColor: ColorConstants.JOB_BG_COLOR,
          body: _makeBody(),
        ),
      ),
    );
  }


  void getCompetitionList(bool isFilter, String? ids) {
    BlocProvider.of<HomeBloc>(context).add(
        CompetitionListEvent(isPopular: false, isFilter: isFilter, ids: ids));
  }

  Widget _makeBody() {
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Container(
        margin: EdgeInsets.only(
            // left: SizeConstants.JOB_LEFT_SCREEN_MGN,
            // top: SizeConstants.JOB_TOP_SCREEN_MGN,
            // right: SizeConstants.JOB_RIGHT_SCREEN_MGN,
            bottom: SizeConstants.JOB_BOTTOM_SCREEN_MGN),
        width: MediaQuery.of(context).size.width,
        child: MultiProvider(
        providers: [
          ChangeNotifierProvider<CompetitionResponseProvider>(
            create: (context) => CompetitionResponseProvider(allJobListResponse?.data),
          ),
         
        ],
        child: Column(
          children: [
            _customAppBar(),

            ///Search Job
            SizedBox(
              height: height(context) * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: SizeConstants.JOB_LEFT_SCREEN_MGN,
                  right: SizeConstants.JOB_RIGHT_SCREEN_MGN),
              child: _searchFilter(),
            ),

            ///My Job Section
            myJobResponse?.data != null ? SizedBox(
              height: 15,
            ):SizedBox(),
            myJobResponse?.data != null ? _myJobSectionCard() : SizedBox(),

            ///Complete Profile
            SizedBox(
              height: 30,
            ),
            _highLightsCard(
                ColorConstants.HIGH_LIGHTS_CARD_COLOR1,
                'Complete Your Profile & Get Noticed!',
                'Profiles with Photo, Headlines and Summary bring Recruiters instant attention.',
                'complete_profile'),

            ///Jobs based Profile
            SizedBox(
              height: 30,
            ),
            //jobList != null ? _jobBasedYourListCard() : BlankPage(),
            myJobLoading == false ? _jobBasedYourListCard() : BlankPage(),

            ///Recommended Opportunities
            recommendedJobOpportunities?.data != null ?
            _recommendedOpportunitiesListCard(): BlankPage(),

            SizedBox(
              height: 30,
            ),
            allJobListResponse?.data != null ?
            _step2Card()
                : BlankPage(),

            ///Build Your Portfolio
            SizedBox(
              height: 30,
            ),
            _highLightsCard(
                ColorConstants.ORANGE,
                'Build Your Portfolio',
                'Creating a Portfolio helps the recruiters to understand better about your profile and your skills.',
                'build_portfolio'),

            ///Recommended Jobs
            SizedBox(
              height: 30,
            ),
            //myJobLoading == false ? _recommendedJobsListCard() : BlankPage(),
            //allJobListResponse?.data != null ? _recommendedJobsListCard() : BlankPage(),
            allJobListResponse?.data != null ?
            _step3Card() : BlankPage(),

          ],
        ),
      ),
    ));
  }

  Widget _customAppBar() {
    return RoundedAppBar(
        appBarHeight: height(context) * 0.1,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Column(
                mainAxisAlignment:
                MainAxisAlignment.start,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    mainAxisAlignment:
                    MainAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      NewPortfolioPage()));
                        },
                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(
                              200),
                          child: SizedBox(
                            width: 40,
                            child: Image.network(
                                '${Preference.getString(Preference.PROFILE_IMAGE)}'),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                       Spacer(),
                            InkWell(
                              onTap: () {
                                _scaffoldKey.currentState?.openEndDrawer();
                              },
                              child: SvgPicture.asset(
                                  'assets/images/hamburger_menu.svg'),
                            )
                      // Column(
                      //   crossAxisAlignment:
                      //   CrossAxisAlignment.start,
                      //   children: [
                      //     Container(
                      //       height: 5,
                      //       width:
                      //       MediaQuery.of(context)
                      //           .size
                      //           .width *
                      //           0.5,
                      //       decoration: BoxDecoration(
                      //           color: ColorConstants
                      //               .WHITE
                      //               .withOpacity(0.2),
                      //           borderRadius:
                      //           BorderRadius
                      //               .circular(10)),
                      //       child: Stack(
                      //         children: [
                      //           Container(
                      //             height: 10,
                      //             width: MediaQuery.of(
                      //                 context)
                      //                 .size
                      //                 .width *
                      //                 0.6 *
                      //                 (30 / 100),
                      //             decoration: BoxDecoration(
                      //                 color: Color(
                      //                     0xffFFB72F),
                      //                 borderRadius:
                      //                 BorderRadius
                      //                     .circular(
                      //                     10)),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     SizedBox(height: 8),
                      //     Text(
                      //         'Profile completed: 30% ',
                      //         style: Styles
                      //             .semiBoldWhite())
                        // ],
                      // ),
                    ],
                  ),
                ])));
  }

  Widget _searchFilter() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 9,
            child: Container(
              child: Text(
                'Find Relevant Jobs'
              ),
            ),
            /*child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    NextPageRoute(JobSearchViewPage(
                      appBarTitle: 'Search',
                      isSearchMode: true,
                    )));
              },
              child: Container(
                height: 40,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_rounded,
                        size: 28,
                      ),
                      Text('Search Jobs'),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.white, spreadRadius: 3),
                  ],
                ),
              ),
            ),*/
          ),

          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () async{
                getFilterList(domainList!.data!.list[0].id.toString());

                await showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (context) {
                  return StatefulBuilder(builder:
                      (BuildContext context,
                      setState) {
                    void
                    handleDomainFilterListResponse(
                        DomainFilterListState
                        state) {
                      var popularCompetitionState =
                          state;
                      setState(() {
                        switch (
                        popularCompetitionState
                            .apiState) {
                          case ApiStatus.LOADING:
                            Log.v(
                                "Loading....................");
                            domainListLoading =
                            true;
                            break;
                          case ApiStatus.SUCCESS:
                            Log.v(
                                "Filter list State....................");
                            domainFilterList =
                                state.response;
                            domainListLoading =
                            false;
                            setState(() {});

                            break;
                          case ApiStatus.ERROR:
                            Log.v(
                                "Filter list CompetitionListIDState ..........................${popularCompetitionState.error}");
                            domainListLoading =
                            false;
                            break;
                          case ApiStatus.INITIAL:
                            break;
                        }
                      });
                    }

                    return BlocListener<HomeBloc,
                        HomeState>(
                        listener: (context, state) {
                          if (state
                          is DomainFilterListState) {
                            handleDomainFilterListResponse(
                                state);
                          }
                        },
                        child: FractionallySizedBox(
                          heightFactor: 0.7,
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: ColorConstants
                                    .WHITE,
                                borderRadius:
                                BorderRadius.only(
                                    topLeft: Radius
                                        .circular(
                                        12),
                                    topRight: Radius
                                        .circular(
                                        8))),
                            child:
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: [
                                  Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: ColorConstants
                                              .GREY_4,
                                          borderRadius:
                                          BorderRadius.circular(
                                              8)),
                                      width: 48,
                                      height: 5,
                                      margin: EdgeInsets
                                          .only(
                                          top: 8),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets
                                        .symmetric(
                                        horizontal:
                                        8,
                                        vertical:
                                        4),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Filter by',
                                          style: Styles
                                              .semibold(
                                              size:
                                              16),
                                        ),
                                        Spacer(),
                                        IconButton(
                                            onPressed: () {
                                              this.setState(() {
                                                seletedIds = '0';
                                                selectedIdList.clear();
                                              });
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(Icons.close))
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color:
                                    ColorConstants
                                        .GREY_4,
                                  ),
                                  Padding(
                                    padding: EdgeInsets
                                        .symmetric(
                                        horizontal:
                                        8,
                                        vertical:
                                        4),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal:
                                                10,
                                                vertical:
                                                4),
                                            child:
                                            Text(
                                              'Domain',
                                              style: Styles.bold(
                                                  size:
                                                  14),
                                            )),
                                        Container(
                                          child: Wrap(
                                            direction:
                                            Axis.horizontal,
                                            children: List.generate(
                                                domainList!.data!.list.length,
                                                    (i) => InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedIndex = i;
                                                      seletedIds = '';
                                                      selectedIdList = [];
                                                    });
                                                    getFilterList(domainList!.data!.list[i].id.toString());
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 10, right: 5),
                                                    child: Chip(
                                                      backgroundColor: i == selectedIndex ? ColorConstants.GREEN : Color(0xffF2F2F2),
                                                      label: Container(
                                                        child: Text(
                                                          '${domainList!.data!.list[i].name}',
                                                          style: Styles.semibold(size: 12, color: i == selectedIndex ? ColorConstants.WHITE : ColorConstants.BLACK),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal:
                                                10,
                                                vertical:
                                                4),
                                            child:
                                            Text(
                                              'Job Roles',
                                              style: Styles.bold(
                                                  size:
                                                  14),
                                            )),
                                        if (domainFilterList != null)
                                          Container(
                                            child:
                                            Wrap(
                                              direction:
                                              Axis.horizontal,
                                              children: List.generate(
                                                  domainFilterList!.data!.list.length,
                                                      (i) => InkWell(
                                                    onTap: () {
                                                      //seletedIds += domainFilterList!.data!.list[i].id.toString() + ',';
                                                      if (selectedIdList.contains(domainFilterList!.data!.list[i].id)) {
                                                        selectedIdList.remove(domainFilterList!.data!.list[i].id);
                                                      } else {
                                                        selectedIdList.add(domainFilterList!.data!.list[i].id);
                                                      }
                                                      print(selectedIdList);
                                                      setState(() {});
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 10, right: 5),
                                                      child: Chip(
                                                        backgroundColor: selectedIdList.contains(domainFilterList!.data!.list[i].id) ? ColorConstants.GREEN : Color(0xffF2F2F2),
                                                        label: Container(
                                                          child: Text('${domainFilterList!.data!.list[i].title}',
                                                              style: Styles.regular(
                                                                size: 12,
                                                                color: selectedIdList.contains(domainFilterList!.data!.list[i].id) ? ColorConstants.WHITE : ColorConstants.BLACK,
                                                              )),
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                            ),
                                          ),

                                        InkWell(
                                          onTap: (){
                                            print('Search  Jobs');
                                            print(seletedIds);
                                            print(selectedIdList);
                                            seletedIds = selectedIdList.toString().replaceAll("[", "").replaceAll("]", "");
                                            print(seletedIds);
                                            Navigator.push(
                                                context,
                                                NextPageRoute(
                                                    JobSearchViewPage(
                                                      appBarTitle: 'Search Jobs',
                                                      isSearchMode: false,
                                                      jobRolesId: seletedIds,
                                                    ),
                                                    isMaintainState: true)).then((value) => null);
                                          },
                                          child: Container(
                                            height: 40,
                                            margin: EdgeInsets.only(left: 50, top: 50, right: 50, bottom: 20),
                                            width: MediaQuery.of(context).size.width,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50),
                                              gradient:
                                              LinearGradient(colors: [
                                                ColorConstants.GRADIENT_ORANGE,
                                                ColorConstants.GRADIENT_RED,]),
                                            ),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: Text('Search Jobs',
                                                  style: Styles.regular(size: 13, color: ColorConstants.WHITE,),),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ));
                  });
                });
                //showBottomSheetJobFilter();
              },
              child: Container(
                padding: EdgeInsets.only(left: 10.0),
                child: Icon(
                  Icons.filter_list,
                  color: Colors.black,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _highLightsCard(Color colorBg, String strTitle, String strDes, String clickType) {
    return Container(
      height: 120,
      margin: const EdgeInsets.only(
          left: SizeConstants.JOB_LEFT_SCREEN_MGN,
          right: SizeConstants.JOB_RIGHT_SCREEN_MGN),
      width: double.infinity,
      child: InkWell(
        onTap: () {
          if (clickType == 'build_portfolio') {
          Navigator.push(context, NextPageRoute(NewPortfolioPage()));

          }else if(clickType == 'complete_profile'){
            Navigator.push(context, NextPageRoute(NewPortfolioPage()));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              clickType != 'complete_profile' ?
              Expanded(child: Image.asset('assets/images/build_read.png', height: 40, width: 40,),):
              SizedBox(),
              Expanded(
                flex: 9,
                child: Container(
                  margin: EdgeInsets.only(left: 10.0, top: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$strTitle',
                          style: Styles.bold(
                              size: 16, color: ColorConstants.WHITE)),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text('$strDes', style: Styles.regularWhite()),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(left: 10.0,),
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
        color: colorBg,
        boxShadow: [
          //  BoxShadow(color: Colors.white, spreadRadius: 3),
        ],
      ),
    );
  }

  Widget _myJobSectionCard() {
    return myJobResponse?.data!.length != 0 ? Column(
      children: [
        //SizedBox(height: 30,),
        SizedBox(height: 10,),
        Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: Text('My Jobs',
                    style: Styles.regular(size: 16, color: ColorConstants.BLACK)),
              ),

              InkWell(
                onTap: (){
                  print('View All');
                  Navigator.push(
                      context,
                      NextPageRoute(MyJobAllViewListPage(
                        myJobResponse: myJobResponse,
                      )));
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Text('View All', style: TextStyle(color: Colors.red),),
                ),
              ),
            ],
          ),
        ),

        Divider(
          height: 1,
          color: ColorConstants.GREY_3,
        ),
        Container(
            padding: EdgeInsets.all(10),
            //height: MediaQuery.of(context).size.height * 0.35,
            height: 170,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: ColorConstants.WHITE),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: myJobResponse?.data!.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: (){
                    print('jobStatus==== ${myJobResponse?.data![index]!.jobStatus}');
                    Navigator.push(
                        context,
                        NextPageRoute(JobDetailsPage(
                          title: myJobResponse?.data![index]!.name,
                          description: myJobResponse?.data![index]!.description,
                          location: myJobResponse?.data![index]!.location,
                          skillNames: myJobResponse?.data![index]!.skillNames,
                          companyName: myJobResponse?.data![index]!.organizedBy,
                          domain: myJobResponse?.data![index]!.domainName,
                          companyThumbnail: myJobResponse?.data![index]!.image,
                          experience: myJobResponse?.data![index]!.experience,
                          //jobListDetails: jobList,
                          id: myJobResponse?.data![index]!.id,
                          jobStatus: myJobResponse?.data![index]!.jobStatus,
                        )));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 120,
                        width: MediaQuery.of(context).size.width -100,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: ColorConstants.GREY_4, width: 0.3),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, top: 15.0, right: 10.0, bottom: 15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      padding: EdgeInsets.only(
                                        right: 10.0,
                                      ),
                                      child: myJobResponse?.data![index]!.image != null
                                          ? Image.network('${myJobResponse?.data![index]!.image}', height: 60, width: 80,)
                                          : Image.asset('assets/images/pb_2.png'), height: 60, width: 80,),

                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${myJobResponse?.data![index]!.name}',
                                          style: Styles.bold(size: 14),),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: Text('${myJobResponse?.data![index]!.organizedBy}',
                                              style: TextStyle(color: ColorConstants.GREY_3),),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),

                            myJobResponse?.data![index]!.jobStatus != null ? Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: Text('${myJobResponse?.data![index]!.jobStatus == 'under_review' ?
                              'Application Under Process' :
                              myJobResponse?.data![index]!.jobStatus == 'shortlisted' ?
                              'Application Shortlisted' :
                              myJobResponse?.data![index]!.jobStatus == 'rejected' ?
                              'Unable To Offer You A Position' :
                              myJobResponse?.data![index]!.jobStatus}',
                                style: TextStyle(
                                    color: myJobResponse?.data![index]!.jobStatus == 'rejected' ?  ColorConstants.VIEW_ALL :
                                    Colors.green, fontSize: 12),),
                            ):SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ))
      ],
    ): SizedBox();
  }

  Widget _jobBasedYourListCard() {
    return Container(
      color: ColorConstants.WHITE,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Text('Jobs based on your Portfolio',
                style: Styles.regular(size: 16, color: ColorConstants.BLACK)),
          ),
          Divider(
            height: 1,
            color: ColorConstants.GREY_3,
          ),

          allJobListResponse?.data != null ?
          renderJobList(4):SizedBox(),

        /*  InkWell(
            onTap: () {
              print('View all Job');
              Navigator.push(
                  context,
                  NextPageRoute(
                      JobSearchViewPage(
                        appBarTitle: 'Job Portfolio',
                        isSearchMode: false,
                      ),
                      isMaintainState: true));
            },
            child: Container(
              height: 70,
              child: Center(
                child: Text('View all Job',
                    style: Styles.semibold(
                        size: 14, color: ColorConstants.RED)),
              ),
            ),
          ),*/

        /*renderJobList(allJobListResponse
                ?.where((element) => element.isRecommended != 1)
                .toList()),*/

        ],
      ),
    );
  }

  Widget _step2Card() {
    return Container(
      color: ColorConstants.WHITE,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //< 4
          if(int.parse('${allJobListResponse?.data?.length}')  > 4) ...[
            renderJobSecondPositionList((allJobListResponse?.data!.length)!-4),
          ],
        ],
      ),
    );
  }

  Widget _step3Card() {
    return Container(
      color: ColorConstants.WHITE,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(int.parse('${allJobListResponse?.data?.length}') > 8) ...[
            renderJobThirdPositionList((allJobListResponse?.data!.length)!-8),
          ],

        ],
      ),
    );
  }

  Widget _recommendedOpportunitiesListCard() {
    return recommendedJobOpportunities?.data!.length != 0 ? Container(
      //decoration: BoxDecoration(color: ColorConstants.WHITE),
      margin: EdgeInsets.only(top: 30),
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
                    'Recommended Opportunities',
                    style: Styles.bold(color: Color(0xff0E1638)),
                  )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              height: 360,
              child: recommendedJobOpportunities?.data!.length != 0 ?
              ListView.builder(
                  itemCount: recommendedJobOpportunities?.data!.length ,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            NextPageRoute(JobDetailsPage(
                              title: recommendedJobOpportunities?.data![index]!.name,
                              description: recommendedJobOpportunities?.data![index]!.description,
                              location: recommendedJobOpportunities?.data![index]!.location,
                              skillNames: recommendedJobOpportunities?.data![index]!.skillNames,
                              companyName: recommendedJobOpportunities?.data![index]!.organizedBy,
                              domain: recommendedJobOpportunities?.data![index]!.domainName,
                              companyThumbnail: recommendedJobOpportunities?.data![index]!.image,
                              experience: recommendedJobOpportunities?.data![index]!.experience,
                              //jobListDetails: jobList,
                              id: recommendedJobOpportunities?.data![index]!.id,
                              jobStatus: recommendedJobOpportunities?.data![index]!.jobStatus,
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
                                      imageUrl: '${recommendedJobOpportunities?.data![index]!.image}',
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
                                        '${recommendedJobOpportunities?.data![index]!.name}',
                                        style: Styles.bold(
                                            color: Color(0xff0E1638), size: 13),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    recommendedJobOpportunities?.data![index]!.location != null ? Row(
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
                                            '${recommendedJobOpportunities?.data![index]!.location}',
                                            style: Styles.regular(
                                                color: ColorConstants.GREY_3,
                                                size: 11),
                                          ),
                                        ),
                                      ],
                                    ) : SizedBox(),
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
                                                    '${recommendedJobOpportunities?.data![index]!.skillNames}',
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
                                    recommendedJobOpportunities?.data![index]!.jobStatus == null || recommendedJobOpportunities?.data![index]!.jobStatus == "" ? InkWell(
                                      onTap: (){
                                        jobApply(int.parse('${recommendedJobOpportunities?.data![index]!.id}'), 1);
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
                                      child: Text('${recommendedJobOpportunities?.data![index]!.jobStatus}', style: Styles.bold(color: Colors.green, size: 14),),
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
    ) :SizedBox();
  }

  Widget renderJobList(int position) {
    return 
    
    Consumer<CompetitionResponseProvider>(
                builder: (context, competitionProvider, child)=>  ListView.builder(
        //itemCount: allJobListResponse?.data!.length,
      itemCount: (allJobListResponse?.data?.length)! < position
          ? allJobListResponse?.data?.length
          : position,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {

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
                        flex: 2,
                        child: Container(
                            padding: EdgeInsets.only(
                              right: 10.0,
                            ),
                            //child: Image.asset('assets/images/google.png'),
                            child: allJobListResponse?.data![index]!.image != null
                                ? Image.network('${allJobListResponse?.data![index]!.image}')
                                : Image.asset('assets/images/pb_2.png')),
                      ),
                      Expanded(
                        flex: 9,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                NextPageRoute(JobDetailsPage(
                                  title: allJobListResponse?.data![index]!.name,
                                  description: allJobListResponse?.data![index]!.description,
                                  location: allJobListResponse?.data![index]!.location,
                                  skillNames: allJobListResponse?.data![index]!.skillNames,
                                  companyName: allJobListResponse?.data![index]!.organizedBy,
                                  domain: allJobListResponse?.data![index]!.domainName,
                                  companyThumbnail: allJobListResponse?.data![index]!.image,
                                  experience: allJobListResponse?.data![index]!.experience,
                                  //jobListDetails: jobList,
                                  id: allJobListResponse?.data![index]!.id,
                                  jobStatus: applied == index ? 'Application under process' : allJobListResponse?.data![index]!.jobStatus,
                                )));

                          },
                          child: Container(
                            padding: EdgeInsets.only(
                              left: 5.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${allJobListResponse?.data![index]!.name}',
                                    style: Styles.bold(
                                        size: 14, color: ColorConstants.BLACK)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text('${allJobListResponse?.data![index]!.organizedBy}',
                                      style: Styles.regular(
                                          size: 12, color: Color(0xff3E4245))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Row(
                                    children: [
                                      Image.asset('assets/images/jobicon.png'),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Text('Exp: ',
                                            style: Styles.regular(
                                                size: 12,
                                                color: ColorConstants.GREY_6)),
                                      ),
                                      Text('${allJobListResponse?.data![index]!.experience != null ?
                                      allJobListResponse?.data![index]!.experience : "0"} Yrs',
                                          style: Styles.regular(
                                              size: 12,
                                              color: ColorConstants.GREY_6)),

                                      allJobListResponse?.data![index]!.location != null ? Row(
                                       children: [
                                         Padding(
                                           padding:
                                           const EdgeInsets.only(left: 20.0),
                                           child: Icon(
                                             Icons.location_on_outlined,
                                             size: 16,
                                             color: ColorConstants.GREY_3,
                                           ),
                                         ),
                                         Text('${allJobListResponse?.data![index]!.location}',
                                             style: Styles.regular(
                                                 size: 12,
                                                 color: ColorConstants.GREY_3)),
                                       ],
                                     ): SizedBox(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child:
                        allJobListResponse?.data![index]!.jobStatus == null || allJobListResponse?.data![index]!.jobStatus == "" 
                        // competitionProvider.list[index]!.jobStatus == null || competitionProvider.list[index]!.jobStatus == "" 
                        ?
                        InkWell(
                          onTap: (){
                            print('jobApply');
                            // applied = index;
                            competitionProvider.updateAppliedStatus(index);
                            jobApply(int.parse('${allJobListResponse?.data![index]!.id}'), 1);
                            _onLoadingForJob();
                            },
                          child: Container(
                            padding: EdgeInsets.only(left: 0.0),
                            child: GradientText(
'Apply',
                              style: Styles.bold(size: 14),
                              colors: [
                                ColorConstants.GRADIENT_ORANGE,
                                ColorConstants.GRADIENT_RED,
                              ],
                            ),
                            /*child: Text(applied == null || applied != index ?'Apply':'',
                                style: Styles.bold(
                                    size: 12, color: ColorConstants.ORANGE)),*/
                          ),
                        ): Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Text('Applied', style: Styles.bold(color: Colors.green, size: 12),),
                        ),
                      ),
                    ],
                  ),
                ),
                /*decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorConstants.WHITE,
                  boxShadow: [
                    BoxShadow(color: Colors.white, spreadRadius: 3),
                  ],
                ),*/
              ),
              Divider(
                height: 1,
                color: ColorConstants.GREY_3,
              ),
            ],
          );
        }));
  }

  Widget renderJobSecondPositionList(int position) {
    return Consumer<CompetitionResponseProvider>(
                builder: (context, competitionProvider, child)=>  ListView.builder(
       //itemCount: allJobListResponse?.data!.length,
      itemCount: position < 4
          ? position
          : 4,
        //itemCount: position,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {

          print('position2===== ${position}');
          int newIndex = index + 4;
          print(newIndex);

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
                        flex: 2,
                        child: Container(
                            padding: EdgeInsets.only(
                              right: 10.0,
                            ),
                            //child: Image.asset('assets/images/google.png'),
                            child: allJobListResponse?.data![newIndex]!.image != null
                                ? Image.network('${allJobListResponse?.data![newIndex]!.image}',
                            height: 80, width: 80,)
                                : Image.asset('assets/images/pb_2.png')),
                      ),
                      Expanded(
                        flex: 9,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                NextPageRoute(JobDetailsPage(
                                  title: allJobListResponse?.data![newIndex]!.name,
                                  description: allJobListResponse?.data![newIndex]!.description,
                                  location: allJobListResponse?.data![newIndex]!.location,
                                  skillNames: allJobListResponse?.data![newIndex]!.skillNames,
                                  companyName: allJobListResponse?.data![newIndex]!.organizedBy,
                                  domain: allJobListResponse?.data![newIndex]!.domainName,
                                  companyThumbnail: allJobListResponse?.data![newIndex]!.image,
                                  experience: allJobListResponse?.data![newIndex]!.experience,
                                  //jobListDetails: jobList,
                                  id: allJobListResponse?.data![newIndex]!.id,
                                  jobStatus: competitionProvider.list[index]?.jobStatus != '' ? 'Application under process' : allJobListResponse?.data![newIndex]!.jobStatus,
                                )));

                          },
                          child: Container(
                            padding: EdgeInsets.only(
                              left: 5.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${allJobListResponse?.data![newIndex]!.name}',
                                    style: Styles.bold(
                                        size: 14, color: ColorConstants.BLACK)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text('${allJobListResponse?.data![newIndex]!.organizedBy}',
                                      style: Styles.regular(
                                          size: 12, color: Color(0xff3E4245))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Row(
                                    children: [
                                      Image.asset('assets/images/jobicon.png'),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 5.0),
                                        child: Text('Exp: ',
                                            style: Styles.regular(
                                                size: 12,
                                                color: ColorConstants.GREY_6)),
                                      ),
                                      Text('${allJobListResponse?.data![newIndex]!.experience != null ?
                                      allJobListResponse?.data![newIndex]!.experience: "0" } Yrs',
                                          style: Styles.regular(
                                              size: 12,
                                              color: ColorConstants.GREY_6)),

                                      allJobListResponse?.data![newIndex]!.location != null ? Row(
                                        children: [
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(left: 20.0),
                                            child: Icon(
                                              Icons.location_on_outlined,
                                              size: 16,
                                              color: ColorConstants.GREY_3,
                                            ),
                                          ),
                                          Text('${allJobListResponse?.data![newIndex]!.location}',
                                              style: Styles.regular(
                                                  size: 12,
                                                  color: ColorConstants.GREY_3)),
                                        ],
                                      ):SizedBox(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: competitionProvider.list[newIndex]!.jobStatus == null || competitionProvider.list[newIndex]!.jobStatus == "" ?
                        InkWell(
                          onTap: (){
                            print('jobApply');
                            // applied = index;
                             competitionProvider.updateAppliedStatus(newIndex);
                            jobApply(int.parse('${allJobListResponse?.data![newIndex]!.id}'), 1);
                            _onLoadingForJob();
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 0.0),

                            child: GradientText(
                              competitionProvider.list[newIndex]?.jobStatus == null?'Apply':'Applied',
                              style: Styles.bold(size: 14),
                              colors: [
                                competitionProvider.list[newIndex]?.jobStatus == null?
                                ColorConstants.GRADIENT_ORANGE : ColorConstants.GREEN,
                                competitionProvider.list[newIndex]?.jobStatus == null?
                                ColorConstants.GRADIENT_RED : ColorConstants.GREEN,
                              ],
                            ),
                           /* child: Text(applied == null || applied != index ?'Apply':'',
                                style: Styles.bold(
                                    size: 12, color: ColorConstants.ORANGE)),*/
                          ),
                        ) :
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Text('Applied', style: Styles.bold(color: Colors.green, size: 12),),
                        ),
                      ),
                    ],
                  ),
                ),
                /*decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorConstants.WHITE,
                  boxShadow: [
                    BoxShadow(color: Colors.white, spreadRadius: 3),
                  ],
                ),*/
              ),
              Divider(
                height: 1,
                color: ColorConstants.GREY_3,
              ),
            ],
          );
        }));
  }

  Widget renderJobThirdPositionList(int position) {
    return Consumer<CompetitionResponseProvider>(
                builder: (context, competitionProvider, child)=>  ListView.builder(
      //itemCount: allJobListResponse?.data!.length,
      /*itemCount: (allJobListResponse?.data?.length)! < position
          ? allJobListResponse?.data?.length
          : position,*/
        itemCount: position,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {

          print('position2===== ${position}');
          int newIndex = index + 8;
          print(newIndex);

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
                        flex: 2,
                        child: Container(
                            padding: EdgeInsets.only(
                              right: 10.0,
                            ),
                            //child: Image.asset('assets/images/google.png'),
                            child: allJobListResponse?.data![newIndex]!.image != null
                                ? Image.network('${allJobListResponse?.data![newIndex]!.image}',
                              height: 80, width: 80,)
                                : Image.asset('assets/images/pb_2.png')),
                      ),
                      Expanded(
                        flex: 9,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                NextPageRoute(JobDetailsPage(
                                  title: allJobListResponse?.data![newIndex]!.name,
                                  description: allJobListResponse?.data![newIndex]!.description,
                                  location: allJobListResponse?.data![newIndex]!.location,
                                  skillNames: allJobListResponse?.data![newIndex]!.skillNames,
                                  companyName: allJobListResponse?.data![newIndex]!.organizedBy,
                                  domain: allJobListResponse?.data![newIndex]!.domainName,
                                  companyThumbnail: allJobListResponse?.data![newIndex]!.image,
                                  experience: allJobListResponse?.data![newIndex]!.experience,
                                  //jobListDetails: jobList,
                                  id: allJobListResponse?.data![newIndex]!.id,
                                  jobStatus: applied == index ? 'Application under process' : allJobListResponse?.data![newIndex]!.jobStatus,
                                )));

                          },
                          child: Container(
                            padding: EdgeInsets.only(
                              left: 5.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${allJobListResponse?.data![newIndex]!.name}',
                                    style: Styles.bold(
                                        size: 14, color: ColorConstants.BLACK)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text('${allJobListResponse?.data![newIndex]!.organizedBy}',
                                      style: Styles.regular(
                                          size: 12, color: Color(0xff3E4245))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Row(
                                    children: [
                                      Image.asset('assets/images/jobicon.png'),
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 5.0),
                                        child: Text('Exp: ',
                                            style: Styles.regular(
                                                size: 12,
                                                color: ColorConstants.GREY_6)),
                                      ),
                                      Text('${allJobListResponse?.data![newIndex]!.experience != null ?
                                      allJobListResponse?.data![newIndex]!.experience: '0'} Yrs',
                                          style: Styles.regular(
                                              size: 12,
                                              color: ColorConstants.GREY_6)),

                                      allJobListResponse?.data![newIndex]!.location != null ? Row(
                                        children: [
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(left: 20.0),
                                            child: Icon(
                                              Icons.location_on_outlined,
                                              size: 16,
                                              color: ColorConstants.GREY_3,
                                            ),
                                          ),
                                          Text('${allJobListResponse?.data![newIndex]!.location}',
                                              style: Styles.regular(
                                                  size: 12,
                                                  color: ColorConstants.GREY_3)),
                                        ],
                                      ):SizedBox(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: competitionProvider.list[newIndex]!.jobStatus == null || competitionProvider.list[newIndex]!.jobStatus == "" ?
                        InkWell(
                          onTap: (){
                            print('jobApply');
                            // applied = index;
                            competitionProvider.updateAppliedStatus(newIndex);
                            jobApply(int.parse('${allJobListResponse?.data![newIndex]!.id}'), 1);
                            _onLoadingForJob();
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 0.0),
                            child: GradientText('Apply',
                              style: Styles.bold(size: 14),
                              colors: [
                                ColorConstants.GRADIENT_ORANGE,
                                ColorConstants.GRADIENT_RED,
                              ],
                            ),
                            /*child: Text(applied == null || applied != index ?'Apply':'',
                                style: Styles.bold(
                                    size: 12, color: ColorConstants.ORANGE)),*/
                          ),
                        ) :
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: Text('Applied', style: Styles.bold(color: Colors.green, size: 12),),
                        ),
                      ),
                    ],
                  ),
                ),
                /*decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorConstants.WHITE,
                  boxShadow: [
                    BoxShadow(color: Colors.white, spreadRadius: 3),
                  ],
                ),*/
              ),
              Divider(
                height: 1,
                color: ColorConstants.GREY_3,
              ),
            ],
          );
        }));
  }


  void showBottomSheetJobFilter() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setSheetState) {
            Timer.periodic(Duration(seconds: 1), (timer) {
              setSheetState(() {});
            });

            return Container(
              margin: EdgeInsets.only(top: 350),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Stack(children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 5,
                        width: 48,
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            color: ColorConstants.GREY_4,
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      ///Filter by
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: Text(
                              'Filter by',
                              style: Styles.bold(size: 18),
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: ColorConstants.GREY_3,
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 20.0, top: 20.0, right: 8.0),
                            width: 100,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Text(
                                  'Applied Only',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 13),
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: ColorConstants.GREY,
                              boxShadow: [
                                BoxShadow(
                                    color: ColorConstants.GREY,
                                    spreadRadius: 1),
                              ],
                            ),
                            height: 40,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Divider(
                          height: 1,
                          color: ColorConstants.GREY_3,
                        ),
                      ),

                      ///Domain
                      //SizedBox(height: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: Text(
                              'Domain',
                              style: Styles.bold(size: 18),
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: ColorConstants.WHITE,
                          ),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0, top: 10.0, right: 8.0),
                                width: 100,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: Text(
                                      'Art & Design',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 13),
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: ColorConstants.GREY,
                                  boxShadow: [
                                    BoxShadow(
                                        color: ColorConstants.GREY,
                                        spreadRadius: 1),
                                  ],
                                ),
                                height: 40,
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, top: 10.0, right: 8.0),
                                width: 100,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: Text(
                                      'Technology',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 13),
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: ColorConstants.GREY,
                                  boxShadow: [
                                    BoxShadow(
                                        color: ColorConstants.GREY,
                                        spreadRadius: 1),
                                  ],
                                ),
                                height: 40,
                              ),
                            ],
                          ),
                        ],
                      ),

                      ///Skill
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 10.0,
                                bottom: 10.0),
                            child: Text(
                              'Skill',
                              style: Styles.bold(size: 18),
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: ColorConstants.WHITE,
                          ),
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 20.0, top: 10.0, right: 8.0),
                                width: 100,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: Text(
                                      'Ui Design',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 13),
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: ColorConstants.GREY,
                                  boxShadow: [
                                    BoxShadow(
                                        color: ColorConstants.GREY,
                                        spreadRadius: 1),
                                  ],
                                ),
                                height: 40,
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 10.0, top: 10.0, right: 8.0),
                                width: 140,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: Text(
                                      'Graphic Design',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 13),
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: ColorConstants.GREY,
                                  boxShadow: [
                                    BoxShadow(
                                        color: ColorConstants.GREY,
                                        spreadRadius: 1),
                                  ],
                                ),
                                height: 40,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
            );
          });
        });
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

  void _handleJobResponse(UserJobListState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          isJobLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("UserJobListState....................");
          //jobList = state.response!.list!;
          isJobLoading = false;
          break;
        case ApiStatus.ERROR:
          isJobLoading = false;
          Log.v("Error..........................");
          Log.v(
              "ErrorUserJobListState..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
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
      ],
    );
  }
}
