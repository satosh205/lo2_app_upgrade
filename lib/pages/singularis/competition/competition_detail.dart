import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/competition_content_list_resp.dart';
import 'package:masterg/data/models/response/home_response/competition_response.dart';
import 'package:masterg/data/models/response/home_response/training_detail_response.dart';
import 'package:masterg/data/models/response/home_response/training_module_response.dart';
import 'package:masterg/data/providers/assessment_detail_provider.dart';
import 'package:masterg/data/providers/assignment_detail_provider.dart';
import 'package:masterg/pages/ghome/widget/read_more.dart';
import 'package:masterg/pages/singularis/competition/competition_navigation/competition_notes.dart';
import 'package:masterg/pages/singularis/competition/competition_navigation/competition_session.dart';
import 'package:masterg/pages/singularis/competition/competition_navigation/competition_video.dart';
import 'package:masterg/pages/singularis/competition/competition_navigation/competition_youtube.dart';
import 'package:masterg/pages/training_pages/assessment_page.dart';
import 'package:masterg/pages/training_pages/assignment_detail_page.dart';
import 'package:masterg/pages/training_pages/training_service.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/constant.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../utils/Log.dart';

enum CardType { assignment, assessment, session, video, note, youtube }

class CompetitionDetail extends StatefulWidget {
  final Competition? competition;
  const CompetitionDetail({super.key, this.competition});

  @override
  State<CompetitionDetail> createState() => _CompetitionDetailState();
}

class _CompetitionDetailState extends State<CompetitionDetail> {
  TrainingModuleResponse? competitionDetail;
  TrainingDetailResponse? programDetail;
  CompetitionContentListResponse? contentList;
  bool? competitionDetailLoading;

  @override
  void initState() {
    getCompetitionContentList();
    super.initState();
  }

  // void getCompetitionDetail(int moduleId) {
  //   BlocProvider.of<HomeBloc>(context)
  //       .add(CompetitionDetailEvent(moduleId: moduleId));
  // }

  // void getProgramDetail() {
  //   BlocProvider.of<HomeBloc>(context)
  //       .add(TrainingDetailEvent(programId: widget.competition?.id));
  // }

  void getCompetitionContentList() {
    BlocProvider.of<HomeBloc>(context).add(
        CompetitionContentListEvent(competitionId: widget.competition?.id));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String startDate = '${widget.competition?.startDate?.split(' ').first}';
    DateTime start = DateFormat("yyyy-MM-dd").parse(startDate);
    return BlocManager(
        initState: (BuildContext context) {},
        child: BlocListener<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is CompetitionDetailState) {
                handlecompetitionDetailResponse(state);
              }
              if (state is TrainingDetailState)
                handleTrainingDetailState(state);

              if (state is CompetitionContentListState)
                handleCompetitionListState(state);
            },
            child: Scaffold(
              backgroundColor: Color(0xffF2F2F2),
              appBar: AppBar(
                  backgroundColor: Color(0xffF2F2F2),
                  elevation: 0,
                  leading: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: Color(0xff0E1638),
                      )),
                  title: Text(
                    '${widget.competition?.name}',
                    style: Styles.semibold(),
                  )),
              body: SingleChildScrollView(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: size.height * 0.3,
                    child: ClipRRect(
                      //borderRadius: BorderRadius.circular(0),
                      child: CachedNetworkImage(
                        imageUrl: '${widget.competition?.image}',
                        width: double.infinity,
                        // height: 120,
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/comp_emp.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.competition?.name}',
                          style: Styles.bold(color: Color(0xff0E1638)),
                        ),
                        SizedBox(
                          height: 3,
                        ),

                        if (widget.competition?.organizedBy != null)
                          Wrap(
                            children: [
                              Text(
                                'Conducted by ',
                                style: Styles.regular(
                                    size: 12, color: Color(0xff929BA3)),
                              ),
                              SizedBox(
                                child: Text(
                                  '${widget.competition?.organizedBy}',
                                  style: Styles.semibold(size: 12),
                                ),
                              ),
                            ],
                          ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 6),
                              margin: EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                  color: ColorConstants.WHITE,
                                  borderRadius: BorderRadius.circular(4)),
                              child: Text(
                                  '${widget.competition?.competitionLevel?.capital() ?? 'Easy'}',
                                  style: Styles.semibold(
                                    size: 12,
                                    color: ColorConstants.GREEN_1,
                                  )),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 6),
                                margin: EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                    color: ColorConstants.WHITE,
                                    borderRadius: BorderRadius.circular(4)),
                                child: Row(
                                  children: [
                                    SizedBox(
                                        height: 15,
                                        child: Image.asset(
                                            'assets/images/coin.png')),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text('${widget.competition?.gScore} Points',
                                        style: Styles.semibold(
                                          size: 12,
                                          color: ColorConstants.ORANGE_4,
                                        )),
                                  ],
                                )),
                            Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 6),
                                margin:
                                    EdgeInsets.only(left: 8, top: 8, bottom: 8),
                                decoration: BoxDecoration(
                                    color: ColorConstants.WHITE,
                                    borderRadius: BorderRadius.circular(4)),
                                child: Row(children: [
                                  Icon(
                                    Icons.calendar_month,
                                    size: 14,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    '${Utility.ordinal(start.day)} ${listOfMonths[start.month - 1]}',
                                    style: Styles.semibold(
                                        size: 12, color: Color(0xff5A5F73)),
                                  )
                                  // Text(
                                  //   '${Utility.convertDateFromMillis(int.parse('${widget.competition?.startDate?.split(" ")}'), "yyy-MM-dd")}',
                                  //   style: Styles.semibold(
                                  //       size: 12, color: Color(0xff5A5F73)),
                                  // )
                                ])),
                          ],
                        ),
                        ReadMoreText(
                          text: '${widget.competition?.description}',
                          color: Color(0xff5A5F73),
                          viewMore: 'view more',
                        ),
                        // Center(
                        //   child: Container(
                        //     width: size.width * 0.5,
                        //     padding: EdgeInsets.symmetric(
                        //         vertical: 8, horizontal: 8),
                        //     margin: EdgeInsets.symmetric(vertical: 10),
                        //     decoration: BoxDecoration(
                        //         border: Border.all(color: Color(0xffFF2452)),
                        //         borderRadius: BorderRadius.circular(8)),
                        //     child: Center(
                        //       child: Row(
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           Image.asset('assets/images/leaderboard.png'),
                        //           SizedBox(width: 8),
                        //           InkWell(
                        //             onTap: () {
                        //               // Navigator.of(context).push(
                        //               //     MaterialPageRoute(
                        //               //         builder: (context) =>
                        //               //             LeaderboardPage()));
                        //             },
                        //             child: Text('View Leaderboard',
                        //                 style: Styles.semibold(
                        //                     size: 12,
                        //                     color: Color(0xff5A5F73))),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: 4,
                        ),

                        if (competitionDetailLoading == false &&
                            contentList?.data?.list?.length != 0)
                          Text('Activities',
                              style: Styles.bold(
                                  size: 14, color: Color(0xff0E1638)))
                      ],
                    ),
                  ),
                  if (competitionDetailLoading == false) ...[
                    ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: contentList?.data?.list?.length,
                        itemBuilder: (context, index) {

                          bool isLocked = index != 0;

                          bool isTick = false;

                              // if(!empty($competitionVal['per_completion']) && in_array($competitionVal['content_type'], array('assignment','assessment')) && $competitionVal['overall_score'] >= $competitionVal['per_completion']){ 
                              //                        $tick = "fa fa-check";
                              //                    }elseif(!empty($competitionVal['per_completion']) && !empty($competitionVal['completion_percentage']) && $competitionVal['completion_percentage'] >= $competitionVal['per_completion']){ 
                              //                        $tick = "fa fa-check";
                              //                    }
                              //                    if($competitionVal['activity_status'] == 2){
                              //                        $tick = "fa fa-check";
                              //                    }

                          if (contentList?.data?.list?[index]
                                      ?.perCompletion !=
                                  0.0 &&
                              (contentList?.data?.list?[index]?.contentType ==
                                      'assignment' ||
                                  contentList
                                          ?.data?.list?[index]?.contentType ==
                                      'assessment') &&
                              double.parse(
                                      '${contentList?.data?.list?[index]?.overallScore ?? 0}') >=
                                  double.parse(
                                      '${contentList?.data?.list?[index]?.perCompletion ?? 0}')) {
                            isTick = true;
                          } else if (contentList?.data?.list?[index]
                                      ?.perCompletion !=
                                  0.0 && contentList?.data?.list?[index]
                                      ?.completionPercentage !=
                                  0.0 &&
                              double.parse(
                                      '${contentList?.data?.list?[index]?.completionPercentage}') >=
                                  double.parse(
                                      '${contentList?.data?.list?[index]?.perCompletion}')) {
                            isTick = true;
                          }
                          if (contentList?.data?.list?[index]?.activityStatus ==
                              2) {
                            isTick = true;
                          }

                          if (index != 0) {
                            CompetitionContent? data =
                                contentList?.data?.list?[index - 1];

                            if (data?.activityStatus != 0) {
                              if (data?.perCompletion != 0.0 &&
                                  (data?.contentType == 'assignment' ||
                                      data?.contentType == 'assessment') &&
                                  double.parse('${data?.overallScore ?? 0}') >=
                                      double.parse('${data?.perCompletion}')) {
                                isLocked = false;
                              } else if (data?.perCompletion != 0.0 &&
                                  (data?.completionPercentage != null ||
                                      data?.completionPercentage != 0.0) &&
                                  double.parse(
                                          '${data?.completionPercentage}') >=
                                      double.parse('${data?.perCompletion}')) {
                                isLocked = false;
                              }
                              if (data?.activityStatus == 2) {
                                isLocked = false;
                              }
                            }
                          }
                          return competitionCard(
                              contentList?.data?.list![index],
                              index ==
                                  ((contentList?.data?.list?.length ?? 1) - 1),
                              isLocked: isLocked,
                              isTick: isTick);
                        }),
                    SizedBox(
                      height: 3,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //what's in for you
                          if (contentList
                                  ?.data?.competitionInstructions?.whatsIn !=
                              null)
                            Text(
                              'What???s in for you',
                              style: Styles.bold(
                                  size: 14, color: Color(0xff5A5F73)),
                            ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Text(
                              '${contentList?.data?.competitionInstructions?.whatsIn ?? ''}',
                              style: Styles.regular(
                                  size: 14, color: Color(0xff5A5F73)),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          if (contentList?.data?.competitionInstructions
                                  ?.instructions !=
                              null)
                            Text(
                              'Instructions',
                              style: Styles.bold(
                                  size: 14, color: Color(0xff5A5F73)),
                            ),
                          SizedBox(
                            height: 4,
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Text(
                              '${contentList?.data?.competitionInstructions?.instructions ?? ''}',
                              style: Styles.regular(
                                  size: 14, color: Color(0xff5A5F73)),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),

                          if (contentList?.data?.competitionInstructions?.faq !=
                              null)
                            Text(
                              'FAQs',
                              style: Styles.bold(
                                  size: 14, color: Color(0xff5A5F73)),
                            ),
                          SizedBox(
                            height: 4,
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Text(
                              '${contentList?.data?.competitionInstructions?.faq ?? ''}',
                              style: Styles.regular(
                                  size: 14, color: Color(0xff5A5F73)),
                            ),
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
                              //              baseColor: ColorConstants.GRADIENT_RED.withOpacity(0.3),
                              // highlightColor: ColorConstants.GRADIENT_ORANGE.withOpacity(0.3),
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
              )),
            )));
  }

  Widget competitionCard(CompetitionContent? data, bool isLast,
      {bool? isLocked, bool? isTick}) {
    CardType? cardType;

    // if (data?.completionPercentage == 100.0) isLocked = false;
    // if (cardType != CardType.session && data?.completionPercentage == 100)
    //   isLocked = false;

    switch (data?.contentType) {
      case "video_yts":
        cardType = CardType.youtube;
        break;
      case "video":
        cardType = CardType.video;
        break;
      case "notes":
        cardType = CardType.note;

        break;
      case "assessment":
        cardType = CardType.assessment;

        break;
      case "assignment":
        cardType = CardType.assignment;

        break;
      case "zoomclass":
        cardType = CardType.session;
        // isLocked = false;
        break;
      case "liveclass":
        cardType = CardType.session;
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
                  isTick == true
                      ? Container(
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorConstants.GREEN_1),
                          child: Icon(
                            Icons.done,
                            size: 20,
                            color: ColorConstants.WHITE,
                          ))
                      : SvgPicture.asset(
                          isLocked == true
                              ? 'assets/images/lock_content.svg'
                              : 'assets/images/circular_border.svg',
                          width:22,
                          height: 22,
                        ),
                  if (!isLast)
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      height: data?.completionPercentage == 100.0 &&
                              (cardType == CardType.assignment ||
                                  cardType == CardType.assessment)
                          ? 100
                          : 75,
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
      onTap: () async {
        if (isLocked == true) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Content Locked!'),
          ));
          return;
        }
        if (cardType == CardType.video) {
          await Navigator.push(
              context,
              PageTransition(
                  duration: Duration(milliseconds: 300),
                  reverseDuration: Duration(milliseconds: 300),
                  type: PageTransitionType.bottomToTop,
                  child: CompetitionVideoPlayer(
                    id: data.id!,
                    videoUrl: data.content!,
                  )));
        }
        if (cardType == CardType.youtube) {
          await Navigator.push(
              context,
              PageTransition(
                  duration: Duration(milliseconds: 300),
                  reverseDuration: Duration(milliseconds: 300),
                  type: PageTransitionType.bottomToTop,
                  child: CompetitionYoutubePlayer(
                    id: data.id,
                    videoUrl: data.content,
                  )));
        } else if (cardType == CardType.note) {
          await Navigator.push(
              context,
              PageTransition(
                  duration: Duration(milliseconds: 300),
                  reverseDuration: Duration(milliseconds: 300),
                  type: PageTransitionType.bottomToTop,
                  child: CompetitionNotes(
                    id: data.id,
                    notesUrl: data.content,
                  )));
        } else if (cardType == CardType.assignment)
          await Navigator.push(
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
                        fromCompetition: true,
                        difficultyLevel:'${data.difficultyLevel?.capital()}',
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
                          fromCompletiton: true, id: data.programContentId),
                      child: AssessmentDetailPage(fromCompetition: true))));
        } else if (cardType == CardType.session) {
          await Navigator.push(
              context,
              PageTransition(
                  duration: Duration(milliseconds: 300),
                  reverseDuration: Duration(milliseconds: 300),
                  type: PageTransitionType.bottomToTop,
                  child: CompetitionSession(
                    data: data,
                  )));
        }
        getCompetitionContentList();
      },
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${data.contentTypeLabel ?? ''}',
                style: Styles.regular(size: 12, color: ColorConstants.GREY_3)),
            if (cardType != CardType.session) ...[
              SizedBox(height: 8),
              Text('${data.title}', style: Styles.bold(size: 12)),
            ],
            SizedBox(height: 8),
            if (cardType == CardType.session)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network('${data.baseFileUrl}/${data.presenterImage}',
                      height: height(context) * 0.06,
                      width: height(context) * 0.06,
                      errorBuilder: (_, __, ___) {
                    return SizedBox();
                  }),
                  SizedBox(
                    width: 8,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${data.presenter}',
                        style: Styles.bold(size: 14),
                      ),
                      Text(
                        '${data.title}',
                        style:
                            Styles.regular(size: 10, color: Color(0xff5A5F73)),
                      ),
                    ],
                  )
                ],
              ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Text(
                    cardType == CardType.note
                        ? '${data.pageCount ?? ''} pages'
                        : cardType == CardType.video ||
                                cardType == CardType.youtube
                            ? '${data.duration ?? data.expectedDuration} mins'
                            : '${data.difficultyLevel?.capital()}',
                    style: Styles.regular(
                        color: ColorConstants.GREEN_1, size: 12)),
                SizedBox(
                  width: 4,
                ),
                Text('???',
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
                        color: ColorConstants.ORANGE_4, size: 12)),
                SizedBox(
                  width: 4,
                ),
                Text('???',
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
                  '${Utility.ordinal(start.day)} ${listOfMonths[start.month - 1]}',
                  style: Styles.regular(size: 12, color: Color(0xff5A5F73)),
                )
              ],
            ),
            if (data.completionPercentage == 100.0 &&
                (cardType == CardType.assignment ||
                    cardType == CardType.assessment))
              Divider(),
            if (data.completionPercentage == 100.0 &&
                (cardType == CardType.assignment ||
                    cardType == CardType.assessment))
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Report: ', style: Styles.regular(size: 12)),
                    TextSpan(
                        text: cardType == CardType.assignment || cardType == CardType.assessment
                            ? '${data.overallScore}'
                            : '${data.completionPercentage}',
                           style: Styles.bold(
                            size: 12, color: ColorConstants.GRADIENT_RED)),
                    TextSpan(
                        text: cardType == CardType.assignment
                            ? ' / ${data.marks} Score'
                            : ' / ${data.maximumMarks} Score',
                               style: Styles.bold(
                            size: 12),
                    )
                   
                  ],
                ),
              ),
          ]),
    );
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

  void handleTrainingDetailState(TrainingDetailState state) {
    var competitionState = state;
    setState(() {
      switch (competitionState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          competitionDetailLoading = true;
          break;
        case ApiStatus.SUCCESS:
          Log.v("Training Competition State....................");
          programDetail = state.response;
          // getCompetitionDetail(int.parse(
          //     '${programDetail?.data?.list?.first.modules?.first.id}'));
          break;
        case ApiStatus.ERROR:
          Log.v(
              "Error Training Competition  ..........................${competitionState.error}");
          competitionDetailLoading = false;
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
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
    "January",
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
}

extension on String {
  String capital() {
    return this[0].toUpperCase() + this.substring(1);
  }
}

// <?php
//      $is_lock = 1;
//   if(!empty($competitionVal['per_completion']) && in_array($competitionVal['content_type'], array('assignment','assessment')) && $competitionVal['overall_score'] >= $competitionVal['per_completion']){
//      $is_lock = 0;
//   }elseif(!empty($competitionVal['per_completion']) && $competitionVal['completion_percentage'] >= $competitionVal['per_completion']){
//      $is_lock = 0;
//   }
//   if($competitionVal['activity_status'] == 2){
//      $is_lock = 0;
//   }
//   ?>

//                           if(per_completion != null (content_type == 'assignment' || assesment)  && overall_score > per_completion){
// $is_lock = 0;
// }
// else if(per_completion != null && completion_percentage >= per_completion ){

// }
// if(activity_status == 2){
//    islocked = 0;
// }
