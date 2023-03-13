import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/utils/resource/colors.dart';
import 'package:video_player/video_player.dart';

class CompetitionVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final int id;
  const CompetitionVideoPlayer({Key? key, required this.videoUrl, required this.id}) : super(key: key);

  @override
  _CompetitionVideoPlayerState createState() => _CompetitionVideoPlayerState();
}

class _CompetitionVideoPlayerState extends State<CompetitionVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
   bool _isPlaying = false;
  bool isLoading = true;
  int currentMin = 0, prevMin = 0;

  void listenVideoChanges() {
    _videoPlayerController.addListener(() {
      currentMin = _videoPlayerController.value.position.inMinutes;
      print("currentMin ${currentMin}");
      print("bookmarkTimerPrevious ${prevMin}");
      if (currentMin != 0 && prevMin != currentMin) {
        print("bookmarkTimer ${currentMin}");
        prevMin = currentMin;
        _updateCourseCompletion(currentMin);
      }
    });
  }

  @override
  void initState() {
    _updateCourseCompletion(0);
    // _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
     _videoPlayerController= VideoPlayerController.network(widget.videoUrl)
      ..addListener(() {
         final bool isPlaying = _videoPlayerController.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      })
      ..initialize().then((_) {
        setState(() {});
      });
      _videoPlayerController.play();
    listenVideoChanges();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _updateCourseCompletion(bookmark) async {
    //change bookmark with 25
    print("bookmarkTimer make api ${bookmark}");
    BlocProvider.of<HomeBloc>(context).add(UpdateVideoCompletionEvent(
        bookmark: bookmark, contentId: widget.id));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Transform.scale(
          scale: 0.7,
          child: Container(
            decoration: BoxDecoration(
              color: ColorConstants.BLACK.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 30,
                color: ColorConstants.WHITE,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      // body: Center(
      //   child: AspectRatio(
      //     aspectRatio: _videoPlayerController.value.aspectRatio,
      //     child: VideoPlayer(_videoPlayerController),
      //   ),
      // ),

      body: Stack(
        children: [
          _videoPlayerController.value.isInitialized
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _isPlaying
                          ? _videoPlayerController.pause()
                          : _videoPlayerController.play();
                    });
                  },
                  child: Center(
                    child: AspectRatio(
                      aspectRatio:
                          _videoPlayerController.value.aspectRatio,
                      child: VideoPlayer(_videoPlayerController),
                    ),
                  ),
                )
              : Container(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _videoPlayerController.value.isInitialized
                ? VideoProgressIndicator(
                    _videoPlayerController,
                    colors: VideoProgressColors(
                      playedColor: Colors.white,
                      bufferedColor: Colors.white.withOpacity(0.5),
                      backgroundColor: Colors.grey,
                    ),
                    allowScrubbing: true,
                    padding: EdgeInsets.all(8),
                    // onDragStart: () {
                    //   _videoPlayerController.pause();
                    // },
                    // onDragEnd: () {
                    //   _videoPlayerController.play();
                    // },
                    // onDragUpdate: (details) {
                    //   final position = details.localPosition.dx /
                    //       context.size!.width *
                    //       _videoPlayerController.value.duration.inMilliseconds;
                    //   _videoPlayerController.seekTo(Duration(milliseconds: position.toInt()));
                    //   _updateCourseCompletion(_videoPlayerController.value.position);
                    // },
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}
