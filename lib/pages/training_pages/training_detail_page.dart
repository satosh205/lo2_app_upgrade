// ignore_for_file: unused_field

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/providers/assessment_detail_provider.dart';
import 'package:masterg/data/providers/assignment_detail_provider.dart';
import 'package:masterg/data/providers/my_course_provider.dart';
import 'package:masterg/data/providers/training_content_provider.dart';
import 'package:masterg/data/providers/training_detail_provider.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/training_pages/assessment_page.dart';
import 'package:masterg/pages/training_pages/assignment_detail_page.dart';
import 'package:masterg/pages/training_pages/training_service.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/custom_progress_indicator.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../utils/Strings.dart';
import '../../utils/utility.dart';
import '../custom_pages/custom_widgets/pdf_view_page.dart';

String selectedType = 'Classes';
int? selectedContentId;
dynamic selectedData;
bool? isAllSelected;
late VideoPlayerController _controller;
late YoutubePlayerController _ytController;
double opacityLevel = 1.0;

bool? isYoutubeView;

class TrainingDetailPage extends StatefulWidget {
  @override
  State<TrainingDetailPage> createState() => _TrainingDetailPageState();
}

class _TrainingDetailPageState extends State<TrainingDetailPage> {
  late BuildContext mContext;
  late String selectedItemName = '';
  bool isNoteView = false;
  String noteUrl = '';
  String noteImgUrl = '';
  // late Route<Object?> routeWidget;
  Function? onClickRoute;

  static bool isOpened = false;
  double popupHeight = 300;

  /*ExpandableController additionalInfoController=ExpandableController(
    initialExpanded: isOpened,
  );
*/
  @override
  void initState() {
    super.initState();

    isAllSelected = true;
    _controller = VideoPlayerController.network('')..initialize().then((_) {});
    _ytController = YoutubePlayerController(initialVideoId: '');
  }

  @override
  void dispose() {
    selectedData = null;
    selectedContentId = null;
    isAllSelected = null;

    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mContext = context;
    final traininDetailProvider = Provider.of<TrainingDetailProvider>(context);
    return Scaffold(
        key: traininDetailProvider.scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: ColorConstants.BG_GREY,
        appBar: AppBar(
          title: Text(traininDetailProvider.program!.name ?? "My Courses",
              style: Styles.bold(size: 18)),
          centerTitle: false,
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              selectedData = null;
              selectedContentId = null;
              _controller.pause();

              Navigator.pop(context);
            },
          ),
        ),
        body: MultiProvider(
          providers: [
            ChangeNotifierProvider<MyCourseProvider>(
              create: (context) => MyCourseProvider(_controller),
            ),
          ],
          child: _content(traininDetailProvider, context),
        ));
  }

  Widget? trainingDetailWidget(
      TrainingDetailProvider traininDetailProvider, context) {
    Widget? trainingDetailWidget;
    switch (traininDetailProvider.apiStatus) {
      case ApiStatus.INITIAL:
        trainingDetailWidget = Center(
          child: CustomProgressIndicator(true, ColorConstants.GREY),
        );
        break;
      case ApiStatus.LOADING:
        trainingDetailWidget =
            CustomProgressIndicator(true, ColorConstants.GREY);
        break;
      case ApiStatus.SUCCESS:
        trainingDetailWidget = _content(traininDetailProvider, context);
        break;
      case ApiStatus.ERROR:
        trainingDetailWidget = Center(
          child: Text('${traininDetailProvider.error}'),
        );
        break;
    }
    return trainingDetailWidget;
  }

  void openAssignment(dynamic data) {
    Navigator.push(
      context,
      NextPageRoute(
          ChangeNotifierProvider<AssignmentDetailProvider>(
              create: (c) =>
                  AssignmentDetailProvider(TrainingService(ApiService()), data),
              child: AssignmentDetailPage(
                id: data.programContentId,
              )),
          isMaintainState: true),
    );
  }

  void openAssessment(dynamic data) {
    Navigator.push(
        context,
        NextPageRoute(
            ChangeNotifierProvider<AssessmentDetailProvider>(
                create: (context) => AssessmentDetailProvider(
                    TrainingService(ApiService()), data),
                child: AssessmentDetailPage()),
            isMaintainState: true));
  }

  Widget _content(TrainingDetailProvider trainingDetailProvider, context) {
    String title = '';
    bool isButtonActive = true;

    if (selectedType == 'Assignment' && selectedContentId != null) {
      title = 'Start Assignment';
    } else if (selectedType == 'Classes' && selectedContentId != null) {
      if (selectedData?.liveclassAction.toString().toLowerCase() == 'concluded')
        title = 'View Recording';
      else if (selectedData?.liveclassAction.toString().toLowerCase() == 'live')
        title = 'Join Now';
      else
        title = selectedData?.liveclassAction;

      // title = selectedData?.contentType!.toLowerCase() == "liveclass" ||
      //         selectedData?.contentType!.toLowerCase() == "zoomclass"
      //     ? "Join Now"
      //     : "Mark your attendance";
    } else if (selectedType == 'Assessments' && selectedContentId != null) {
      title = 'Start Assessment';
    } else if (selectedType == 'Notes' && selectedContentId != null) {
      title = 'View Notes';
    } else if (selectedType == 'Videos' && selectedContentId != null) {
      title = 'Start Video';
    } else if (selectedType == 'Quiz' && selectedContentId != null) {
      if (selectedData.status == 'Active' &&
          selectedData.attemptAllowed == selectedData.attemptsRemaining)
        title = 'Start Quiz';
      else
        title = 'Re-Submit/ Review';
      if (selectedData.attemptsRemaining == 0) {
        isButtonActive = false;
      }
    }

    return Column(
      // shrinkWrap: true,

      children: [
        selectedContentId != null
            ? SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: AspectRatio(
                    aspectRatio:
                        !isNoteView ? _controller.value.aspectRatio : 16 / 9,
                    child: Stack(
                      // alignment: Alignment.center,
                      children: [
                        Hero(
                          tag: 'videoPlayer',
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  opacityLevel =
                                      opacityLevel == 1.0 ? 0.0 : 1.0;
                                });
                                // if (selectedType == 'Notes') {
                                //   playVideo(context);
                                // } else if (selectedType == 'Assignment') {
                                //   openAssignment(selectedData);
                                // } else if (selectedType == 'Quiz') {
                                //   openAssessment(selectedData);
                                // }
                              },
                              child: !isNoteView
                                  ? isYoutubeView == true
                                      ? YoutubePlayer(
                                          controller: _ytController,
                                          showVideoProgressIndicator: false,
                                          bottomActions: [
                                            CurrentPosition(),
                                            RemainingDuration(),
                                            ProgressBar(
                                              isExpanded: true,
                                              colors: ProgressBarColors(
                                                  handleColor: ColorConstants
                                                      .PRIMARY_COLOR,
                                                  bufferedColor:
                                                      ColorConstants.BG_GREY,
                                                  backgroundColor:
                                                      ColorConstants
                                                          .PRIMARY_COLOR
                                                          .withOpacity(0.3)),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                // _ytController.pause();

                                                YoutubePlayerController cntrl =
                                                    _ytController;

                                                _ytController.pause();

                                                await Navigator.push(
                                                    context,
                                                    NextPageRoute(
                                                        FullScreenYoutubePlayer(
                                                          controller: cntrl,
                                                        ),
                                                        isMaintainState:
                                                            false));

                                                SystemChrome
                                                    .setPreferredOrientations([
                                                  DeviceOrientation.portraitUp
                                                ]);
                                              },
                                              child: Icon(
                                                Icons.fullscreen,
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                          // bottomActions: [
                                          //   CurrentPosition(),
                                          //   SizedBox(
                                          //     width: 10,
                                          //   ),
                                          //   ProgressBar(
                                          //     isExpanded: true,
                                          //   ),
                                          //   SizedBox(
                                          //     width: 10,
                                          //   ),
                                          //   RemainingDuration(),
                                          //   SizedBox(
                                          //     width: 10,
                                          //   ),
                                          //   FullScreenButton(
                                          //       // onFullScreen: () {
                                          //       //   setState(() {
                                          //       //     isFullScreen = true;
                                          //       //   });
                                          //       // },
                                          //       // onExit: () {
                                          //       //   setState(() {
                                          //       //     isFullScreen = false;
                                          //       //   });
                                          //       // },
                                          //       ),
                                          // ],
                                        )
                                      : VideoPlayer(_controller)
                                  : Stack(
                                      children: [
                                        selectedType != 'Assignment' &&
                                                selectedType != 'Quiz'
                                            ? ColorFiltered(
                                                colorFilter: ColorFilter.mode(
                                                    selectedType == 'Classes'
                                                        ? Colors.black
                                                            .withOpacity(0.2)
                                                        : Colors.black
                                                            .withOpacity(1),
                                                    BlendMode.dstATop),
                                                child: CachedNetworkImage(
                                                  width: double.infinity,
                                                  imageUrl: noteImgUrl,
                                                  fit: BoxFit.cover,
                                                ))
                                            : Container(
                                                color: ColorConstants.COURSE_BG,
                                                width: double.infinity,
                                              ),
                                        if (selectedType == 'Classes')
                                          Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 8, horizontal: 8),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          '${Utility.convertDateFromMillis(selectedData.startDate, Strings.REQUIRED_DATE_DD_MMM_YYYY)}'),
                                                      Container(
                                                        width: 40,
                                                        height: 20,
                                                        decoration: BoxDecoration(
                                                            color:
                                                                ColorConstants
                                                                    .WHITE,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4)),
                                                        child: Center(
                                                            child:
                                                                Text('Live')),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text('Instructor name'),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    '${selectedData.title}',
                                                    style:
                                                        Styles.bold(size: 16),
                                                  )
                                                ],
                                              )),
                                        if (selectedType == 'Assignment' ||
                                            selectedType == 'Quiz' &&
                                                selectedContentId != null)
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Submit before: ${Utility.convertDateFromMillis(selectedData.endDate, Strings.REQUIRED_DATE_DD_MMM_YYYY)}',
                                                      // '${selectedType}',
                                                      style: Styles.bold(
                                                          size: 14,
                                                          color: ColorConstants
                                                              .WHITE),
                                                    ),
                                                    if (selectedType == 'Quiz')
                                                      Text(
                                                        '${selectedData.durationInMinutes} mins',
                                                        // '${selectedType}',
                                                        style: Styles.bold(
                                                            size: 14,
                                                            color:
                                                                ColorConstants
                                                                    .WHITE),
                                                      ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Text('${selectedData.title}',
                                                    style: Styles.bold(
                                                        size: 16,
                                                        color: ColorConstants
                                                            .WHITE)),
                                                Row(
                                                  children: [
                                                    Text(
                                                      '80/100 marks',
                                                      style: Styles.regular(
                                                          size: 14,
                                                          color: ColorConstants
                                                              .WHITE),
                                                    ),
                                                    if (selectedType == 'Quiz')
                                                      Text(
                                                        ' .  ${selectedData.attemptsRemaining} attemps available',
                                                        style: Styles.regular(
                                                            size: 14,
                                                            color:
                                                                ColorConstants
                                                                    .WHITE),
                                                      ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        Positioned(
                                          bottom: 10,
                                          left: 50,
                                          right: 50,
                                          child: GestureDetector(
                                            onTap: () {
                                              if (isButtonActive) {
                                                _controller.pause();

                                                if (selectedType == 'Classes') {
                                                  // playVideo(context);
                                                }
                                                if (selectedType == 'Notes') {
                                                  playVideo(context);
                                                } else if (selectedType ==
                                                    'Assignment') {
                                                  openAssignment(selectedData);
                                                } else if (selectedType ==
                                                    'Quiz') {
                                                  openAssessment(selectedData);
                                                }
                                              }
                                            },
                                            child: Container(
                                                width: 150,
                                                height: 38,
                                                decoration: BoxDecoration(
                                                    color: !isButtonActive
                                                        ? ColorConstants.GREY_2
                                                        : selectedType == 'Quiz'
                                                            ? selectedData
                                                                        .status ==
                                                                    'Active'
                                                                ? ColorConstants
                                                                    .PRIMARY_COLOR
                                                                : ColorConstants
                                                                    .GREY_2
                                                            : ColorConstants
                                                                .PRIMARY_COLOR,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: Center(
                                                  child: Text(
                                                    '$title',
                                                    style: Styles.regular(
                                                        size: 14,
                                                        color: ColorConstants
                                                            .WHITE),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ],
                                    )),
                          transitionOnUserGestures: true,
                        ),
                        if (!isNoteView && isYoutubeView == false)
                          Positioned.fill(
                              child: AnimatedOpacity(
                            opacity: opacityLevel,
                            duration: const Duration(seconds: 2),
                            child: Visibility(
                              visible: opacityLevel == 1.0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        _controller.seekTo(Duration(
                                            seconds: _controller
                                                    .value.position.inSeconds -
                                                10));
                                      },
                                      child: SvgPicture.asset(
                                        'assets/images/rewind.svg',
                                        color: ColorConstants.WHITE,
                                        height: 30,
                                        width: 30,
                                        allowDrawingOutsideViewBox: true,
                                      )),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _controller.value.isPlaying
                                            ? _controller.pause()
                                            : _controller.play();
                                      });
                                    },
                                    child: !_controller.value.isPlaying
                                        ? SvgPicture.asset(
                                            'assets/images/play.svg',
                                            color: ColorConstants.WHITE,
                                            height: 30,
                                            width: 30,
                                            allowDrawingOutsideViewBox: true,
                                          )
                                        : Icon(Icons.pause,
                                            color: ColorConstants.WHITE,
                                            size: 30),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        _controller.seekTo(Duration(
                                            seconds: _controller
                                                    .value.position.inSeconds +
                                                10));
                                      },
                                      child: SvgPicture.asset(
                                        'assets/images/forward.svg',
                                        color: ColorConstants.WHITE,
                                        height: 30,
                                        width: 30,
                                        allowDrawingOutsideViewBox: true,
                                      )),
                                ],
                              ),
                            ),
                          )),
                        if (!isNoteView && isYoutubeView == false)
                          Positioned(
                            bottom: 6,
                            right: 6,
                            child: GestureDetector(
                                onTap: () {
                                  playVideo(context);
                                },
                                child: SvgPicture.asset(
                                  'assets/images/full_screen_video.svg',
                                  color: ColorConstants.WHITE,
                                  height: 26,
                                  width: 26,
                                  allowDrawingOutsideViewBox: true,
                                )),
                          ),
                        if (!isNoteView && isYoutubeView == false)
                          Positioned(
                              bottom: 6,
                              left: 6,
                              child: ValueListenableBuilder(
                                valueListenable: _controller,
                                builder:
                                    (context, VideoPlayerValue value, child) {
                                  //Do Something with the value.
                                  return Text(
                                    '${value.position.toString().substring(0, 7)}/${value.duration.toString().substring(0, 7)}',
                                    style: Styles.regular(
                                        color: ColorConstants.WHITE),
                                  );
                                },
                              )),
                      ],
                    ),
                  ),
                ),
              )
            : isAllSelected == true
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.20,
                    color: ColorConstants.GREY_4,
                    child: Center(child: CircularProgressIndicator()),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.20,
                    color: ColorConstants.WHITE,
                    child: Center(
                        child: Text(
                      'No Content found',
                      style: Styles.regular(),
                    )),
                  ),
        if (!isNoteView && isYoutubeView == false)
          VideoProgressIndicator(
            _controller,
            allowScrubbing: true,
            padding: EdgeInsets.all(0),
            colors: VideoProgressColors(
                backgroundColor: ColorConstants.GREY_3,
                bufferedColor: ColorConstants.GREY_3,
                playedColor: ColorConstants().primaryColor()),
          ),
        if (selectedType == 'Videos' && selectedContentId != null)
          Container(
            color: ColorConstants.WHITE,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Now playing',
                    style: Styles.regular(
                      size: 14,
                    )),
                Text('$selectedItemName', style: Styles.semibold(size: 16)),
              ],
            ),
          ),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      isAllSelected = true;

                      selectedContentId = null;

                      _controller.pause();

                      setState(() {});
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      margin: EdgeInsets.only(top: 6, right: 6, bottom: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: isAllSelected == true
                              ? ColorConstants().primaryColor()
                              : ColorConstants.WHITE),
                      child: Text('All',
                          style: Styles.regular(
                              size: 14,
                              color: isAllSelected == true
                                  ? ColorConstants.WHITE
                                  : ColorConstants.GREY_3)),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      selectedType = 'Classes';
                      isAllSelected = false;

                      selectedContentId = null;
                      _controller.pause();

                      setState(() {});
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      margin: EdgeInsets.only(top: 6, right: 6, bottom: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: selectedType == 'Classes' &&
                                  isAllSelected == false
                              ? ColorConstants().primaryColor()
                              : ColorConstants.WHITE),
                      child: Text('Classes',
                          style: Styles.regular(
                              size: 14,
                              color: selectedType == 'Classes' &&
                                      isAllSelected == false
                                  ? ColorConstants.WHITE
                                  : ColorConstants.GREY_3)),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        selectedType = 'Videos';
                        isAllSelected = false;

                        selectedContentId = null;

                        _controller.pause();

                        setState(() {});
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        margin: EdgeInsets.only(top: 6, right: 6, bottom: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: selectedType == 'Videos' &&
                                    isAllSelected == false
                                ? ColorConstants().primaryColor()
                                : ColorConstants.WHITE),
                        child: Text('Videos',
                            style: Styles.regular(
                                size: 14,
                                color: selectedType == 'Videos' &&
                                        isAllSelected == false
                                    ? ColorConstants.WHITE
                                    : ColorConstants.GREY_3)),
                      )),
                  InkWell(
                      onTap: () {
                        selectedType = 'Notes';
                        selectedContentId = null;
                        isAllSelected = false;

                        _controller.pause();

                        setState(() {});
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        margin: EdgeInsets.only(top: 6, right: 6, bottom: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: selectedType == 'Notes' &&
                                    isAllSelected == false
                                ? ColorConstants().primaryColor()
                                : ColorConstants.WHITE),
                        child: Text('Notes',
                            style: Styles.regular(
                                size: 14,
                                color: selectedType == 'Notes' &&
                                        isAllSelected == false
                                    ? ColorConstants.WHITE
                                    : ColorConstants.GREY_3)),
                      )),
                  InkWell(
                      onTap: () {
                        setState(() {
                          selectedType = 'Assignment';
                          selectedContentId = null;
                          isAllSelected = false;

                          _controller.pause();
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        margin: EdgeInsets.only(top: 6, right: 6, bottom: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: selectedType == 'Assignment' &&
                                    isAllSelected == false
                                ? ColorConstants().primaryColor()
                                : ColorConstants.WHITE),
                        child: Text('Assignment',
                            style: Styles.regular(
                                size: 14,
                                color: selectedType == 'Assignment' &&
                                        isAllSelected == false
                                    ? ColorConstants.WHITE
                                    : ColorConstants.GREY_3)),
                      )),
                  InkWell(
                      onTap: () {
                        setState(() {
                          selectedType = 'Quiz';
                          selectedContentId = null;
                          isAllSelected = false;

                          _controller.pause();
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        margin: EdgeInsets.only(top: 6, right: 6, bottom: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color:
                                selectedType == 'Quiz' && isAllSelected == false
                                    ? ColorConstants().primaryColor()
                                    : ColorConstants.WHITE),
                        child: Text('Quiz',
                            style: Styles.regular(
                                size: 14,
                                color: selectedType == 'Quiz' &&
                                        isAllSelected == false
                                    ? ColorConstants.WHITE
                                    : ColorConstants.GREY_3)),
                      ))
                ],
              ),
            )),
        Expanded(
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: trainingDetailProvider.modules!.length,
              itemBuilder: (context, index) {
                bool isVisible = true;
                return Visibility(
                  visible: isVisible,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      margin: EdgeInsets.symmetric(vertical: 0),
                      decoration: BoxDecoration(
                        color: ColorConstants.WHITE,
                      ),
                      child: ExpandablePanel(
                        controller: ExpandableController(initialExpanded: true),
                        header: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${trainingDetailProvider.modules!.elementAt(index).name}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: Styles.bold(size: 16)),
                            Text(
                              '${trainingDetailProvider.modules!.elementAt(index).description}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: Styles.regular(size: 14),
                            )
                          ],
                        ),
                        collapsed: SizedBox(
                          height: 0,
                        ),
                        expanded:
                            ChangeNotifierProvider<TrainingContentProvier>(
                                create: (context) => TrainingContentProvier(
                                    TrainingService(ApiService()),
                                    trainingDetailProvider.modules!
                                        .elementAt(index)),
                                child: ModuleCourseCard(
                                  sendValue: (dynamic controller,
                                      String title,
                                      bool isNote,
                                      String NoteUrl,
                                      String noteImageUrl,
                                      // Function? onClick,
                                      dynamic data,
                                      {isYoutubeController = false}
                                      // Route<Object?>? widget
                                      ) {
                                    isYoutubeView = isYoutubeController;
                                    selectedItemName = title;
                                    isNoteView = isNote;
                                    selectedData = data;
                                    if (isNote) {
                                      setState(() {
                                        noteUrl = NoteUrl;
                                        noteImgUrl = noteImageUrl;

                                        popupHeight =
                                            MediaQuery.of(context).size.height;
                                      });
                                    } else {
                                      setState(() {
                                        print(
                                            'check is  $isYoutubeController and ${controller}');
                                        isYoutubeController == true
                                            ? _ytController = controller
                                            : _controller = controller;
                                        popupHeight = 300;
                                        // if (isYoutubeController == true)
                                        _controller
                                            .initialize()
                                            .then((value) => setState(() {
                                                  _controller.play();
                                                }));
                                      });
                                    }
                                  },
                                )),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }

  playVideo(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
            height: double.infinity,
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.cancel,
                      color: Colors.white,
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                    height: popupHeight,
                    //height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: Stack(
                        // alignment: Alignment.center,
                        children: [
                          Hero(
                            tag: 'videoPlayer',
                            child: isNoteView
                                ? PdfViewPage(
                                    url: '$noteUrl',
                                    callBack: false,
                                  )
                                : VideoPlayer(_controller),
                          ),

// ValueListenableBuilder(
//                                 valueListenable: _controller,
//                                 builder:
//                                     (context, VideoPlayerValue value, child) {
//                                   //Do Something with the value.
//                                   return Text(
//                                     '${value.position.toString().substring(0, 7)}/${value.duration.toString().substring(0, 7)}',
//                                     style: Styles.regular(
//                                         color: ColorConstants.WHITE),
//                                   );
//                                 },
//                               ))

                          if (!isNoteView)
                            Positioned.fill(
                              child: ValueListenableBuilder(
                                valueListenable: _controller,
                                builder:
                                    (context, VideoPlayerValue value, child) {
                                  //Do Something with the value.
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            _controller.seekTo(Duration(
                                                seconds: _controller.value
                                                        .position.inSeconds -
                                                    10));
                                          },
                                          child: SvgPicture.asset(
                                            'assets/images/rewind.svg',
                                            color: ColorConstants.WHITE,
                                            height: 30,
                                            width: 30,
                                            allowDrawingOutsideViewBox: true,
                                          )),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _controller.value.isPlaying
                                                ? _controller.pause()
                                                : _controller.play();
                                          });
                                        },
                                        child: !value.isPlaying
                                            ? SvgPicture.asset(
                                                'assets/images/play.svg',
                                                color: ColorConstants.WHITE,
                                                height: 30,
                                                width: 30,
                                                allowDrawingOutsideViewBox:
                                                    true,
                                              )
                                            : Icon(Icons.pause,
                                                color: ColorConstants.WHITE,
                                                size: 30),
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            _controller.seekTo(Duration(
                                                seconds: _controller.value
                                                        .position.inSeconds +
                                                    10));
                                          },
                                          child: SvgPicture.asset(
                                            'assets/images/forward.svg',
                                            color: ColorConstants.WHITE,
                                            height: 30,
                                            width: 30,
                                            allowDrawingOutsideViewBox: true,
                                          )),
                                    ],
                                  );
                                },
                              ),
                            ),
                          if (!isNoteView)
                            Positioned(
                              bottom: 0,
                              child: Container(
                                  color: Colors.red,
                                  height: 4,
                                  width: MediaQuery.of(context).size.width,
                                  child: VideoProgressIndicator(
                                    _controller,
                                    allowScrubbing: true,
                                    padding: EdgeInsets.all(0),
                                    colors: VideoProgressColors(
                                        backgroundColor: ColorConstants.GREY_3,
                                        bufferedColor: ColorConstants.GREY_3,
                                        playedColor:
                                            ColorConstants().primaryColor()),
                                  )),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class ModuleCourseCard extends StatefulWidget {
  final Function? sendValue;

  const ModuleCourseCard({super.key, this.sendValue});

  @override
  State<ModuleCourseCard> createState() => _ModuleCourseCardState();
}

class _ModuleCourseCardState extends State<ModuleCourseCard> {
  late BuildContext mContext;
  bool isFirstLoaded = false;

  @override
  void initState() {
    isFirstLoaded = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final traininDetailProvider = Provider.of<TrainingContentProvier>(context);

    return Column(
      children: [
        if (traininDetailProvider.trainingModuleResponse.data?.module![0]
                    .content?.sessions?.length !=
                0 &&
            (selectedType == 'Classes' || isAllSelected == true))
          ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: traininDetailProvider.trainingModuleResponse.data
                  ?.module![0].content?.sessions?.length,
              itemBuilder: (BuildContext context, int index) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (selectedContentId == null) {
                    selectedType = 'Classes';
                    setState(() {
                      selectedContentId = traininDetailProvider
                          .trainingModuleResponse
                          .data
                          ?.module![0]
                          .content
                          ?.sessions
                          ?.first
                          .programContentId;
                    });
                    _controller.pause();
                    String? videoUrl = traininDetailProvider
                        .trainingModuleResponse
                        .data
                        ?.module![0]
                        .content
                        ?.sessions
                        ?.first
                        .url;

                    dynamic controller =
                        VideoPlayerController.network('$videoUrl');

                    widget.sendValue!(
                      controller,
                      '${traininDetailProvider.trainingModuleResponse.data?.module![0].content?.sessions?.first.title}',
                      true,
                      '${traininDetailProvider.trainingModuleResponse.data?.module![0].content?.sessions?.first.url}',
                      '${traininDetailProvider.trainingModuleResponse.data?.module![0].content?.sessions?.first.image}',
                      traininDetailProvider.trainingModuleResponse.data
                          ?.module![0].content?.sessions?.first,
                      isYoutubeController: true,
                    );
                  }
                });
                return _moduleCard(
                    leadingid: traininDetailProvider
                                .trainingModuleResponse
                                .data
                                ?.module![0]
                                .content
                                ?.sessions![index]
                                .liveclassAction ==
                            'Concluded'
                        ? 2
                        : traininDetailProvider
                                    .trainingModuleResponse
                                    .data
                                    ?.module![0]
                                    .content
                                    ?.sessions![index]
                                    .liveclassAction ==
                                'Join Class'
                            ? 3
                            : 1,
                    '${traininDetailProvider.trainingModuleResponse.data?.module![0].content?.sessions![index].title}',
                    '${traininDetailProvider.trainingModuleResponse.data?.module![0].content?.sessions![index].description}',
                    'session',
                    traininDetailProvider
                        .trainingModuleResponse.data?.module![0].content,
                    index,
                    context,
                    traininDetailProvider
                        .trainingModuleResponse
                        .data
                        ?.module![0]
                        .content
                        ?.sessions![index]
                        .programContentId);
              }),
        if (traininDetailProvider.trainingModuleResponse.data?.module![0]
                    .content?.assessments?.length !=
                0 &&
            (selectedType == 'Quiz' || isAllSelected == true))
          ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: traininDetailProvider.trainingModuleResponse.data
                ?.module![0].content?.assessments?.length,
            itemBuilder: (BuildContext context, int index) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (selectedContentId == null) {
                  selectedType = 'Quiz';
                  _controller.pause();
                  widget.sendValue!(
                    VideoPlayerController.network(
                        '${traininDetailProvider.trainingModuleResponse.data?.module![0].content?.assessments?.first.url}'),
                    '${traininDetailProvider.trainingModuleResponse.data?.module![0].content?.assessments?.first.title}',
                    true,
                    '${traininDetailProvider.trainingModuleResponse.data?.module![0].content?.assessments?.first.url}',
                    '',
                    traininDetailProvider.trainingModuleResponse.data
                        ?.module![0].content?.assessments?.first,
                  );

                  setState(() {
                    selectedContentId = traininDetailProvider
                        .trainingModuleResponse
                        .data
                        ?.module![0]
                        .content
                        ?.assessments
                        ?.first
                        .programContentId;
                  });
                }
              });
              return _moduleCard(
                  '${traininDetailProvider.trainingModuleResponse.data?.module![0].content?.assessments![index].title}',
                  '${capitalize(traininDetailProvider.trainingModuleResponse.data?.module![0].content?.assessments![index].contentType)}',
                  'assessment',
                  traininDetailProvider
                      .trainingModuleResponse.data?.module![0].content,
                  index,
                  context,
                  traininDetailProvider.trainingModuleResponse.data?.module![0]
                      .content?.assessments![index].programContentId);
            },
          ),
        if (traininDetailProvider.trainingModuleResponse.data?.module![0]
                    .content?.assignments?.length !=
                0 &&
            (selectedType == 'Assignment' || isAllSelected == true))
          ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: traininDetailProvider.trainingModuleResponse.data
                  ?.module![0].content?.assignments?.length,
              itemBuilder: (BuildContext context, int index) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    if (selectedContentId == null) {
                      selectedType = 'Assignment';
                      selectedContentId = traininDetailProvider
                          .trainingModuleResponse
                          .data
                          ?.module![0]
                          .content
                          ?.assignments![0]
                          .programContentId;
                      _controller.pause();
                      widget.sendValue!(
                          VideoPlayerController.network(
                              '${traininDetailProvider.trainingModuleResponse.data?.module![0].content?.assignments![0].url}'),
                          '${traininDetailProvider.trainingModuleResponse.data?.module![0].content?.assignments![0].title}',
                          true,
                          '${traininDetailProvider.trainingModuleResponse.data?.module![0].content?.assignments![0].url}',
                          'https://qa.learningoxygen.com/images/programs/2095.jpeg',
                          traininDetailProvider.trainingModuleResponse.data
                              ?.module![0].content?.assignments![0]);
                    }
                  });
                });
                return _moduleCard(
                    '${traininDetailProvider.trainingModuleResponse.data?.module![0].content?.assignments![index].title}',
                    '${capitalize(traininDetailProvider.trainingModuleResponse.data?.module![0].content?.assignments![index].contentType)}',
                    'assignment',
                    traininDetailProvider
                        .trainingModuleResponse.data?.module![0].content,
                    index,
                    context,
                    traininDetailProvider
                        .trainingModuleResponse
                        .data
                        ?.module![0]
                        .content
                        ?.assignments![index]
                        .programContentId);
              }),
        if (traininDetailProvider.trainingModuleResponse.data?.module![0]
                    .content?.learningShots?.length !=
                0 &&
            (selectedType == 'Videos' ||
                selectedType == 'Notes' ||
                isAllSelected == true))
          Consumer<MyCourseProvider>(
            builder: (context, value, child) => ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: traininDetailProvider.trainingModuleResponse.data
                  ?.module![0].content?.learningShots?.length,
              itemBuilder: (BuildContext context, int index) {
                dynamic list;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (selectedContentId == null) {
                    setState(() {
                      if (selectedType == 'Videos') {
                        selectedType = 'Videos';
                        opacityLevel = 0.0;
                        list = traininDetailProvider.trainingModuleResponse.data
                            ?.module![0].content?.learningShots
                            ?.where((element) =>
                                element.contentType == 'video' ||
                                element.contentType?.toLowerCase() ==
                                    'video_yts')
                            .first;
                        selectedContentId = list.programContentId;

                        final controller =
                            list.contentType.toLowerCase() == 'video_yts'
                                ? YoutubePlayerController(
                                    initialVideoId:
                                        YoutubePlayer.convertUrlToId(
                                            '${list.url}')!,
                                    flags: YoutubePlayerFlags(
                                      autoPlay: true,
                                      mute: false,
                                    ),
                                  )
                                : VideoPlayerController.network(
                                    '${list.url}',
                                  );
                        // value.changeController(controller);

                        widget.sendValue!(
                          controller,
                          '${list.title}',
                          false,
                          '',
                          '',
                          null,
                          isYoutubeController:
                              list.contentType.toLowerCase() == 'video_yts',
                        );
                      } else if (selectedType == 'Notes') {
                        // setState(() {
                        selectedType = 'Notes';
                        selectedContentId = traininDetailProvider
                            .trainingModuleResponse
                            .data
                            ?.module![0]
                            .content
                            ?.learningShots
                            ?.where((element) => element.contentType == 'notes')
                            .first
                            .programContentId;

                        // value.changeController(controller);
                        _controller.pause();
                        widget.sendValue!(
                            VideoPlayerController.network(
                                '${traininDetailProvider.trainingModuleResponse.data?.module![0].content?.learningShots!.first.url}'),
                            '${traininDetailProvider.trainingModuleResponse.data?.module![0].content?.learningShots!.first.title}',
                            true,
                            '${traininDetailProvider.trainingModuleResponse.data?.module![0].content?.learningShots!.first.url}',
                            '${traininDetailProvider.trainingModuleResponse.data?.module![0].content?.learningShots!.first.image}',
                            traininDetailProvider.trainingModuleResponse.data
                                ?.module![0].content?.learningShots!.first);
                      }
                    });
                  }
                });
                return Visibility(
                    visible: isAllSelected == true ||
                        selectedType.toLowerCase().substring(0, 4) ==
                            traininDetailProvider
                                .trainingModuleResponse
                                .data
                                ?.module![0]
                                .content
                                ?.learningShots![index]
                                .contentType
                                ?.toLowerCase()
                                .substring(0, 4),
                    child: _moduleCard(
                        '${traininDetailProvider.trainingModuleResponse.data?.module![0].content?.learningShots![index].title}',
                        '${capitalize(traininDetailProvider.trainingModuleResponse.data?.module![0].content?.learningShots![index].contentType)}',
                        'learningShots',
                        traininDetailProvider
                            .trainingModuleResponse.data?.module![0].content,
                        index,
                        context,
                        traininDetailProvider
                            .trainingModuleResponse
                            .data
                            ?.module![0]
                            .content
                            ?.learningShots![index]
                            .programContentId));
              },
            ),
          )
      ],
    );
  }

  Widget _moduleCard(String title, String description, String type, data,
      int index, context, int? programContentId,
      {int leadingid = 1, bool showNotificationIcon = false}) {
    //1-> empty circle, 2-> green, 3-> red
    return Consumer<MyCourseProvider>(
        builder: (context, value, child) => InkWell(
              onTap: () {
                if (type == 'learningShots') {
                  if (data!.learningShots!.elementAt(index).contentType ==
                      "notes") {
                    selectedType = 'Notes';
                    _controller.pause();
                    widget.sendValue!(
                        VideoPlayerController.network(
                            '${data!.learningShots!.elementAt(index).url}'),
                        title,
                        true,
                        '${data!.learningShots!.elementAt(index).url}',
                        '${data!.learningShots!.elementAt(index).image}',
                        data!.learningShots!.elementAt(index));
                  } else {
                    opacityLevel = 0.0;
                    String videoUrl = data.learningShots.elementAt(index).url;
                    selectedType = 'Videos';
                    final controller = data!.learningShots!
                                .elementAt(index)
                                .contentType
                                .toLowerCase() !=
                            'video_yts'
                        ? VideoPlayerController.network('$videoUrl')
                        : YoutubePlayerController(
                            initialVideoId:
                                YoutubePlayer.convertUrlToId('$videoUrl')!,
                            flags: YoutubePlayerFlags(
                              autoPlay: true,
                              mute: false,
                            ),
                          );
                    // value.changeController(controller);

                    _controller.pause();
                    widget.sendValue!(
                      controller,
                      title,
                      false,
                      '',
                      '',
                      data.learningShots.elementAt(index),
                      isYoutubeController: data!.learningShots!
                              .elementAt(index)
                              .contentType
                              .toLowerCase() ==
                          'video_yts',
                    );
                  }
                } else if (type == 'assessment') {
                  selectedType = 'Quiz';
                  _controller.pause();

                  widget.sendValue!(
                      VideoPlayerController.network(
                          '${data!.assessments!.elementAt(index).url}'),
                      title,
                      true,
                      '${data!.assessments!.elementAt(index).url}',
                      'https://qa.learningoxygen.com/images/programs/2095.jpeg',
                      data!.assessments!.elementAt(index));
                } else if (type == 'assignment') {
                  selectedType = 'Assignment';
                  _controller.pause();

                  widget.sendValue!(
                      VideoPlayerController.network(
                          '${data!.assignments!.elementAt(index).url}'),
                      title,
                      true,
                      '${data!.assignments!.elementAt(index).url}',
                      'https://qa.learningoxygen.com/images/programs/2095.jpeg',
                      data!.assignments!.elementAt(index));
                } else if (type == 'session') {
                  selectedType = 'Classes';
                  _controller.pause();
                  widget.sendValue!(
                    VideoPlayerController.network(
                        '${data!.sessions!.elementAt(index).url}'),
                    title,
                    true,
                    '${data!.sessions!.elementAt(index).url}',
                    '${data!.sessions!.elementAt(index).image}',
                    data!.sessions!.elementAt(index),
                  );
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    selectedContentId = programContentId;
                  });
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: programContentId == selectedContentId
                    ? ColorConstants.BG_GREY
                    : ColorConstants.WHITE,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    leadingid == 0
                        ? SizedBox()
                        : leadingid == 1
                            ? SvgPicture.asset(
                                'assets/images/empty_circle.svg',
                                height: 20.0,
                                width: 20.0,
                                allowDrawingOutsideViewBox: true,
                              )
                            : leadingid == 2
                                ? Icon(
                                    Icons.check_circle,
                                    color: ColorConstants.GREEN,
                                  )
                                : SvgPicture.asset(
                                    'assets/images/circle_red.svg',
                                    height: 20.0,
                                    width: 20.0,
                                    allowDrawingOutsideViewBox: true,
                                  ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$title',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: Styles.semibold(size: 16),
                          ),
                          Text(
                            '$description',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: Styles.regular(
                              size: 14,
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    if (showNotificationIcon)
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ColorConstants.ICON_BG_GREY,
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          child: SvgPicture.asset(
                            'assets/images/notification_icon.svg',
                            height: 20.0,
                            width: 20.0,
                            allowDrawingOutsideViewBox: true,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ));
  }

  String capitalize(String? letter) {
    return "${letter![0].toUpperCase()}${letter.substring(1).toLowerCase()}";
  }
}

class FullScreenYoutubePlayer extends StatefulWidget {
  final YoutubePlayerController controller;

  FullScreenYoutubePlayer({Key? key, required this.controller})
      : super(key: key);

  @override
  State<FullScreenYoutubePlayer> createState() =>
      _FullScreenYoutubePlayerState();
}

class _FullScreenYoutubePlayerState extends State<FullScreenYoutubePlayer> {
  @override
  void initState() {
    super.initState();
  }

  // void update() {
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: YoutubePlayer(
        onEnded: (YoutubeMetaData data) {
          Navigator.pop(context);
        },
        controller: widget.controller,
        showVideoProgressIndicator: false,
        bottomActions: [
          CurrentPosition(),
          RemainingDuration(),
          ProgressBar(
            isExpanded: true,
            colors: ProgressBarColors(
                handleColor: ColorConstants().primaryColor(),
                bufferedColor: ColorConstants.BG_GREY,
                backgroundColor:
                    ColorConstants().primaryColor().withOpacity(0.3)),

            //full screen toggle button
          ),
          FullScreenButton(),
        ],
      ),
    );
  }
}
