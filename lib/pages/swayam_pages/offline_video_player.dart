import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masterg/blocs/bloc_manager.dart';
import 'package:masterg/blocs/home_bloc.dart';
import 'package:masterg/data/api/api_service.dart';
import 'package:masterg/utils/Log.dart';
import 'package:masterg/utils/Styles.dart';
import 'package:video_player/video_player.dart';

class OfflineVideoScreen extends StatefulWidget {
  final String? url;
  final String? title;
  final contentId;
  OfflineVideoScreen({this.url, this.title, this.contentId});

  @override
  _OfflineVideoScreenState createState() => _OfflineVideoScreenState();
}

class _OfflineVideoScreenState extends State<OfflineVideoScreen> {
  // VideoPlayerController _videoController;
  // ChewieController _chewieController;
  // bool _isFullScreen=false;
  // VlcPlayerController _videoPlayerController;
  FlickManager? flickManager;

  bool isLoading = true;
  VideoPlayerController? _videoPlayerController;
  int currentMin = 0, prevMin = 0;

  @override
  void initState() {
    _videoPlayerController = getController();
    _getData(_videoPlayerController);
    listenVideoChanges();
    //_updateCourseCompletion(currentMin);

    super.initState();
  }

//get time of current video
  VideoPlayerController getController() {
    return VideoPlayerController.network('${widget.url}');
  }

  void listenVideoChanges() {
    print("listenVideoChanges");
    _videoPlayerController?.addListener(() {
      currentMin = _videoPlayerController!.value.position.inMinutes;
      print("currentMin ${currentMin}");
      print("bookmarkTimerPrevious ${prevMin}");
      if (currentMin != 0 && prevMin != currentMin) {
        print("bookmarkTimer ${currentMin}");
        prevMin = currentMin;
        _updateCourseCompletion(currentMin);
      }
    });
  }

  void _updateCourseCompletion(bookmark) async {
    //change bookmark with 25
    print("bookmarkTimer ${bookmark}");
    BlocProvider.of<HomeBloc>(context).add(UpdateVideoCompletionEvent(
        bookmark: bookmark, contentId: widget.contentId));
    setState(() {});
  }

  @override
  void dispose() {
    // if (_isFullScreen==false) {
    //   _chewieController?.dispose();
    //   _videoController?.dispose();
    // }
    flickManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocManager(
        initState: (c) {},
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is UpdateVideoCompletionState) {
              _handleResponse(state);
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FlickVideoPlayer(flickManager: flickManager!),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.title ?? "",
                  style: Styles.textBold(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _getData(controller) async {
    print(widget.url);
    flickManager = FlickManager(
      autoInitialize: true,
      videoPlayerController: controller,
    );

    // _videoPlayerController = VideoPlayerController.network(widget.url);
    // print("HEEre1");
    // await _videoPlayerController.initialize();
    // print("HEEre2");
    // _chewieController = ChewieController(
    //     videoPlayerController: _videoPlayerController, autoPlay: true,deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp]);
    // print("HEEre3");
    // setState(() {
    //   isLoading = false;
    // });
  }

  void _handleResponse(UpdateVideoCompletionState state) {
    var loginState = state;
    setState(() {
      switch (loginState.apiState) {
        case ApiStatus.LOADING:
          Log.v("Loading....................");
          break;
        case ApiStatus.SUCCESS:
          Log.v("Success....................");

          break;
        case ApiStatus.ERROR:
          Log.v("Error..........................");
          Log.v("Error..........................${loginState.error}");
          break;
        case ApiStatus.INITIAL:
          // TODO: Handle this case.
          break;
      }
    });
  }
}
