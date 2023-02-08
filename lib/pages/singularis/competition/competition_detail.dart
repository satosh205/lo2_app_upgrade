import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
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
import 'package:masterg/pages/singularis/competition/competition_navigation/competition_youtube.dart';
import 'package:masterg/pages/training_pages/assessment_page.dart';
import 'package:masterg/pages/training_pages/assignment_detail_page.dart';
import 'package:masterg/pages/training_pages/training_service.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
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
                    height: size.height * 0.15,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: '${widget.competition?.image}',
                        width: double.infinity,
                        // height: 120,
                        errorWidget: (context, url, error) => SvgPicture.asset(
                          'assets/images/gscore_postnow_bg.svg',
                        ),
                        fit: BoxFit.contain,
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
                        if (widget.competition?.organizedBy != null)
                          Row(
                            children: [
                              Text(
                                'Conducted by ',
                                style: Styles.regular(
                                    size: 12, color: Color(0xff929BA3)),
                              ),
                              Text(
                                '${widget.competition?.organizedBy}',
                                style: Styles.semibold(size: 12),
                              ),
                            ],
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
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month,
                                      size: 14,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    // Text(
                                    //   '${Utility.convertDateFromMillis(int.parse('${widget.competition?.endDate}'), "dd MMM yyyy")}',
                                    //   style: Styles.semibold(
                                    //       size: 12, color: Color(0xff5A5F73)),
                                    // )
                                  ],
                                )),
                          ],
                        ),
                        ReadMoreText(
                          text: '${widget.competition?.description}',
                          color: Color(0xff5A5F73),
                        ),
                        Center(
                          child: Container(
                            width: size.width * 0.5,
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 8),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(0xffFF2452)),
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/leaderboard.png'),
                                  SizedBox(width: 8),
                                  InkWell(
                                    onTap: () {
                                      // Navigator.of(context).push(
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             LeaderboardPage()));
                                    },
                                    child: Text('View Leaderboard',
                                        style: Styles.semibold(
                                            size: 12,
                                            color: Color(0xff5A5F73))),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                          return competitionCard(
                              contentList?.data?.list![index],
                              index == (contentList!.data!.list!.length - 1),
                              isLocked: index != 0);
                        }),
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
                            style: Styles.regular(color: Color(0xff5A5F73)),
                          ),
                          SizedBox(
                            height: 40,
                          ),

                          Text(
                            'Instructions',
                            style:
                                Styles.bold(size: 14, color: Color(0xff5A5F73)),
                          ),
                          SizedBox(
                            height: 8,
                          ),

                          Text(
                            '${contentList?.data?.competitionInstructions?.instructions}',
                            style: Styles.regular(color: Color(0xff5A5F73)),
                          ),
                          SizedBox(
                            height: 40,
                          ),

                          Text(
                            'FAQs',
                            style:
                                Styles.bold(size: 14, color: Color(0xff5A5F73)),
                          ),
                          SizedBox(
                            height: 8,
                          ),

                          Text(
                            '${contentList?.data?.competitionInstructions?.faq}',
                            style: Styles.regular(color: Color(0xff5A5F73)),
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
      {bool? isLocked}) {
    CardType? cardType;

    if (data?.completionPercentage == 100) isLocked = false;
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
                  SvgPicture.asset(
                    isLocked == true
                        ? 'assets/images/lock_content.svg'
                        : 'assets/images/circular_border.svg',
                    width: 18,
                    height: 18,
                  ),
                  if (!isLast)
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      height: 75,
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
              child: card(data!, cardType),
            )
          ]),
    );
  }

  Widget card(CompetitionContent data, CardType? cardType) {
    return InkWell(
      onTap: () {
        if (cardType == CardType.youtube) {
          Navigator.push(
              context,
              PageTransition(
                  duration: Duration(milliseconds: 300),
                  reverseDuration: Duration(milliseconds: 300),
                  type: PageTransitionType.bottomToTop,
                  child: CompetitionYoutubePlayer(
                    videoUrl: data.content,
                  )));
        } else if (cardType == CardType.note) {
          Navigator.push(
              context,
              PageTransition(
                  duration: Duration(milliseconds: 300),
                  reverseDuration: Duration(milliseconds: 300),
                  type: PageTransitionType.bottomToTop,
                  child: CompetitionNotes(
                    notesUrl: data.content,
                  )));
        } else if (cardType == CardType.assignment)
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
                        fromCompetition: true,
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
            Navigator.push(
              context,
              PageTransition(
                  duration: Duration(milliseconds: 300),
                  reverseDuration: Duration(milliseconds: 300),
                  type: PageTransitionType.bottomToTop,
                  child: CompetitionSession(data: data,)));
            
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
            SizedBox(height: 8),
            Row(
              children: [
                Text('${data.difficultyLevel?.capital()}',
                    style: Styles.regular(
                        color: ColorConstants.GREEN_1, size: 12)),
                SizedBox(
                  width: 4,
                ),
                Text('•',
                    style: Styles.regular(
                        color: ColorConstants.GREY_2, size: 12)),
                SizedBox(
                  width: 4,
                ),
                SizedBox(
                    height: 15,
                    child: Image.asset('assets/images/coin.png')),
                SizedBox(
                  width: 4,
                ),
                Text('${data.gScore ?? 0} Points',
                    style: Styles.regular(
                        color: ColorConstants.ORANGE_4, size: 12)),
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
                  '31st December',
                  style: Styles.regular(
                      size: 12, color: Color(0xff5A5F73)),
                )
              ],
            )
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
}


extension on String {
  String capital() {
    return this[0].toUpperCase() + this.substring(1);
  }
}
