

import 'dart:async';
import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/user_jobs_list_response.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/rounded_appbar.dart';
import 'package:masterg/pages/singularis/job/job_search_view_page.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/resource/size_constants.dart';
import 'package:shimmer/shimmer.dart';

import '../../../blocs/bloc_manager.dart';
import '../../../blocs/home_bloc.dart';
import '../../../local/pref/Preference.dart';
import '../../../utils/Styles.dart';
import '../../custom_pages/custom_widgets/CommonWebView.dart';
import '../../custom_pages/custom_widgets/NextPageRouting.dart';
import 'job_details_page.dart';

class JobDashboardPage extends StatefulWidget {
  const 
  JobDashboardPage({Key? key}) : super(key: key);

  @override
  State<JobDashboardPage> createState() => _JobDashboardPageState();
}

class _JobDashboardPageState extends State<JobDashboardPage> {

  bool? isJobLoading;
  List<ListElement>? jobList;


  @override
  void initState() {
    super.initState();
    getJobList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocManager(
      initState: (context) {},
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is UserJobListState) {
            _handleJobResponse(state);
          }
        },
        child: Scaffold(
          backgroundColor: ColorConstants.JOB_BG_COLOR,
          body: _makeBody(),
        ),
      ),
    );

  }


  void getJobList(){
    BlocProvider.of<HomeBloc>(context).add(UserJobsListEvent());
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
        child: Column(
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
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(200),
                                    child: SizedBox(
                                      width: 40,
                                      child: Image.network(
                                          '${Preference.getString(Preference.PROFILE_IMAGE)}'),
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

                        SizedBox(
                          height: height(context) * 0.06,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [Text('Skill Assessment'), Text('Career Opportunities')]),
                        ),
            ///Search Job
            Padding(
              padding: const  EdgeInsets.only(
                  left: SizeConstants.JOB_LEFT_SCREEN_MGN,
                       right: SizeConstants.JOB_RIGHT_SCREEN_MGN),
              child: _searchFilter(),
            ),

            ///Complete Profile
            SizedBox(height: 30,),
            _highLightsCard(ColorConstants.HIGH_LIGHTS_CARD_COLOR1,
            'Complete Your Profile & Get Noticed!',
                'Profiles with Photo, Headlines and Summary bring Recruiters instant attention.',
            'complete_profile'),

            ///Jobs based Profile
            SizedBox(height: 30,),
           jobList != null ? _jobBasedYourListCard() : BlankPage(),

            ///Build Your Portfolio
            SizedBox(height: 30,),
            _highLightsCard(ColorConstants.ORANGE,
                'Build Your Portfolio',
                'Creating a Portfolio helps the recruiters to understand better about your profile and your skills.',
            'build_portfolio'),

            ///Recommended Jobs
            SizedBox(height: 30,),
            jobList != null ? _recommendedJobsListCard() : BlankPage(),
          ],
        ),
      ),
    );
  }


  Widget _searchFilter(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 9,
              child: InkWell(
                onTap: (){
                  Navigator.push(context, NextPageRoute(JobSearchViewPage(appBarTitle: 'Search', isSearchMode: true,)));
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
                        Icon(Icons.search_rounded, size: 28,),
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
              ),
          ),
          Expanded(
            flex: 1,
              child: InkWell(
                onTap: (){
                  showBottomSheetJobFilter();
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Icon(Icons.filter_list, color: Colors.black, size: 28,),
                ),
              ),
          ),
        ],
      ),
    );
  }

  Widget _highLightsCard(Color colorBg, String strTitle, String strDes, String clickType){
   return Container(
       height: 120,
        margin: const EdgeInsets.only(
                  left: SizeConstants.JOB_LEFT_SCREEN_MGN,
                       right: SizeConstants.JOB_RIGHT_SCREEN_MGN),
       width: double.infinity,
       child: InkWell(
         onTap: (){
           if(clickType == 'build_portfolio'){
             print('object');

             print('Email == ${Preference.getString(Preference.USER_EMAIL)}');

             if(Preference.getString(Preference.USER_EMAIL) != null){
               String portfolioUrl = 'https://singularis.learningoxygen.com/user-portfolio-webview?email=${Preference.getString(Preference.USER_EMAIL)}';
               Navigator.push(
                   context,
                   NextPageRoute(CommonWebView(
                     url: portfolioUrl,
                   ))).then((isSuccess) {
                 if (isSuccess == true) {
                   Navigator.pop(context, true);
                 }
               });
             }
           }
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
                           style: Styles.bold(size: 16, color: ColorConstants.WHITE)),
                       Padding(
                         padding: const EdgeInsets.only(top: 4.0),
                         child: Text('$strDes',
                             style: Styles.regularWhite()),
                       ),
                     ],
                   ),
                 ),
               ),

               Expanded(
                 flex: 1,
                 child: Container(
                   padding: EdgeInsets.only(left: 10.0),
                   child: Icon(Icons.arrow_forward_ios,
                     color: Colors.white, size: 28,),
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

  Widget _jobBasedYourListCard() {
    return Container(
      color: ColorConstants.WHITE,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Text('Jobs based on your Portfolio',
                style: Styles.regular(size:16,color: ColorConstants.BLACK)),
          ),
          Divider(height: 1,color: ColorConstants.GREY_3,),

          if(isJobLoading == false ) renderJobList(jobList?.where((element) => element.isRecommended != 1).toList()) ,

          jobList != null ? InkWell(
            onTap: (){
              print('View all Job');
              Navigator.push(context, NextPageRoute(JobSearchViewPage(
                appBarTitle: 'Job Portfolio',
                isSearchMode: false,),isMaintainState: true));
            },
            child: Container(
              height: 70,
              child: Center(
                child: Text('View all Job',
                    style: Styles.semibold(size:14,color: ColorConstants.RED)),
              ),
            ),
          ) : SizedBox(),
        ],
      ),
    );
  }

  Widget _recommendedJobsListCard() {
    return Container(
      color: ColorConstants.WHITE,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Text('Recommended Jobs',
                style: Styles.regular(size:16,color: ColorConstants.BLACK)),
          ),
          Divider(height: 1,color: ColorConstants.GREY_3,),

          if(isJobLoading == false ) renderJobList(jobList?.where((element) => element.isRecommended == 1).toList()) ,

          jobList != null ? InkWell(
            onTap: (){
              Navigator.push(context, NextPageRoute(JobSearchViewPage(
                appBarTitle: 'Job Portfolio',
                isSearchMode: false,), isMaintainState: true));
            },
            child: Container(
              height: 70,
              child: Center(
                child: Text('View all Job',
                    style: Styles.bold(size:14,color: ColorConstants.RED)),
              ),
            ),
          ):SizedBox(),
        ],
      ),
    );
  }

  Widget renderJobList(jobList){
    return ListView.builder(
        itemCount: jobList?.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index){
          return Column(
              children: [
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 15.0, right: 10.0, bottom: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.only(right: 10.0, ),
                            //child: Image.asset('assets/images/google.png'),
                              child: jobList?[index].companyThumbnail != null ?
                              Image.network(jobList?[index].companyThumbnail):
                              Image.asset('assets/images/pb_2.png')
                          ),
                        ),
                        Expanded(
                          flex: 9,
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, NextPageRoute(JobDetailsPage(
                                title: jobList[index].title,
                                description: jobList[index].description,
                                location: jobList[index].location,
                                skillNames: jobList[index].skillNames,
                                companyName: jobList[index].companyName,
                                domain: jobList[index].domain,
                                companyThumbnail: jobList[index].companyThumbnail,
                                experience: jobList[index].experience,
                                jobListDetails: jobList,
                                id: jobList[index].id,
                              )
                              ));

                              print('jobList == ${jobList[index].title}');
                            },
                            child: Container(
                              padding: EdgeInsets.only(left: 5.0, ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${jobList?[index].title}',
                                      style: Styles.bold(
                                          size: 14, color: ColorConstants.BLACK)),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: Text(
                                        '${jobList?[index].companyName}',
                                        style: Styles.regular(size:12,color: Color(0xff3E4245))),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Row(
                                      children: [
                                        Image.asset('assets/images/jobicon.png'),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5.0),
                                          child: Text('Exp: ',
                                              style: Styles.regular(size:12,color: ColorConstants.GREY_6)),
                                        ),
                                        Text('${jobList?[index].experience} Yrs',
                                            style: Styles.regular(size:12,color: ColorConstants.GREY_6)),

                                        Padding(
                                          padding: const EdgeInsets.only(left: 20.0),
                                          child: Icon(Icons.location_on_outlined, size: 16,
                                            color: ColorConstants.GREY_3,),
                                        ),

                                        Text('${jobList?[index].location}',
                                            style: Styles.regular(size:12,color: ColorConstants.GREY_3)
                                        ),

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
                          child: Container(
                            padding: EdgeInsets.only(left: 5.0),
                            child: Text('Apply',style: Styles.bold(
                                size: 12, color: ColorConstants.ORANGE)),),
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
                Divider(height: 1,color: ColorConstants.GREY_3,),
              ],
            );
        });
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

                child: Stack(
                children: [
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
                                  left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                              child: Text(
                                'Filter by',
                                style: Styles.bold(size: 18),
                              ),
                            ),
                            Divider(height: 1, color: ColorConstants.GREY_3,),

                            Container(
                              margin: const EdgeInsets.only(left: 20.0, top: 20.0, right: 8.0),
                              width: 100,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                  child: Text(
                                    'Applied Only',
                                    style: TextStyle(color: Colors.black, fontSize: 13),
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: ColorConstants.GREY,
                                boxShadow: [
                                  BoxShadow(color: ColorConstants.GREY, spreadRadius: 1),
                                ],
                              ),
                              height: 40,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Divider(height: 1, color: ColorConstants.GREY_3,),
                        ),

                        ///Domain
                        //SizedBox(height: 20,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                              child: Text(
                                'Domain',
                                style: Styles.bold(size: 18),
                              ),
                            ),
                            Divider(height: 1, color: ColorConstants.WHITE,),

                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 20.0, top: 10.0, right: 8.0),
                                  width: 100,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                      child: Text(
                                        'Art & Design',
                                        style: TextStyle(color: Colors.black, fontSize: 13),
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: ColorConstants.GREY,
                                    boxShadow: [
                                      BoxShadow(color: ColorConstants.GREY, spreadRadius: 1),
                                    ],
                                  ),
                                  height: 40,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 10.0, top: 10.0, right: 8.0),
                                  width: 100,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                      child: Text(
                                        'Technology',
                                        style: TextStyle(color: Colors.black, fontSize: 13),
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: ColorConstants.GREY,
                                    boxShadow: [
                                      BoxShadow(color: ColorConstants.GREY, spreadRadius: 1),
                                    ],
                                  ),
                                  height: 40,
                                ),
                              ],
                            ),
                          ],
                        ),

                        ///Skill
                        SizedBox(height: 20,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                              child: Text(
                                'Skill',
                                style: Styles.bold(size: 18),
                              ),
                            ),
                            Divider(height: 1, color: ColorConstants.WHITE,),
                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 20.0, top: 10.0, right: 8.0),
                                  width: 100,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                      child: Text(
                                        'Ui Design',
                                        style: TextStyle(color: Colors.black, fontSize: 13),
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: ColorConstants.GREY,
                                    boxShadow: [
                                      BoxShadow(color: ColorConstants.GREY, spreadRadius: 1),
                                    ],
                                  ),
                                  height: 40,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 10.0, top: 10.0, right: 8.0),
                                  width: 140,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                      child: Text(
                                        'Graphic Design',
                                        style: TextStyle(color: Colors.black, fontSize: 13),
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: ColorConstants.GREY,
                                    boxShadow: [
                                      BoxShadow(color: ColorConstants.GREY, spreadRadius: 1),
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
          jobList = state.response!.list!;
          isJobLoading = false;
          break;
        case ApiStatus.ERROR:
          isJobLoading = false;
          Log.v("Error..........................");
          Log.v("ErrorUserJobListState..........................${loginState.error}");
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
            padding: const EdgeInsets.only(left: 10.0, top: 15.0, right: 10.0, bottom: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                      padding: EdgeInsets.only(right: 10.0, ),
                      child: Image.asset('assets/images/blank.png'),
                  ),
                ),

                Expanded(
                  flex: 9,
                  child: Container(
                    padding: EdgeInsets.only(left: 5.0, ),
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
        Divider(height: 1,color: ColorConstants.GREY_3,),
        Container(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 15.0, right: 10.0, bottom: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.only(right: 10.0, ),
                    child: Image.asset('assets/images/blank.png'),
                  ),
                ),

                Expanded(
                  flex: 9,
                  child: Container(
                    padding: EdgeInsets.only(left: 5.0, ),
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