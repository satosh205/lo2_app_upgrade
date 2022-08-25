import 'package:cached_network_image/cached_network_image.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/gcarvaan_post_reponse.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/custom_pages/custom_widgets/NextPageRouting.dart';
import 'package:masterg/pages/gcarvaan/comment/comment_view_page.dart';
import 'package:masterg/pages/ghome/video_player_screen.dart';
import 'package:masterg/pages/pdf_view_page.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';
import 'package:masterg/utils/widget_size.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:visibility_detector/visibility_detector.dart';

class GCarvaanCardPost extends StatefulWidget {
  final String? image_path;
  final String? profile_path;
  final String? user_name;
  final String date;
  final String? description;
  final int commentCount;
  final bool comment_visible;
  final int? likeCount;
  final int index;
  final int? viewCount;
  final bool? islikedPost;
  final int? contentId;
  final List<String>? fileList;
  final GCarvaanListModel? value;

  // final Widget child;

  GCarvaanCardPost(
      {required this.image_path,
      required this.date,
      required this.description,
      required this.commentCount,
      required this.user_name,
      required this.profile_path,
      required this.index,
      // @required this.child,
      required this.comment_visible,
      this.likeCount,
      this.viewCount,
      this.islikedPost,
      this.contentId,
      this.fileList,
      this.value});

  @override
  _GCarvaanCardPostState createState() => _GCarvaanCardPostState();
}

class _GCarvaanCardPostState extends State<GCarvaanCardPost> {
  // VideoPlayerController _videoController;
  bool isShowPlaying = false;
  // GlobalKey<FormState> _abcKey = GlobalKey<FormState>();
  int? likeCount;
  int currentIndex = 0;
  // Download download = new Download();
  FlickManager? flickManager;

  @override
  void initState() {
    super.initState();

    setValues();
  }

  void setValues() {
    // updateLikeandViews(null);
    setState(() {
      likeCount = widget.likeCount;
    });
  }

  @override
  void dispose() {
    super.dispose();
    //flickManager.dispose();
    // if (_videoController != null) {
    //   _videoController.dispose();
    // }
  }

  @override
  Widget build(BuildContext context) {
    var millis = int.parse(widget.date);
    DateTime date = DateTime.fromMillisecondsSinceEpoch(
      millis * 1000,
    );

    final now = DateTime.now();

    String calculateTimeDifferenceBetween(
        DateTime startDate, DateTime endDate) {
      int seconds = endDate.difference(startDate).inSeconds;
      if (seconds < 60)
        return '$seconds s';
      else if (seconds >= 60 && seconds < 3600)
        return '${startDate.difference(endDate).inMinutes.abs()} m';
      else if (seconds >= 3600 && seconds < 86400)
        return '${startDate.difference(endDate).inHours.abs()} h';
      else {
        // convert day to month
        int days = startDate.difference(endDate).inDays.abs();
        if (days < 30 && days > 7) {
          return '${(startDate.difference(endDate).inDays ~/ 30).abs()} w';
        }
        if (days > 30) {
          int month = (startDate.difference(endDate).inDays ~/ 30).abs();
          return '${month} mos';
        } else
          return '${startDate.difference(endDate).inDays.abs()} d';
      }
    }

    // Widget isPlaying() {
    //   return _videoController.value.isPlaying && !isShowPlaying
    //       ? Container()
    //       : Icon(
    //           Icons.play_arrow,
    //           size: 80,
    //           color: Color(0xFFFFFFFF).withOpacity(0.5),
    //         );
    // }

    var itemCount = widget.fileList!.length;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: ColorConstants.GREY_4)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      child: Center(
                    child: ClipOval(
                      child: widget.profile_path != null
                          ? Image.network(
                              widget.profile_path ?? '',
                              height: 45,
                              width: 45,
                              fit: BoxFit.cover,
                              errorBuilder: (context, url, error) {
                                return SvgPicture.asset(
                                  'assets/images/default_user.svg',
                                  height: 50,
                                  width: 50,
                                  allowDrawingOutsideViewBox: true,
                                );
                              },
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Shimmer.fromColors(
                                  baseColor: Color(0xffe6e4e6),
                                  highlightColor: Color(0xffeaf0f3),
                                  child: Container(
                                      height: 45,
                                      margin: EdgeInsets.only(left: 2),
                                      width: 45,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      )),
                                );
                              },
                            )
                          : Icon(Icons.account_circle_rounded,
                              size: 50, color: Colors.grey),
                    ),
                  )),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                          ),
                          child: Text(
                            widget.user_name ?? '',
                            style: Styles.semibold(size: 14),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            calculateTimeDifferenceBetween(
                                DateTime.parse(
                                    date.toString().substring(0, 19)),
                                now),
                            style: Styles.regular(size: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      bool reportPostFormEnabled = false;
                      bool reportInprogress = false;
                      await showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.black,
                          builder: (context) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(top: 10),
                                    height: 4,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                                Container(
                                  child: ListTile(
                                    leading: new Icon(
                                      Icons.report,
                                      color: Colors.white,
                                    ),
                                    title: new Text(
                                      'Report this post',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        reportPostFormEnabled = true;
                                      });
                                      return Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            );
                          });

                      void _handleReport(ReportState state) {
                        var reportState = state;
                        setState(() {
                          switch (reportState.apiState) {
                            case ApiStatus.LOADING:
                              Log.v(
                                  "ContentReportState Loading....................");
                              reportInprogress = true;
                              break;
                            case ApiStatus.SUCCESS:
                              Log.v("ContentReportState....................");
                              Navigator.pop(context);
                              widget.value?.hidePost(widget.index);

                              Utility.showSnackBar(
                                  scaffoldContext: context,
                                  message: '${reportState.response?.message}');
                              reportInprogress = false;
                              break;
                            case ApiStatus.ERROR:
                              Log.v(
                                  "ContentReportState error....................");
                              reportInprogress = false;
                              break;
                            case ApiStatus.INITIAL:
                              break;
                          }
                        });
                      }

                      if (reportPostFormEnabled) {
                        bool showTextField = false;
                        TextEditingController reportController =
                            TextEditingController();

                        List<dynamic> reportList = Utility.getReportList();

                        showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.black,
                            builder: (BuildContext context) {
                              return FractionallySizedBox(
                                heightFactor: 1,
                                child: BlocManager(
                                  initState: (BuildContext context) {},
                                  child: BlocListener<HomeBloc, HomeState>(
                                    listener: (BuildContext context, state) {
                                      if (state is ReportState) {
                                        _handleReport(state);
                                      }
                                    },
                                    child: BottomSheet(
                                        onClosing: () {},
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(
                                            builder: (BuildContext context,
                                                    setState) =>
                                                SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Center(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      margin: EdgeInsets.only(
                                                          top: 10),
                                                      height: 4,
                                                      width: 70,
                                                      decoration: BoxDecoration(
                                                          color: ColorConstants
                                                              .GREY_4,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      'Report',
                                                      style: Styles.bold(),
                                                    ),
                                                  ),
                                                  Divider(),
                                                  Text(
                                                      'Why are you reporting this post?',
                                                      style: Styles.regular(
                                                          color: ColorConstants
                                                              .WHITE)),
                                                  if (showTextField == false)
                                                    Column(
                                                      children: [
                                                        ListView.builder(
                                                            physics:
                                                                BouncingScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                reportList
                                                                    .length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              return ListTile(
                                                                  onTap: () {
                                                                    reportPost(
                                                                        widget
                                                                            .contentId,
                                                                        '${reportList[index]['value']}',
                                                                        reportController
                                                                            .value
                                                                            .text);
                                                                  },
                                                                  title: Text(
                                                                      '${reportList[index]['title']}'));
                                                            }),
                                                        ListTile(
                                                            onTap: () {
                                                              setState(() {
                                                                showTextField =
                                                                    true;
                                                              });
                                                            },
                                                            title: Text(
                                                                'Something else')),
                                                      ],
                                                    ),
                                                  if (showTextField == true)
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 14,
                                                              vertical: 8),
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          children: [
                                                            TextFormField(
                                                              controller:
                                                                  reportController,
                                                              style:
                                                                  Styles.bold(
                                                                size: 14,
                                                              ),
                                                              decoration:
                                                                  InputDecoration(
                                                                hintText:
                                                                    'What are you trying to report?',
                                                                isDense: true,
                                                                helperStyle: Styles.regular(
                                                                    size: 12,
                                                                    color: ColorConstants
                                                                        .GREY_3
                                                                        .withOpacity(
                                                                            0.1)),
                                                                counterText: "",
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            InkWell(
                                                                onTap: () {
                                                                  reportPost(
                                                                      widget
                                                                          .contentId,
                                                                      '',
                                                                      reportController
                                                                          .value
                                                                          .text);
                                                                },
                                                                child:
                                                                    Container(
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                          vertical:
                                                                              12),
                                                                  width: double
                                                                      .infinity,
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      WidgetSize
                                                                          .AUTH_BUTTON_SIZE,
                                                                  decoration: BoxDecoration(
                                                                      color: ColorConstants()
                                                                          .buttonColor(),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                  child: Center(
                                                                      child:
                                                                          Text(
                                                                    'Submit',
                                                                    style: Styles
                                                                        .regular(
                                                                      color: ColorConstants
                                                                          .WHITE,
                                                                    ),
                                                                  )),
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                ),
                              );
                            });
                      }
                    },
                    child: Icon(
                      Icons.more_vert,
                      color: ColorConstants.BLACK,
                    ),
                  ) //singh
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 7, left: 10),
              child: Text(
                widget.description ?? '',
                style: Styles.regular(size: 14, color: ColorConstants.BLACK),
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 360,
                maxHeight: 420,
              ),
              // color: Colors.red,
              child: PageView.builder(
                  scrollDirection: Axis.horizontal,
                  controller:
                      PageController(initialPage: 0, viewportFraction: 1),
                  itemCount: itemCount,
                  itemBuilder: (BuildContext context, int index) {
                    // var filePath =
                    //     download.getFilePath('${widget.fileList[index]}');
                    return Column(children: [
                      ConstrainedBox(
                          constraints: widget.fileList![index]
                                      .contains('.mp4') ||
                                  widget.fileList![index].contains('.mov') ==
                                      true
                              ? BoxConstraints(
                                  minHeight: 360,
                                  maxHeight: 420,
                                )
                              : BoxConstraints(
                                  minHeight: 360,
                                  maxHeight: 410,
                                ),
                          // padding: EdgeInsets.symmetric(horizontal: 2),
                          child: VisibilityDetector(
                            key: ObjectKey('${widget.contentId}'),
                            onVisibilityChanged: (visibility) async {
                              var visiblePercentage =
                                  visibility.visibleFraction * 100;
                              if (visiblePercentage.round() <= 70 &&
                                  this.mounted) {
                              } else {
                                await Future.delayed(Duration(seconds: 2));
                                updateLikeandViews(null);
                              }
                            },
                            child: Container(
                              child: Stack(
                                children: [
                                  Center(
                                      child: widget.fileList![index]
                                                  .contains('.mp4') ||
                                              widget.fileList![index]
                                                  .contains('.mov')
                                          // ? CustomBetterPlayer(
                                          //     url: widget.fileList[index])

                                          ? CustomVideoPlayer(
                                              url: widget.fileList![index],
                                              isLocalVideo: false,
                                              likeCount: widget.likeCount,
                                              viewCount: widget.viewCount,
                                              commentCount:
                                                  widget.commentCount != null
                                                      ? widget.commentCount
                                                      : 0,
                                              index: index,
                                              desc: widget.description,
                                              userName: widget.user_name,
                                              profilePath: widget.profile_path,
                                              time:
                                                  calculateTimeDifferenceBetween(
                                                      DateTime.parse(date
                                                          .toString()
                                                          .substring(0, 19)),
                                                      now),
                                            )
                                          : widget.fileList![index]
                                                  .contains('.docx')
                                              ? InkWell(
                                                  onTap: () {
                                                    OpenFile.open(
                                                        '${widget.fileList![index]}');
                                                  },
                                                  child: Container(
                                                    child: Image.asset(
                                                      'assets/images/docx.png',
                                                      height: 120,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ))
                                              : widget.fileList![index]
                                                      .contains('.pdf')
                                                  ? InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            NextPageRoute(
                                                              ViewPdfPage(
                                                                path: widget
                                                                        .fileList![
                                                                    index],
                                                              ),
                                                              isMaintainState:
                                                                  true,
                                                            ));
                                                      },
                                                      child: Container(
                                                        child: Image.asset(
                                                          'assets/images/pdf.png',
                                                          height: 120,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    )
                                                  : widget.fileList![index] !=
                                                          null
                                                      ? InkWell(
                                                          onTap: () {
                                                            _displayDialog(
                                                              context: context,
                                                              imgUrl: widget
                                                                      .fileList![
                                                                  index],
                                                              fileList: widget
                                                                  .fileList,
                                                              likeCount: widget
                                                                  .likeCount,
                                                              viewCount: widget
                                                                  .viewCount,
                                                              commentCount: widget
                                                                  .commentCount,
                                                              index: index,
                                                              desc: widget
                                                                  .description,
                                                              userName: widget
                                                                  .user_name,
                                                              profilePath: widget
                                                                  .profile_path,
                                                              time: calculateTimeDifferenceBetween(
                                                                  DateTime.parse(date
                                                                      .toString()
                                                                      .substring(
                                                                          0,
                                                                          19)),
                                                                  now),
                                                            );
                                                          },
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                "${widget.fileList![index]}",
                                                            progressIndicatorBuilder:
                                                                (context, url,
                                                                        downloadProgress) =>
                                                                    Shimmer
                                                                        .fromColors(
                                                              baseColor: Color(
                                                                  0xffe6e4e6),
                                                              highlightColor:
                                                                  Color(
                                                                      0xffeaf0f3),
                                                              child: Container(
                                                                height: double
                                                                    .infinity,
                                                                margin: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            10,
                                                                        vertical:
                                                                            10),
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            6)),
                                                              ),
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Icon(Icons
                                                                        .error),
                                                          ), // child: Image.network(
                                                          // widget.fileList![
                                                          //     index],
                                                          //   filterQuality:
                                                          //       FilterQuality
                                                          //           .low,
                                                          //   fit: BoxFit.fill,
                                                          //   width:
                                                          //       MediaQuery.of(
                                                          //               context)
                                                          //           .size
                                                          //           .width,
                                                          // ),
                                                        )
                                                      : InkWell(
                                                          onTap: () {
                                                            _displayDialog(
                                                              context: context,
                                                              imgUrl: widget
                                                                      .fileList![
                                                                  index],
                                                              fileList: widget
                                                                  .fileList,
                                                              likeCount: widget
                                                                  .likeCount,
                                                              viewCount: widget
                                                                  .viewCount,
                                                              commentCount: widget
                                                                  .commentCount,
                                                              index: index,
                                                              desc: widget
                                                                  .description,
                                                              userName: widget
                                                                  .user_name,
                                                              profilePath: widget
                                                                  .profile_path,
                                                              time: calculateTimeDifferenceBetween(
                                                                  DateTime.parse(date
                                                                      .toString()
                                                                      .substring(
                                                                          0,
                                                                          19)),
                                                                  now),
                                                            );
                                                          },
                                                          child: Image.network(
                                                            widget.fileList![
                                                                index],
                                                            filterQuality:
                                                                FilterQuality
                                                                    .low,
                                                            fit: BoxFit.contain,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            loadingBuilder: (BuildContext
                                                                    context,
                                                                Widget child,
                                                                ImageChunkEvent
                                                                    loadingProgress) {
                                                              if (loadingProgress ==
                                                                  null)
                                                                return child;
                                                              return Shimmer
                                                                  .fromColors(
                                                                baseColor: Color(
                                                                    0xffe6e4e6),
                                                                highlightColor:
                                                                    Color(
                                                                        0xffeaf0f3),
                                                                child:
                                                                    Container(
                                                                  height: double
                                                                      .infinity,
                                                                  margin: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          10),
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6)),
                                                                ),
                                                              );
                                                            } as Widget Function(
                                                                BuildContext,
                                                                Widget,
                                                                ImageChunkEvent?)?,
                                                          ))),
                                  if (itemCount > 1)
                                    Positioned(
                                      child: Container(
                                        height: 22,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.black),
                                        child: Center(
                                          child: Text(
                                            '${index + 1}/${itemCount}',
                                            style: Styles.semiBoldWhite(),
                                          ),
                                        ),
                                      ),
                                      top: 8,
                                      right: 8,
                                    ),
                                ],
                              ),
                            ),
                          )),
                    ]);
                  }),
            ),
            Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, bottom: 8.0, top: 8.0),
                child: Text(
                  '${widget.viewCount != 0 ? widget.viewCount.toString() + ' ${Strings.of(context)?.Views}' : ''}'
                  '${widget.viewCount! > 1 && Preference.getInt(Preference.APP_LANGUAGE) == 1 ? 's' : ''}',
                  style: Styles.regular(size: 12, color: ColorConstants.BLACK),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 1.0, left: 8.0, right: 8.0),
              child: Container(
                color: ColorConstants.GREY_3.withOpacity(0.5),
                height: 0.5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (widget.value?.isLiked(widget.index) == true) {
                          updateLikeandViews(0);

                          widget.value?.updateIsLiked(widget.index, 0);

                          widget.value?.decrementLike(widget.index);
                        } else {
                          updateLikeandViews(1);

                          widget.value?.updateIsLiked(widget.index, 1);

                          widget.value?.incrementLike(widget.index);
                        }
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
                              widget.value?.isLiked(widget.index) == false
                                  ? 'assets/images/like_icon.svg'
                                  : 'assets/images/liked_icon.svg',
                              height: 18.8,
                              width: 17.86,
                              // color:
                              //     widget.value?.isLiked(widget.index) == false
                              //         ? ColorConstants.BLACK
                              //         : ColorConstants().primaryColor(),
                              allowDrawingOutsideViewBox: true,
                            ),
                          ),
                          Text(
                            widget.value?.getLikeCount(widget.index) != 0
                                ? '${widget.value?.getLikeCount(widget.index)} ${Strings.of(context)?.Like}'
                                : ' ${Strings.of(context)?.Like}',
                            style: Styles.regular(
                                size: 12, color: ColorConstants.BLACK),
                          ),
                          if (widget.value?.getLikeCount(widget.index) != 0 &&
                              widget.value?.getLikeCount(widget.index) != 1 &&
                              Preference.getInt(Preference.APP_LANGUAGE) == 1)
                            Text(
                              's',
                              style: Styles.regular(
                                  size: 12, color: ColorConstants.BLACK),
                            )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          backgroundColor: ColorConstants.WHITE,
                          isScrollControlled: true,
                          builder: (context) {
                            return FractionallySizedBox(
                              heightFactor: 0.7,
                              child: CommentViewPage(
                                postId: widget.contentId,
                                value: widget.value,
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
                              allowDrawingOutsideViewBox: true,
                            ),
                          ),
                          Text(
                            widget.commentCount != 0
                                ? '${widget.commentCount} ${Strings.of(context)?.Comment}'
                                : ' ${Strings.of(context)?.Comment}',
                            style: Styles.regular(
                                size: 12, color: ColorConstants.BLACK),
                          ),
                          if (widget.commentCount > 1 &&
                              Preference.getInt(Preference.APP_LANGUAGE) == 1)
                            Text(
                              's',
                              style: Styles.regular(
                                  size: 12, color: ColorConstants.BLACK),
                            )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Share.share('${widget.image_path}');
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
                              allowDrawingOutsideViewBox: true,
                            ),
                          ),
                          Text(
                            '${Strings.of(context)?.Share}',
                            style: Styles.regular(
                                size: 12, color: ColorConstants.BLACK),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateLikeandViews(int? like) async {
    BlocProvider.of<HomeBloc>(context).add(LikeContentEvent(
        contentId: widget.contentId, like: like, type: 'contents'));
  }

  void reportPost(int? postId, String category, String comment) {
    BlocProvider.of<HomeBloc>(context)
        .add(ReportEvent(postId: postId, comment: comment, category: category));
  }

  _displayDialog(
      {required BuildContext context,
      final String? imgUrl,
      final List<String>? fileList,
      final int? likeCount,
      final int? viewCount,
      final int? commentCount,
      final int? index,
      final String? desc,
      final String? profilePath,
      final String? userName,
      final String? time}) {
    showGeneralDialog(
      context: context,
      //barrierDismissible: false,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: Duration(milliseconds: 200),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Scaffold(
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 70.0,
                ),
                Container(
                  height: 40.0,
                  margin: EdgeInsets.only(left: 18.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: new GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.close, color: ColorConstants.BLACK),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 15.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: ClipOval(
                            child: Image.network(
                          widget.profile_path ?? '',
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, url, error) {
                            return SvgPicture.asset(
                              'assets/images/default_user.svg',
                              height: 50,
                              width: 50,
                              allowDrawingOutsideViewBox: true,
                            );
                          },
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Shimmer.fromColors(
                              baseColor: Color(0xffe6e4e6),
                              highlightColor: Color(0xffeaf0f3),
                              child: Container(
                                  height: 50,
                                  margin: EdgeInsets.only(left: 2),
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, top: 2.0),
                              child: Text(
                                userName ?? '',
                                style: Styles.textRegular(size: 14),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                time ?? '',
                                style: Styles.textRegular(size: 10),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 2, left: 4),
                              child: Text(
                                desc ?? '',
                                style: Styles.textRegular(size: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Icon(
                      //   Icons.more_horiz,
                      //   color: Colors.black,
                      // ) //singh
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.65,
                  //height: 300,

                  child: Column(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(0),
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.65,
                          width: MediaQuery.of(context).size.width,
                          child: fileList![index!] != null &&
                                  fileList[index].isNotEmpty
                              ? fileList[index].contains('.mp4')
                                  ? VisibilityDetector(
                                      key: ObjectKey(flickManager),
                                      onVisibilityChanged: (visibility) {
                                        if (visibility.visibleFraction == 0 &&
                                            this.mounted) {
                                          flickManager?.flickControlManager
                                              ?.pause(); //pausing  functionality
                                        } else {
                                          flickManager?.flickControlManager
                                              ?.play(); //playing functionality
                                        }
                                      },
                                      child: FlickVideoPlayer(
                                        flickManager: flickManager!,
                                      ),
                                    )
                                  : Image.network(
                                      imgUrl!,
                                      fit: BoxFit.fitWidth,
                                    )
                              : SizedBox(
                                  child: Text('no data'),
                                )),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
