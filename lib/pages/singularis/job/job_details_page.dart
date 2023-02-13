
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:masterg/pages/singularis/job/widgets/blank_widget_page.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../../blocs/bloc_manager.dart';
import '../../../blocs/home_bloc.dart';
import '../../../data/api/api_service.dart';
import '../../../data/models/response/home_response/competition_content_list_resp.dart';
import '../../../data/providers/assessment_detail_provider.dart';
import '../../../data/providers/assignment_detail_provider.dart';
import '../../../utils/Log.dart';
import '../../../utils/Styles.dart';
import '../../../utils/resource/colors.dart';
import '../../../utils/resource/size_constants.dart';
import '../../custom_pages/custom_widgets/NextPageRouting.dart';
import '../../training_pages/assessment_page.dart';
import '../../training_pages/assignment_detail_page.dart';
import '../competition/competition_navigation/competition_session.dart';
import 'model/ExampleItem.dart';
import 'package:masterg/data/models/response/home_response/user_jobs_list_response.dart';
import 'package:masterg/pages/training_pages/training_service.dart';
import 'package:masterg/utils/utility.dart';


enum CardType { assignment, assessment, session, video, note, youtube }
class JobDetailsPage extends StatefulWidget {

  final String? title;
  final String? description;
  final String? location;
  final String? skillNames;
  final String? companyName;
  final String? domain;
  final String? companyThumbnail;
  final String? experience;
  final List<ListElement>? jobListDetails;
  final int? id;
  String? jobStatus = '';

   JobDetailsPage({Key? key,
    this.title,
    this.description,
    this.location,
    this.skillNames,
    this.companyName,
    this.domain,
    this.companyThumbnail,
    this.experience,
    this.jobListDetails,
    this.id,
    this.jobStatus,
  }) : super(key: key);

  @override
  State<JobDetailsPage> createState() => _JobDetailsPageState();
}

class _JobDetailsPageState extends State<JobDetailsPage> {

  bool? competitionDetailLoading = true;
  CompetitionContentListResponse? contentList;
  int? applied = 0;

  @override
  void initState() {
    getCompetitionContentList(0);
    super.initState();
  }


  void getCompetitionContentList(int? isApplied) {
    BlocProvider.of<HomeBloc>(context).add(
        CompetitionContentListEvent(competitionId: widget.id, isApplied: isApplied));
  }

  void handleCompetitionListState(CompetitionContentListState state) {
    var competitionState = state;
    setState(() {
      switch (competitionState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          competitionDetailLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("Competition Content List State....................");
          contentList = competitionState.response;
          competitionDetailLoading = false;
          if(applied != 0){
            Utility.showSnackBar(
                scaffoldContext: context, message: 'Your application is successfully submitted.');
          }
          break;
        case ApiStatus.ERROR:
          Log.v(
              "Error Competition Content ..........................${competitionState.response?.error}");
          competitionDetailLoading = false;
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }


  List<String> listOfMonths = [
    "Janaury",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];


  @override
  Widget build(BuildContext context) {
    return BlocManager(
      initState: (context) {},
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          /*if (state is GetUserProfileState) {
            //_handleResponse(state);
          }*/
          if (state is CompetitionContentListState)
            handleCompetitionListState(state);
        },
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            elevation: 0.0,
            backgroundColor: ColorConstants.WHITE,
            title: Text('', style: TextStyle(color: Colors.black),),
          ),
          backgroundColor: ColorConstants.JOB_BG_COLOR,
          body: _makeBody(),
        ),
      ),
    );
  }

  Widget _makeBody() {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(bottom: SizeConstants.JOB_BOTTOM_SCREEN_MGN),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            ///Job List
             Divider(height: 1,color: ColorConstants.GREY_3,),
            _jobDetailsWidget(),

            ///Similar Jobs
            SizedBox(height: 30,),
            _progressActivitiesSection(),
          ],
        ),
      ),
    );
  }


  Widget _jobDetailsWidget() {
    return Container(
      color: Colors.white,
      child: Column(
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
                        child: widget.companyThumbnail != null
                            ? Image.network('${widget.companyThumbnail}')
                            : Image.asset('assets/images/pb_2.png')),
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
                          Text('${widget.title}',
                              style: Styles.bold(
                                  size: 14, color: ColorConstants.BLACK)),
                          Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text('${widget.companyName}',
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
                                Text('${widget.experience} Yrs',
                                    style: Styles.regular(
                                        size: 12,
                                        color: ColorConstants.GREY_6)),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(left: 20.0),
                                  child: Icon(
                                    Icons.location_on_outlined,
                                    size: 16,
                                    color: ColorConstants.GREY_3,
                                  ),
                                ),
                                Text('${widget.location}',
                                    style: Styles.regular(
                                        size: 12,
                                        color: ColorConstants.GREY_3)),
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
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 30.0),
              child: Text('${widget.description}',
                style: Styles.regular(size: 13, color: ColorConstants.GREY_3,),),
            ),
          ),

         widget.jobStatus == null || widget.jobStatus == "" ? InkWell(
           onTap: (){
             applied = 1;
             getCompetitionContentList(1);
             _onLoadingForJob();

             this.setState(() {
               widget.jobStatus = 'Application under process';
             });
           },
           child: Container(
              height: 40,
              margin: EdgeInsets.only(left: 50, top: 10, right: 50, bottom: 20),
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
                  child: Text('Apply',
                    style: Styles.regular(size: 13, color: ColorConstants.WHITE,),),
                ),
              ),
            ),
         ):
         Padding(
           padding: const EdgeInsets.only(bottom: 20.0),
           child: Text('${widget.jobStatus == 'under_review' ? 'Application under process' : widget.jobStatus}', style: Styles.bold(color: Colors.green, size: 14),),
         ),
        ],
      ),

      /*child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///Job Title Block
          Container(
            color: ColorConstants.WHITE,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 0.0),
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
                            child: widget.companyThumbnail != null ?
                            Image.network(widget.companyThumbnail!):
                            Image.asset('assets/images/pb_2.png'),
                          ),
                        ),

                        Expanded(
                          flex: 9,
                          child: Text('${widget.title}',
                              style: Styles.bold(
                                  size: 16, color: ColorConstants.BLACK)),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 40.0),
                  padding: EdgeInsets.only(left: 5.0, ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text('${widget.companyName}',
                            style: Styles.regular(size:12,color: ColorConstants.GREY_3)),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: [
                            //Image.asset('assets/images/jobicon.png'),
                            Icon(Icons.card_travel_sharp, size: 16,
                              color: ColorConstants.GREY_3,),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text('Exp: ',
                                  style: Styles.regular(size:12,color: ColorConstants.GREY_3)),
                            ),
                            Text('${widget.experience}  Yrs',
                                style: Styles.regular(size:12,color: ColorConstants.GREY_3)),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: [
                            Icon(Icons.location_on_outlined, size: 16,
                              color: ColorConstants.GREY_3,),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text('${widget.location}',
                                  style: Styles.regular(size:12,color: ColorConstants.GREY_3)
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child:
                              Text('Domain:',
                                  style: Styles.regular(size:13,color: ColorConstants.GREY_1)
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text('${widget.domain}',
                                  style: Styles.regular(size:12,color: ColorConstants.GREY_3)
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, top: 10.0),
                        child: Text('Good to have skills',
                            style: Styles.regular(size:13,color: ColorConstants.GREY_1)
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, top: 3.0),
                        child: Text('${widget.skillNames}',
                            style: Styles.regular(size:12,color: ColorConstants.GREY_3)
                        ),
                      ),
                    ],
                  ),
                ),

                ///Apply This Job Button
                Container(
                  margin: EdgeInsets.only(bottom: 20.0),
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Apply to this Job',style: Styles.regular(
                        size: 15, color: ColorConstants.RED)),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                    color: ColorConstants.WHITE,
                    boxShadow: [
                      BoxShadow(color: Colors.red, spreadRadius: 1),
                    ],
                  ),
                ),
              ],
            ),
          ),

          ///Job Description Block
          Container(
            margin: EdgeInsets.only(top: 15.0,),

            width: MediaQuery.of(context).size.width,
            color: ColorConstants.WHITE,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Text('Job Description',
                      style: Styles.bold(size:18,color: ColorConstants.BLACK)),
                ),
                Divider(height: 1,color: ColorConstants.GREY_3,),

                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 15.0, right: 10.0, bottom: 20.0),
                  child: Text('${widget.description}',
                      style: Styles.regular(size:13,color: ColorConstants.GREY_3)),
                ),
              ],
            ),
          ),
        ],
      ),*/
    );
  }


  //TODO:Progress============
  Widget _progressActivitiesSection(){
    return Container(

      child: Column(
        children: [
          if (competitionDetailLoading == false ) ...[
            widget.jobStatus == 'shortlisted' || widget.jobStatus == 'placed' ?
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('Progress', style: Styles.bold(size: 16, color: Color(0xff0E1638)))),
            ):SizedBox(),
          ],

          //TODO:Progress List
          if (competitionDetailLoading == false ) ...[
            widget.jobStatus == 'shortlisted' || widget.jobStatus == 'placed' ?
            ListView.builder(
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: contentList?.data?.list?.length,
                itemBuilder: (context, index) {
                  // return Text('nice');
                  bool isLocked = index != 0;
                  // if(index != 0 && contentList?.data?.list?[index - 1]?.completionPercentage == 100.0){
                  //   isLocked = false;
                  // }

                  if (index != 0) {
                            CompetitionContent? data =
                              contentList?.data?.list?[index-1];
                            if (data?.completionPercentage != null &&
                                (data?.contentType == 'assignment' ||
                                    data?.contentType == 'assessment') &&
                               double.parse('${data?.overallScore ?? 0}') >=
                                    double.parse('${data?.perCompletion}')) {
                              isLocked = false;
                            } 
                            else if (data?.completionPercentage != null &&
                                 double.parse('${data?.completionPercentage}') >=
                                     double.parse('${data?.perCompletion}')) {
                              isLocked = false;
                            }
                            if (data?.activityStatus == 2) {
                              isLocked = false;
                            }

                             if(index == 1){
                            print(' and the dats is ${data?.completionPercentage } and ${data?.perCompletion}');
                          }
                          }

                  return competitionCard(
                      contentList?.data?.list![index],
                      index == ((contentList?.data?.list?.length ?? 1) - 1),
                      isLocked:  isLocked);
                }): SizedBox(),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //what's in for you
                  Text(
                    'What’s in for you',
                    style:
                    Styles.bold(size: 14, color: Color(0xff5A5F73)),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    '${contentList?.data?.competitionInstructions?.whatsIn}',
                    style: Styles.regular(color: Color(0xff5A5F73), size: 14),
                  ),
                  SizedBox(
                    height: 40,
                  ),

                  Text(
                    'Requirements',
                    style:
                    Styles.bold(size: 14, color: Color(0xff5A5F73)),
                  ),
                  SizedBox(
                    height: 8,
                  ),

                  Text(
                    '${contentList?.data?.competitionInstructions?.instructions}',
                    style: Styles.regular(color: Color(0xff5A5F73), size: 14),
                  ),
                  SizedBox(
                    height: 40,
                  ),

                  Text(
                    'Job Description',
                    style:
                    Styles.bold(size: 14, color: Color(0xff5A5F73)),
                  ),
                  SizedBox(
                    height: 8,
                  ),

                  Text(
                    '${contentList?.data?.competitionInstructions?.faq}',
                    style: Styles.regular(color: Color(0xff5A5F73), size: 14),
                  ),
                ],
              ),
            )
          ] else
            ListView.builder(
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) =>
                    Shimmer.fromColors(
                      baseColor: Color(0xffe6e4e6),
                      highlightColor: Color(0xffeaf0f3),
                      child: Container(
                        height:
                        MediaQuery.of(context).size.height * 0.1,
                        margin: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6)),
                      ),
                    )),
        ],
      ),
    );
  }

  Widget competitionCard(CompetitionContent? data, bool isLast, {bool? isLocked}) {
    CardType? cardType;

    if (data?.completionPercentage == 100.0) isLocked = false;
    // if (cardType != CardType.session && data?.completionPercentage == 100)
    //   isLocked = false;

    switch (data?.contentType) {
      /*case "video_yts":
        cardType = CardType.youtube;
        break;
      case "video":
        cardType = CardType.video;
        break;
      case "notes":
        cardType = CardType.note;
        break;*/
      case "assessment":
        cardType = CardType.assessment;
        break;
      case "assignment":
        cardType = CardType.assignment;
        break;
      case "zoomclass":
        cardType = CardType.session;
        break;
    }
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  data?.completionPercentage == 100.0   ? Container(
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: ColorConstants.GREEN_1),
                      child: Icon(Icons.done, size: 20, color: ColorConstants.WHITE,)): SvgPicture.asset(
                    isLocked == true
                        ? 'assets/images/lock_content.svg'
                        : 'assets/images/circular_border.svg',
                    width: 18,
                    height: 18,
                  ),
                  if (!isLast)
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      height:data?.completionPercentage == 100.0  && (cardType == CardType.assignment  || cardType == CardType.assessment) ?100 : 75,
                      width: 4,
                      decoration: BoxDecoration(
                          color: Color(0xffCECECE),
                          borderRadius: BorderRadius.circular(14)),
                    )
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.86,
              // height: 100,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: ColorConstants.WHITE,
                  borderRadius: BorderRadius.circular(10)),
              child: card(data!, cardType, isLocked),
            )
          ]),
    );
  }

  Widget card(CompetitionContent data, CardType? cardType, bool? isLocked) {
    String startDate = '${data.startDate?.split(' ').first}';
    DateTime start = DateFormat("yyyy-MM-dd").parse(startDate);
    return InkWell(
      onTap: () {
        if (isLocked == true) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Content Locked!'),
          ));
          return;
        }
        /*if (cardType == CardType.youtube) {
          Navigator.push(
              context,
              PageTransition(
                  duration: Duration(milliseconds: 300),
                  reverseDuration: Duration(milliseconds: 300),
                  type: PageTransitionType.bottomToTop,
                  child: CompetitionYoutubePlayer(
                    id: data.id,
                    videoUrl: data.content,
                  )));
        }*/
        /*else if (cardType == CardType.note) {
          Navigator.push(
              context,
              PageTransition(
                  duration: Duration(milliseconds: 300),
                  reverseDuration: Duration(milliseconds: 300),
                  type: PageTransitionType.bottomToTop,
                  child: CompetitionNotes(
                    id: data.id,
                    notesUrl: data.content,
                  )));
        }*/

        else if (cardType == CardType.assignment)
          Navigator.push(
              context,
              PageTransition(
                  duration: Duration(milliseconds: 300),
                  reverseDuration: Duration(milliseconds: 300),
                  type: PageTransitionType.bottomToTop,
                  child: ChangeNotifierProvider<AssignmentDetailProvider>(
                      create: (c) => AssignmentDetailProvider(
                          TrainingService(ApiService()), data,
                          fromCompletiton: true, id: data.programContentId),
                      child: AssignmentDetailPage(
                        id: data.id,
                        fromCompetition: false,
                      ))));
        else if (cardType == CardType.assessment) {
          Navigator.push(
              context,
              PageTransition(
                  duration: Duration(milliseconds: 300),
                  reverseDuration: Duration(milliseconds: 300),
                  type: PageTransitionType.bottomToTop,
                  child: ChangeNotifierProvider<AssessmentDetailProvider>(
                      create: (context) => AssessmentDetailProvider(
                          TrainingService(ApiService()), data,
                          fromCompletiton: false, id: data.programContentId),
                      child: AssessmentDetailPage(fromCompetition: false))));
        } else if (cardType == CardType.session) {
          Navigator.push(
              context,
              PageTransition(
                  duration: Duration(milliseconds: 300),
                  reverseDuration: Duration(milliseconds: 300),
                  type: PageTransitionType.bottomToTop,
                  child: CompetitionSession(
                    data: data,
                  )));
        }
      },
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${data.contentTypeLabel ?? ''}',
                style: Styles.regular(size: 12, color: ColorConstants.GREY_3)),
            SizedBox(height: 8),
            Text('${data.description}', style: Styles.bold(size: 12)),
            SizedBox(height: 13),
            Row(
              children: [
                /*Text('${data.difficultyLevel?.capital()}',
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
                Text('${data.gScore ?? 0} Points',
                    style: Styles.regular(
                        color: ColorConstants.ORANGE_4, size: 12)),*/
                Icon(
                  Icons.calendar_month,
                  size: 15,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  '${Utility.ordinal(start.day)} ${listOfMonths[start.month - 1]}',
                  style: Styles.regular(size: 12, color: Color(0xff5A5F73)),
                )
              ],
            ),

            if( data.completionPercentage == 100.0  && (cardType == CardType.assignment  || cardType == CardType.assessment))   Divider(),
            if( data.completionPercentage == 100.0  && (cardType == CardType.assignment  || cardType == CardType.assessment)) Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text:'Report: ',
                      style: Styles.regular(size: 12)),
                  TextSpan(
                      text: cardType == CardType.assignment ? '${data.marks}' : '${data.score}',
                      style: Styles.bold(size: 12, color: ColorConstants.GRADIENT_RED)),
                  TextSpan(
                      text:cardType == CardType.assignment ?  '/${data.passingMarks} Score':  '/${data.maximumMarks} Score',
                      style: Styles.regular(size: 12)),
                ],
              ),
            ),
          ]),
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

  //TODO:What is questions qqqqqq
  Widget _questionsSection() {
    return Container(
      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                Text('What’s in for you'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///Similar Jobs Widget
  Widget _recommendedJobsListCard() {
    return Container(
      color: ColorConstants.WHITE,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: Text('Similar Jobs',
                style: Styles.bold(size:16,color: ColorConstants.BLACK)),
          ),
          Divider(height: 1,color: ColorConstants.GREY_3,),

          //renderJobList(widget.jobListDetails) ,
        ],
      ),
    );
  }

 /* Widget renderJobList(jobList){
    return ListView.builder(
        itemCount: jobList?.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index){
          return jobList[index].id != widget.id ? Column(
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
                            Navigator.pushReplacement(context, NextPageRoute(JobDetailsPage(
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
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 5.0, ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${jobList?[index].title}',
                                    style: Styles.bold(
                                        size: 16, color: ColorConstants.BLACK)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                      '${jobList?[index].companyName}',
                                      style: Styles.regular(size:12,color: ColorConstants.GREY_3)),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Row(
                                    children: [
                                      Image.asset('assets/images/jobicon.png'),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5.0),
                                        child: Text('Exp: ',
                                            style: Styles.regular(size:12,color: ColorConstants.GREY_3)),
                                      ),
                                      Text('${jobList?[index].experience} Yrs',
                                          style: Styles.regular(size:12,color: ColorConstants.GREY_3)),

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
                              size: 15, color: ColorConstants.ORANGE)),),
                      ),
                    ],
                  ),
                ),
                *//*decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorConstants.WHITE,
                  boxShadow: [
                    BoxShadow(color: Colors.white, spreadRadius: 3),
                  ],
                ),*//*
              ),
              Divider(height: 1,color: ColorConstants.GREY_3,),
            ],
          ):SizedBox();
        });
  }*/

}

extension on String {
  String capital() {
    return this[0].toUpperCase() + this.substring(1);
  }
}