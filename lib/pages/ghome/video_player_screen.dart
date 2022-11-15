import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:masterg/data/providers/video_player_provider.dart';
import 'package:masterg/pages/ghome/widget/read_more.dart';
import 'package:masterg/pages/reels/theme/colors.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CustomVideoPlayer extends StatefulWidget {
  final url;
  final isLocalVideo;
  final showPlayButton;
  final maintainAspectRatio;
  final autoPlay;

  final int? likeCount;
  final int? viewCount;
  final int? commentCount;
  final int? index;
  final String? desc;
  final String? profilePath;
  final String? userName;
  final String? time;
  final double? height;

  CustomVideoPlayer({
    Key? key,
    this.url,
    this.isLocalVideo = false,
    this.showPlayButton = false,
    this.maintainAspectRatio = false,
    this.autoPlay = true,
    this.likeCount,
    this.viewCount,
    this.commentCount,
    this.index,
    this.desc,
    this.profilePath,
    this.userName,
    this.time,
    this.height
  }) : super(key: key);

  @override
  VideoPlayerState createState() => VideoPlayerState();
}

class VideoPlayerState extends State<CustomVideoPlayer> {
  FlickManager? flickManager;
  late VideoPlayerController controller;
  // Download download = new Download();

  @override
  void initState() {
    super.initState();
    print(widget.autoPlay);

    controller = widget.isLocalVideo
        ? VideoPlayerController.file(
            File(
              widget.url,
            ),
          )
        : VideoPlayerController.network(widget.url);

    controller.setLooping(true);
    controller.setVolume(1.0);
    
    flickManager = FlickManager(
      autoPlay: false,
      videoPlayerController: controller,
    );
    flickManager!.flickDisplayManager!.handleShowPlayerControls(showWithTimeout: false);

  
    /*print(controller.value.size.height / (controller.value.aspectRatio * 2));*/
  }

  @override
  void dispose() {
    flickManager!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  context.read<VideoPlayerProvider>().state.coursesGroupList;

    VideoPlayerProvider videoPlayerState =
        Provider.of<VideoPlayerProvider>(context, listen: false);

    if (videoPlayerState.providerControlEnable) {
      if (!videoPlayerState.isPlaying) {
        controller.pause();
        videoPlayerState.disableProivderControl();
      }
    }

    return GestureDetector(
      /*onTap: widget.showPlayButton ? () {
              if (controller.value.isPlaying) {
                controller.pause();
              } else {
                controller.play();
              }
              setState(() {});

            }
          : null,*/
      onTap: () {
        if (widget.showPlayButton != null) {
          if (controller.value.isPlaying) {
            controller.pause();
            videoPlayerState.pause();
          } else {
            controller.play();
            videoPlayerState.play();
          }
          setState(() {});
        }

        if (widget.showPlayButton == false) {
          setState(() {
            controller.setVolume(1.0);
          });
          _displayDialog(
            context: context,
            url: widget.url,
            likeCount: widget.likeCount,
            viewCount: widget.viewCount,
            commentCount: widget.commentCount,
            desc: widget.desc,
            userName: widget.userName,
            profilePath: widget.profilePath,
            time: widget.time!,
          );
        }
      },
      child: VisibilityDetector(
        key: ObjectKey(flickManager),
        onVisibilityChanged: (visibility) {
          if (!videoPlayerState.providerControlEnable) {
            var visiblePercentage = visibility.visibleFraction * 100;
            //if (visibility.visibleFraction == 0 && this.mounted) {
            if (visiblePercentage.round() <= 70 && this.mounted) {
              setState(() {
                flickManager?.flickControlManager?.pause();
                videoPlayerState.pause();
              }); //pausing  functionality
            } else {
              if (videoPlayerState.isPlaying == false) {
                setState(() {
                  flickManager?.flickControlManager?.pause();
                  videoPlayerState.pause();
                });
              }
              if (this.mounted)
                setState(() {
                  // flickManager?.flickControlManager?.play();
                  // videoPlayerState.play();

                  // videoPlayerState.isMute
                  //     ? controller.setVolume(0.0)
                  //     : controller.setVolume(1.0);
                });
            }
          }
        },
        child: Stack(children: [
          Container(
            height:  widget.height,
            child: FlickVideoPlayer(
              flickVideoWithControls: FlickVideoWithControls(
                   videoFit: BoxFit.cover,
                  ),
              flickManager: flickManager!,
              flickVideoWithControlsFullscreen: FlickToggleSoundAction(),
            ),
          ),
          if (widget.showPlayButton) Positioned.fill(child: isPlaying()),
          Positioned(
              bottom: 0,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  if (controller.value.volume == 1.0) {
                    controller.setVolume(0.0);
                    videoPlayerState.mute();
                  } else {
                    controller.setVolume(1.0);
                    videoPlayerState.unMute();
                  }
                  setState(() {});
                },
                child: !videoPlayerState.isMute
                    ? Icon(Icons.volume_up, color: Colors.white)
                    : Icon(Icons.volume_off_outlined, color: Colors.white),
              )),
        ]),
      ),
    );
  }

  Widget isPlaying() {
    return controller.value.isPlaying
        ? SizedBox()
        : Icon(
            Icons.play_arrow,
            size: 60,
            color: white.withOpacity(0.7),
          );
  }

  // void playVideo() {
  //   setState(() {
  //     controller.play();
  //   });
  // }

  // void pauseVideo() {
  //   setState(() {
  //     controller.pause();
  //   });
  // }

  void mute() {
    //mute video
    controller.setVolume(0.0);
  }

  void unmute() {
    controller.setVolume(1.0);
  }

  _displayDialog(
      {required BuildContext context,
      final String? url,
      final int? likeCount,
      final int? viewCount,
      final int? commentCount,
      final String? desc,
      final String? profilePath,
      final String? userName,
      required final String time}) {
    if (time.contains('.mp4')) {
      flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.network(time),
        autoPlay: true,
        autoInitialize: true,
      );
      //print(flickManager.getPlayerControlsTimeout());
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    height: 40.0,
                    margin: EdgeInsets.only(left: 18.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: new GestureDetector(
                        onTap: () {
                          mute();
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
                            child: profilePath != null
                                // ? download.getFilePath(profilePath) != null
                                //     ? Image.file(
                                //         File(
                                //             '${download.getFilePath(profilePath)}'),
                                //         filterQuality: FilterQuality.low,
                                //         height: 50,
                                //         width: 50,
                                //         fit: BoxFit.cover,
                                //       )
                                //     :
                                ? Image.network(
                                    profilePath,
                                    height: 50,
                                    width: 50,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
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
                                  )
                                : Icon(Icons.account_circle_rounded,
                                    size: 50, color: Colors.grey),
                          ),
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
                                  time,
                                  style: Styles.textRegular(size: 10),
                                ),
                              ),
                              /*Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 2, left: 4),
                                  child: ReadMoreText(text: desc ?? '')
                                  // child: Text(
                                  //   desc ?? '',
                                  //   style: Styles.textRegular(size: 14),
                                  // ),
                                  ),*/
                            ],
                          ),
                        ),
                        /*Icon(
                      Icons.more_horiz,
                      color: Colors.black,)*/ //singh
                      ],
                    ),
                  ),
                  Container(
                    //height: MediaQuery.of(context).size.height * 0.65,
                    child: Column(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Container(
                            //height: MediaQuery.of(context).size.height * 0.65,
                            width: MediaQuery.of(context).size.width,
                            child: url != null && url.isNotEmpty
                                ? url.contains('.mp4') || url.contains('.mov')
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
                                            flickVideoWithControls:
                                                FlickVideoWithControls(
                                              controls: FlickSeekVideoAction(
                                                // child: FlickVideoBuffer(),
                                                seekForward: (value) {
                                                  flickManager
                                                      ?.flickControlManager
                                                      ?.seekForward(value);
                                                },
                                                seekBackward: (value) {
                                                  flickManager
                                                      ?.flickControlManager
                                                      ?.seekBackward(value);
                                                },
                                              ),
                                                  videoFit: BoxFit.contain,
                                            )),
                                      )
                                    : Container()
                                : SizedBox(
                                    child: Text('no data'),
                                  )),
                      ),
                    ]),
                  ),

                  ///Add New
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10, left: 10, top: 10),
                            child: Align(
                              alignment: Alignment.bottomLeft,
                                child: ReadMoreText(text: desc ?? ''),
                            ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
