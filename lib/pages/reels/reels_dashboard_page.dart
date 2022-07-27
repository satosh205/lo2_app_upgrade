import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/data/models/response/home_response/greels_response.dart';
import 'package:masterg/data/providers/reels_proivder.dart';
import 'package:masterg/pages/gcarvaan/createpost/create_post_provider.dart';
import 'package:masterg/pages/reels/theme/colors.dart';
import 'package:masterg/pages/reels/video_recording/video_recording_camera_page.dart';
import 'package:masterg/pages/reels/widgets/left_panel.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ReelsDashboardPage extends StatefulWidget {
  @override
  _ReelsDashboardPageState createState() => _ReelsDashboardPageState();
}

class _ReelsDashboardPageState extends State<ReelsDashboardPage>
    with TickerProviderStateMixin {
  TabController? _tabController;
  bool isGReelsLoading = true;
  List<GReelsElement>? greelsList;
  //Box box;

  @override
  void initState() {
    super.initState();
    print('====flagVideoM=====');
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
              create: (context) => CreatePostProvider([]),
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
                builder: (context, greelsModel, child) => BlocListener<HomeBloc,
                        HomeState>(
                    listener: (context, state) async {
                      if (state is GReelsPostState) {
                        _handleGReelsResponse(state, greelsModel);
                      }
                    },
                    child: Stack(children: [
                      getBody(greelsModel),
                      Consumer2<CreatePostProvider, ReelsProvider>(
                          builder: (context, createPostProvider, reelsProvider,
                                  child) =>
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
                                        borderRadius: BorderRadius.circular(22),
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
                                            greelsList?.clear();
                                            Future.delayed(Duration(seconds: 1))
                                                .then((value) => _getGReels());
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
                                            Text('Create',
                                                style: Styles.bold(
                                                    color: ColorConstants.WHITE,
                                                    size: 14)),
                                          ],
                                        ),
                                      )))),
                    ])),
              ))),
    );
  }

  Widget getBody(GReelsModel greelsList) {
    _tabController = TabController(length: 50, vsync: this);

    if (greelsList.list == null) {
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

    _tabController =
        TabController(length: greelsList.list!.length, vsync: this);
    var size = MediaQuery.of(context).size;

    return RotatedBox(
      quarterTurns: 1,
      child: TabBarView(
        controller: _tabController,
        children: List.generate(greelsList.list!.length, (index) {
          return VideoPlayerItem(
            videoUrl: greelsList.list![index].resourcePath,
            size: size,
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
      this.greelsModel})
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

    _videoController = VideoPlayerController.network(widget.videoUrl!);
    _videoController!.addListener(() {
      // setState(() {});
    });
    _videoController!.setLooping(true);
    _videoController!.initialize().then((_) => setState(() {
          setState(() {
            isShowPlaying = true;
          });
          _videoController!.play();
        }));

    WidgetsBinding.instance.addObserver(this);
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
        if (value.isPaused)
          _videoController!.pause();
        else {
          _videoController!.play();
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
                                : ShowImage(path: widget.videoUrl),
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
                                            size: widget.size,
                                            likes: widget.likes,
                                            comments: "${widget.comments}",
                                            shares: "${widget.shares}",
                                            profileImg: "${widget.profileImg}",
                                            albumImg: "${widget.albumImg}",
                                            isLiked: widget.isLiked,
                                            contentId: widget.contentId,
                                            greelsModel: widget.greelsModel,
                                          ),
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
  final int? likes;
  final String? comments;
  final String? shares;
  final String? profileImg;
  final String? albumImg;
  final bool? isLiked;
  final int? contentId;
  final GReelsModel? greelsModel;

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
      this.greelsModel})
      : super(key: key);

  final Size size;

  @override
  State<RightPanel> createState() => _RightPanelState();
}

class _RightPanelState extends State<RightPanel> {
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
                likes: '${widget.likes}',
                isLiked: widget.isLiked,
                contentId: widget.contentId,
                greelsModel: widget.greelsModel,
              ),
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
                  ))
            ],
          ))
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class LikeWidget extends StatefulWidget {
  final String? likes;
  bool? isLiked;
  final int? contentId;
  GReelsModel? greelsModel;

  LikeWidget(
      {Key? key, this.likes, this.isLiked, this.contentId, this.greelsModel})
      : super(key: key);

  @override
  State<LikeWidget> createState() => _LikeWidgetState();
}

class _LikeWidgetState extends State<LikeWidget> {
  int? likeCount;
  bool? isLiked;
  @override
  void initState() {
    super.initState();

    updateInfo();
    updateLikeandViews(null);
  }

  updateInfo() {
    setState(() {
      likeCount = int.parse(widget.likes!);
      isLiked = widget.isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          if (isLiked!) {
            updateLikeandViews(0);
            likeCount = likeCount! - 1;
            widget.greelsModel?.decreaseLikeCount(widget.contentId!);
            isLiked = false;
          } else {
            updateLikeandViews(1);
            likeCount = likeCount! + 1;
            widget.greelsModel?.increaseLikeCount(widget.contentId!);
            isLiked = true;
          }
        });
      },
      child: Container(
        child: Column(
          children: <Widget>[
            isLiked!
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
              '${likeCount}',
              style: Styles.regular(size: 12, color: ColorConstants.WHITE),
            )
          ],
        ),
      ),
    );
  }

  void updateLikeandViews(int? like) async {
    BlocProvider.of<HomeBloc>(context).add(LikeContentEvent(
        contentId: widget.contentId, like: like, type: 'contents'));
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
        ? Image.memory(
            imageFile!,
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          )
        : Text('loading image');
  }
}
