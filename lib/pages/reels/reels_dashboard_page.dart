import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/greels_response.dart';
import 'package:masterg/data/providers/reels_proivder.dart';
import 'package:masterg/local/pref/Preference.dart';
import 'package:masterg/pages/custom_pages/alert_widgets/alerts_widget.dart';
import 'package:masterg/pages/gcarvaan/createpost/create_post_provider.dart';
import 'package:masterg/pages/reels/theme/colors.dart';
import 'package:masterg/pages/reels/video_recording/video_recording_camera_page.dart';
import 'package:masterg/pages/reels/widgets/left_panel.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Strings.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:masterg/utils/utility.dart';
import 'package:masterg/utils/widget_size.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

TabController? _tabController;

class ReelsDashboardPage extends StatefulWidget {
  final bool fromDashboard;
  final int scrollTo;

  const ReelsDashboardPage(
      {super.key, this.fromDashboard = false, this.scrollTo = 0});
  @override
  _ReelsDashboardPageState createState() => _ReelsDashboardPageState();
}

class _ReelsDashboardPageState extends State<ReelsDashboardPage>
    with TickerProviderStateMixin {
  bool isGReelsLoading = true;
  List<GReelsElement>? greelsList;
  bool? isScrolled = false;

  //Box box;

  @override
  void initState() {
    super.initState();
    _getGReels();
    _tabController = TabController(length: 0, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiProvider(
          providers: [
            ChangeNotifierProvider<CreatePostProvider>(
              create: (context) => CreatePostProvider([], false),
            ),
            ChangeNotifierProvider<ReelsProvider>(
              create: (context) => ReelsProvider(false, false),
            ),
            ChangeNotifierProvider<GReelsModel>(
              create: (context) => GReelsModel(greelsList),
            ),
          ],
          child: BlocManager(
              initState: (context) {},
              child: Consumer<GReelsModel>(
                builder: (context, greelsModel, child) =>
                    BlocListener<HomeBloc, HomeState>(
                        listener: (context, state) async {
                          if (state is GReelsPostState) {
                            _handleGReelsResponse(state, greelsModel);
                          }
                        },
                        child: Stack(children: [
                          getBody(greelsModel),
                          Positioned(
                              left: 0,
                              top: 40,
                              child: IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: ColorConstants.WHITE,
                                  // size: 200,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )),
                          Consumer2<CreatePostProvider, ReelsProvider>(
                              builder: (context, createPostProvider,
                                      reelsProvider, child) =>
                                  Positioned(
                                      right: 10,
                                      top: 50,
                                      child: Container(
                                          padding: const EdgeInsets.only(
                                              top: 7,
                                              bottom: 7,
                                              left: 11,
                                              right: 11),
                                          decoration: BoxDecoration(
                                            color: ColorConstants.BLACK
                                                .withOpacity(0.4),
                                            borderRadius:
                                                BorderRadius.circular(22),
                                          ),
                                          child: GestureDetector(
                                            onTap: () async {
                                              createPostProvider.files!.clear();
                                              reelsProvider.pause();

                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          VideoRecordingCameraPage(
                                                            provider:
                                                                createPostProvider,
                                                          ))).then((value) {
                                                setState(() {
                                                  isGReelsLoading = true;
                                                });
                                                greelsList?.clear();

                                                _getGReels();
                                                reelsProvider.play();
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/images/camera_y.svg',
                                                  height: 20,
                                                  width: 20,
                                                  color: white,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    '${Strings.of(context)?.CreateReels}',
                                                    style: Styles.bold(
                                                        color: ColorConstants
                                                            .WHITE,
                                                        size: 14)),
                                              ],
                                            ),
                                          )))),
                        ])),
              ))),
    );
  }

  Widget getBody(GReelsModel greelsList) {
    if (widget.fromDashboard && isScrolled != true)
      Future.delayed(Duration(seconds: 1), () {
        print('sccrolling to ');
      }).then((value) {
        print('sccrolling to scorllred $isScrolled');
        isScrolled = true;
        _tabController?.animateTo(
          widget.scrollTo,
        );
      });

    if (greelsList.list == null || isGReelsLoading) {
      return Container(
        height: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(0)),
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Reels',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height - 180,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 40),
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            ColorConstants.WHITE,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    _tabController = TabController(
        length: greelsList.list!.length,
        initialIndex: greelsList.getCurrentIndex(),
        vsync: this);
    var size = MediaQuery.of(context).size;

    return RotatedBox(
      quarterTurns: 1,
      child: TabBarView(
        controller: _tabController,
        // chi
        children: List.generate(greelsList.list!.length, (index) {
          return VideoPlayerItem(
            videoUrl: greelsList.list![index].resourcePath,
            size: size,
            userStatus: greelsList.list![index].userStatus?.toLowerCase(),
            name: greelsList.list![index].name,
            caption: greelsList.list![index].description,
            profileImg: greelsList.list![index].profileImage,
            likes: greelsList.list![index].likeCount ?? 0,
            comments: 0,
            shares: '80K',
            albumImg:
                'https://images.unsplash.com/photo-1502982899975-893c9cf39028?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60',
            isLiked: greelsList.list![index].userLiked == 0 ? false : true,
            contentId: greelsList.list![index].id,
            viewCount: greelsList.list![index].viewCount ?? 0,
            createdAt: greelsList.list![index].createdAt.toString(),
            greelsModel: greelsList,
            index: index,
            userID: greelsList.list![index].userId,
            thumbnail: greelsList.list![index].thumbnailUrl,
          );

          // return;
        }),
      ),
    );
  }

  void _getGReels() async {
    BlocProvider.of<HomeBloc>(context).add(GReelsPostEvent());
  }

  void _handleGReelsResponse(GReelsPostState state, GReelsModel greelsModel) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          isGReelsLoading = true;
          break;
        case ApiStatus.SUCCESS:
          greelsList = state.response!.data!.list;
          greelsModel.refreshList(greelsList!);
          Log.v("ReelsUsersState.................... ${greelsList?.length}");

          isGReelsLoading = false;
          break;
        case ApiStatus.ERROR:
          isGReelsLoading = false;

          Log.v("Error..........................");
          Log.v("ErrorHome..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          break;
      }
    });
  }
}

class VideoPlayerItem extends StatefulWidget {
  final String? videoUrl;
  final String? name;
  final String? caption;
  final String? profileImg;
  final int? likes;
  final int? comments;
  final String? shares;
  final String? albumImg;
  final bool? isLiked;
  final int? contentId;
  final int? viewCount;
  final String? createdAt;
  final GReelsModel? greelsModel;
  final int? index;
  final int? userID;
  final String? userStatus;
  final String? thumbnail;
  VideoPlayerItem(
      {Key? key,
      required this.size,
      this.name,
      this.caption,
      this.profileImg,
      this.likes,
      this.comments,
      this.shares,
      this.albumImg,
      this.videoUrl,
      this.isLiked,
      this.contentId,
      this.viewCount,
      this.createdAt,
      this.index,
      this.userID,
      this.userStatus,
      this.greelsModel,
      this.thumbnail})
      : super(key: key);

  final Size size;

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem>
    with WidgetsBindingObserver {
  VideoPlayerController? _videoController;
  bool isShowPlaying = false;

  @override
  void initState() {
    super.initState();

    //assets/videos/video_1.mp4
    print('===========>>widget.videoUrl111');
    print(widget.videoUrl!.trim());
    initVideo(widget.videoUrl!);

    WidgetsBinding.instance.addObserver(this);
  }

  void initVideo(String url) async {
    final fileInfo = await checkForCache(url);
    if (fileInfo == null) {
      _videoController = VideoPlayerController.network(url);
      _videoController!.addListener(() {});
      _videoController!.setLooping(true);
      _videoController!.initialize().then((_) => setState(() {
            cacheVideo(url);
            setState(() {
              isShowPlaying = true;
            });
            _videoController?.play();
          }));
    } else {
      print('playing from local ');
      final file = fileInfo.file;
      _videoController = VideoPlayerController.file(file);
      _videoController!.addListener(() {});
      _videoController!.setLooping(true);
      _videoController!.initialize().then((_) => setState(() {
            setState(() {
              isShowPlaying = true;
            });
            _videoController?.play();
          }));
    }
  }

  Future<FileInfo?> checkForCache(String url) async {
    final FileInfo? value = await DefaultCacheManager().getFileFromCache(url);
    return value;
  }

  void cacheVideo(String url) async {
    await DefaultCacheManager()
        .getSingleFile(url)
        .then((value) => print('video cache from url $url'));
  }

  @override
  void dispose() {
    _videoController!.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) if (mounted)
      setState(() {
        _videoController!.pause();
      });
  }

  Widget isPlaying() {
    return _videoController!.value.isPlaying
        ? Container()
        : Icon(
            Icons.play_arrow,
            size: 80,
            color: white.withOpacity(0.5),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReelsProvider>(
      builder: (context, value, child) {
        //adding temporary for mute

        if (value.isPaused)
          _videoController?.pause();
        else {
          _videoController?.play();
        }

        return Material(
          child: InkWell(
            onTap: () {
              setState(() {
                value.showVolumnIcon();
                if (value.isMuted) {
                  _videoController?.setVolume(1.0);
                  value.unMute();
                } else {
                  _videoController?.setVolume(0.0);

                  value.mute();
                }
                new Future.delayed(Duration(seconds: 1), () {
                  value.hideVolumneIcon();
                });
              });
            },
            child: RotatedBox(
              quarterTurns: -1,
              child: Container(
                  height: widget.size.height,
                  width: widget.size.width,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: widget.size.height,
                        width: widget.size.width,
                        decoration: BoxDecoration(color: black),
                        child: Stack(
                          children: <Widget>[
                            isShowPlaying
                                ? VisibilityDetector(
                                    key: ObjectKey(_videoController),
                                    onVisibilityChanged: (visibility) {
                                      var visiblePercentage =
                                          visibility.visibleFraction * 100;
                                      if (visiblePercentage.round() <= 60 &&
                                          this.mounted) {
                                        setState(() {
                                          _videoController!.pause();
                                        }); //pausing  functionality
                                      } else {
                                        if (this.mounted) if (this.mounted)
                                          setState(() {
                                            _videoController!.play();
                                          });
                                      }
                                    },
                                    child: VideoPlayer(_videoController!))
                                // : ShowImage(path: widget.videoUrl),
                                : Center(
                                    child: Image.network(
                                    '${widget.thumbnail}',
                                    height: double.infinity,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        ((context, error, stackTrace) =>
                                            SizedBox()),
                                  )),
                                   if( isShowPlaying == false) Center(child: CircularProgressIndicator(),),
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: value.volumneIconInView
                                        ? ColorConstants.BLACK.withOpacity(0.5)
                                        : Colors.transparent,
                                    shape: BoxShape.circle),
                                child: value.isMuted
                                    ? Icon(Icons.volume_off_outlined,
                                        color: value.volumneIconInView
                                            ? ColorConstants.WHITE
                                            : Colors.transparent)
                                    : Icon(Icons.volume_up,
                                        color: value.volumneIconInView
                                            ? ColorConstants.WHITE
                                            : Colors.transparent),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        //height: widget.size.height,
                        width: widget.size.width,

                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 0, top: 0, bottom: 0),
                          child: SafeArea(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                // HeaderHomePage(),
                                Expanded(
                                    child: Container(
                                  /*decoration: BoxDecoration(
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                            color: Colors.black.withOpacity(0.4),
                                            blurRadius: 50.0,
                                            offset: Offset(0.0, 540.0)
    
                                        )
                                      ],
                                    ),*/
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: [0.81, 1.0],
                                      colors: [
                                        Colors.black.withOpacity(0.0),
                                        Colors.black.withOpacity(0.4),
                                      ],
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 0, bottom: 15),
                                    child: Row(
                                      children: <Widget>[
                                        LeftPanel(
                                          size: widget.size,
                                          userStatus: widget.userStatus,
                                          name: "${widget.name}",
                                          caption: "${widget.caption}",
                                          viewCounts: widget.viewCount,
                                          createdAt: widget.createdAt,
                                          profileImg: "${widget.profileImg}",
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: RightPanel(
                                              mContext: context,
                                              size: widget.size,
                                              likes: widget.likes,
                                              comments: "${widget.comments}",
                                              shares: "${widget.shares}",
                                              profileImg:
                                                  "${widget.profileImg}",
                                              albumImg: "${widget.albumImg}",
                                              isLiked: widget.isLiked,
                                              contentId: widget.contentId,
                                              greelsModel: widget.greelsModel,
                                              index: widget.index,
                                              userID: widget.userID),
                                        )
                                      ],
                                    ),
                                  ),
                                ))
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }
}

class RightPanel extends StatefulWidget {
  final BuildContext mContext;
  final int? likes;
  final String? comments;
  final String? shares;
  final String? profileImg;
  final String? albumImg;
  final bool? isLiked;
  final int? contentId;
  final int? index;
  final int? userID;
  final GReelsModel? greelsModel;
  final GReelsModel? joyContentModel;

  const RightPanel(
      {Key? key,
      required this.size,
      this.likes,
      this.comments,
      this.shares,
      this.profileImg,
      this.albumImg,
      this.isLiked,
      this.contentId,
      this.greelsModel,
      this.index,
      this.userID,
      required this.mContext,
      this.joyContentModel})
      : super(key: key);

  final Size size;

  @override
  State<RightPanel> createState() => _RightPanelState();
}

class _RightPanelState extends State<RightPanel> with TickerProviderStateMixin {
  void deletePost(int? postId) {
    BlocProvider.of<HomeBloc>(context).add(DeletePostEvent(postId: postId));
  }

  void reportPost(
      String? status, int? postId, String category, String comment) {
    BlocProvider.of<HomeBloc>(context).add(ReportEvent(
        status: status, postId: postId, comment: comment, category: category));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),

              LikeWidget(
                // mcontext: widget.mContext,
                joyContentModel: widget.greelsModel!,
                contentId: widget.contentId!,
              ),
              // LikeWidget(
              //   likes: '${widget.likes}',
              //   isLiked: widget.isLiked,
              //   contentId: widget.contentId,
              //   greelsModel: widget.greelsModel,
              // ),
              SizedBox(
                height: 18,
              ),
              InkWell(
                  onTap: () {
                    Share.share(
                        '${widget.greelsModel?.getResourcePath(widget.contentId!)}');
                  },
                  child: SvgPicture.asset(
                    'assets/images/share_icon_reels.svg',
                    height: 40,
                    width: 40,
                    color: ColorConstants.WHITE,
                    allowDrawingOutsideViewBox: true,
                  )),
              SizedBox(
                height: 18,
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
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: new Icon(
                                      Icons.report,
                                      color: Colors.white,
                                    ),
                                    title: new Text(
                                      '${Strings.of(context)?.reportThisPost}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        reportPostFormEnabled = true;
                                      });
                                      return Navigator.pop(context);
                                    },
                                  ),
                                  Container(
                                    child: ListTile(
                                      leading: new Icon(
                                        Icons.hide_image_outlined,
                                        color: Colors.white,
                                      ),
                                      title: new Text(
                                        '${Strings.of(context)?.removeHidePost}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onTap: () {
                                        reportPost(
                                            'remove', widget.contentId, '', '');
                                        widget.greelsModel
                                            ?.hidePost(widget.index);
                                        if (widget.index == 0) {
                                          Future.delayed(
                                                  Duration(milliseconds: 500))
                                              .then((value) => setState(() {
                                                    _tabController
                                                        ?.animateTo(1);
                                                  }));
                                        }

                                        return Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                  if (Preference.getInt(Preference.USER_ID) ==
                                      widget.userID)
                                    ListTile(
                                      leading: new Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                      title: new Text(
                                        '${Strings.of(context)?.deleteThisPost}',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);

                                        AlertsWidget.showCustomDialog(
                                            context: context,
                                            title:
                                                "${Strings.of(context)?.deletePost}!",
                                            text:
                                                "${Strings.of(context)?.areYouSureDelete}",
                                            icon:
                                                'assets/images/circle_alert_fill.svg',
                                            onOkClick: () async {
                                              deletePost(widget.contentId);
                                              widget.greelsModel
                                                  ?.hidePost(widget.index);
                                              if (widget.index == 0) {
                                                await Future.delayed(Duration(
                                                        milliseconds: 500))
                                                    .then((value) =>
                                                        setState(() {
                                                          _tabController
                                                              ?.animateTo(1);
                                                        }));
// Future.delayed(Duration(milliseconds: 1000)).then((value) => setState((){
//   _tabController?.animateTo(0);
// }));
                                              }
                                            });
                                      },
                                    ),
                                ],
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
                          widget.greelsModel?.hidePost(widget.index);

                          if (widget.index == 0) {
                            Future.delayed(Duration(milliseconds: 500))
                                .then((value) => setState(() {
                                      _tabController?.animateTo(1);
                                    }));
                          }

                          Utility.showSnackBar(
                              scaffoldContext: context,
                              message: '${reportState.response?.message}');
                          reportInprogress = false;
                          break;
                        case ApiStatus.ERROR:
                          Log.v("ContentReportState error....................");
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
                                        builder:
                                            (BuildContext context, setState) =>
                                                SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Center(
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  margin:
                                                      EdgeInsets.only(top: 10),
                                                  height: 4,
                                                  width: 70,
                                                  decoration: BoxDecoration(
                                                      color:
                                                          ColorConstants.GREY_4,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8)),
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
                                                SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      ListView.builder(
                                                          physics:
                                                              BouncingScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              reportList.length,
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            return ListTile(
                                                                onTap: () {
                                                                  reportPost(
                                                                      'offensive',
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
                                                ),
                                              if (showTextField == true)
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 14,
                                                      vertical: 8),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        TextFormField(
                                                          controller:
                                                              reportController,
                                                          style: Styles.bold(
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
                                                                  'offensive',
                                                                  widget
                                                                      .contentId,
                                                                  '',
                                                                  reportController
                                                                      .value
                                                                      .text);
                                                            },
                                                            child: Container(
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
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              child: Center(
                                                                  child: Text(
                                                                'Submit',
                                                                style: Styles
                                                                    .regular(
                                                                  color:
                                                                      ColorConstants
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
                  color: ColorConstants.WHITE,
                  size: 40,
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }
}

class LikeWidget extends StatefulWidget {
  final int contentId;
  final GReelsModel joyContentModel;
  const LikeWidget(
      {Key? key, required this.contentId, required this.joyContentModel})
      : super(key: key);

  @override
  State<LikeWidget> createState() => _LikeWidgetState();
}

class _LikeWidgetState extends State<LikeWidget> {
  @override
  void initState() {
    // TODO: implement initState
    //  joyContentModel= Provider.of<GReelsModel>(context);
    update();

    super.initState();
  }

  void update() async {
    Future.delayed(Duration.zero, () {
      print('init is called');

      widget.joyContentModel.updateCurrentIndex(
          widget.joyContentModel.getCurrentPostIndex(widget.contentId));
    });
  }

  @override
  Widget build(BuildContext context) {
    updateLikeandViews(null, context);
    // reels refresh issue fix

    // joyContentModel
    //     .updateCurrentIndex(joyContentModel.getCurrentPostIndex(contentId));

    bool isLiked = widget.joyContentModel.isUserLiked(widget.contentId);
    return InkWell(
      onTap: () {
        if (isLiked) {
          updateLikeandViews(0, context);
          widget.joyContentModel.decreaseLikeCount(widget.contentId);
        } else {
          updateLikeandViews(1, context);

          widget.joyContentModel.increaseLikeCount(widget.contentId);
        }
      },

      // child :Text('nice'),
      child: Container(
        child: Column(
          children: <Widget>[
            isLiked
                ? SvgPicture.asset(
                    'assets/images/greels_liked.svg',
                    height: 40.0,
                    width: 40.0,
                    allowDrawingOutsideViewBox: true,
                  )
                : SvgPicture.asset(
                    'assets/images/greels_like.svg',
                    height: 40.0,
                    width: 40.0,
                    allowDrawingOutsideViewBox: true,
                  ),
            SizedBox(
              height: 5,
            ),
            Text(
              '${widget.joyContentModel.getLikeCount(widget.contentId)}',
              style: Styles.regular(size: 12, color: ColorConstants.WHITE),
            )
          ],
        ),
      ),
    );
  }

  void updateLikeandViews(int? like, context) async {
    BlocProvider.of<HomeBloc>(context).add(LikeContentEvent(
        contentId: widget.contentId, like: like, type: 'contents'));
  }
}
